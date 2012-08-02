package com.androidworks.navsys.wuffit.service;

import android.app.Service;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.telephony.PhoneNumberUtils;
import android.telephony.gsm.SmsManager;
import android.telephony.gsm.SmsMessage;
import android.util.Log;
import com.androidworks.navsys.wuffit.content.Tracker;

public class SMSHandler extends Service {

    private final IBinder mBinder = new LocalBinder();

    /**
     * Class for clients to access.  Because we know this service always
     * runs in the same process as its clients, we don't need to deal with
     * IPC.
     */
    public class LocalBinder extends Binder {
        public SMSHandler getService() {
            return SMSHandler.this;
        }
    }

    @Override
    public void onStart(Intent intent, int i) {
        super.onStart(intent, i);
        performSMSParsing(intent);
    }

    private void performSMSParsing(Intent intent) {
        Log.d("SMSHandler: ", "Service started " + intent.toString());
        Bundle bundle = intent.getBundleExtra("SMS_BUNDLE");
// read from content://sms/inbox directly
        Object[] pdus = (Object[]) bundle.get("pdus");
        for (Object pdu : pdus) {
            SmsMessage msg = SmsMessage.createFromPdu((byte[]) pdu);
            Log.d("SMSHandler: Message ==> ", msg.toString());
            parseSMSMessage(msg);
        }
        stopSelf();
        Log.d("SMSHandler: ", "Service stopped ");
    }

    private void parseSMSMessage(SmsMessage sms) {
//        String name = sms.getDisplayOriginatingAddress();
        String msg = sms.getDisplayMessageBody();
        String num = sms.getOriginatingAddress();
        String formatnum = PhoneNumberUtils.formatNumber(num);
        Cursor cursor = getContentResolver().query(Tracker.Details.CONTENT_URI,
                new String[]{Tracker.Details._ID, Tracker.Details.NUMBER},
                null, null, null);
        int sz = cursor.getCount();
        if (sz > 0) {
            cursor.moveToFirst();
            for (int i = 0; i < sz; i++) {
                String dbnum = cursor.getString(1);
                if (PhoneNumberUtils.compare(formatnum, dbnum)) {
                    Log.d("SMSHandler:parseSMSMessage: ",
                            "Phone numbers are equal: " + formatnum + " and: " + dbnum);
                    if (msg.contains("$GPRMC")) {
// location
                        updateTrackerLocationReply(msg, cursor.getString(0));
                    } else {
// might be setup update
                        updateTrackerSetupReply(cursor.getString(0), msg);
                    }
                    break;
                }
                cursor.moveToNext();
            }
        }
        cursor.close();
    }

    private void updateTrackerLocationReply(String msg, String fid) {
        ContentValues contentValues = new ContentValues(2);
        contentValues.put(Tracker.Locations.UPDATE_TIME, System.currentTimeMillis());
        contentValues.put(Tracker.Locations.LOCATION, msg);
        String where = Tracker.Locations._FID + " = ? ";
        String[] whereArgs = new String[]{fid};
        getContentResolver().update(Tracker.Locations.CONTENT_URI, contentValues, where, whereArgs);
        Log.d("SMSHandler: ", "Updated: " + Tracker.Locations.CONTENT_URI);
    }

    private void updateTrackerSetupReply(String fid, String reply) {
        ContentValues contentValues = new ContentValues(2);
        contentValues.put(Tracker.Setup.REPLY_TIME, System.currentTimeMillis());
        contentValues.put(Tracker.Setup.REPLY, reply);
        String where = Tracker.Setup._FID + " = ? ";
        String[] whereArgs = new String[]{fid};
        getContentResolver().update(Tracker.Setup.CONTENT_URI, contentValues, where, whereArgs);
        Log.d("SMSHandler: ", "Updated: " + Tracker.Setup.CONTENT_URI);
    }

    public IBinder onBind(Intent intent) {
        return mBinder;
    }

    public void setupWuffIT(String cmd) {
// Send SMS to each tracker, and sets up the wuffit database
        Cursor cursor = getContentResolver().query(Tracker.Details.CONTENT_URI,
                new String[]{Tracker.Details._ID, Tracker.Details.NUMBER},
                null, null, null);
        int sz = cursor.getCount();
        if (0 == sz) {
            Log.w("SMSHandler#setupWuffIT: ",
                    "No Records found in database: " + Tracker.Details.CONTENT_URI);
        } else {
            cursor.moveToFirst();
            for (int i = 0; i < sz; i++) {
                setupWuffIT(cmd, cursor.getString(1), cursor.getString(0));
                cursor.moveToNext();
            }
        }
        cursor.close();
    }

    public void setupWuffIT(String cmd, String num, String id) {
// Send SMS to each tracker, and sets up the wuffit database
        SmsManager.getDefault().sendTextMessage(num, null, cmd, null, null);
        ContentValues contentValues = new ContentValues(1);
        contentValues.put(Tracker.Setup.SETUP_TIME, System.currentTimeMillis());
        String where = Tracker.Setup._FID + " = ? ";
        String[] whereArgs = new String[]{id};
        getContentResolver().update(Tracker.Setup.CONTENT_URI, contentValues, where, whereArgs);
    }


    public void requestLocationUpdates(String cmd) {
// Send SMS to each tracker, and sets up the wuffit database
        Cursor cursor = getContentResolver().query(Tracker.Details.CONTENT_URI,
                new String[]{Tracker.Details._ID, Tracker.Details.NUMBER},
                null, null, null);
        int sz = cursor.getCount();
        if (0 == sz) {
            Log.w("SMSHandler#requestLocationUpdates: ",
                    "No Records found in database: " + Tracker.Details.CONTENT_URI);
        } else {
            cursor.moveToFirst();
            for (int i = 0; i < sz; i++) {
                requestLocationUpdates(cmd, cursor.getString(1), cursor.getString(0));
                cursor.moveToNext();
            }
        }
        cursor.close();
    }

    public void requestLocationUpdates(String cmd, String num, String id) {
// Send SMS to each tracker, and sets up the wuffit database
        SmsManager.getDefault().sendTextMessage(num, null, cmd, null, null);
        ContentValues contentValues = new ContentValues(1);
        contentValues.put(Tracker.Locations.REQUEST_TIME, System.currentTimeMillis());
        String where = Tracker.Locations._FID + " = ? ";
        String[] whereArgs = new String[]{id};
        getContentResolver().update(Tracker.Locations.CONTENT_URI, contentValues, where, whereArgs);
    }


}