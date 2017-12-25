/*
 * Copyright (C) 2018 Intel Corporation
 *
 * Author: Tang Haoyu <haoyu.tang@intel.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "ioc_cbcd"
#include <cutils/log.h>
#include <cutils/properties.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/tty.h>
#include <log/log.h>
#include <malloc.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

#define CBC_VERSION_INFO_RESPONSE_LEN 28
#define CBC_VERSION_INFO_REQUEST_LEN 1
#define CBC_LIFECYCLE_FRAME_LEN 4
#define FW_VERSION_SIZE 16
#define IOC_FW_VERSION_RESPONSE 5
typedef enum {
  e_ias_hardware_revision_gr_fab_ab = 11,
  e_ias_hardware_revision_gr_fab_c = 12,
  e_ias_hardware_revision_gr_fab_d = 13,
  e_ias_hardware_revision_gr_fab_e = 14,
} ias_hardware_revision;

typedef struct {
  uint8_t debug_command_ind;
  uint32_t bootloader_version_major;
  uint32_t bootloader_version_minor;
  uint32_t bootloader_version_revision;
  uint32_t firmware_version_major;
  uint32_t firmware_version_minor;
  uint32_t firmware_version_revision;
  uint8_t mainboard_revision;
  uint16_t pad;
} __attribute__((packed)) ioc_version_info_response_frame;

typedef pthread_t cbc_thread_t;
typedef void* (*cbc_thread_func_t)(void *arg);

static char cbc_lifecycle_dev[] = "/dev/cbc-lifecycle";
static char cbc_diagnosis_dev[] = "/dev/cbc-diagnosis";

static char cbc_version_info_req[] = {0x04};
static char cbc_suppres_heartbeat_1min[] = {0x04, 0x60, 0xEA, 0x00};
static char cbc_suppres_heartbeat_5min[] = {0x04, 0xE0, 0x93, 0x04};
static char cbc_suppres_heartbeat_10min[] = {0x04, 0xC0, 0x27, 0x09};
static char cbc_suppres_heartbeat_30min[] = {0x04, 0x40, 0x77, 0x1B};
static char cbc_toggle_sus_stat_2_shutdown[] = {0x02, 0x00, 0x05, 0x00};
static char cbc_toggle_sus_stat_1_shutdown[] = {0x02, 0x00, 0x03, 0x00};
static char cbc_toggle_sus_stat_2_reboot[] = {0x02, 0x00, 0x06, 0x00};
static char cbc_toggle_sus_stat_1_reboot[] = {0x02, 0x00, 0x04, 0x00};
static char cbc_sysctl_config_reboot[] = {0x02, 0x00, 0x02, 0x00};
static char cbc_sysctl_config_shutdown[] = {0x02, 0x00, 0x01, 0x00};
static char cbc_heartbeat_active[] = {0x02, 0x01, 0x00, 0x00};
static char cbc_heartbeat_init[] = {0x02, 0x03, 0x00, 0x00};

static int cbc_diagnosis_fd = -1;
static int cbc_lifecycle_fd = -1;
static int is_ver_info_ok = 0;

static void wait_for_device(const char *dev_name) {
  if (dev_name == NULL) {
    return;
  }
  while (true) {
    if (access(dev_name, F_OK)) {
      ALOGE("waiting for %s\n", dev_name);
      usleep(5000);
      continue;
    }
    break;
  }
}

static int open_cbc_device(char *cbc_device) {
  int fd;
  wait_for_device(cbc_device);
  if ((fd = open(cbc_device, O_RDWR | O_NOCTTY)) < 0) {
    ALOGE("%s failed to open %s\n", __func__, cbc_device);
    exit(1);
  }
  ALOGD("%s open %s successfully\n", __func__, cbc_device);
  return fd;
}

static void close_cbc_device(int fd) { close(fd); }

int cbc_send_data(int fd, char *cbc_frame, int len) {
  int ret = 0;
  do {
    ret = write(fd, cbc_frame, len);
    if (ret == len) {
      ret = 0;
      break;
    } else if (ret == EDQUOT) {
      /*
       * To prevent flood of message from user space, there is inhibit time
       * in the kernel when TX rate exceed limit. During this time, it will
       * return EDQUOT. For this case, we just need to sleep for a while and
       * retry it later.
       */
      ALOGE("%s sleep for a while during inhibit time", __func__);
      usleep(1000);
    } else {
      ALOGE("%s Write issue : %d", __func__, errno);
      ret = -1;
      break;
    }
  } while (ret == EDQUOT);
  return ret;
}

int cbc_read_data(int fd, char *p_cbc_frame, int len) {
  int nbytes = 0;
  nbytes = read(fd, p_cbc_frame, len);

  if (nbytes < 0) {
    ALOGE("%s read issue %d", __func__, errno);
    usleep(5000);
    return 0;
  }
  return nbytes;
}

static __inline__ int cbc_thread_create(cbc_thread_t *pthread,
                                        cbc_thread_func_t start, void *arg) {
  pthread_attr_t attr;

  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);

  return pthread_create(pthread, &attr, start, arg);
}

void cbc_heatbeat_cyclic() {
  cbc_send_data(cbc_lifecycle_fd, cbc_heartbeat_init, CBC_LIFECYCLE_FRAME_LEN);
  ALOGD("send heartbeat init\n");
  while (1) {
    cbc_send_data(cbc_lifecycle_fd, cbc_heartbeat_active,
                  CBC_LIFECYCLE_FRAME_LEN);
    ALOGD("send heartbeat active\n");
    /* delay 1 second to send next heart beat */
    sleep(1);
  }
}

void *cbc_wakeup_reason_thread() {
  char rx_data[CBC_LIFECYCLE_FRAME_LEN];
  int len = 0;
  while (1) {
    len = cbc_read_data(cbc_lifecycle_fd, rx_data, CBC_LIFECYCLE_FRAME_LEN);
    if (len > 0) {
      ALOGD("received wakeup reason");
      // wakeup reason
    }
  }
  return 0;
}

static int update_ioc_version(char *versions) {
  ioc_version_info_response_frame *frame =
      (ioc_version_info_response_frame *)versions;
  char ioc_buff[FW_VERSION_SIZE];

  if (frame->debug_command_ind != IOC_FW_VERSION_RESPONSE) return 0;

  snprintf(ioc_buff, FW_VERSION_SIZE, "%d.%d.%x",
           frame->bootloader_version_major, frame->bootloader_version_minor,
           frame->bootloader_version_revision);
  property_set("ioc.bootloader.version", ioc_buff);

  snprintf(ioc_buff, FW_VERSION_SIZE, "%d.%d.%d", frame->firmware_version_major,
           frame->firmware_version_minor, frame->firmware_version_revision);
  property_set("ioc.firmware.version", ioc_buff);
  ALOGI("ioc.firmware.version = %s\n", ioc_buff);
  switch (frame->mainboard_revision) {
    case e_ias_hardware_revision_gr_fab_ab:
      snprintf(ioc_buff, FW_VERSION_SIZE, "GR_FAB_AB");
      break;
    case e_ias_hardware_revision_gr_fab_c:
      snprintf(ioc_buff, FW_VERSION_SIZE, "GR_FAB_C");
      break;
    case e_ias_hardware_revision_gr_fab_d:
      snprintf(ioc_buff, FW_VERSION_SIZE, "GR_FAB_D");
      break;
    case e_ias_hardware_revision_gr_fab_e:
      snprintf(ioc_buff, FW_VERSION_SIZE, "GR_FAB_E");
      break;
    default:
      snprintf(ioc_buff, FW_VERSION_SIZE, "unknown");
      break;
  }
  property_set("ioc.hardware.version", ioc_buff);
  ALOGI("ioc.hardware.version = %s\n", ioc_buff);

  return 1;
}

void *cbc_get_version_info_thread() {
  char rx_data[CBC_VERSION_INFO_RESPONSE_LEN];
  int len = 0;
  do {
    len =
        cbc_read_data(cbc_diagnosis_fd, rx_data, CBC_VERSION_INFO_RESPONSE_LEN);
    if (len > 0) {
      is_ver_info_ok = update_ioc_version(rx_data);  // parse received data
    } else {
      sleep(1);
      ALOGD("failed to read cbc_diagnosis channel,resend version request\n");
      cbc_send_data(cbc_diagnosis_fd, cbc_version_info_req,
                    CBC_VERSION_INFO_REQUEST_LEN);  // resend request
    }
  } while (!is_ver_info_ok);

  close_cbc_device(cbc_diagnosis_fd);
  return 0;
}

int cbc_version_info_request(void) {
  int ret = 0;
  cbc_thread_t version_info_thread_ptr;

  cbc_diagnosis_fd = open_cbc_device(cbc_diagnosis_dev);  // open channel
  cbc_thread_create(&version_info_thread_ptr, cbc_get_version_info_thread,
                    NULL);  // create receive thread

  ALOGD("send version request to IOC\n");
  if (!is_ver_info_ok)
    ret = cbc_send_data(cbc_diagnosis_fd, cbc_version_info_req,
                        CBC_VERSION_INFO_REQUEST_LEN);  // send request
  return ret;
}

int main(void) {
  cbc_thread_t wakeup_reason_thread_ptr;

  cbc_lifecycle_fd = open_cbc_device(cbc_lifecycle_dev);

  cbc_thread_create(&wakeup_reason_thread_ptr, cbc_wakeup_reason_thread,
                    NULL);  // thread to handle Rx data

  cbc_version_info_request();

  cbc_heatbeat_cyclic();  // send heartbeats in main thread
  // should NOT run here
  close_cbc_device(cbc_lifecycle_fd);
  return 0;
}
