package com.griffingroup.twrends;

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

public class TwRendsActivity extends Activity {

    private static final String TAG = TwRendsActivity.class.getName();
    private CountDownTimer countDownTimer;
    private TrendsTask trendsTask;

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
        trendsTask = new TrendsTask();
        trendsTask.execute();

        countDownTimer = new CountDownTimer(30000, 1000) {
            public void onTick(long millisUntilFinished) {
                ((TextView) findViewById(R.id.next)).setText("Worldwide Twitter Trends - next in: " +
                        millisUntilFinished / 1000);
            }

            public void onFinish() {
//                hack.. for refresh!
                startActivity(new Intent("com.griffingroup.twrends"));
            }
        };
        countDownTimer.start();
    }

    @Override
    protected void onPause() {
        countDownTimer.cancel();
        trendsTask.cancel(true);
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
        countDownTimer = null;
        trendsTask = null;
    }

    public String getTrends() {
// Acquire a reference to the system Location Manager
/*
        LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        String loc = "";
        if (lastKnownLocation != null) {
            loc = lastKnownLocation.getLatitude() + "," + lastKnownLocation.getLongitude();
        }
*/
        final HttpGet get = new HttpGet("http://api.twitter.com/1/trends.json");
        try {
            return executeRequest(get);
        } catch (IOException e) {
            // e.printStackTrace();
            Log.e(TAG, e.getMessage());
            Log.e(TAG, "Could not get Twitter Trends");
        }
        return "Could not get Twitter Trends";
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

    private class TrendsTask extends AsyncTask<Void, Void, Void> {
        private String trends;

        @Override
        protected Void doInBackground(Void... voids) {
            trends = getTrends();
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            final String mimeType = "text/html";
            final String encoding = "UTF-8";
            WebView webView = (WebView) findViewById(R.id.trends);
            try {
                if (null == trends) {
                    webView.clearView();
                    webView.loadData("Oops.. API error. Please report by email below", mimeType, encoding);
                } else {
                    JSONObject jsonObject = new JSONObject(trends);
                    String asOf = jsonObject.getString("as_of");
                    ((TextView) findViewById(R.id.as_of)).setText("as of: " + asOf);

                    JSONArray trendsJson = jsonObject.getJSONArray("trends");
                    StringBuilder builder = new StringBuilder("<!DOCTYPE html " +
                            "PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" " +
                            "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> " +
                            "<html> " +
                            "<head>" +
                            "<style type=\"text/css\">" +
                            "div.ex" +
                            "{" +
                            "padding:5px;" +
                            "border:2px solid gray;" +
                            "margin:0px;" +
                            "}" +
                            "</style>" +
                            "</head>" +
                            "<body> ");
                    int len = trendsJson.length();
                    for (int i = 0; i < len; i++) {
                        JSONObject obj = (JSONObject) trendsJson.get(i);
                        String url = obj.getString("url");
                        String name = obj.getString("name");
                        builder.append("<div class=\"ex\"> " +
                                "<a href=\"").
                                append(url).append("\">").
                                append(name).append("</a> " +
                                "</div> ");
                    }
                    builder.append(" </body></html>");
                    webView.clearView();
                    webView.loadData(builder.toString(), mimeType, encoding);
                    webView.reload();
                }
            } catch (JSONException e) {
                e.printStackTrace();
                webView.clearView();
                webView.loadData("Oops.. Data load error. Please report by email below", mimeType, encoding);
            }
        }
    }

}
