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

import java.util.ArrayList;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.net.Uri;

// Add Reflection class
import com.android.contacts.common.model.RawContactDelta;
import com.android.contacts.common.model.RawContactDeltaList;
import com.intel.contacts.common.SimContactsOperation;

public class SimContactsOperation {

    public static final int RESULT_SUCCESS = -1;
    public static final int RESULT_FAILURE = -1;
    public static final int RESULT_OVER = -1;
    public static final String[] ACCOUNT_PROJECTION = new String[] {};

    public static final int RESULT_NO_NUMBER_AND_EMAIL = -1;
    public static final int RESULT_SIM_FAILURE = -1;
    public static final int RESULT_AIR_PLANE_MODE = -1;

    public static final int RESULT_EMAIL_FAILURE = -1; // only for sim email
                                                       // operation failure
    // only for sim failure of number or anr is too long
    public static final int RESULT_NUMBER_ANR_FAILURE = -1;
    public static final int RESULT_SIM_FULL_FAILURE = -1; // only for sim card
                                                          // is
                                                          // full
    public static final int RESULT_TAG_FAILURE = -1; // only for sim failure of
                                                     // name is too long
    public static final int RESULT_NUMBER_INVALID = -1; // only for sim failure
                                                        // of number is valid

    public static final int RESULT_MEMORY_FULL_FAILURE = -1; // for memory full
                                                             // exception
    public static final int RESULT_NUMBER_TYPE_FAILURE = -1; // only for sim
                                                             // failure of
                                                             // number TYPE
    private ContentValues mValues = new ContentValues();

    private static SimContactsOperation mSimContactsOperation;

    public static SimContactsOperation newInstance(Context context) {
        if (mSimContactsOperation == null) {
            mSimContactsOperation = new SimContactsOperation(context);
        }
        return mSimContactsOperation;
    }

    private SimContactsOperation(Context context) {
    }

    public Uri insert(ContentValues values, int subscription) {
        return null;
    }

    public int update(ContentValues values, int subscription) {

        return -1;
    }

    public int updateContactsToGroup(ContentValues values, int subscription) {
        return -1;
    }

    public ArrayList<String> getGroupIdsByContacts(int solt, long rawContactId) {
        return null;
    }

    public int delete(ContentValues values, int subscription) {
        return -1;
    }

    public static ContentValues getSimAccountValuesByRawContactId(
            long rawcontactId, String groupIds) {
        return null;
    }

    public static ContentValues getSimAccountValues(long contactId) {
        return null;
    }

    public static int getSimSubscription(long contactId) {
        return -1;
    }

    public void wrappedDeleteSimContact(Uri contactUri) {
    }

    public int wrappedSaveSimContact(Context context, RawContactDelta entity,
            ContentResolver resolver, int subscription) {
        return -1;
    }

    public int updateSimContact(Context context, RawContactDeltaList state,
            ContentResolver resolver) {
        return -1;
    }
}
