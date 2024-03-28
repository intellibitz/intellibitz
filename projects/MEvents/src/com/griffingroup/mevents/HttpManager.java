package com.griffingroup.mevents;

import android.util.Log;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.params.HttpClientParams;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;

import java.io.IOException;
import java.net.SocketTimeoutException;

/**
 * User: Muthu
 * Date: 9/5/11
 * Time: 6:09 PM
 */
public class HttpManager {
    private static final String TAG = HttpManager.class.getName();

    private static final DefaultHttpClient sClient;

    static {
        final HttpParams params = new BasicHttpParams();
        HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
        HttpProtocolParams.setContentCharset(params, "UTF-8");

        HttpConnectionParams.setStaleCheckingEnabled(params, false);
        HttpConnectionParams.setConnectionTimeout(params, 20 * 1000);
        HttpConnectionParams.setSoTimeout(params, 20 * 1000);
        HttpConnectionParams.setSocketBufferSize(params, 8192);

        HttpClientParams.setRedirecting(params, false);

        HttpProtocolParams.setUserAgent(params,
                "com.griffingroup.twrends.AndroidClient/1.1");

        SchemeRegistry schemeRegistry = new SchemeRegistry();
        schemeRegistry.register(new Scheme("http", PlainSocketFactory
                .getSocketFactory(), 80));
        schemeRegistry.register(new Scheme("https", SSLSocketFactory
                .getSocketFactory(), 443));

        ClientConnectionManager manager = new ThreadSafeClientConnManager(
                params, schemeRegistry);
        sClient = new DefaultHttpClient(manager, params);
        // Log.d(TAG, "Initialized : "+sClient);
    }

    private HttpManager() {
    }

    public static HttpResponse execute(HttpGet get) throws IOException {
        // Log.d(TAG, "Executing: "+get);
        try {
            return sClient.execute(get);
        } catch (SocketTimeoutException e) {
            Log.e(TAG, e.getMessage());
            return null;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            return null;
        }
    }

}
