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

import java.util.List;

import android.accounts.Account;
import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.telecom.PhoneAccountHandle;
// Add Reflection class
import com.intel.internal.telephony.ex.IIccPhoneBookEx;
import com.intel.internal.telephony.ex.GroupRecord;

public class SimCardUtil {

    private static final String TAG = "SimCardUtil";
    public static final int MAX_LENGTH_NAME_IN_SIM = -1;
    public static final int MAX_LENGTH_NAME_WITH_CHINESE_IN_SIM =-1;
    public static final int MAX_LENGTH_NUMBER_IN_SIM = -1;
    public static final int MAX_LENGTH_EMAIL_IN_SIM = -1;
    public static final String[] MULTI_SIM_NAME =null;

    public static final String PREFERRED_SIM_ICON_INDEX = null;
    public static final String[] IPCALL_PREFIX = null;
    public final static int[] IC_SIM_PICTURE = {};

    /**
     * Get SIM card account name
     */
    public static String getSimAccountName(int subscription) {
        return null;
    }

    public static int getSubscription(String accountType, String accountName) {
        return -1;
    }

    public static int getAnrCount(int slot) {
        return -1;
    }

    public static IIccPhoneBookEx getIccIpb() {
        return null;
    }

    public static int getGroupCount(int slot) {
        return -1;
    }

    public static String getGroupName(int slot, int grpId)
            throws android.os.RemoteException {
        return null;
    }

    public static boolean insertGroup(int slot, String group_name)
            throws android.os.RemoteException {
        return false;
    }

    public static int insertGroupToSim(int slot, String group_name)
            throws android.os.RemoteException {
        return -1;
    }

    public static boolean removeGroup(int slot, String group_name)
            throws android.os.RemoteException {
        return false;
    }

    public static int getSimGroupId(int slot, String group_name, boolean insert)
            throws android.os.RemoteException {
        int groupId = -1;
        return groupId;
    }

    public static boolean updateGroup(int slot, int groupId,
            String new_groupname) throws android.os.RemoteException {
        return false;
    }

    public static List<GroupRecord> getGroups(int slot)
            throws android.os.RemoteException {
        return null;
    }

    public static int getAdnCount(int subscription) {
        return 0;
    }

    public static int getEmailCount(int slot) {

        return 0;
    }

    /**
     * Returns the subscription's card can save anr or not.
     */
    public static boolean canSaveAnr(Context context, int slot) {
        return false;
    }

    /**
     * Returns the subscription's card can save email or not.
     */
    public static boolean canSaveEmail(Context context, int subscription) {
        return false;
    }

    public static boolean isUsim(Context context, int subscription) {

        return false;
    }

    public static int getOneSimAnrCount(int slot) {
        return -1;
    }

    public static int getOneSimEmailCount(int slot) {
        return -1;
    }

    public static boolean insertToPhone(String[] values,
            final ContentResolver resolver, int sub) {
        return false;
    }

    public static Uri insertToCard(Context context, String name, String number,
            String emails, String anrNumber, int subscription) {
        return null;
    }

    public static Account getAcount(int sub) {
        return null;
    }

    public static int getEnabledSimCount() {
        return -1;
    }

    public static int getSimFreeCount(Context context, int sub) {
        return -1;
    }

    public static int getSpareAnrCount(int sub) {
        return -1;
    }

    public static int getSpareEmailCount(int sub) {
        return -1;
    }

    /**
     * Get SIM card aliases name, which defined in Settings
     */
    public static String getMultiSimAliasesName(Context context,
            int subscription) {
        return null;
    }

    /**
     * Get SIM card icon index by subscription
     */
    public static int getCurrentSimIconIndex(Context context, int subscription) {
        return -1;
    }

    /**
     * Get Network SPN name, e.g. China Unicom
     */
    public static String getNetworkSpnName(Context context, int subscription) {
        return null;
    }

    public static String toUpperCaseFirstOne(String s) {
        return null;
    }

    public static String getDisabledSimFilter() {
        return null;
    }

    /**
     * Check one SIM card is enabled
     */
    public static boolean isMultiSimEnable(Context context, int slotId) {
        return false;
    }

    public static boolean isMultiSimEnable(Context context) {
        return false;
    }

    public static PhoneAccountHandle getAccount(int slot) {
       return null;
    }

    public static int[] getSubId(int subscription) {
        return null;
    }

    public static boolean isAPMOnAndSIMPowerDown(Context context) {
        return false;
    }

    public static int getSlotId(String subscriptionId) {
        return 0;
    }

    public static void LogContacts(String str) {
        Log.d(TAG + "Intel", str);
    }
}
