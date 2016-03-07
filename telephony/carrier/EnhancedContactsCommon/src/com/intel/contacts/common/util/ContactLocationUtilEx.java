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

import android.content.Context;
import android.database.Cursor;
import android.widget.ImageView;

import com.android.contacts.common.list.ContactListItemView;
import com.intel.contacts.common.util.ContactLocationUtilEx;

public class ContactLocationUtilEx {
    private static ContactLocationUtilEx mContactLocationUtilEx;

    private ContactLocationUtilEx() {
    }

    public static ContactLocationUtilEx newInstance() {
        if (mContactLocationUtilEx == null) {
            mContactLocationUtilEx = new ContactLocationUtilEx();
        }
        return mContactLocationUtilEx;
    }

    public int getNameTextWidthByAccountTypeIco(boolean switchAccountStorage,
            int textIndent) {

        return 0;
    }

    public int setAccountTypeIcoLayout(boolean switchAccountStorage,
            ImageView accountType, int rightBound, int topBound, int bottomBound) {
        return 0;
    }

    /**
     * @return Projection useful for children.
     */
    public final String[] getProjection(boolean forSearch, int sortOrder) {
        return null;
    }

    /**
     * Returns the image view for the contacts list.
     */
    public ImageView getAccountTypeIco(ContactListItemView view) {
        return null;
    }

    public void setAccountTypeIco(ContactListItemView view, Cursor cursor) {
    }

    public boolean isEnable(Context context, String name, String type) {
        return false;
    }
}
