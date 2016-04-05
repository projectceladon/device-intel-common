/* INTEL CONFIDENTIAL
** Copyright 2015 Intel Corporation All Rights Reserved.
** The source code contained or described herein and all documents
** related to the source code ("Material") are owned by Intel Corporation
** or its suppliers or licensors. Title to the Material remains with
** Intel Corporation or its suppliers and licensors. The Material contains
** trade secrets and proprietary and confidential information of Intel or
** its suppliers and licensors. The Material is protected by worldwide
** copyright and trade secret laws and treaty provisions. No part of the
** Material may be used, copied, reproduced, modified, published, uploaded,
** posted, transmitted, distributed, or disclosed in any way without Intel's
** prior express written permission.
**
** No license under any patent, copyright, trade secret or other intellectual
** property right is granted to or conferred upon you by disclosure or delivery
** of the Materials, either expressly, by implication, inducement, estoppel or
** otherwise. Any license under such intellectual property rights must be
** express and approved by Intel in writing.
** limitations under the License.
*/

/*
** Copyright (C) 2015 Intel Corporation, All rights reserved
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/

package com.intel.util;

import android.content.Context;
import android.util.SparseIntArray;
import android.widget.ImageButton;
import android.widget.PopupMenu;

import com.android.contacts.common.util.MaterialColorMapUtils.MaterialPalette;
import com.android.incallui.CallButtonFragment;
import com.intel.incallui.RecorderHandler;



public class VoiceRecordUtils implements RecorderHandler.RecorderStateListener {

    public VoiceRecordUtils() {}

    public VoiceRecordUtils (Context context, ImageButton imageButton) {
    }

    public void setListener() {
    }

    public void recorderQuit() {
    }

    public void stopRecord() {
    }

    public void updateRecordMenu(PopupMenu menu,
            SparseIntArray mButtonVisibilityMap) {
    }

    public void recordClicked() {
    }

    @Override
    public void onRecorderStateChanged() {
    }

    public void setRecord(boolean isRecording) {
    }

    public void voiceRecord(CallButtonFragment callButtonFragment) {
    }

    public void updateRecordColors(MaterialPalette themeColors) {
    }

    public void processPermissionResult(int requestCode, int[] grantResults) {
    }
}
