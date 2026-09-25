package com.androidworks.navsys.wuffit.content;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.net.Uri;
import android.provider.BaseColumns;
import android.util.Log;

public class Tracker {

    // This class cannot be instantiated
    private Tracker() {
    }

    public static final String AUTHORITY = "com.androidworks.navsys.wuffit.content.Tracker";
    public static final String DATABASE_NAME = "trackers.db";
    public static final int DATABASE_VERSION = 3;

    /**
     * This class helps open, create, and upgrade the database file.
     */
    static class DatabaseHelper
            extends SQLiteOpenHelper {

        DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            db.execSQL("CREATE TABLE " + Details.TABLE_NAME + " ("
                    + Details._ID + " INTEGER PRIMARY KEY,"
                    + Details.ID + " INTEGER NOT NULL UNIQUE,"
                    + Details.NAME + " TEXT NOT NULL UNIQUE,"
                    + Details.NUMBER + " TEXT NOT NULL UNIQUE"
                    + ");");
            db.execSQL("CREATE TABLE " + Setup.TABLE_NAME + " ("
                    + Setup._ID + " INTEGER PRIMARY KEY,"
                    + Setup._FID + " INTEGER NOT NULL UNIQUE,"
                    + Setup.REPLY + " TEXT,"
                    + Setup.REPLY_TIME + " INTEGER,"
                    + Setup.SETUP_TIME + " INTEGER"
                    + ");");
            db.execSQL("CREATE TABLE " + Locations.TABLE_NAME + " ("
                    + Locations._ID + " INTEGER PRIMARY KEY,"
                    + Locations._FID + " INTEGER NOT NULL UNIQUE,"
                    + Locations.LOCATION + " TEXT,"
                    + Locations.UPDATE_TIME + " INTEGER,"
                    + Locations.REQUEST_TIME + " INTEGER"
                    + ");");
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            Log.w("Trackers#DatabaseHelper ==>", "Upgrading database from version " + oldVersion + " to "
                    + newVersion + ", which will destroy all old data");
            db.execSQL("DROP TABLE IF EXISTS " + Details.TABLE_NAME);
            db.execSQL("DROP TABLE IF EXISTS " + Setup.TABLE_NAME);
            db.execSQL("DROP TABLE IF EXISTS " + Locations.TABLE_NAME);
            onCreate(db);
        }
    }

    /**
     * Common Trackers columns
     */
    public static class TrackerColumns
            implements BaseColumns {

        private TrackerColumns() {/*This class cannot be instantiated*/}

        static final String CONTENT_TYPE_PREFIX = "vnd.navsys.cursor.dir/vnd.navsys.";
        static final String CONTENT_ITEM_TYPE_PREFIX = "vnd.navsys.cursor.item/vnd.navsys.";
        static final String CONTENT_URI_PREFIX = "content://";
        static final String CONTENT_SEPARATOR = "/";
    }

    public static final class Details
            extends TrackerColumns {
        private Details() {/*This class cannot be instantiated*/}

        public static final String TABLE_NAME = "details";

        public static final String CONTENT_TYPE = CONTENT_TYPE_PREFIX + TABLE_NAME;
        public static final String CONTENT_ITEM_TYPE = CONTENT_ITEM_TYPE_PREFIX + TABLE_NAME;
        public static final Uri CONTENT_URI = Uri.parse(CONTENT_URI_PREFIX
                + AUTHORITY + CONTENT_SEPARATOR + TABLE_NAME);

        public static final String ID = "id";
        public static final String NAME = "name";
        public static final String NUMBER = "number";
    }

    public static final class Setup
            extends TrackerColumns {
        private Setup() {/*This class cannot be instantiated*/}

        public static final String TABLE_NAME = "setup";

        public static final String CONTENT_TYPE = CONTENT_TYPE_PREFIX + TABLE_NAME;
        public static final String CONTENT_ITEM_TYPE = CONTENT_ITEM_TYPE_PREFIX + TABLE_NAME;
        public static final Uri CONTENT_URI = Uri.parse(CONTENT_URI_PREFIX
                + AUTHORITY + CONTENT_SEPARATOR + TABLE_NAME);

        public static final String _FID = "_fid";
        public static final String SETUP_TIME = "setup_t";
        public static final String REPLY_TIME = "reply_t";
        public static final String REPLY = "reply";
    }

    public static final class Locations
            extends TrackerColumns {
        private Locations() {/*This class cannot be instantiated*/}

        public static final String TABLE_NAME = "locations";

        public static final String CONTENT_TYPE = CONTENT_TYPE_PREFIX + TABLE_NAME;
        public static final String CONTENT_ITEM_TYPE = CONTENT_ITEM_TYPE_PREFIX + TABLE_NAME;
        public static final Uri CONTENT_URI = Uri.parse(CONTENT_URI_PREFIX
                + AUTHORITY + CONTENT_SEPARATOR + TABLE_NAME);

        public static final String _FID = "_fid";
        public static final String LOCATION = "location";
        public static final String UPDATE_TIME = "update_t";
        public static final String REQUEST_TIME = "request_t";
    }

}
