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

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.ReaderException;
import com.google.zxing.Result;
import com.google.zxing.common.GlobalHistogramBinarizer;

import android.content.SharedPreferences;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;

import java.util.Hashtable;
import java.util.Vector;

/**
 * This thread does all the heavy lifting of decoding the images.
 */
final class DecodeThread extends Thread {

  public static final String BARCODE_BITMAP = "barcode_bitmap";
  private static final String TAG = "DecodeThread";

  public Handler mHandler;
  private final CaptureActivity mActivity;
  private final MultiFormatReader mMultiFormatReader;

  DecodeThread(CaptureActivity activity, String mode) {
    mActivity = activity;
    mMultiFormatReader = new MultiFormatReader();

    // The prefs can't change while the thread is running, so pick them up once here.
    if (mode == null || mode.length() == 0) {
      SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(activity);
      boolean decode1D = prefs.getBoolean(PreferencesActivity.KEY_DECODE_1D, true);
      boolean decodeQR = prefs.getBoolean(PreferencesActivity.KEY_DECODE_QR, true);
      if (decode1D && decodeQR) {
        setDecodeAllMode();
      } else if (decode1D) {
        setDecode1DMode();
      } else if (decodeQR) {
        setDecodeQRMode();
      }
    } else {
      if (mode.equals(Intents.Scan.PRODUCT_MODE)) {
        setDecodeProductMode();
      } else if (mode.equals(Intents.Scan.ONE_D_MODE)) {
        setDecode1DMode();
      } else if (mode.equals(Intents.Scan.QR_CODE_MODE)) {
        setDecodeQRMode();
      } else {
        setDecodeAllMode();
      }
    }
  }

  @Override
  public void run() {
    Looper.prepare();
    mHandler = new Handler() {
      @Override
      public void handleMessage(Message message) {
        switch (message.what) {
          case R.id.decode:
            decode((byte[]) message.obj, message.arg1, message.arg2);
            break;
          case R.id.quit:
            Looper.myLooper().quit();
            break;
        }
      }
    };
    Looper.loop();
  }

  private void setDecodeProductMode() {
    Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>(3);
    Vector<BarcodeFormat> vector = new Vector<BarcodeFormat>(4);
    vector.addElement(BarcodeFormat.UPC_A);
    vector.addElement(BarcodeFormat.UPC_E);
    vector.addElement(BarcodeFormat.EAN_13);
    vector.addElement(BarcodeFormat.EAN_8);
    hints.put(DecodeHintType.POSSIBLE_FORMATS, vector);
    mMultiFormatReader.setHints(hints);
  }

  /**
   * Select the 1D formats we want this client to decode by hand.
   */
  private void setDecode1DMode() {
    Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>(3);
    Vector<BarcodeFormat> vector = new Vector<BarcodeFormat>(7);
    vector.addElement(BarcodeFormat.UPC_A);
    vector.addElement(BarcodeFormat.UPC_E);
    vector.addElement(BarcodeFormat.EAN_13);
    vector.addElement(BarcodeFormat.EAN_8);
    vector.addElement(BarcodeFormat.CODE_39);
    vector.addElement(BarcodeFormat.CODE_128);
    vector.addElement(BarcodeFormat.ITF);
    hints.put(DecodeHintType.POSSIBLE_FORMATS, vector);
    mMultiFormatReader.setHints(hints);
  }

  private void setDecodeQRMode() {
    Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>(3);
    Vector<BarcodeFormat> vector = new Vector<BarcodeFormat>(1);
    vector.addElement(BarcodeFormat.QR_CODE);
    hints.put(DecodeHintType.POSSIBLE_FORMATS, vector);
    mMultiFormatReader.setHints(hints);
  }

  /**
   * Instead of calling setHints(null), which would allow new formats to sneak in, we
   * explicitly set which formats are available.
   */
  private void setDecodeAllMode() {
    Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>(3);
    Vector<BarcodeFormat> vector = new Vector<BarcodeFormat>(8);
    vector.addElement(BarcodeFormat.UPC_A);
    vector.addElement(BarcodeFormat.UPC_E);
    vector.addElement(BarcodeFormat.EAN_13);
    vector.addElement(BarcodeFormat.EAN_8);
    vector.addElement(BarcodeFormat.CODE_39);
    vector.addElement(BarcodeFormat.CODE_128);
    vector.addElement(BarcodeFormat.ITF);
    vector.addElement(BarcodeFormat.QR_CODE);
    hints.put(DecodeHintType.POSSIBLE_FORMATS, vector);
    mMultiFormatReader.setHints(hints);
  }

  /**
   * Decode the data within the viewfinder rectangle, and time how long it took. For efficiency,
   * reuse the same reader objects from one decode to the next.
   *
   * @param data   The YUV preview frame.
   * @param width  The width of the preview frame.
   * @param height The height of the preview frame.
   */
  private void decode(byte[] data, int width, int height) {
    long start = System.currentTimeMillis();
    boolean success;
    Result rawResult = null;
    Rect rect = CameraManager.get().getFramingRect();
    YUVLuminanceSource source = new YUVLuminanceSource(data, width, height, rect.left, rect.top,
        rect.width(), rect.height());
    BinaryBitmap bitmap = new BinaryBitmap(new GlobalHistogramBinarizer(source));
    try {
      rawResult = mMultiFormatReader.decodeWithState(bitmap);
      success = true;
    } catch (ReaderException e) {
      success = false;
    }
    long end = System.currentTimeMillis();

    if (success) {
      Log.v(TAG, "Found barcode (" + (end - start) + " ms):\n" + rawResult.toString());
      Message message = Message.obtain(mActivity.mHandler, R.id.decode_succeeded, rawResult);
      Bundle bundle = new Bundle();
      bundle.putParcelable(BARCODE_BITMAP, source.renderToBitmap());
      message.setData(bundle);
      message.sendToTarget();
    } else {
      Message message = Message.obtain(mActivity.mHandler, R.id.decode_failed);
      message.sendToTarget();
    }
  }

}
