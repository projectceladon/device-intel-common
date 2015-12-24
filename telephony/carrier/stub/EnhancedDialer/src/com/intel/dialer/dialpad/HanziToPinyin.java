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


package com.intel.dialer.dialpad;

import java.util.ArrayList;

/**
 * An object to convert Chinese character to its corresponding pinyin string.
 * For characters with multiple possible pinyin string, only one is selected
 * according to ICU Transliterator class. Polyphone is not supported in this
 * implementation.
 */

public class HanziToPinyin {

    private static HanziToPinyin sInstance;

    public static class Token {

        public Token() {
        }

        public Token(int type, String source, String target) {
        }
    }

    public boolean hasChineseTransliterator() {
        return false;
    }

    public static HanziToPinyin getInstance() {
        synchronized (HanziToPinyin.class) {
            if (sInstance == null) {
                sInstance = new HanziToPinyin();
            }
            return sInstance;
        }
    }

    public String transliterate(final String input) {
        return "";
    }

    /**
     * Convert the input to a array of tokens. The sequence of ASCII or Unknown characters without
     * space will be put into a Token, One Hanzi character which has pinyin will be treated as a
     * Token. If there is no Chinese transliterator, the empty token array is returned.
     */

    public ArrayList<Token> get(final String input) {
        return null;
    }

    public String getNameNumber(String name) {
        return "";
    }

    public String getNumberFormChar(char c) {
        return "";
    }
}
