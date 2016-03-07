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

package com.intel.contacts.common.util;

//import android.os.SystemProperties;
// Add Reflection class

public class SimContactsUtil {

    public static final String TAG = "SimContacts";

    public static String getSimAccountName(int subscription) {
        return null;
    }

    public static boolean isMultiSimEnabled() {
        return false;
    }

    public static int getPhoneCount() {
        return -1;
    }

    public static boolean supportSne() {
        return false;
    }

    public static boolean supportAas() {
        return false;
    }

    public static boolean supportAnr2() {
        return false;
    }

    public static final String ACCOUNT_NAME_PHONE = null;
    public static final String ACCOUNT_TYPE_SIM = null;
    public static final String ACCOUNT_TYPE_PHONE = null;
    public static final String ACCOUNT_PASSWORD = "";
    public static final String EXTRA_ACCOUNT_NAME = "";
    public static final String AUTHORITY = "";
    public static final String STR_TAG = "";
    public static final String STR_NUMBER = "";
    public static final String STR_EMAILS = "";
    public static final String STR_ANRS = "";
    public static final String STR_NEW_TAG = "";
    public static final String STR_NEW_NUMBER = "";
    public static final String STR_NEW_EMAILS = "";
    public static final String STR_NEW_ANRS = "";
    public static final String STR_PIN2 = "";
    public static final String USIM = "";
    public static final int SIM_STATE_LOAD = -1;
    public static final int SIM_STATE_READY = -1;
    public static final int SIM_STATE_NOT_READY = -1;
    public static final int SIM_STATE_ERROR = -1;
    public static final int SIM_STATE_SWAP = -1;
    public static final int SIM_REFRESH_UPDATE = -1;
    public static final String SIM_STATE = "";
    public static final String SUBSCRIPTION_KEY = "";

    public static final String AAS_TYPE = "";

    public static final String STR_ANRAAS = "";
    public static final String STR_NEW_ANRAAS = "";
    public static final String STR_ANR2AAS = "";
    public static final String STR_NEW_ANR2AAS = "";
    // these value must as same as
    // frameworks/base/telephony/java/com/android/internal/telephony/IccCardConstants.java
    // definition
    /* The extra data for broacasting intent INTENT_ICC_STATE_CHANGE */
    public static final String INTENT_KEY_ICC_STATE = "";
    /* UNKNOWN means the ICC state is unknown */
    public static final String INTENT_VALUE_ICC_UNKNOWN = "";
    /*
     * NOT_READY means the ICC interface is not ready (eg, radio is off or
     * powering on)
     */
    public static final String INTENT_VALUE_ICC_NOT_READY = "";
    /* ABSENT means ICC is missing */
    public static final String INTENT_VALUE_ICC_ABSENT = "";
    /* CARD_IO_ERROR means for three consecutive times there was SIM IO error */
    public static final String INTENT_VALUE_ICC_CARD_IO_ERROR = "";
    /* LOCKED means ICC is locked by pin or by network */
    public static final String INTENT_VALUE_ICC_LOCKED = "";
    /* READY means ICC is ready to access */
    public static final String INTENT_VALUE_ICC_READY = "";
    /* IMSI means ICC IMSI is ready in property */
    public static final String INTENT_VALUE_ICC_IMSI = "";
    /* LOADED means all ICC records, including IMSI, are loaded */
    public static final String INTENT_VALUE_ICC_LOADED = "";

}
