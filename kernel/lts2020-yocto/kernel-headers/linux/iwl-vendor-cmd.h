/******************************************************************************
 *
 * This file is provided under a dual BSD/GPLv2 license.  When using or
 * redistributing this file, you may do so under either license.
 *
 * GPL LICENSE SUMMARY
 *
 * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
 * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
 * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
 * Copyright(c) 2018 Intel Corporation
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * The full GNU General Public License is included in this distribution
 * in the file called COPYING.
 *
 * Contact Information:
 *  Intel Linux Wireless <linuxwifi@intel.com>
 * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
 *
 * BSD LICENSE
 *
 * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
 * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
 * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
 * Copyright(c) 2018 Intel Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  * Neither the name Intel Corporation nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************/
#ifndef __VENDOR_CMD_H__
#define __VENDOR_CMD_H__

#define INTEL_OUI	0x001735

/**
 * enum iwl_mvm_vendor_cmd - supported vendor commands
 * @IWL_MVM_VENDOR_CMD_GET_FW_VERSION:
 * @IWL_MVM_VENDOR_CMD_GET_DRV_VERSION:
 */

enum iwl_mvm_vendor_cmd {
	IWL_MVM_VENDOR_CMD_GET_FW_VERSION			= 0x00,
	IWL_MVM_VENDOR_CMD_GET_DRV_VERSION			= 0x01,
};

/**
 * enum iwl_mvm_vendor_attr - attributes used in vendor commands
 * @__IWL_MVM_VENDOR_ATTR_INVALID: attribute 0 is invalid
 * @IWL_MVM_VENDOR_ATTR_DRV_VER: string attribute
 * @IWL_MVM_VENDOR_ATTR_FW_VER: string attribute
 * @NUM_IWL_MVM_VENDOR_ATTR: number of vendor attributes
 * @MAX_IWL_MVM_VENDOR_ATTR: highest vendor attribute number
 */
enum iwl_mvm_vendor_attr {
	__IWL_MVM_VENDOR_ATTR_INVALID,
	IWL_MVM_VENDOR_ATTR_FW_VER,
	IWL_MVM_VENDOR_ATTR_DRV_VER,

	NUM_IWL_MVM_VENDOR_ATTR,
	MAX_IWL_MVM_VENDOR_ATTR = NUM_IWL_MVM_VENDOR_ATTR - 1,
};
#endif /* __VENDOR_CMD_H__ */
