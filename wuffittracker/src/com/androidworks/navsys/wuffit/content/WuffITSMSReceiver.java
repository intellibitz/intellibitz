package com.androidworks.navsys.wuffit.content;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class WuffITSMSReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Intent serviceIntent = new Intent("com.androidworks.navsys.wuffit.SERVICE_SMS_HANDLER");
        serviceIntent.putExtra("SMS_BUNDLE", intent.getExtras());
        context.startService(serviceIntent);
    }
}