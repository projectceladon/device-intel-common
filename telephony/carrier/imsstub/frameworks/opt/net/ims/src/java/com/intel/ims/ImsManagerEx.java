/*
 * Copyright (c) 2015 The Android Open Source Project
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

package com.intel.ims;

import android.content.Context;

import com.android.ims.ImsConfig;

public class ImsManagerEx {

    public static boolean isVolteEnabledByUser(Context context) {
        return false;
    }

    public static void setVolteModeSetting(Context context, boolean enabled) {
    }

    public static boolean isVtEnabledByUser(Context context) {
        return false;
    }

    public static void setVtModeSetting(Context context, boolean enabled) {
    }

    public static boolean isVtProvisionedOnDevice(Context context) {
        return false;
    }

    public static int getWfcRoamingMode(Context context, int wfcMode) {
        return ImsConfig.WfcModeFeatureValueConstants.WIFI_ONLY;
    }

    public static void setWfcRoamingMode(Context context, int wfcMode) {
    }

    public static void setWfcRoamingModeInternal(Context context, int wfcMode) {
    }

    public static boolean isWfcProvisionedOnDevice(Context context) {
        return false;
    }

    public static boolean isEabPRovisionnedOnDevice(Context context) {
        return false;
    }
}