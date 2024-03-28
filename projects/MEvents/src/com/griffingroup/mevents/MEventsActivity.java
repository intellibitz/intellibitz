package com.griffingroup.mevents;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.webkit.WebView;
import android.widget.TextView;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.protocol.HTTP;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;

public class MEventsActivity extends Activity {
    private static final String TAG = MEventsActivity.class.getName();
    private CountDownTimer countDownTimer;
    private EventsTask eventsTask;

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setTitle(R.string.app_desc);
        setContentView(R.layout.main);
    }

    @Override
    protected void onStart() {
        super.onStart();
//        coming from either oncreate, or onrestart
    }

    @Override
    protected void onResume() {
        super.onResume();
//        activity comes to the foreground
        eventsTask = new EventsTask();
        eventsTask.execute();

        countDownTimer = new CountDownTimer(60000, 1000) {
            public void onTick(long millisUntilFinished) {
                ((TextView) findViewById(R.id.next)).setText("My Yahoo Upcoming Events - next in: " +
                        millisUntilFinished / 1000);
            }

            public void onFinish() {
//                hack.. for refresh!
                startActivity(new Intent("com.griffingroup.mevents"));
            }
        };
        countDownTimer.start();
    }

    @Override
    protected void onPause() {
        countDownTimer.cancel();
        eventsTask.cancel(true);
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
        countDownTimer = null;
        eventsTask = null;
    }

    public String getEvents() {
// Acquire a reference to the system Location Manager
        LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        String loc = "";
        if (lastKnownLocation != null) {
            loc = lastKnownLocation.getLatitude() + "," + lastKnownLocation.getLongitude();
        }
        final HttpGet get = new HttpGet(
                "http://upcoming.yahooapis.com/services/rest/?method=event.search&api_key=0cb4d3fd50&format=json&per_page=10&location=" + loc);
        try {
            return executeRequest(get);
        } catch (IOException e) {
            // e.printStackTrace();
            Log.e(TAG, e.getMessage());
            Log.e(TAG, "Could not get Upcoming Events");
        }
        return "Could not get Upcoming Events";
    }

    private String executeRequest(HttpGet get)
            throws IOException {
        // Log.d(TAG, "executeRequest: " + host + get);
        HttpEntity entity = null;
        String result = null;
        try {
            final HttpResponse response = HttpManager.execute(get);
            if (null != response
                    && response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
                entity = response.getEntity();
                final InputStream in = entity.getContent();
                result = IOUtils.toString(in, HTTP.UTF_8);
            }
        } finally {
            if (entity != null) {
                entity.consumeContent();
            }
        }
        // Log.d(TAG, "executeRequest: " + result);
        return result;
    }

    private class EventsTask extends AsyncTask<Void, Void, Void> {
        private String events;

        @Override
        protected Void doInBackground(Void... voids) {
            events = getEvents();
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            final String mimeType = "text/html";
            final String encoding = "UTF-8";
            WebView trendsWebView = (WebView) findViewById(R.id.events);
            try {
                JSONObject jsonObject = new JSONObject(events);
                String asOf = Calendar.getInstance().getTime().toString();
                ((TextView) findViewById(R.id.as_of)).setText("as of: " + asOf);

                JSONObject rsp = jsonObject.getJSONObject("rsp");
                JSONArray trendsJson = rsp.getJSONArray("event");
                StringBuilder builder = new StringBuilder("<p> ");
                int len = trendsJson.length();
                for (int i = 0; i < len; i++) {
                    JSONObject obj = (JSONObject) trendsJson.get(i);
                    String url = obj.getString("url");
                    String name = obj.getString("name");
                    builder.append("<a href=\"").
                            append(url).append("\">").
                            append(name).append("</a><br>");
                    if (i < len - 1) {
                        builder.append("<br>");
                    }
                }
                builder.append(" </p>");
//            final String encoding = "ISO-8859-1";
                trendsWebView.loadData(builder.toString(), mimeType, encoding);
                trendsWebView.reload();

            } catch (JSONException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                trendsWebView.loadData("Oops.. Data load error. Please report by email below", mimeType, encoding);
                trendsWebView.reload();
            }
        }
    }

}
