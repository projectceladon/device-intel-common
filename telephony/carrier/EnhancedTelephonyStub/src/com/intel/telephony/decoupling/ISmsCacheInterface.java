/*
 * INTEL CONFIDENTIAL
 *
 * Copyright 2015 Intel Corporation All Rights Reserved.
 * The source code contained or described herein and all documents
 * related to the source code ("Material") are owned by Intel Corporation
 * or its suppliers or licensors. Title to the Material remains with
 * Intel Corporation or its suppliers and licensors. The Material contains
 * trade secrets and proprietary and confidential information of Intel or
 * its suppliers and licensors. The Material is protected by worldwide
 * copyright and trade secret laws and treaty provisions. No part of the
 * Material may be used, copied, reproduced, modified, published, uploaded,
 * posted, transmitted, distributed, or disclosed in any way without Intel's
 * prior express written permission.
 *
 * No license under any patent, copyright, trade secret or other intellectual
 * property right is granted to or conferred upon you by disclosure or delivery
 * of the Materials, either expressly, by implication, inducement, estoppel or
 * otherwise. Any license under such intellectual property rights must be
 * express and approved by Intel in writing.
 * limitations under the License.
 */

/*
 * Copyright (C) 2015 The Android Open Source Project
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

package com.intel.telephony.decoupling;

import java.util.ArrayList;
import java.util.List;

public interface ISmsCacheInterface {

    public void setPhoneBase(Object phone);
    /**
     * Return the SMS cache list.
     *
     * @return List<SmsRawData>.
     */
    public Object getSmsCache();

    public void reset();

    /**
     * Update SMS cache list.
     *
     * @param sms List<SmsRawData>.
     * @param index record index of message to update.
     */
    public void updateMessageOnCache(Object sms, int index);

    /**
     * Insert message to SMS cache list.
     *
     * @param sms List<SmsRawData>.
     * @param index record index of message to update.
     * @param ar.
     */
    public void insertMessageOnCache(Object sms, int index, Object ar);

    /**
     * Mark SMS as read after importing it from Icc card and update cache.
     *
     * @param scAddress List<SmsRawData>.
     * @return List<SmsRawData>.
     */
    public Object markMessagesAsReadSync(Object sms);

    /**
     * Convert to SmsRawData
     *
     * @param status message status (STATUS_ON_ICC_READ, STATUS_ON_ICC_UNREAD, STATUS_ON_ICC_SENT,
     *            STATUS_ON_ICC_UNSENT)
     * @param pdu the raw PDU to store
     * @param smsc the SMSC for this message, or NULL for the default SMSC
     * @return SmsRawData
     */
    public Object convertPduToRaw(int status, byte[] pdu, byte[] smsc);
}
