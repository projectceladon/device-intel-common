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

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.net.Uri;
import android.util.Log;

// Add Reflection class
import com.android.contacts.common.model.account.AccountWithDataSet;
import com.android.contacts.common.util.AccountSelectionUtil;
/**
 * Utility class for selecting an Account for importing contact(s)
 */
public class AccountSelectionUtilEx extends AccountSelectionUtil{
    // TODO: maybe useful for EditContactActivity.java...

    protected List<AccountWithDataSet> mAccountList=null;

    public static Uri mPath;


    public static class AccountSelectedListener
            implements DialogInterface.OnClickListener {
        final protected List<AccountWithDataSet> mAccountList;

        public AccountSelectedListener(Context context, List<AccountWithDataSet> accountList,
                int resId, int subscriptionId) {
            mAccountList =null;
        }

        public AccountSelectedListener(Context context, List<AccountWithDataSet> accountList,
                int resId) {
            // Subscription id is only needed for importing from SIM card. We can safely ignore
            // its value for SD card importing.
            this(context, accountList, resId, /* subscriptionId = */ -1);
        }

        public void onClick(DialogInterface dialog, int which) {

        }
    }

    public static void setImportSubscription(int subscription) {}

    public static Dialog getSelectAccountDialog(Context context, int resId,
            DialogInterface.OnClickListener onClickListener,
            DialogInterface.OnCancelListener onCancelListener) {
        return null;
    }

    /**
     * When OnClickListener or OnCancelListener is null, uses a default listener.
     * The default OnCancelListener just closes itself with {@link Dialog#dismiss()}.
     */
    public static Dialog getSelectAccountDialog(Context context, int resId,
            DialogInterface.OnClickListener onClickListener,
            DialogInterface.OnCancelListener onCancelListener, boolean includeSIM) {
        return null;
    }

    public static void doImport(Context context, int resId, AccountWithDataSet account,
            int subscriptionId) {}

    public static void doImportFromSim(Context context, AccountWithDataSet account,
            int subscriptionId) {}

    public static void doImportFromSim2(Context context, AccountWithDataSet account,
            int subscriptionId) {}

    public static void doImportFromMultiSim(Context context,
            AccountWithDataSet account, int selectedSim) {}

//    public static class SimSelectedListener implements
//            DialogInterface.OnClickListener {}

 }

