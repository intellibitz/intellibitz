package com.androidworks.navsys.wuffit.activity;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.Contacts;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;
import android.widget.Toast;
import com.androidworks.navsys.wuffit.R;
import com.androidworks.navsys.wuffit.WuffITApplication;
import com.androidworks.navsys.wuffit.content.Tracker;

public class SelectTracker extends ListActivity {
    private TextView footerCountText;

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.select_tracker);

        findViewById(R.id.pick_tracker).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent(Intent.ACTION_PICK);
                intent.setData(Contacts.Phones.CONTENT_URI);
                startActivityForResult(intent, 1);
            }
        });
        findViewById(R.id.sync_tracker).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Syncs trackers with contacts
                ((WuffITApplication) getApplication()).syncTrackers();
            }
        });
        findViewById(R.id.main_menu).setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
// Go to select trackers screen
                Intent intent = new Intent("com.androidworks.navsys.wuffit.ACTION_MAIN_MENU");
                intent.addCategory(Intent.CATEGORY_DEFAULT);
                startActivity(intent);
            }
        });

        View footer = ((LayoutInflater) getSystemService(
                Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.footer_view, null);
        footerCountText = (TextView) footer.findViewById(R.id.text2);
        getListView().addFooterView(footer);

    }

    @Override
    protected void onActivityResult(int i, int i1, Intent intent) {
        if (null == intent) {
            Toast.makeText(this, "No Contacts Picked.. Try again", Toast.LENGTH_LONG).show();
        } else {
            Log.d("WuffITTracker", intent.getDataString());
            ((WuffITApplication) getApplication()).storeTrackerId(intent.getDataString());
//            Toast.makeText(this, "Contact Picked = " + intent.getDataString(), Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateTrackersOnView();
    }

    private void updateTrackersOnView() {
        Cursor cursor = managedQuery(Tracker.Details.CONTENT_URI,
                new String[]{Tracker.Details._ID, Tracker.Details.NAME,
                        Tracker.Details.NUMBER}, null, null, null);
        SimpleCursorAdapter simpleCursorAdapter = new TrackerSimpleAdapter
                (this, R.layout.select_tracker_item, cursor,
                        new String[]{Tracker.Details.NAME, Tracker.Details.NUMBER},
                        new int[]{android.R.id.text1, android.R.id.text2});
        footerCountText.setText("(" + cursor.getCount() + ")");
        getListView().setAdapter(simpleCursorAdapter);
    }

    class TrackerSimpleAdapter extends SimpleCursorAdapter {

        public TrackerSimpleAdapter(Context context, int i, Cursor cursor, String[] strings, int[] ints) {
            super(context, i, cursor, strings, ints);
        }

        @Override
        public View getView(int i, View view, ViewGroup viewGroup) {
            View v = super.getView(i, view, viewGroup);
            View ib = v.findViewById(R.id.delete);
            ib.setTag(getCursor().getString(0));
            ib.setOnClickListener(new View.OnClickListener() {
                public void onClick(View view) {
// delete the tracker item
                    Log.d("TrackerSimpleAdapter:OnClick ", "id: " + view.getTag());
                    ((WuffITApplication) getApplication()).deleteTracker((String) view.getTag());
                    updateTrackersOnView();
                }
            });
            return v;
        }
    }
}