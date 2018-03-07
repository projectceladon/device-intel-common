/*
 * Copyright (C) 2016 Intel Corporation
 *
 * Author: Guillaume Betous <guillaume.betous@intel.com>
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

#define LOG_TAG "ioc_slcand"
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <log/log.h>
#include <cutils/properties.h>
#include <stdio.h>
#include <errno.h>
#include <malloc.h>
#include <pthread.h>
#include <stdint.h>
#include <sys/prctl.h>
#include <time.h>
#include <cutils/log.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <termios.h>
#include <linux/tty.h>
#include <linux/sockios.h>
#include <linux/can.h>
#include <linux/can/raw.h>

static char *slcand_init[] = {"slcand", "-S", "4000000", "-t", "hw", "ttyS1", "slcan0", NULL};
static char *slcan_attach_init[] = {"slcan_attach", "-o", "-f", "/dev/ttyS1", NULL};
static char *ifconfig_init[] = {"/vendor/bin/ifconfig", "slcan0", "up", NULL};
static char *stack_ready[] = {"cansend", "slcan0", "0000FFFF#0A005555555555", NULL};

#define CANID_IOC	0x0000FFFF
#define CANID_DELIM	'#'
#define DATA_SEPERATOR	'.'
#define FW_VERSION_SIZE         16

#define POWER_STATE "/sys/power/state"

static char *slcan_link_name = "slcan0";
static int slcan_socket_fd;

typedef  pthread_t	slcan_thread_t;
typedef void*	(*slcan_thread_func_t)(void*  arg);

typedef enum
{
	e_ias_slcan_dummy_ctrl_wakeup_reasons = 1U,
	e_ias_slcan_dummy_ctrl_ioc_ready      = 2U,
	e_ias_slcan_dummy_ctrl_timestamp      = 3U,
	e_ias_slcan_dummy_ctrl_gyro_data      = 4U,
	e_ias_slcan_dummy_ctrl_bat_fan        = 5U,
	e_ias_slcan_dummy_ctrl_temp           = 6U,
	e_ias_slcan_dummy_ctrl_version_resp   = 7U
}
ias_slcan_dummy_ctrl;

typedef enum
{
	e_ias_wakeup_reason_ignition_line           =  0U,
	e_ias_wakeup_reason_ignition_message        =  1U,
	e_ias_wakeup_reason_can_high_speed_trcv     =  2U,
	e_ias_wakeup_reason_can_low_speed_trcv      =  3U,
	e_ias_wakeup_reason_asr_nm_msg_received     =  4U,
	e_ias_wakeup_reason_wakeup_button           =  5U,
	e_ias_wakeup_reason_diagnostics_active      =  6U,
	e_ias_wakeup_reason_pwf                     =  7U,
	e_ias_wakeup_reason_s3_timer_event          =  8U,
	e_ias_wakeup_reason_wakeup_timer_event      =  9U,
	e_ias_wakeup_reason_dummy_3                 = 10U,
	e_ias_wakeup_reason_dummy_4                 = 11U,
	e_ias_wakeup_reason_dummy_5                 = 12U,
	e_ias_wakeup_reason_dummy_6                 = 13U,
	e_ias_wakeup_reason_dummy_7                 = 14U,
	e_ias_wakeup_reason_dummy_8                 = 15U,
	e_ias_wakeup_reason_dummy_9                 = 16U,
	e_ias_wakeup_reason_dummy_10                = 17U,
	e_ias_wakeup_reason_dummy_11                = 18U,
	e_ias_wakeup_reason_dummy_12                = 19U,
	e_ias_wakeup_reason_terminal_active         = 20U,
	e_ias_wakeup_reason_dummy_0                 = 21U,
	e_ias_wakeup_reason_testinterface_active    = 22U,
	e_ias_wakeup_reason_cm_active               = 23U,
	e_ias_wakeup_reason_cm_delay_timer          = 24U,
	e_ias_wakeup_reason_cm_memory_training      = 25U,
	e_ias_wakeup_reason_cm_os_reboot            = 26U,
	e_ias_wakeup_reason_suppress_heartbeat      = 27U,
	e_ias_wakeup_reason_startup_in_progress     = 28U,
	e_ias_wakeup_reason_cm_delay                = 29U,
	e_ias_wakeup_reason_alive_reason_number     = 30U,
}
ias_wakeup_reasons;

typedef enum
{
        e_ias_hardware_revision_gr_fab_ab = 11,
        e_ias_hardware_revision_gr_fab_c =  12,
        e_ias_hardware_revision_gr_fab_d =  13,
        e_ias_hardware_revision_gr_fab_e =  14,
}
ias_hardware_revision;

static __inline__ int  slcan_thread_create( slcan_thread_t  *pthread, slcan_thread_func_t  start, void*  arg )
{
	pthread_attr_t   attr;

	pthread_attr_init (&attr);
	pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_DETACHED);

	return pthread_create( pthread, &attr, start, arg );
}

static int create_slcan_socket(void)
{
	struct ifreq ifr;
	int s;
	struct sockaddr_can addr;

	strncpy(ifr.ifr_name, slcan_link_name, IFNAMSIZ);
	ifr.ifr_ifindex = if_nametoindex(ifr.ifr_name);
	if (!ifr.ifr_ifindex) {
		ALOGE("%s Ifr index issue %d", __func__, errno);
		return -1;
	}

	if ((s = socket(PF_CAN, SOCK_RAW, CAN_RAW)) < 0) {
		ALOGE("%s socket open failed", __func__);
		return -1;
	}

	addr.can_family = AF_CAN;
	addr.can_ifindex = ifr.ifr_ifindex;

	if (bind(s, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
		ALOGE("%s socket bind issue %d", __func__, errno);
		return -1;
	}

	return s;
}

static void close_slcan_socket(int socket)
{
	close(socket);
}

unsigned char asc2nibble(char c) {

	if ((c >= '0') && (c <= '9'))
		return c - '0';

	if ((c >= 'A') && (c <= 'F'))
		return c - 'A' + 10;

	if ((c >= 'a') && (c <= 'f'))
		return c - 'a' + 10;

	return 16; /* error */
}

int slcan_send_data(int socket_fd, struct canfd_frame frame)
{
	int ret = 0;

	do {
		ret = write(socket_fd, &frame, CAN_MTU);
		if (ret == CAN_MTU) {
			ret = 0;
			break;
		}
		else if (ret == EDQUOT) {
			/*
			 * To prevent flood of message from user space, there is inhibit time
			 * in the kernel when TX rate exceed limit. During this time, it will
			 * return EDQUOT. For this case, we just need to sleep for a while and
			 * retry it later.
			 */
			ALOGE("%s sleep for a while during inhibit time", __func__);
			sleep(1);
		}
		else {
			ALOGE("%s Write issue : %d", __func__, errno);
			ret = -1;
			break;
		}
	} while (ret == EDQUOT);

	return ret;
}

int slcan_read_data(int socket_fd, struct canfd_frame* frame)
{
	int nbytes;

	nbytes = read(socket_fd, frame, sizeof(struct can_frame));

	if (nbytes < 0) {
		ALOGE("%s read issue %d", __func__, errno);
		return -1;
	}

	return 0;
}

int parse_canframe(char *cs, struct canfd_frame *cf) {

	int i, idx, dlen, len;
	int maxdlen = CAN_MAX_DLEN;
	int ret = CAN_MTU;
	unsigned char tmp;

	len = strlen(cs);
	memset(cf, 0, sizeof(*cf)); /* init CAN FD frame, e.g. LEN = 0 */

	if (len < 4)
		return 0;

	if (cs[3] == CANID_DELIM) { /* 3 digits */

		idx = 4;
		for (i=0; i<3; i++){
			if ((tmp = asc2nibble(cs[i])) > 0x0F)
				return 0;
			cf->can_id |= (tmp << (2-i)*4);
		}

	} else if (cs[8] == CANID_DELIM) { /* 8 digits */

		idx = 9;
		for (i=0; i<8; i++){
			if ((tmp = asc2nibble(cs[i])) > 0x0F)
				return 0;
			cf->can_id |= (tmp << (7-i)*4);
		}
		if (!(cf->can_id & CAN_ERR_FLAG)) /* 8 digits but no errorframe?  */
			cf->can_id |= CAN_EFF_FLAG;   /* then it is an extended frame */

	} else
		return 0;

	if((cs[idx] == 'R') || (cs[idx] == 'r')){ /* RTR frame */
		cf->can_id |= CAN_RTR_FLAG;

		/* check for optional DLC value for CAN 2.0B frames */
		if(cs[++idx] && (tmp = asc2nibble(cs[idx])) <= CAN_MAX_DLC)
			cf->len = tmp;

		return ret;
	}

	if (cs[idx] == CANID_DELIM) { /* CAN FD frame escape char '##' */

		maxdlen = CANFD_MAX_DLEN;
		ret = CANFD_MTU;

		/* CAN FD frame <canid>##<flags><data>* */
		if ((tmp = asc2nibble(cs[idx+1])) > 0x0F)
			return 0;

		cf->flags = tmp;
		idx += 2;
	}

	for (i=0, dlen=0; i < maxdlen; i++){

		if(cs[idx] == DATA_SEPERATOR) /* skip (optional) separator */
			idx++;

		if(idx >= len) /* end of string => end of data */
			break;

		if ((tmp = asc2nibble(cs[idx++])) > 0x0F)
			return 0;
		cf->data[i] = (tmp << 4);
		if ((tmp = asc2nibble(cs[idx++])) > 0x0F)
			return 0;
		cf->data[i] |= tmp;
		dlen++;
	}
	cf->len = dlen;

	return ret;
}

/*
*
*  4.1.1.14. Request version information
*  This command requests the IOC version, Selector: 16 (0x10) No parameters.
*  The IOC will answer with a response message. The message layout follows #IOC to CM Basic Message.
*  Selector: 7
*  Payload Byte 0: bootloader version major
*  Payload Byte 1: bootloader version minor
*  Payload Byte 2: firmware version major
*  Payload Byte 3: firmware version minor
*  Payload Byte 4: firmware version revision / build id
*      Firmware revision / build id value 0 defines internal development builds;
*      release builds do have a value different to 0.
*
*  Payload Byte 5: mainboard revision
*  11 = GR MRB Fab A / B
*  12 = GR MRB Fab C
*  13 = GR MRB Fab D
*  14 = GR MRB Fab E
*/
static int update_ioc_version(struct canfd_frame *frame)
{
       char ioc_buff[FW_VERSION_SIZE];

       snprintf(ioc_buff, FW_VERSION_SIZE, "%.2d.%.2d",
                       frame->data[0], frame->data[1]);
       property_set("ioc.bootloader.version", ioc_buff);

       snprintf(ioc_buff, FW_VERSION_SIZE, "%.2d.%.2d.%.2d",
                       frame->data[2], frame->data[3], frame->data[4]);
       property_set("ioc.firmware.version", ioc_buff);
       ALOGI("ioc.firmware.version = %s\n", ioc_buff);

       switch(frame->data[5]) {
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

       return 0;
}

void execute(char **argv)
{
	pid_t  pid;
	int    status;

	pid = fork();
	if (pid < 0) {
		ALOGE("forking child process failed\n");
		exit(1);
	}

	if (pid == 0) {
		if (execvp(*argv, argv) < 0) {
			ALOGE("exec failed\n");
			exit(1);
		}
	}
	else {
		while (wait(&status) != pid)
			sleep(1);
	}
}

void *slcan_heatbeat_thread()
{
	struct canfd_frame t_frame;

	while (1) {
		parse_canframe("0000FFFF#00015555555555", &t_frame);
		/* if send heatbeat fail, exit and restart ioc_slcand */
		if(slcan_send_data(slcan_socket_fd, t_frame)) {
			ALOGE("send heatbeat fail!!!\n");
			exit(-1);
		}

		/* delay 2 secs to send next heart beat */
		sleep(2);
	}
	return 0;
}

void wait_for_device(const char *dev_name) {
    if (dev_name == NULL) {
        return ;
    }
    while (true) {
        if (access(dev_name, F_OK)) {
            usleep(5000);
            continue;
        }
        break;
    }
}

int main(void)
{
	struct canfd_frame r_frame, t_frame;
	int r_sel, ret;
	slcan_thread_t heatbeat_thread_ptr;
	fd_set rfds;
	struct timeval tv;
	wait_for_device("/dev/ttyS1");
	execute(slcand_init);
	execute(slcan_attach_init);
	execute(ifconfig_init);
	execute(stack_ready);

	slcan_socket_fd = create_slcan_socket();
	if(slcan_socket_fd < 0) {
		ALOGE("ioc_slcand failed to create socket!!!\n");
		return -1;
	}
	/* send stack ready */
	parse_canframe("0000FFFF#0A005555555555", &t_frame);
	slcan_send_data(slcan_socket_fd, t_frame);

	/* send ioc version request */
	parse_canframe("0000FFFF#10005555555555", &t_frame);
	slcan_send_data(slcan_socket_fd, t_frame);

	slcan_thread_create(&heatbeat_thread_ptr, slcan_heatbeat_thread, NULL );

	while(1) {
		FD_ZERO(&rfds);
		FD_SET((slcan_socket_fd%FD_SETSIZE), &rfds);
		/*timeout up to 1s */
		tv.tv_sec = 1;
		tv.tv_usec = 0;

		ret = select(slcan_socket_fd + 1, &rfds, NULL, NULL, &tv);

		if(ret == 0) {
			ALOGE("ioc_slcand timeout!!!\n");
			continue;
		}

		if (slcan_read_data(slcan_socket_fd, &r_frame) < 0)
			continue;
		if (r_frame.can_id == (CANID_IOC | CAN_EFF_FLAG)) {
			r_sel = r_frame.data[7];
			switch (r_sel)
			{
				case e_ias_slcan_dummy_ctrl_version_resp:
					{
						ALOGE("ioc firmware version r_frame.data = %x\n",r_frame.data[7]);
						update_ioc_version(&r_frame);
					}
				default:
					break;
			}
		} else {
			ALOGE("Unsupported can msg! CAN_ID = %x; LEN = %x;\n", r_frame.can_id, r_frame.len);
		}
	}

	close_slcan_socket(slcan_socket_fd);

	return 0;
}
