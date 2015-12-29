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

import com.intel.providers.contacts.ContactsProviderApplication;

import android.app.Application;
import android.content.Context;

public final class ContactsProviderApplication extends Application {

    private static ContactsProviderApplication sContactsProviderApplication;
    public final String GROUP_SWITCH = "group";
    public final String SWITCH_TYPE = "bool";
    public final String BLACKLIST_SWITCH = "black";

    @Override
    public void onCreate() {

    }

    private ContactsProviderApplication() {
    }

    public static ContactsProviderApplication newInstance() {
        if (sContactsProviderApplication == null) {
            sContactsProviderApplication = new ContactsProviderApplication();
        }
        return sContactsProviderApplication;
    }
    public void setContext(Context context) {

    }

    public Context getContext() {
        return null;
    }

    public boolean isEnableGroup(){
        return false;
    }
    public boolean isEnableBlackList(){
        return false;
    }
}
