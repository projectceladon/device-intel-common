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

package com.intel.contacts.util;

import java.util.List;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;

import com.android.contacts.common.GroupMetaData;
import com.android.contacts.common.model.Contact;
import com.android.contacts.quickcontact.ExpandingEntryCardView.Entry;
public class ContactsHelper {
    public static String TAG = "ContactsHelper";
    public static String BLACK_URI = "";
    public static final String GROUP_SWITCH = " ";
    public static final String SWITCH_TYPE = " ";
    public static final String SIM_COPY_SWITCH = "  ";
    public static final String CONTACTS_IMPORT_SWITCH = " ";
    public static final String BLACKLIST_SWITCH = " ";

    public static boolean addToBlackList(Context context, String num,
            String blackname) {
        return true;
    }

    public static String getGroupName(List<GroupMetaData> groupMetaData,
            long groupId) {
        return "";
    }

    public static boolean removeSimGroup(String mAccountName,
            String mAccountTypeString, String mGroupName) {
        return false;
    }

    public static boolean insertSimGroup(Context context, int slotId,
            String oldGroupName, String newGroupName) {
        boolean inSertToSim = false;
        return inSertToSim;
    }

    public static int addMembersToSimGroup(Context context,
            long[] rawContactsToAdd, String groupName, String accountName) {
        return -1;
    }

    public static String[] getGroupInformation(ContentResolver resolver,
            int grpId) {
        return null;
    }

    public static int removeMembersfromSimGroup(Context context,
            long[] rawContactsToAdd, String groupName, String accountName) {
        return -1;
    }

    public static boolean removeMembersfromSimGroup(Context context,
            ContentResolver resolver, long[] rawContactsToRemove, long groupId) {
        boolean simflag = false;
        return simflag;
    }

    public static boolean addMembersToSimGroup(Context context,
            ContentResolver resolver, long[] rawContactsToAdd, long groupId) {
        return false;
    }

    public static void doMultiPickContact(Intent data, Context context) {

    }

    public static void doExportContacts(Intent data, Context context) {
    }

    public static void addContactsToBlackList(Context context, long contactId,
            String name) {

    }

    public static Entry getEntry(Contact contactData, String str, long groupId) {
        return null;
    }

    public static int getResourceId(Resources res, String name, String type,
            String packagename) {
        return -1;
    }

    public static boolean isSupport(Context context, int resId) {
        boolean surport = false;
        return surport;
    }
    public static int getSlotId (String name, String type){
        return -1;
    }
    public static boolean isSupport(Context context, String name, String type) {
        return false;
    }

    public static Intent createPickGroupMemberIntent(String accountName,
            String accountType, long groupId) {
        return null;
    }

    public static boolean addSimGroup(Context context, String accountName,
            String accountType, String backName, String groupName) {
        return false;
    }

    public static Intent createBlacklistOrGroupIntent(int blackListResId,
            int groupResId, int itemResId) {
        return null;
    }

    public static void LogContacts(String str) {

    }
}
