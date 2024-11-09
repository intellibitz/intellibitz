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

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.provider.Contacts;

import com.androidrocks.bex.zxing.client.android.Contents;
import com.androidrocks.bex.zxing.client.android.Intents;
import com.androidrocks.bex.zxing.client.android.LocaleManager;
import com.androidrocks.bex.R;
import com.androidrocks.bex.zxing.client.android.SearchBookContentsActivity;
import com.google.zxing.client.result.ParsedResult;
import com.google.zxing.client.result.ParsedResultType;

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.text.DateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public abstract class ResultHandler {

  private static final DateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd");
  private static final DateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmmss");

  public static final int MAX_BUTTON_COUNT = 4;

  protected final ParsedResult mResult;
  private final Activity mActivity;

  protected ResultHandler(Activity activity, ParsedResult result) {
    mResult = result;
    mActivity = activity;
  }

  /**
   * Indicates how many buttons the derived class wants shown.
   *
   * @return The integer button count.
   */
  public abstract int getButtonCount();

  /**
   * The text of the nth action button.
   *
   * @param index From 0 to getButtonCount() - 1
   * @return The button text as a resource ID
   */
  public abstract int getButtonText(int index);


  /**
   * Execute the action which corresponds to the nth button.
   *
   * @param index The button that was clicked.
   */
  public abstract void handleButtonPress(int index);

  /**
   * Create a possibly styled string for the contents of the current barcode.
   *
   * @return The text to be displayed.
   */
  public CharSequence getDisplayContents() {
    String contents = mResult.getDisplayResult();
    return contents.replace("\r", "");
  }

  /**
   * A string describing the kind of barcode that was found, e.g. "Found contact info".
   *
   * @return The resource ID of the string.
   */
  public abstract int getDisplayTitle();

  /**
   * A convenience method to get the parsed type. Should not be overridden.
   *
   * @return The parsed type, e.g. URI or ISBN
   */
  public final ParsedResultType getType() {
    return mResult.getType();
  }

  /**
   * Sends an intent to create a new calendar event by prepopulating the Add Event UI. Older
   * versions of the system have a bug where the event title will not be filled out.
   *
   * @param summary A description of the event
   * @param start   The start time as yyyyMMdd or yyyyMMdd'T'HHmmss or yyyyMMdd'T'HHmmss'Z'
   * @param end     The end time as yyyyMMdd or yyyyMMdd'T'HHmmss or yyyyMMdd'T'HHmmss'Z'
   */
  public final void addCalendarEvent(String summary, String start, String end) {
    Intent intent = new Intent(Intent.ACTION_EDIT);
    intent.setType("vnd.android.cursor.item/event");
    intent.putExtra("beginTime", calculateMilliseconds(start));
    if (start.length() == 8) {
      intent.putExtra("allDay", true);
    }
    intent.putExtra("endTime", calculateMilliseconds(end));
    intent.putExtra("title", summary);
    launchIntent(intent);
  }

  private static long calculateMilliseconds(String when) {
    if (when.length() == 8) {
      // Only contains year/month/day
      Date date;
      synchronized (DATE_FORMAT) {
        date = DATE_FORMAT.parse(when, new ParsePosition(0));
      }
      return date.getTime();
    } else {
      // The when string can be local time, or UTC if it ends with a Z
      Date date;
      synchronized (DATE_TIME_FORMAT) {
       date = DATE_TIME_FORMAT.parse(when.substring(0, 15), new ParsePosition(0));
      }
      long milliseconds = date.getTime();
      if (when.length() == 16 && when.charAt(15) == 'Z') {
        Calendar calendar = new GregorianCalendar();
        int offset = calendar.get(Calendar.ZONE_OFFSET) + calendar.get(Calendar.DST_OFFSET);
        milliseconds += offset;
      }
      return milliseconds;
    }
  }

  public final void addContact(String[] names, String[] phoneNumbers, String[] emails, String note,
                         String address, String org, String title) {

    // Only use the first name in the array, if present.
    Intent intent = new Intent(Contacts.Intents.Insert.ACTION, Contacts.People.CONTENT_URI);
    putExtra(intent, Contacts.Intents.Insert.NAME, names != null ? names[0] : null);

    int phoneCount = Math.min((phoneNumbers != null) ? phoneNumbers.length : 0,
        Contents.PHONE_KEYS.length);
    for (int x = 0; x < phoneCount; x++) {
      putExtra(intent, Contents.PHONE_KEYS[x], phoneNumbers[x]);
    }

    int emailCount = Math.min((emails != null) ? emails.length : 0, Contents.EMAIL_KEYS.length);
    for (int x = 0; x < emailCount; x++) {
      putExtra(intent, Contents.EMAIL_KEYS[x], emails[x]);
    }

    putExtra(intent, Contacts.Intents.Insert.NOTES, note);
    putExtra(intent, Contacts.Intents.Insert.POSTAL, address);
    putExtra(intent, Contacts.Intents.Insert.COMPANY, org);
    putExtra(intent, Contacts.Intents.Insert.JOB_TITLE, title);
    launchIntent(intent);
  }

  public final void shareByEmail(String contents) {
    sendEmailFromUri("mailto:", mActivity.getString(R.string.msg_share_subject_line), contents);
  }

  public final void sendEmail(String address, String subject, String body) {
    sendEmailFromUri("mailto:" + address, subject, body);
  }

  // Use public Intent fields rather than private GMail app fields to specify subject and body.
  public final void sendEmailFromUri(String uri, String subject, String body) {
    Intent intent = new Intent(Intent.ACTION_SEND, Uri.parse(uri));
    putExtra(intent, Intent.EXTRA_SUBJECT, subject);
    putExtra(intent, Intent.EXTRA_TEXT, body);
    intent.setType("text/plain");
    launchIntent(intent);
  }

  public final void shareBySMS(String contents) {
    sendSMSFromUri("smsto:", mActivity.getString(R.string.msg_share_subject_line) + ":\n" +
        contents);
  }

  public final void sendSMS(String phoneNumber, String body) {
    sendSMSFromUri("smsto:" + phoneNumber, body);
  }

  public final void sendSMSFromUri(String uri, String body) {
    Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse(uri));
    putExtra(intent, "sms_body", body);
    // Exit the app once the SMS is sent
    intent.putExtra("compose_mode", true);
    launchIntent(intent);
  }

  public final void sendMMS(String phoneNumber, String subject, String body) {
    sendMMSFromUri("mmsto:" + phoneNumber, subject, body);
  }

  public final void sendMMSFromUri(String uri, String subject, String body) {
    Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse(uri));
    // The Messaging app needs to see a valid subject or else it will treat this an an SMS.
    if (subject == null || subject.length() == 0) {
      putExtra(intent, "subject", mActivity.getString(R.string.msg_default_mms_subject));
    } else {
      putExtra(intent, "subject", subject);
    }
    putExtra(intent, "sms_body", body);
    intent.putExtra("compose_mode", true);
    launchIntent(intent);
  }

  public final void dialPhone(String phoneNumber) {
    launchIntent(new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + phoneNumber)));
  }

  public final void dialPhoneFromUri(String uri) {
    launchIntent(new Intent(Intent.ACTION_DIAL, Uri.parse(uri)));
  }

  public final void openMap(String geoURI) {
    launchIntent(new Intent(Intent.ACTION_VIEW, Uri.parse(geoURI)));
  }

  /**
   * Do a geo search using the address as the query.
   *
   * @param address The address to find
   * @param title An optional title, e.g. the name of the business at this address
   */
  public final void searchMap(String address, String title) {
    String query = address;
    if (title != null && title.length() > 0) {
      query = query + " (" + title + ')';
    }
    launchIntent(new Intent(Intent.ACTION_VIEW, Uri.parse("geo:0,0?q=" + Uri.encode(query))));
  }

  public final void getDirections(double latitude, double longitude) {
    launchIntent(new Intent(Intent.ACTION_VIEW, Uri.parse("http://maps.google." +
        LocaleManager.getCountryTLD() + "/maps?f=d&daddr=" + latitude + ',' + longitude)));
  }

  // Uses the mobile-specific version of Product Search, which is formatted for small screens.
  public final void openProductSearch(String upc) {
    Uri uri = Uri.parse("http://www.google." + LocaleManager.getProductSearchCountryTLD() +
        "/m/products?q=" + upc + "&source=zxing");
    launchIntent(new Intent(Intent.ACTION_VIEW, uri));
  }

  public final void openBookSearch(String isbn) {
    Uri uri = Uri.parse("http://books.google." + LocaleManager.getBookSearchCountryTLD() +
        "/books?vid=isbn" + isbn);
    launchIntent(new Intent(Intent.ACTION_VIEW, uri));
  }

  public final void searchBookContents(String isbn) {
    Intent intent = new Intent(Intents.SearchBookContents.ACTION);
    intent.setClassName(mActivity, SearchBookContentsActivity.class.getName());
    putExtra(intent, Intents.SearchBookContents.ISBN, isbn);
    launchIntent(intent);
  }

  public final void openURL(String url) {
    launchIntent(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
  }

  public final void webSearch(String query) {
    Intent intent = new Intent(Intent.ACTION_WEB_SEARCH);
    intent.putExtra("query", query);
    launchIntent(intent);
  }

  private void launchIntent(Intent intent) {
    if (intent != null) {
      try {
        mActivity.startActivity(intent);
      } catch (ActivityNotFoundException e) {
        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        builder.setTitle(mActivity.getString(R.string.app_name));
        builder.setMessage(mActivity.getString(R.string.msg_intent_failed));
        builder.setPositiveButton(R.string.button_ok, null);
        builder.show();
      }
    }
  }

  private static void putExtra(Intent intent, String key, String value) {
    if (value != null && value.length() > 0) {
      intent.putExtra(key, value);
    }
  }

}
