package com.intel.phone;

import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceScreen;
import android.preference.SwitchPreference;

import com.android.internal.telephony.Phone;

public class DvpOption {

    public DvpOption(PreferenceActivity prefActivity, PreferenceScreen prefScreen,
        Phone phone) {
    }

    public void updatePhone(Phone phone) {
    }

    public SwitchPreference getDvpPreference() {
        return null;
    }

    public boolean preferenceTreeClick(Preference preference) {
        return false;
    }

    public void init() {
    }
}
