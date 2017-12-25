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

#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <linux/tty.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <termios.h>
#include <unistd.h>

char const *const cbc_default_tty_dev = "/dev/ttyS1";
char const *cbc_lifecycle_dev = "/dev/cbc-lifecycle";

#define CBC_LIFECYCLE_FRAME_LEN 4
#define CBC_LIFECYCLE_FRAME_OFFSET 3
#define CBC_LIFECYCLE_RAW_FRAME_LEN 8
static uint8_t cbc_suppres_heartbeat_1min[] = {0x05, 0x00, 0x0E, 0x04,
                                               0x60, 0xEA, 0x00, 0x9F};
static uint8_t cbc_suppres_heartbeat_5min[] = {0x05, 0x00, 0x0E, 0x04,
                                               0xE0, 0x93, 0x04, 0x72};
static uint8_t cbc_suppres_heartbeat_10min[] = {0x05, 0x00, 0x0E, 0x04,
                                                0xC0, 0x27, 0x09, 0xF9};
static uint8_t cbc_suppres_heartbeat_30min[] = {0x05, 0x00, 0x0E, 0x04,
                                                0x40, 0x77, 0x1B, 0x17};
static uint8_t cbc_toggle_sus_stat_2_shutdown[] = {0x05, 0x00, 0x0E, 0x02,
                                                   0x00, 0x05, 0x00, 0xE6};
static uint8_t cbc_toggle_sus_stat_1_shutdown[] = {0x05, 0x00, 0x0E, 0x02,
                                                   0x00, 0x03, 0x00, 0xE8};
static uint8_t cbc_toggle_sus_stat_2_reboot[] = {0x05, 0x00, 0x0E, 0x02,
                                                 0x00, 0x06, 0x00, 0xE5};
static uint8_t cbc_toggle_sus_stat_1_reboot[] = {0x05, 0x00, 0x0E, 0x02,
                                                 0x00, 0x04, 0x00, 0xE7};
static uint8_t cbc_sysctl_config_reboot[] = {0x05, 0x00, 0x0E, 0x02,
                                             0x00, 0x02, 0x00, 0xE9};
static uint8_t cbc_sysctl_config_shutdown[] = {0x05, 0x00, 0x0E, 0x02,
                                               0x00, 0x01, 0x00, 0xEA};

static struct option longOpts[] = {
    {"help", no_argument, 0, 'h'},
    {"reboot", no_argument, 0, 'r'},
    {"suppress-heartbeat", required_argument, 0, 's'},
    {"ignore-toggle-sus-stat", required_argument, 0, 'i'},
    {0, 0, 0, 0}};

void printMainUsage() {
  fprintf(stderr, "cbc_reboot tool - IOC CBC reboot control tool\n\n");
  fprintf(stderr, "Usage: cbc_reboot [OPTION]... \n\n");
  fprintf(stderr, "-h , --help\n");
  fprintf(stderr, "-r , --reboot\n");
  fprintf(stderr, "-s , --suppress-heartbeat=<1,5,10,30> minutes\n");
  fprintf(stderr, "-i , --ignore-toggle-sus-stat=<0,1,2>\n");
}

int cbc_send_data(int fd, uint8_t *cbc_frame, int len) {
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
      usleep(1000);
    } else {
      fprintf(stderr, "Failed to send data, errno : %d", errno);
      ret = 1;
      break;
    }
  } while (ret == EDQUOT);
  return ret;
}

void send_cbc_frames(char const *dev_name, bool reboot, uint8_t suppress_hb,
                     uint8_t ignore_toggle) {
  uint8_t frame_offset = 0, frame_len = 0;
  uint8_t *p_frame = NULL;
  int fd = -1;
  if (access(cbc_lifecycle_dev, F_OK)) {
    frame_offset = 0;
    frame_len = CBC_LIFECYCLE_RAW_FRAME_LEN;
    if ((fd = open(dev_name, O_WRONLY | O_NOCTTY)) < 0) {
      fprintf(stderr, "failed to open %s\n", dev_name);
      exit(1);
    }
  } else {
    frame_offset = CBC_LIFECYCLE_FRAME_OFFSET;
    frame_len = CBC_LIFECYCLE_FRAME_LEN;
    if ((fd = open(cbc_lifecycle_dev, O_WRONLY | O_NOCTTY)) < 0) {
      fprintf(stderr, "failed to open %s\n", cbc_lifecycle_dev);
      exit(1);
    }
  }
  switch (suppress_hb) {
    case 1:
      p_frame = cbc_suppres_heartbeat_1min;
      break;
    case 5:
      p_frame = cbc_suppres_heartbeat_5min;
      break;
    case 10:
      p_frame = cbc_suppres_heartbeat_10min;
      break;
    case 30:
      p_frame = cbc_suppres_heartbeat_30min;
      break;
    default:
      p_frame = NULL;
  }
  if (p_frame) cbc_send_data(fd, p_frame + frame_offset, frame_len);

  switch (ignore_toggle) {
    case 0:
      if (reboot == true)
        p_frame = cbc_sysctl_config_reboot;
      else
        p_frame = cbc_sysctl_config_shutdown;
      break;
    case 1:
      if (reboot == true)
        p_frame = cbc_toggle_sus_stat_1_reboot;
      else
        p_frame = cbc_toggle_sus_stat_1_shutdown;
      break;
    default:
      if (reboot == true)
        p_frame = cbc_toggle_sus_stat_2_reboot;
      else
        p_frame = cbc_toggle_sus_stat_2_shutdown;
      break;
  }
  cbc_send_data(fd, p_frame + frame_offset, frame_len);
  close(fd);
}

int main(int argc, char **argv) {
  int optionIndex;
  int c;

  uint8_t suppress_hb = 0;
  bool reboot = false;
  uint8_t ignore_toggle = 0;
  int deviceFd = 0;
  char const *deviceName = cbc_default_tty_dev;

  // Try to get the CBC TTY device name from an environment variable.
  char const *envDeviceName = getenv("CBC_TTY");
  if (envDeviceName != nullptr) {
    deviceName = envDeviceName;
  }

  // Parse command line options.
  if (argc == 0) {
    return 1;
  }

  while (1) {
    c = getopt_long(argc, argv, "hrs:i:", longOpts, &optionIndex);
    if (c == -1) {
      break;
    }
    switch (c) {
      case 'h':
        printMainUsage();
        return 0;
        break;

      case 's':
        if (optarg != NULL) {
          suppress_hb = atoi(optarg);
          switch (suppress_hb) {
            case 1:
            case 5:
            case 10:
            case 30:
              break;
            default:
              fprintf(stderr, "Unsupport suppress-heartbeat: %s\n", optarg);
              return 1;
          }
        }
        break;

      case 'i':
        if (optarg != NULL) {
          ignore_toggle = atoi(optarg);
          switch (ignore_toggle) {
            case 0:
            case 1:
            case 2:
              break;
            default:
              fprintf(stderr, "Unsupport ignore-toggle-sus-stat: %s\n", optarg);
              return 1;
          }
        }
        break;

      case 'r':
        reboot = true;
        break;

      default:
        return 1;
    }
  }

  send_cbc_frames(deviceName, reboot, suppress_hb, ignore_toggle);
  fprintf(
      stderr,
      "%s,ignore toggle of sus_stat:%i, suppress heartbeat: %imins, then %s\n",
      argv[0], ignore_toggle, suppress_hb, reboot ? "reboot" : "halt");
  return 0;
}
