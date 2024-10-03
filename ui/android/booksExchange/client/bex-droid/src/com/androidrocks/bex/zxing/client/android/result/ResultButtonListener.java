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

package com.androidrocks.bex.zxing.client.android.result;

import android.view.View;
import android.widget.Button;

/**
 * Handles the result of barcode decoding in the context of the Android platform, by dispatching the
 * proper intents to open other activities like GMail, Maps, etc.
 */
public final class ResultButtonListener implements Button.OnClickListener {

  final ResultHandler mResultHandler;
  final int mIndex;

  public ResultButtonListener(ResultHandler resultHandler, int index) {
    mResultHandler = resultHandler;
    mIndex = index;
  }

  public void onClick(View view) {
    mResultHandler.handleButtonPress(mIndex);
  }

}
