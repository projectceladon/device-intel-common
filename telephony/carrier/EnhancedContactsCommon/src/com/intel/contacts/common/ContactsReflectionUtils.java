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

package com.intel.contacts.common;

import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.telephony.TelephonyManager;

public class ContactsReflectionUtils {

    // Field
    // IccCardConstants
    public static final String INTENT_KEY_ICC_STATE = null;
    public static final String INTENT_VALUE_ICC_ABSENT = null;
    public static final String INTENT_VALUE_ICC_LOADED = null;
    public static final String INTENT_VALUE_ICC_CARD_IO_ERROR = null;
    // TelephonyIntents
    public static final String ACTION_SIM_STATE_CHANGED = null;
    // Intents(android.provider.ContactsContract.Intents)
    public static final String EXTRA_PHONE_URIS = null;
    // Method
    // TelephonyManager
    public static TelephonyManager TelephonyManager_getDefault() {

        return null;
    }

    public static boolean TelephonyManager_isMultiSimEnabled() {

        return false;
    }

    public static boolean TelephonyManager_hasIccCard() {

        return false;
    }

    public static boolean TelephonyManager_hasIccCard(int slotId) {

        return false;
    }

    public static int TelephonyManager_getPhoneCount() {

        return 0;
    }

    public static int TelephonyManager_getSimState() {

        return 0;
    }

    public static int TelephonyManager_getSimState(int slotIdx) {

        return 0;
    }

    public static String TelephonyManager_getSimSerialNumber() {

        return null;
    }

    public static String TelephonyManager_getSimSerialNumber(int subId) {

        return null;
    }

    public static String TelephonyManager_getNetworkOperatorName() {

        return null;
    }

    public static String TelephonyManager_getNetworkOperatorName(int subId) {

        return null;
    }

    // SubcriptionManager
    public static int SubscriptionManager_getSlotId(int subId) {

        return -1;
    }

    public static int SubscriptionManager_getDefaultSubId() {

        return -1;
    }

    public static int[] SubscriptionManager_getSubId(int slotId) {

        return null;
    }

    public static int SubscriptionManager_getPhoneId(int subId) {

        return 0;
    }

    public static int SubscriptionManager_getAllSubscriptionInfoCount(
            Context context) {

        return 0;
    }

    // Intent
    public static Object Intent_getExtra(Intent intent, String name) {

        return null;
    }

    // PhoneNumberUtils
    public static boolean PhoneNumberUtils_isUriNumber(String number) {

        return false;
    }

    // Resources
    /*-----------SystemProperty------------*/
    public static String getStringBySystemProperty(String prop) {

        return null;
    }

    public static String getStringBySystemProperty(String prop, String def) {

        return def;
    }

    public static int getIntBySystemProperty(String prop, int def) {

        return def;
    }

    public static boolean getBooleanBySystemProperty(String prop, boolean def) {

        return def;
    }

    public static void setStringBySystemProperty(String prop, String val) {

    }

    /*-----------ServiceManager------------*/
    public static IBinder getServiceByServiceManager(String serviceName) {

        return null;
    }

    /*-----com.android.internal.R----------*/
    public static int getBooleanIdFromInternalR(String res) {
        return -1;
    }

    public static int getStringIdFromInternalR(String res) {

        return -1;
    }

    public static int getStyleIdFromInternalR(String res) {

        return -1;
    }
}
