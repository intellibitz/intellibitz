package com.androidworks.navsys.wuffit;

import android.app.Application;
import android.content.ContentUris;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.provider.Contacts;
import android.util.Log;
import android.widget.Toast;
import com.androidworks.navsys.wuffit.content.Tracker;

public class WuffITApplication extends Application {
    static final String TAG = "WuffITApplication";

    @Override
    public void onCreate() {
        super.onCreate();
    }

    /**
     * stores the tracker name and number in the tracker details database
     *
     * @param id the id to be stored
     * @return boolean true if id stored success, false otherwise
     */
    public boolean storeTrackerId(String id) {
        Cursor cursor = getContentResolver().query
                (Uri.parse(id), new String[]{Contacts.Phones.NUMBER, Contacts.Phones.NAME}, null, null, null);
// ERROR HANDLING
        if (0 == cursor.getCount()) {
            Log.e("WuffITApplication#storeTrackerId: ",
                    "No Records found in database for tracker id: " + id);
            Toast.makeText(this, "No Records found for tracker id: " + id,
                    Toast.LENGTH_LONG).show();
            return false;
        } else {
            cursor.moveToFirst();
            String num = cursor.getString(0);
            String name = cursor.getString(1);
            cursor.close();

// insert tracker details
            ContentValues contentValues = new ContentValues();
            contentValues.put(Tracker.Details.ID, id);
            contentValues.put(Tracker.Details.NUMBER, num);
            contentValues.put(Tracker.Details.NAME, name);
            Uri uri = getContentResolver().insert(Tracker.Details.CONTENT_URI, contentValues);
            Log.d("WuffITApplication#storeTrackerId: ", uri.toString());

// insert tracker setup row
            contentValues.clear();
            contentValues.put(Tracker.Setup._FID, uri.getPathSegments().get(1));
            uri = getContentResolver().insert(Tracker.Setup.CONTENT_URI, contentValues);
            Log.d("WuffITApplication#storeTrackerId: ", uri.toString());

// insert tracker location row
            uri = getContentResolver().insert(Tracker.Locations.CONTENT_URI, contentValues);
            Log.d("WuffITApplication#storeTrackerId: ", uri.toString());

            return true;

        }
    }

    public void syncTrackers() {
// fetch all trackers
        Cursor cursor = getContentResolver().query(Tracker.Details.CONTENT_URI,
                new String[]{Tracker.Details._ID, Tracker.Details.ID},
                null, null, null);
        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            do {
                String u = cursor.getString(1);
                Cursor c = getContentResolver().query
                        (Uri.parse(u), new String[]{Contacts.Phones.NUMBER,
                                Contacts.Phones.NAME}, null, null, null);
// ERROR HANDLING
                if (0 == c.getCount()) {
                    Log.e("WuffITApplication#syncTrackers: ",
                            "No Records found in database for tracker id: " + u);
                } else {
                    c.moveToFirst();
                    String num = c.getString(0);
                    String name = c.getString(1);
                    c.close();
// update tracker details
                    ContentValues contentValues = new ContentValues();
                    contentValues.put(Tracker.Details.NUMBER, num);
                    contentValues.put(Tracker.Details.NAME, name);
                    String where = Tracker.Details._ID + " = ? ";
                    String[] whereArgs = new String[]{cursor.getString(0)};
                    int count = getContentResolver().update
                            (Tracker.Details.CONTENT_URI, contentValues,
                                    where, whereArgs);
                    Log.d("WuffITApplication#syncTrackers: ", "Updated: " + count);
                    Toast.makeText(this, "Updated: " + name, Toast.LENGTH_SHORT).show();
                }

            } while (cursor.moveToNext());
        }
    }

    public void deleteTracker(String id) {
        Uri uri = ContentUris.withAppendedId
                (Tracker.Details.CONTENT_URI, Long.valueOf(id));
        int count = getContentResolver().delete(uri, null, null);
        Log.d(TAG, "Deleted: " + uri + " :count= " + count);

        String where = Tracker.Locations._FID + " = ? ";
        String[] whereArgs = new String[]{id};

        count = getContentResolver().delete
                (Tracker.Locations.CONTENT_URI, where, whereArgs);
        Log.d(TAG, "Deleted: " + Tracker.Locations.CONTENT_URI + where + whereArgs + " :count= " + count);

        count = getContentResolver().delete
                (Tracker.Setup.CONTENT_URI, where, whereArgs);
        Log.d(TAG, "Deleted: " + Tracker.Setup.CONTENT_URI + where + whereArgs + " :count= " + count);
    }
}
