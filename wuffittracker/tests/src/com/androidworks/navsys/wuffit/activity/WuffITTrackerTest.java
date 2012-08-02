package com.androidworks.navsys.wuffit.activity;

import android.test.ActivityInstrumentationTestCase;

/**
 * This is a simple framework for a test of an Application.  See
 * {@link android.test.ApplicationTestCase ApplicationTestCase} for more information on
 * how to write and extend Application tests.
 * <p/>
 * To run this test, you can type:
 * adb shell am instrument -w \
 * -e class com.fiteclub.android.FiteClubApplicationTest \
 * com.androidworks.navssys.wuffit.tests/android.test.InstrumentationTestRunner
 */
public class WuffITTrackerTest extends ActivityInstrumentationTestCase<WuffITTracker> {
    public WuffITTrackerTest() {
        super("com.androidworks.navsys.wuffit", WuffITTracker.class);
    }
}
