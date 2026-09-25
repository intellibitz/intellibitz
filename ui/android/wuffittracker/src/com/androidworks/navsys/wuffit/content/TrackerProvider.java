package com.androidworks.navsys.wuffit.content;

import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.text.TextUtils;

public class TrackerProvider extends ContentProvider {

    private static final String TAG = "TrackerProvider";

    private static final int DETAILS = 1;
    private static final int DETAILS_ITEM = 2;
    private static final int SETUP = 11;
    private static final int SETUP_ITEM = 22;
    private static final int LOCATIONS = 111;
    private static final int LOCATIONS_ITEM = 222;

    private Tracker.DatabaseHelper databaseHelper;

    private static final UriMatcher uriMatcher;

    static {
        uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Details.TABLE_NAME, DETAILS);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Details.TABLE_NAME + "/#", DETAILS_ITEM);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Setup.TABLE_NAME, SETUP);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Setup.TABLE_NAME + "/#", SETUP_ITEM);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Locations.TABLE_NAME, LOCATIONS);
        uriMatcher.addURI(Tracker.AUTHORITY, Tracker.Locations.TABLE_NAME + "/#", LOCATIONS_ITEM);
    }


    @Override
    public boolean onCreate() {
        databaseHelper = new Tracker.DatabaseHelper(getContext());
        return true;
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection,
                        String[] selectionArgs,
                        String sortOrder) {
        SQLiteQueryBuilder qb = new SQLiteQueryBuilder();

        switch (uriMatcher.match(uri)) {
            case LOCATIONS:
                qb.setTables(Tracker.Locations.TABLE_NAME);
                break;
            case LOCATIONS_ITEM:
                qb.setTables(Tracker.Locations.TABLE_NAME);
                qb.appendWhere(Tracker.Locations._ID + "=" +
                        uri.getPathSegments().get(1));
                break;

            case SETUP:
                qb.setTables(Tracker.Setup.TABLE_NAME);
                break;
            case SETUP_ITEM:
                qb.setTables(Tracker.Setup.TABLE_NAME);
                qb.appendWhere(Tracker.Setup._ID + "=" +
                        uri.getPathSegments().get(1));
                break;

            case DETAILS:
                qb.setTables(Tracker.Details.TABLE_NAME);
                break;
            case DETAILS_ITEM:
                qb.setTables(Tracker.Details.TABLE_NAME);
                qb.appendWhere(Tracker.Details._ID + "=" +
                        uri.getPathSegments().get(1));
                break;

            default:
                throw new IllegalArgumentException("Unknown URI " + uri);
        }

        // Get the database and run the query
        SQLiteDatabase db = databaseHelper.getReadableDatabase();
        Cursor c = qb.query(db, projection, selection, selectionArgs, null,
                null, sortOrder);

        // Tell the cursor what uri to watch, so it knows when its source data changes
        c.setNotificationUri(getContext().getContentResolver(), uri);
        return c;
    }

    @Override
    public Uri insert(Uri uri, ContentValues initialValues) {
        ContentValues values = new ContentValues(initialValues);
        SQLiteDatabase db = databaseHelper.getWritableDatabase();
        long rowId;
        switch (uriMatcher.match(uri)) {
            case SETUP:
                rowId = db.insert(Tracker.Setup.TABLE_NAME, Tracker.Setup._FID, values);
                if (rowId > 0) {
                    Uri noteUri = ContentUris.withAppendedId(Tracker.Setup.CONTENT_URI, rowId);
                    getContext().getContentResolver().notifyChange(noteUri, null);
                    return noteUri;
                }
                break;
            case LOCATIONS:
                rowId = db.insert(Tracker.Locations.TABLE_NAME, Tracker.Locations._FID, values);
                if (rowId > 0) {
                    Uri noteUri = ContentUris.withAppendedId(Tracker.Locations.CONTENT_URI, rowId);
                    getContext().getContentResolver().notifyChange(noteUri, null);
                    return noteUri;
                }
                break;
            case DETAILS:
                rowId = db.insert(Tracker.Details.TABLE_NAME, Tracker.Details.ID, values);
                if (rowId > 0) {
                    Uri noteUri = ContentUris.withAppendedId(Tracker.Details.CONTENT_URI, rowId);
                    getContext().getContentResolver().notifyChange(noteUri, null);
                    return noteUri;
                }
                break;
            default:
                throw new IllegalArgumentException("Unknown URI " + uri);
        }
        throw new SQLException("Failed to insert row into " + uri);
    }

    @Override
    public int delete(Uri uri, String where, String[] whereArgs) {
        SQLiteDatabase db = databaseHelper.getWritableDatabase();
        int count;
        switch (uriMatcher.match(uri)) {
            case SETUP:
                count = db.delete(Tracker.Setup.TABLE_NAME, where, whereArgs);
                break;
            case SETUP_ITEM:
                String resultId = uri.getPathSegments().get(1);
                count = db.delete(Tracker.Setup.TABLE_NAME,
                        Tracker.Setup._ID + "=" + resultId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' :
                                ""), whereArgs);
                break;

            case LOCATIONS:
                count = db.delete(Tracker.Locations.TABLE_NAME, where, whereArgs);
                break;
            case LOCATIONS_ITEM:
                resultId = uri.getPathSegments().get(1);
                count = db.delete(Tracker.Locations.TABLE_NAME,
                        Tracker.Locations._ID + "=" + resultId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' :
                                ""), whereArgs);
                break;

            case DETAILS:
                count = db.delete(Tracker.Details.TABLE_NAME, where, whereArgs);
                break;
            case DETAILS_ITEM:
                String queryId = uri.getPathSegments().get(1);
                count = db.delete(Tracker.Details.TABLE_NAME,
                        Tracker.Details._ID + "=" + queryId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' :
                                ""), whereArgs);
                break;

            default:
                throw new IllegalArgumentException("Unknown URI " + uri);
        }

        getContext().getContentResolver().notifyChange(uri, null);
        return count;
    }

    @Override
    public int update(Uri uri, ContentValues values, String where,
                      String[] whereArgs) {
        SQLiteDatabase db = databaseHelper.getWritableDatabase();
        int count;
        switch (uriMatcher.match(uri)) {
            case DETAILS:
                count = db.update(Tracker.Details.TABLE_NAME, values, where,
                        whereArgs);
                break;
            case DETAILS_ITEM:
                String noteId = uri.getPathSegments().get(1);
                count = db.update(Tracker.Details.TABLE_NAME, values,
                        Tracker.Details._ID + "=" + noteId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' : ""), whereArgs);
                break;

            case SETUP:
                count = db.update(Tracker.Setup.TABLE_NAME, values, where,
                        whereArgs);
                break;
            case SETUP_ITEM:
                noteId = uri.getPathSegments().get(1);
                count = db.update(Tracker.Setup.TABLE_NAME, values,
                        Tracker.Setup._ID + "=" + noteId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' : ""), whereArgs);
                break;

            case LOCATIONS:
                count = db.update(Tracker.Locations.TABLE_NAME, values, where,
                        whereArgs);
                break;
            case LOCATIONS_ITEM:
                noteId = uri.getPathSegments().get(1);
                count = db.update(Tracker.Locations.TABLE_NAME, values,
                        Tracker.Locations._ID + "=" + noteId
                                + (!TextUtils.isEmpty(where) ?
                                " AND (" + where + ')' : ""), whereArgs);
                break;

            default:
                throw new IllegalArgumentException("Unknown URI " + uri);
        }

        getContext().getContentResolver().notifyChange(uri, null);
        return count;
    }

    @Override
    public String getType(Uri uri) {
        switch (uriMatcher.match(uri)) {
            case SETUP:
                return Tracker.Setup.CONTENT_TYPE;
            case SETUP_ITEM:
                return Tracker.Setup.CONTENT_ITEM_TYPE;

            case LOCATIONS:
                return Tracker.Locations.CONTENT_TYPE;
            case LOCATIONS_ITEM:
                return Tracker.Locations.CONTENT_ITEM_TYPE;

            case DETAILS:
                return Tracker.Details.CONTENT_TYPE;
            case DETAILS_ITEM:
                return Tracker.Details.CONTENT_ITEM_TYPE;

            default:
                throw new IllegalArgumentException("Unknown URI " + uri);
        }
    }

}