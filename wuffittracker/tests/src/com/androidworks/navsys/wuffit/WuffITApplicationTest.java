package com.androidworks.navsys.wuffit;

import android.test.ApplicationTestCase;

public class WuffITApplicationTest extends ApplicationTestCase<WuffITApplication> {
    public WuffITApplicationTest() {
        super(WuffITApplication.class);
    }

    @Override
    protected void setUp() throws Exception {
        super.setUp();
        createApplication();
    }
}
