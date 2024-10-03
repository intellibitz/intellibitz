package com.androidworks.navsys.wuffit.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import com.androidworks.navsys.wuffit.R;

public class WuffITTracker extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

// SELECT the trackers from the contacts phone list
        findViewById(R.id.select_tracker).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_SELECT_TRACKER");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

// SETS UP the trackers, by sending an sms
        findViewById(R.id.setup_wuffit).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_SETUP_WUFFIT");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

// REQUESTS trackers location, by sending an sms
        findViewById(R.id.request_location).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_REQUEST_LOCATION");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

// DISPLAYS trackers location, by sending an sms
        findViewById(R.id.display_location).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_DISPLAY_LOCATION");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

// EXIT       
        findViewById(R.id.exit).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
//                finish();
// Intent { action=android.intent.action.MAIN categories={android.intent.category.HOME} flags=0x10200000 comp={com.android.launcher/com.android.launcher.Launcher} }               
// Go Home
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.addCategory(Intent.CATEGORY_HOME);
                startActivity(intent);
            }
        });

    }

}
