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

package com.intel.contacts.common.interactions;

import java.util.ArrayList;

import android.app.Activity;
import android.app.Dialog;
import android.app.FragmentManager;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import com.android.contacts.common.interactions.ImportExportDialogFragment;
import com.android.contacts.common.model.account.AccountWithDataSet;
// Add Reflection class

/**
 * An dialog invoked to import/export contacts.
 */
public class ImportExportDialogFragmentEx extends ImportExportDialogFragment {
    public static final String TAG = "StubImportExportDialogFragment";
    public static final int SUBACTIVITY_EXPORT_CONTACTS = -1;
    public static final int SUBACTIVITY_SHARE_VISILBLE_CONTACTS = -1;
    public static final int MAX_COUNT_ALLOW_SHARE_CONTACT =-1;
    // This value needs to start at 7. See {@link PeopleActivity}.
    public static final int SUBACTIVITY_MULTI_PICK_CONTACT =-1000;
    // TODO: we need to refactor the export code in future release.
    // QRD enhancement: export subscription selected by user
    public static int mExportSub;

    // this flag is the same as defined in MultiPickContactActivit
    public static boolean isExportingToSIM() {
        return false;
    }

    public ExportToSimThread createExportToSimThread(int subscription,
            ArrayList<String[]> contactList, Context context) {

        return null;
    }

    public static void destroyExportToSimThread() {

    }

    public void showExportToSIMProgressDialog(Activity activity) {
    }

    public static void show(FragmentManager fragmentManager,
            boolean contactsAreAvailable, Class callingActivity) {
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        return null;
    }

    @Override
    public void onAccountChosen(AccountWithDataSet account, Bundle extraArgs) {
    }

    /**
     * Handle "import from SIM" and "import from SD".
     *
     * @return {@code true} if the dialog show be closed. {@code false}
     *         otherwise.
     */

    public class ImportFromSimSelectListener implements
            DialogInterface.OnClickListener {
        public void onClick(DialogInterface dialog, int which) {

        }
    }

    public void showSimSelectDialog() {
    }

    public ImportFromSimSelectListener listener;

    /**
     * A thread that export contacts to sim card
     */
    public class ExportToSimThread extends Thread {
    }
}
