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

package com.intel.providers.contacts;

import java.util.List;
import java.util.Locale;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import com.android.common.content.ProjectionMap;
import com.android.providers.contacts.AccountWithDataSet;
import com.android.providers.contacts.aggregation.util.MatchScore;

public class ContactsProviderHelper {

    public static final String PHONE_NAME = "";
    public static final String ACCOUNT_TYPE_PHONE = "";
    public static final String ACCOUNT_TYPE_SIM = "";
    public static final int BACKGROUND_TASK_ADD_DEFAULT_CONTACTS = 12;

    public static String WITHOUT_SIM_FLAG = "no_sim";
    public static boolean isWhereAppended = false;
    public static final String ADD_GROUP_MEMBERS = "";
    public static final int DELETED_BLACKLIST = 23002;

    public static final AccountWithDataSet LOCAL = new AccountWithDataSet(
            null, null, null);
    public static final String BLACK_LIST = "";

    public static final String CONTACTS_IN_GROUP_ID_SELECT = null;

    public static final String CONTACTS_NOT_IN_GROUP_ID_SELECT = null;

    public static void createPhoneAccount(SQLiteDatabase db) {
    }

    public static void rebuildDefaultGroupTitles(Context context,
            SQLiteDatabase db, Locale locale) {
    }

    public static void buildGroupFilter(Uri uri, SQLiteQueryBuilder qb) {
    }

    public static void buildselectionArgs(String[] selectionArgs, Uri uri,
            SQLiteQueryBuilder qb, long groupId) {
    }

    public static long getGroupId(Uri uri) {
            return -1;
    }

    public static void createSbwhereWithoutSim(Uri uri, long[] accountId,
            StringBuilder sbWhere) {
    }

    public static void createSbWhereWithSIM(long[] accountId, StringBuilder sb) {
    }

    public static void createSbwhereWithSim(Long accountId,
            StringBuilder sbWhere) {
    }

    public static void checkSbWhere(SQLiteQueryBuilder qb,
            StringBuilder sbWhere, StringBuilder sb, String withoutSim) {
    }

    public static long[] getAccountIdWithoutSim(Uri uri, String accountType,
            String accountName, SQLiteOpenHelper contactsHelper) {
        return null;
    }

    public static final String GROUP_MEMBER_COUNT = null;

    public static final String Local_ACCOUNT_ID = null;

    public static void appendGroupBuilder(StringBuilder sb) {
    }

    public static void trimSimContactMatches(SQLiteDatabase db,
            List<MatchScore> bestMatches) {
    }

    public static final String RAW_CONTACT_IS_LOCAL = "raw_contacts.account_id "
            + "=" + Local_ACCOUNT_ID;

    public static String contactIsVisibleEx(String zeroGroupMemberships,
            String rawContactsJoinSettingsDataGroups,
            String outerRawContactsId, String outerRawContacts){
        return "";
    }

    public static boolean isEnableGroup(Context mContext) {
        return false;
    }

    public static boolean isEnableBlackList(Context mContext) {
        return false;
    }

    public static ProjectionMap contactsProjectionMapEx(
            ProjectionMap sContactsProjectionMap){
        return null;
    }

    public static ProjectionMap contactsProjectionWithSnippetMapEx(
            ProjectionMap contactsProjectionMap_EX,
            ProjectionMap snippetColumns){
        return null;
    }

    public static ProjectionMap strequentStarredProjectionMapEx(
            ProjectionMap sContactsProjectionMap_EX){
        return null;
    }

    public static ProjectionMap strequentFrequentProjectionMapEx(
            ProjectionMap sContactsProjectionMap_EX){
        return null;
    }

    public static ProjectionMap sStrequentPhoneOnlyProjectionMapEx(
            ProjectionMap sContactsProjectionMap_EX){
        return null;
    }
}
