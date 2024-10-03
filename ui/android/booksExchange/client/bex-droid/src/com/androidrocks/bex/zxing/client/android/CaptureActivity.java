/*
 * Copyright (C) 2009 Muthu Ramadoss. All rights reserved.
 *
 * Modified from Zxing project to suit Books-Exchange requirements.
 * Original source from Zxing - http://code.google.com/p/zxing/
 */

/*
 * Copyright (C) 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.androidrocks.bex.zxing.client.android;

import com.androidrocks.bex.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.os.Vibrator;
import android.preference.PreferenceManager;
import android.text.ClipboardManager;
import android.text.SpannableStringBuilder;
import android.text.style.UnderlineSpan;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.androidrocks.bex.zxing.client.android.result.ResultButtonListener;
import com.androidrocks.bex.zxing.client.android.result.ResultHandler;
import com.androidrocks.bex.zxing.client.android.result.ResultHandlerFactory;
import com.google.zxing.Result;
import com.google.zxing.ResultPoint;

import java.io.IOException;

/**
 * The barcode reader activity itself. This is loosely based on the CameraPreview
 * example included in the Android SDK.
 */
public final class CaptureActivity extends Activity implements SurfaceHolder.Callback {

  private static final String TAG = "CaptureActivity";

  private static final int SHARE_ID = Menu.FIRST;
  private static final int SETTINGS_ID = Menu.FIRST + 1;
  private static final int HELP_ID = Menu.FIRST + 2;
  private static final int ABOUT_ID = Menu.FIRST + 3;

  private static final int MAX_RESULT_IMAGE_SIZE = 150;
  private static final long INTENT_RESULT_DURATION = 1500L;
  private static final float BEEP_VOLUME = 0.15f;
  private static final long VIBRATE_DURATION = 200L;

  private static final String PACKAGE_NAME = "com.androidrocks.bex.zxing.client.android";
  private static final String PRODUCT_SEARCH_URL_PREFIX = "http://www.google";
  private static final String PRODUCT_SEARCH_URL_SUFFIX = "/m/products/scan";
  private static final String ZXING_URL = "http://zxing.appspot.com/scan";

  private enum Source {
    NATIVE_APP_INTENT,
    PRODUCT_SEARCH_LINK,
    ZXING_LINK,
    NONE
  }

  public CaptureActivityHandler mHandler;

  private ViewfinderView mViewfinderView;
  private View mStatusView;
  private View mResultView;
  private MediaPlayer mMediaPlayer;
  private Result mLastResult;
  private boolean mHasSurface;
  private boolean mPlayBeep;
  private boolean mVibrate;
  private boolean mCopyToClipboard;
  private Source mSource;
  private String mSourceUrl;
  private String mDecodeMode;
  private String mVersionName;

  private final OnCompletionListener mBeepListener = new BeepListener();

  @Override
  public void onCreate(Bundle icicle) {
    Log.i(TAG, "Creating CaptureActivity");
    super.onCreate(icicle);

    Window window = getWindow();
    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    setContentView(R.layout.capture);

    CameraManager.init(getApplication());
    mViewfinderView = (ViewfinderView) findViewById(R.id.viewfinder_view);
    mResultView = findViewById(R.id.result_view);
    mStatusView = findViewById(R.id.status_view);
    mHandler = null;
    mLastResult = null;
    mHasSurface = false;

    showHelpOnFirstLaunch();
  }

  @Override
  protected void onResume() {
    super.onResume();

    SurfaceView surfaceView = (SurfaceView) findViewById(R.id.preview_view);
    SurfaceHolder surfaceHolder = surfaceView.getHolder();
    if (mHasSurface) {
      // The activity was paused but not stopped, so the surface still exists. Therefore
      // surfaceCreated() won't be called, so init the camera here.
      initCamera(surfaceHolder);
    } else {
      // Install the callback and wait for surfaceCreated() to init the camera.
      surfaceHolder.addCallback(this);
      surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    }

    Intent intent = getIntent();
    String action = intent == null ? null : intent.getAction();
    String dataString = intent == null ? null : intent.getDataString();
    if (intent != null && action != null) {
      if (action.equals(Intents.Scan.ACTION) || action.equals(Intents.Scan.DEPRECATED_ACTION)) {
        // Scan the formats the intent requested, and return the result to the calling activity.
        mSource = Source.NATIVE_APP_INTENT;
        mDecodeMode = intent.getStringExtra(Intents.Scan.MODE);
        resetStatusView();
      } else if (dataString != null && dataString.contains(PRODUCT_SEARCH_URL_PREFIX) &&
          dataString.contains(PRODUCT_SEARCH_URL_SUFFIX)) {
        // Scan only products and send the result to mobile Product Search.
        mSource = Source.PRODUCT_SEARCH_LINK;
        mSourceUrl = dataString;
        mDecodeMode = Intents.Scan.PRODUCT_MODE;
        resetStatusView();
      } else if (dataString != null && dataString.equals(ZXING_URL)) {
        // Scan all formats and handle the results ourselves.
        // TODO: In the future we could allow the hyperlink to include a URL to send the results to.
        mSource = Source.ZXING_LINK;
        mSourceUrl = dataString;
        mDecodeMode = null;
        resetStatusView();
      } else {
        // Scan all formats and handle the results ourselves (launched from Home).
        mSource = Source.NONE;
        mDecodeMode = null;
        resetStatusView();
      }
    } else {
      mSource = Source.NONE;
      mDecodeMode = null;
      if (mLastResult == null) {
        resetStatusView();
      }
    }

    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
    mPlayBeep = prefs.getBoolean(PreferencesActivity.KEY_PLAY_BEEP, true);
    mVibrate = prefs.getBoolean(PreferencesActivity.KEY_VIBRATE, false);
    mCopyToClipboard = prefs.getBoolean(PreferencesActivity.KEY_COPY_TO_CLIPBOARD, true);
    initBeepSound();
  }

  @Override
  protected void onPause() {
    super.onPause();
    if (mHandler != null) {
      mHandler.quitSynchronously();
      mHandler = null;
    }
    CameraManager.get().closeDriver();
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    if (keyCode == KeyEvent.KEYCODE_BACK) {
      if (mSource == Source.NATIVE_APP_INTENT) {
        setResult(RESULT_CANCELED);
        finish();
        return true;
      } else if ((mSource == Source.NONE || mSource == Source.ZXING_LINK) && mLastResult != null) {
        resetStatusView();
        mHandler.sendEmptyMessage(R.id.restart_preview);
        return true;
      }
    } else if (keyCode == KeyEvent.KEYCODE_FOCUS || keyCode == KeyEvent.KEYCODE_CAMERA) {
      // Handle these events so they don't launch the Camera app
      return true;
    }
    return super.onKeyDown(keyCode, event);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    super.onCreateOptionsMenu(menu);
    menu.add(0, SHARE_ID, 0, R.string.menu_share).setIcon(R.drawable.share_menu_item);
    menu.add(0, SETTINGS_ID, 0, R.string.menu_settings)
        .setIcon(android.R.drawable.ic_menu_preferences);
    menu.add(0, HELP_ID, 0, R.string.menu_help)
        .setIcon(android.R.drawable.ic_menu_help);
    menu.add(0, ABOUT_ID, 0, R.string.menu_about)
        .setIcon(android.R.drawable.ic_menu_info_details);
    return true;
  }

  // Don't display the share menu item if the result overlay is showing.
  @Override
  public boolean onPrepareOptionsMenu(Menu menu) {
    super.onPrepareOptionsMenu(menu);
    menu.findItem(SHARE_ID).setVisible(mLastResult == null);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case SHARE_ID: {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setClassName(this, ShareActivity.class.getName());
        startActivity(intent);
        break;
      }
      case SETTINGS_ID: {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setClassName(this, PreferencesActivity.class.getName());
        startActivity(intent);
        break;
      }
      case HELP_ID: {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setClassName(this, HelpActivity.class.getName());
        startActivity(intent);
        break;
      }
      case ABOUT_ID:
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(getString(R.string.title_about) + mVersionName);
        builder.setMessage(getString(R.string.msg_about) + "\n\n" + getString(R.string.zxing_url));
        builder.setIcon(R.drawable.zxing_icon);
        builder.setPositiveButton(R.string.button_open_browser, mAboutListener);
        builder.setNegativeButton(R.string.button_cancel, null);
        builder.show();
        break;
    }
    return super.onOptionsItemSelected(item);
  }

  @Override
  public void onConfigurationChanged(Configuration config) {
    // Do nothing, this is to prevent the activity from being restarted when the keyboard opens.
    super.onConfigurationChanged(config);
  }

  private final DialogInterface.OnClickListener mAboutListener = new DialogInterface.OnClickListener() {
    public void onClick(DialogInterface dialogInterface, int i) {
      Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.zxing_url)));
      startActivity(intent);
    }
  };

  public void surfaceCreated(SurfaceHolder holder) {
    if (!mHasSurface) {
      mHasSurface = true;
      initCamera(holder);
    }
  }

  public void surfaceDestroyed(SurfaceHolder holder) {
    mHasSurface = false;
  }

  public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

  }

  /**
   * A valid barcode has been found, so give an indication of success and show the results.
   *
   * @param rawResult The contents of the barcode.
   * @param barcode   A greyscale bitmap of the camera data which was decoded.
   */
  public void handleDecode(Result rawResult, Bitmap barcode) {
    mLastResult = rawResult;
    playBeepSoundAndVibrate();
    drawResultPoints(barcode, rawResult);

    switch (mSource) {
      case NATIVE_APP_INTENT:
      case PRODUCT_SEARCH_LINK:
        handleDecodeExternally(rawResult, barcode);
        break;
      case ZXING_LINK:
      case NONE:
        handleDecodeInternally(rawResult, barcode);
        break;
    }
  }

  /**
   * Superimpose a line for 1D or dots for 2D to highlight the key features of the barcode.
   *
   * @param barcode   A bitmap of the captured image.
   * @param rawResult The decoded results which contains the points to draw.
   */
  private void drawResultPoints(Bitmap barcode, Result rawResult) {
    ResultPoint[] points = rawResult.getResultPoints();
    if (points != null && points.length > 0) {
      Canvas canvas = new Canvas(barcode);
      Paint paint = new Paint();
      paint.setColor(getResources().getColor(R.color.result_image_border));
      paint.setStrokeWidth(3.0f);
      paint.setStyle(Paint.Style.STROKE);
      Rect border = new Rect(2, 2, barcode.getWidth() - 2, barcode.getHeight() - 2);
      canvas.drawRect(border, paint);

      paint.setColor(getResources().getColor(R.color.result_points));
      if (points.length == 2) {
        paint.setStrokeWidth(4.0f);
        canvas.drawLine(points[0].getX(), points[0].getY(), points[1].getX(),
            points[1].getY(), paint);
      } else {
        paint.setStrokeWidth(10.0f);
        for (ResultPoint point : points) {
          canvas.drawPoint(point.getX(), point.getY(), paint);
        }
      }
    }
  }

  // Put up our own UI for how to handle the decoded contents.
  private void handleDecodeInternally(Result rawResult, Bitmap barcode) {
    mStatusView.setVisibility(View.GONE);
    mViewfinderView.setVisibility(View.GONE);
    mResultView.setVisibility(View.VISIBLE);

    ImageView barcodeImageView = (ImageView) findViewById(R.id.barcode_image_view);
    barcodeImageView.setMaxWidth(MAX_RESULT_IMAGE_SIZE);
    barcodeImageView.setMaxHeight(MAX_RESULT_IMAGE_SIZE);
    barcodeImageView.setImageBitmap(barcode);

    TextView formatTextView = (TextView) findViewById(R.id.format_text_view);
    formatTextView.setText(getString(R.string.msg_default_format) + ": " +
        rawResult.getBarcodeFormat().toString());

    ResultHandler resultHandler = ResultHandlerFactory.makeResultHandler(this, rawResult);
    TextView typeTextView = (TextView) findViewById(R.id.type_text_view);
    typeTextView.setText(getString(R.string.msg_default_type) + ": " +
        resultHandler.getType().toString());

    TextView contentsTextView = (TextView) findViewById(R.id.contents_text_view);
    CharSequence title = getString(resultHandler.getDisplayTitle());
    SpannableStringBuilder styled = new SpannableStringBuilder(title + "\n\n");
    styled.setSpan(new UnderlineSpan(), 0, title.length(), 0);
    CharSequence displayContents = resultHandler.getDisplayContents();
    styled.append(displayContents);
    contentsTextView.setText(styled);

    int buttonCount = resultHandler.getButtonCount();
    ViewGroup buttonView = (ViewGroup) findViewById(R.id.result_button_view);
    buttonView.requestFocus();
    for (int x = 0; x < ResultHandler.MAX_BUTTON_COUNT; x++) {
      Button button = (Button) buttonView.getChildAt(x);
      if (x < buttonCount) {
        button.setVisibility(View.VISIBLE);
        button.setText(resultHandler.getButtonText(x));
        button.setOnClickListener(new ResultButtonListener(resultHandler, x));
      } else {
        button.setVisibility(View.GONE);
      }
    }

    if (mCopyToClipboard) {
      ClipboardManager clipboard = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
      clipboard.setText(displayContents);
    }
  }

  // Briefly show the contents of the barcode, then handle the result outside Barcode Scanner.
  private void handleDecodeExternally(Result rawResult, Bitmap barcode) {
    mViewfinderView.drawResultBitmap(barcode);

    // Since this message will only be shown for a second, just tell the user what kind of
    // barcode was found (e.g. contact info) rather than the full contents, which they won't
    // have time to read.
    ResultHandler resultHandler = ResultHandlerFactory.makeResultHandler(this, rawResult);
    TextView textView = (TextView) findViewById(R.id.status_text_view);
    textView.setGravity(Gravity.CENTER);
    textView.setTextSize(18.0f);
    textView.setText(getString(resultHandler.getDisplayTitle()));

    mStatusView.setBackgroundColor(getResources().getColor(R.color.transparent));

    if (mCopyToClipboard) {
      ClipboardManager clipboard = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
      clipboard.setText(resultHandler.getDisplayContents());
    }

    if (mSource == Source.NATIVE_APP_INTENT) {
      // Hand back whatever action they requested - this can be changed to Intents.Scan.ACTION when
      // the deprecated intent is retired.
      Intent intent = new Intent(getIntent().getAction());
      intent.putExtra(Intents.Scan.RESULT, rawResult.toString());
      intent.putExtra(Intents.Scan.RESULT_FORMAT, rawResult.getBarcodeFormat().toString());
      Message message = Message.obtain(mHandler, R.id.return_scan_result);
      message.obj = intent;
      mHandler.sendMessageDelayed(message, INTENT_RESULT_DURATION);
    } else if (mSource == Source.PRODUCT_SEARCH_LINK) {
      // Reformulate the URL which triggered us into a query, so that the request goes to the same
      // TLD as the scan URL.
      Message message = Message.obtain(mHandler, R.id.launch_product_query);
      int end = mSourceUrl.lastIndexOf("/scan");
      message.obj = mSourceUrl.substring(0, end) + "?q=" +
          resultHandler.getDisplayContents().toString() + "&source=zxing";
      mHandler.sendMessageDelayed(message, INTENT_RESULT_DURATION);
    }
  }

  /**
   * We want the help screen to be shown automatically the first time a new version of the app is
   * run. The easiest way to do this is to check android:versionCode from the manifest, and compare
   * it to a value stored as a preference.
   */
  private void showHelpOnFirstLaunch() {
    try {
      PackageInfo info = getPackageManager().getPackageInfo(PACKAGE_NAME, 0);
      int currentVersion = info.versionCode;
      // Since we're paying to talk to the PackageManager anyway, it makes sense to cache the app
      // version name here for display in the about box later.
      this.mVersionName = info.versionName;
      SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
      int lastVersion = prefs.getInt(PreferencesActivity.KEY_HELP_VERSION_SHOWN, 0);
      if (currentVersion > lastVersion) {
        prefs.edit().putInt(PreferencesActivity.KEY_HELP_VERSION_SHOWN, currentVersion).commit();
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setClassName(this, HelpActivity.class.getName());
        startActivity(intent);
      }
    } catch (PackageManager.NameNotFoundException e) {
      Log.w(TAG, e);
    }
  }

  /**
   * Creates the beep MediaPlayer in advance so that the sound can be triggered with the least
   * latency possible.
   */
  private void initBeepSound() {
    if (mPlayBeep && mMediaPlayer == null) {
      mMediaPlayer = new MediaPlayer();
      mMediaPlayer.setAudioStreamType(AudioManager.STREAM_SYSTEM);
      mMediaPlayer.setOnCompletionListener(mBeepListener);

      AssetFileDescriptor file = getResources().openRawResourceFd(R.raw.beep);
      try {
        mMediaPlayer.setDataSource(file.getFileDescriptor(), file.getStartOffset(),
            file.getLength());
        file.close();
        mMediaPlayer.setVolume(BEEP_VOLUME, BEEP_VOLUME);
        mMediaPlayer.prepare();
      } catch (IOException e) {
        mMediaPlayer = null;
      }
    }
  }

  private void playBeepSoundAndVibrate() {
    if (mPlayBeep && mMediaPlayer != null) {
      mMediaPlayer.start();
    }
    if (mVibrate) {
      Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
      vibrator.vibrate(VIBRATE_DURATION);
    }
  }

  private void initCamera(SurfaceHolder surfaceHolder) {
    try {
      CameraManager.get().openDriver(surfaceHolder);
    } catch (IOException ioe) {
      Log.w(TAG, ioe);
      return;
    }
    if (mHandler == null) {
      boolean beginScanning = mLastResult == null;
      mHandler = new CaptureActivityHandler(this, mDecodeMode, beginScanning);
    }
  }

  private void resetStatusView() {
    mResultView.setVisibility(View.GONE);
    mStatusView.setVisibility(View.VISIBLE);
    mStatusView.setBackgroundColor(getResources().getColor(R.color.status_view));
    mViewfinderView.setVisibility(View.VISIBLE);

    TextView textView = (TextView) findViewById(R.id.status_text_view);
    textView.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL);
    textView.setTextSize(14.0f);
    textView.setText(R.string.msg_default_status);
    mLastResult = null;
  }

  public void drawViewfinder() {
    mViewfinderView.drawViewfinder();
  }

  /**
   * When the beep has finished playing, rewind to queue up another one.
   */
  private static class BeepListener implements OnCompletionListener {
    public void onCompletion(MediaPlayer mediaPlayer) {
      mediaPlayer.seekTo(0);
    }
  }

}
