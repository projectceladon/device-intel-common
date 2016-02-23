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

package com.intel.providers.telephony;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;

import com.android.providers.telephony.SmsProvider;

public class MmsDelChmodSmsProvider extends SmsProvider{

    //DUAL SIM
    public static final int INVALID_SUBSCRIPTION = -1;
    public static final int SUB1 = com.android.internal.telephony.PhoneConstants.SUB1;
    public static final int SUB2 = com.android.internal.telephony.PhoneConstants.SUB2;
    //QUERY
    public static final int MESSAGE_ID = 1;
    //DELETE
    public static final int DELETE_FAIL = 0;
    //INSERT
    private static final Uri INSERT_SMS_INTO_ICC_FAIL = Uri.parse("content://iccsms/fail");

    public static final int SMS_ALL_ICC1 = 28;
    public static final int SMS_ICC1 = 29;
    public static final int SMS_ALL_ICC2 = 30;
    public static final int SMS_ICC2 = 31;

    public MmsDelChmodSmsProvider(Context context) {

    }

    public int deleteOnce(Uri url, String where, String[] whereArgs) {
        return 0;
    }

    @Override
    public Cursor query(Uri url, String[] projectionIn, String selection, String[] selectionArgs,
            String sort) {
        return null;
    }

    public int deleteNormal(Uri url, String where, String[] whereArgs) {
        return 0;
    }

    public Uri insertMessageIntoIcc(ContentValues values) {
        return INSERT_SMS_INTO_ICC_FAIL;
    }

    public static byte[] getSubmitPdu(String scAddress,
            String destinationAddress, String message, boolean statusReportRequested, int subId) {
        return "".getBytes();
    }

    public static byte[] getDeliveryPdu(String scAddress, String destinationAddress, String message,
            long date, int subscription) {
        return "".getBytes();
    }

    public static byte[] getCdmaDeliveryPdu(String scAddress, String destinationAddress,
            String message, long date) {
        return "".getBytes();
    }

    /**
     * Generate a Delivery PDU byte array. see getSubmitPdu for reference.
     */
    public static byte[] getGsmDeliveryPdu(String scAddress, String destinationAddress,
            String message, long date, byte[] header, int encoding) {
        return "".getBytes();
    }

    /**
     * The following method is for deleting message from icc of dual sim.
     * */
    public int deleteMessageFromIcc(String messageIndexString, int phoneId) {
        return 0;
    }

    /**
     * The following method is for querying message from icc of dual sim.
     * */
    public Cursor getAllMessagesFromIcc(int phoneId) {
        return null;
    }

    public Cursor getSingleMessageFromIcc(String messageIndexString, int phoneId) {
        return null;
    }

}
