package com.androidworks.navsys.wuffit.activity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;
import com.androidworks.navsys.wuffit.R;
import com.androidworks.navsys.wuffit.content.Tracker;
import com.google.android.maps.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class DisplayLocation extends MapActivity {
    private MapView mapView;
    private MyLocationOverlay myLocationOverlay;
    private TrackerItemizedOverlay normalTrackerItems;
    private TrackerItemizedOverlay warningTrackerItems;
    private static final int ALERT_MAP_LOCATION = 100;
    private String itemDetails;
    private AlertDialog itemDetailsDialog;

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.display_location);

        findViewById(R.id.main_menu).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_MAIN_MENU");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

        mapView = (MapView) findViewById(R.id.display_location);
//        mapView.getController().setZoom(12);

        myLocationOverlay = new MyLocationOverlay(this, mapView);
        myLocationOverlay.runOnFirstFix(new Runnable() {
            public void run() {
                mapView.getController().animateTo(myLocationOverlay.getMyLocation());
            }
        });

        Drawable defaultMarker = getResources().getDrawable(android.R.drawable.presence_online);
        Drawable warning = getResources().getDrawable(android.R.drawable.presence_busy);
        normalTrackerItems = new TrackerItemizedOverlay(defaultMarker);
        warningTrackerItems = new TrackerItemizedOverlay(warning);

        /**
         * Get the zoom controls and add them to the bottom of the map
         */
        LinearLayout linearLayout = (LinearLayout) findViewById(R.id.zoomview);
        View zoomControls = mapView.getZoomControls();
        linearLayout.addView(zoomControls);
    }


    @Override
    protected Dialog onCreateDialog(int i) {
        switch (i) {
            case ALERT_MAP_LOCATION:
                if (null == itemDetailsDialog) {
                    itemDetailsDialog = new AlertDialog.Builder(this)
                            .setTitle("Tracker Location Details")
                            .setCancelable(true)
                            .setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialogInterface, int i) {
                                }
                            })
                            .create();
                }
                itemDetailsDialog.setMessage(itemDetails);
                return itemDetailsDialog;
        }
        return super.onCreateDialog(i);
    }

    @Override
    protected void onPrepareDialog(int i, Dialog dialog) {
        super.onPrepareDialog(i, dialog);
        switch (i) {
            case ALERT_MAP_LOCATION:
                itemDetailsDialog.setMessage(itemDetails);
                break;
        }
    }

    @Override
    protected boolean isRouteDisplayed() {
        return false;
    }

    @Override
    protected void onResume() {
        super.onResume();
        myLocationOverlay.enableMyLocation();
        addOverlaysToMap();
    }

    private void addOverlaysToMap() {
// resets the overlays, if the location info had changed maybe
// todo: OPTIMIZE THIS, NOT TO RELOAD ON RESUME
        final List<Overlay> overlays = mapView.getOverlays();
        overlays.clear();
        normalTrackerItems.clear();
        warningTrackerItems.clear();
        overlays.add(myLocationOverlay);

        Cursor cursor = getContentResolver().query(Tracker.Locations.CONTENT_URI,
                new String[]{Tracker.Locations._FID, Tracker.Locations.LOCATION, Tracker.Locations.UPDATE_TIME},
                null, null, null);
        if (cursor.getCount() > 0) {
// builds all the overlay tracker items
// convert to overlays
            convertGPRMCToOverlayItems(cursor);
        }
        cursor.close();
        if (warningTrackerItems.size() > 0) {
            overlays.add(warningTrackerItems);
        }
        if (normalTrackerItems.size() > 0) {
            overlays.add(normalTrackerItems);
        }
    }

    private void convertGPRMCToOverlayItems(Cursor cursor) {
        cursor.moveToFirst();
        do {
            String gprmc = cursor.getString(1);
            String loc = "Updated on: <not available>";
            long rt = cursor.getLong(2);
            if (rt > 0) {
                Calendar cal = Calendar.getInstance();
                cal.setTimeInMillis(rt);
                DateFormat sdf = SimpleDateFormat.getDateTimeInstance();
                loc = "Updated on: " + sdf.format(cal.getTime());
            }
            if (null != gprmc) {
                String id = cursor.getString(0);
                String sel = Tracker.Details._ID + " = ? ";
                String[] selArgs = new String[]{id};
                Cursor details = getContentResolver().query(Tracker.Details.CONTENT_URI,
                        new String[]{Tracker.Details.NAME, Tracker.Details.NUMBER},
                        sel, selArgs, null);
                if (0 == details.getCount()) {
                    Log.e("DisplayLocation#convertGPRMCToOverlayItems: ",
                            "No Records found in database for tracker id: " + id);
                    Toast.makeText(this, "No Records found for tracker id: " + id,
                            Toast.LENGTH_LONG).show();
                } else {
                    details.moveToFirst();
// $GPRMC,003400.000,A,3725.3433,N,12205.7921,W,0.02,227.11,061007,,,D*76
// wuffit,$GPRMC,022410.000,V,3904.1340,N,10453.1140,W,0.00,0.00,010409,,*17,POLL                   
                    TrackerOverlayItem item = createTrackerOverlayItem
                            (details.getString(0) + " \n " + details.getString(1)
                                    + " \n " + loc, gprmc);
                    if (item.isNormal()) {
                        normalTrackerItems.addOverlayItem(item);
                    } else {
                        warningTrackerItems.addOverlayItem(item);
                    }
                }
                details.close();
            }
        } while (cursor.moveToNext());
    }

    private TrackerOverlayItem createTrackerOverlayItem(String detail, String gprmc) {
        String[] contents = gprmc.split(",");
// Wuffit,$GPRMC, 171717.0000, A, 3904.1289, N, 10453.1007, W, 0.00, 0.00, 070309,,*13, POLL
// wuffit,$GPRMC,022410.000,V,3904.1340,N,10453.1140,W,0.00,0.00,010409,,*17,POLL
        int lat = degToDec(contents[4].trim());
        if ("S".equalsIgnoreCase(contents[5].trim())) lat = -lat;
        int lang = degToDec(contents[6].trim());
        if ("W".equalsIgnoreCase(contents[7].trim())) lang = -lang;

        GeoPoint geoPoint = new GeoPoint(lat, lang);
        String ts = contents[2].trim();
        ts = ts.split("\\.")[0];
        Log.d("DisplayLocation#convertGPRMCToOverlayItems: ", "Time String: " + ts);
        ts = ts.substring(0, 2) + ":" + ts.substring(2, 4) + ":" + ts.substring(4, 6);
        String ds = contents[10].trim();
        ds = ds.substring(0, 2) + "-" + ds.substring(2, 4) + "-" + ds.substring(4, 6);
        String date =
                " Lat/Long: " + geoPoint.toString()
                        + "\n Date: " + ds + " Time: " + ts;
        TrackerOverlayItem item = new TrackerOverlayItem(geoPoint, detail, date);
        if ("V".equalsIgnoreCase(contents[3])) {
            item.setNormal(false);
        }
        return item;
    }

    int degToDec(String val) {
/*
Degrees Minutes Seconds to Degrees Minutes.m (GPS)
Degrees = Degrees, Minutes.m = Minutes + (Seconds / 60)

Degrees Minutes.m to Decimal Degrees
.d = M.m / 60, Decimal Degrees = Degrees + .d
 */

        String min = val.substring(val.length() - 7, val.length());
        String deg = val.substring(0, val.length() - min.length());
        return (int) ((Double.valueOf(deg) + (Double.valueOf(min) / 60)) * 1000000);
    }

    @Override
    protected void onStop() {
        myLocationOverlay.disableMyLocation();
        super.onStop();
    }

    /**
     * Custom overlay to display the Panoramio pushpin
     */
    public class TrackerItemizedOverlay extends ItemizedOverlay {
        private ArrayList<TrackerOverlayItem> trackerOverlayItems =
                new ArrayList<TrackerOverlayItem>();

        public TrackerItemizedOverlay(Drawable defaultMarker) {
//            super(boundCenterBottom(defaultMarker));
            super(boundCenter(defaultMarker));
        }

        public void addOverlayItem(TrackerOverlayItem overlayItem) {
            trackerOverlayItems.add(overlayItem);
            populate();
        }

        protected OverlayItem createItem(int i) {
            return trackerOverlayItems.get(i);
        }

        public int size() {
            return trackerOverlayItems.size();
        }

        public void clear() {
            trackerOverlayItems.clear();
        }

        @Override
        protected boolean onTap(int i) {
            boolean res = super.onTap(i);
            itemDetails = getItem(i).getTitle() + "\n" + getItem(i).getSnippet();
            Log.d("TrackerItemizedOverlay#onTap: ", itemDetails);
//            Toast.makeText(getApplicationContext(), itemDetails, Toast.LENGTH_LONG).show();
            showDialog(ALERT_MAP_LOCATION);
            return res;
        }

    }

    class TrackerOverlayItem extends OverlayItem {
        boolean normal = true;

        public TrackerOverlayItem(GeoPoint geoPoint, String s, String s1) {
            super(geoPoint, s, s1);
        }

        public boolean isNormal() {
            return normal;
        }

        public void setNormal(boolean normal) {
            this.normal = normal;
        }
    }
}

/**

 $GPRMC

 Recommended minimum specific GPS/Transit data

 eg1. $GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E*62
 eg2. $GPRMC,225446,A,4916.45,N,12311.12,W,000.5,054.7,191194,020.3,E*68


 225446       Time of fix 22:54:46 UTC
 A            Navigation receiver warning A = OK, V = warning
 4916.45,N    Latitude 49 deg. 16.45 min North
 12311.12,W   Longitude 123 deg. 11.12 min West
 000.5        Speed over ground, Knots
 054.7        Course Made Good, True
 191194       Date of fix  19 November 1994
 020.3,E      Magnetic variation 20.3 deg East
 *68          mandatory checksum


 eg3. $GPRMC,220516,A,5133.82,N,00042.24,W,173.8,231.8,130694,004.2,W*70
 1    2    3    4    5     6    7    8      9     10  11 12


 1   220516     Time Stamp
 2   A          validity - A-ok, V-invalid
 3   5133.82    current Latitude
 4   N          North/South
 5   00042.24   current Longitude
 6   W          East/West
 7   173.8      Speed in knots
 8   231.8      True course
 9   130694     Date Stamp
 10  004.2      Variation
 11  W          East/West
 12  *70        checksum


 eg4. $GPRMC,hhmmss.ss,A,llll.ll,a,yyyyy.yy,a,x.x,x.x,ddmmyy,x.x,a*hh
 1    = UTC of position fix
 2    = Data status (V=navigation receiver warning)
 3    = Latitude of fix
 4    = N or S
 5    = Longitude of fix
 6    = E or W
 7    = Speed over ground in knots
 8    = Track made good in degrees True
 9    = UT date
 10   = Magnetic variation degrees (Easterly var. subtracts from true course)
 11   = E or W
 12   = Checksum


 */