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

import android.app.ListActivity;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.Browser;
import android.view.View;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;

import com.androidrocks.bex.R;


/**
 * This class is only needed because I can't successfully send an ACTION_PICK intent to
 * com.android.browser.BrowserBookmarksPage. It can go away if that starts working in the future.
 */
public final class BookmarkPickerActivity extends ListActivity {

  private static final String[] BOOKMARK_PROJECTION = {
      Browser.BookmarkColumns.TITLE,
      Browser.BookmarkColumns.URL
  };

  private static final int[] TWO_LINE_VIEW_IDS = {
      R.id.bookmark_title,
      R.id.bookmark_url
  };

  private static final int TITLE_COLUMN = 0;
  private static final int URL_COLUMN = 1;

  // Without this selection, we'd get all the history entries too
  private static final String BOOKMARK_SELECTION = "bookmark = 1";

  private Cursor mCursor;

  @Override
  protected void onCreate(Bundle icicle) {
    super.onCreate(icicle);

    mCursor = getContentResolver().query(Browser.BOOKMARKS_URI, BOOKMARK_PROJECTION,
        BOOKMARK_SELECTION, null, null);
    startManagingCursor(mCursor);

    ListAdapter adapter = new SimpleCursorAdapter(this, R.layout.bookmark_picker_list_item,
        mCursor, BOOKMARK_PROJECTION, TWO_LINE_VIEW_IDS);
    setListAdapter(adapter);
  }

  @Override
  protected void onListItemClick(ListView l, View view, int position, long id) {
    if (mCursor.moveToPosition(position)) {
      Intent intent = new Intent();
      intent.putExtra(Browser.BookmarkColumns.TITLE, mCursor.getString(TITLE_COLUMN));
      intent.putExtra(Browser.BookmarkColumns.URL, mCursor.getString(URL_COLUMN));
      setResult(RESULT_OK, intent);
    } else {
      setResult(RESULT_CANCELED);
    }
    finish();
  }

}
