package com.griffingroup.udigg;

import android.app.Activity;
import android.content.Intent;
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

public class UDiggActivity extends Activity {
    private static final String TAG = UDiggActivity.class.getName();
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
                ((TextView) findViewById(R.id.next)).setText("Digg most popular right now - next in: " +
                        millisUntilFinished / 1000);
            }

            public void onFinish() {
//                hack.. for refresh!
                startActivity(new Intent("com.griffingroup.udigg"));
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
/*
        LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        String loc = "";
        if (lastKnownLocation != null) {
            loc = lastKnownLocation.getLatitude() + "," + lastKnownLocation.getLongitude();
        }
*/
        final HttpGet get = new HttpGet(
                "http://services.digg.com/2.0/digg.getAll?count=10");
        try {
            return executeRequest(get);
        } catch (IOException e) {
            // e.printStackTrace();
            Log.e(TAG, e.getMessage());
            Log.e(TAG, "Could not get Digg");
        }
        return "Could not get Digg";
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
            WebView webView = (WebView) findViewById(R.id.events);
            try {
                if (null == events) {
                    webView.clearView();
                    webView.loadData("Oops.. API error. Please report by email below", mimeType, encoding);
                } else {
                    JSONObject jsonObject = new JSONObject(events);
                    String asOf = Calendar.getInstance().getTime().toString();
                    ((TextView) findViewById(R.id.as_of)).setText("as of: " + asOf);

                    JSONArray diggsJsonArray = jsonObject.getJSONArray("diggs");
                    StringBuilder builder = new StringBuilder("<html><body><p> ");
                    int len = diggsJsonArray.length();
                    for (int i = 0; i < len; i++) {
                        JSONObject obj = (JSONObject) diggsJsonArray.get(i);
                        JSONObject itemJson = obj.getJSONObject("item");
                        String url = itemJson.getString("href");
                        String name = itemJson.getString("title");
                        JSONObject thumbnail = itemJson.getJSONObject("thumbnail");
                        String img = thumbnail.getString("src");
                        String ht = thumbnail.getString("height");
                        String wd = thumbnail.getString("width");
                        builder.append("<a href=\"").
                                append(url).append("\">").
                                append("<img src=\"").append(img).append("\"").
                                append(" height=").append(ht).
                                append(" width=").append(wd).
                                append(" \"> ").
                                append(name).append("</a><br>");
                        if (i < len - 1) {
                            builder.append("<br>");
                        }
                    }
                    builder.append(" </p></body></html>");
                    webView.clearView();
                    webView.loadData(builder.toString(), mimeType, encoding);
                }
            } catch (JSONException e) {
                e.printStackTrace();
                webView.clearView();
                webView.loadData("Oops.. Data load error. Please report by email below", mimeType, encoding);
            }
        }
    }

}
