package intellibitz.intellidroid.fragment;

import android.app.Activity;
import android.content.ComponentName;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.Resources;
import android.database.ContentObserver;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.Parcelable;
import android.os.RemoteException;
import android.text.TextUtils;
import android.text.util.Rfc822Token;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;
import intellibitz.intellidroid.IntellibitzActivityFragment;
import intellibitz.intellidroid.bean.BaseItemComparator;
import intellibitz.intellidroid.data.ContactItem;
import intellibitz.intellidroid.data.MessageItem;
import intellibitz.intellidroid.db.ContactItemColumns;
import intellibitz.intellidroid.db.DatabaseHelper;
import intellibitz.intellidroid.db.MessageItemColumns;
import intellibitz.intellidroid.graphics.ColorGenerator;
import intellibitz.intellidroid.graphics.TextDrawable;
import intellibitz.intellidroid.listener.ContactListener;
import intellibitz.intellidroid.listener.MessageListener;
import intellibitz.intellidroid.listener.PeopleDetailListener;
import intellibitz.intellidroid.listener.PeopleTopicListener;
import intellibitz.intellidroid.task.BitmapFromUrlTask;
import intellibitz.intellidroid.task.CreateDraftTask;
import intellibitz.intellidroid.task.CreateGroupTask;
import intellibitz.intellidroid.task.DeleteMsgsTask;
import intellibitz.intellidroid.task.GetDraftsTask;
import intellibitz.intellidroid.task.GroupsAddUsersTask;
import intellibitz.intellidroid.util.MainApplicationSingleton;
import intellibitz.intellidroid.util.NetworkImageView;
import intellibitz.intellidroid.IntellibitzActivityFragment;
import intellibitz.intellidroid.R;
import intellibitz.intellidroid.activity.ClutterEmailsActivity;
import intellibitz.intellidroid.activity.ContactSelectActivity;
import intellibitz.intellidroid.activity.MessageChatGroupActivity;
import intellibitz.intellidroid.activity.MsgChatGrpContactsDetailActivity;
import intellibitz.intellidroid.activity.PeopleDetailActivity;
import intellibitz.intellidroid.bean.BaseItemComparator;
import intellibitz.intellidroid.content.IntellibitzContactContentProvider;
import intellibitz.intellidroid.content.MessageChatContentProvider;
import intellibitz.intellidroid.content.MessageChatGroupContentProvider;
import intellibitz.intellidroid.content.MessageEmailContentProvider;
import intellibitz.intellidroid.content.MessagesChatContentProvider;
import intellibitz.intellidroid.content.MsgsGrpDraftContentProvider;
import intellibitz.intellidroid.content.MsgsGrpPeopleContentProvider;
import intellibitz.intellidroid.content.UserEmailContentProvider;
import intellibitz.intellidroid.content.task.GroupsSaveToDBTask;
import intellibitz.intellidroid.data.ContactItem;
import intellibitz.intellidroid.data.MessageItem;
import intellibitz.intellidroid.db.ContactItemColumns;
import intellibitz.intellidroid.db.DatabaseHelper;
import intellibitz.intellidroid.db.MessageItemColumns;
import intellibitz.intellidroid.domain.account.EmailAccountListActivity;
import intellibitz.intellidroid.graphics.ColorGenerator;
import intellibitz.intellidroid.graphics.TextDrawable;
import intellibitz.intellidroid.listener.ContactListener;
import intellibitz.intellidroid.listener.MessageListener;
import intellibitz.intellidroid.listener.PeopleDetailListener;
import intellibitz.intellidroid.listener.PeopleTopicListener;
import intellibitz.intellidroid.service.ChatService;
import intellibitz.intellidroid.task.BitmapFromUrlTask;
import intellibitz.intellidroid.task.CreateDraftTask;
import intellibitz.intellidroid.task.CreateGroupTask;
import intellibitz.intellidroid.task.DeleteMsgsTask;
import intellibitz.intellidroid.task.GetDraftsTask;
import intellibitz.intellidroid.task.GroupsAddUsersTask;
import intellibitz.intellidroid.util.MainApplicationSingleton;
import intellibitz.intellidroid.util.NetworkImageView;
import intellibitz.intellidroid.widget.NewBottomDialogFragment;
import intellibitz.intellidroid.widget.NewEmailDialogFragment;

import intellibitz.intellidroid.activity.ClutterEmailsActivity;
import intellibitz.intellidroid.content.*;
import intellibitz.intellidroid.service.ChatService;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.view.ActionMode;
import androidx.appcompat.widget.SearchView;
import androidx.fragment.app.DialogFragment;
import androidx.loader.app.LoaderManager;
import androidx.loader.content.CursorLoader;
import androidx.loader.content.Loader;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import static intellibitz.intellidroid.util.MainApplicationSingleton.ACTIVITY_CONTACTSELECT_RQ_CODE;
import static intellibitz.intellidroid.util.MainApplicationSingleton.ACTIVITY_MSGCHATGRPCONTACTS_RQ_CODE;
import static intellibitz.intellidroid.util.MainApplicationSingleton.getBaseItem;

public class MsgsGrpDraftFragment extends
        IntellibitzActivityFragment implements
        SearchView.OnQueryTextListener,
        SearchView.OnCloseListener,
        ContactListener,
        PeopleDetailListener,
        CreateGroupTask.CreateGroupTaskListener,
        GroupsAddUsersTask.GroupsAddUsersTaskListener,
        GroupsSaveToDBTask.GroupsSaveToDBTaskListener,
        NewEmailDialogFragment.OnNewEmailDialogFragmentListener,
        LoaderManager.LoaderCallbacks<Cursor>,
        AdapterView.OnItemClickListener,
        View.OnClickListener,
        DeleteMsgsTask.DeleteMsgsTaskListener,
        NewBottomDialogFragment.NewBottomDialogListener,
        GetDraftsTask.GetDraftsTaskListener,
        CreateDraftTask.CreateDraftTaskListener
//        FetchMessageThreadShalJoinCursorTask.FetchCursorTaskListener
{

    private static final String TAG = "MsgsGrpDraftFrag";
    /**
     * Target we publish for clients to send messages to IncomingHandler.
     */
    final Messenger mMessenger = new Messenger(new IncomingHandler());
    private final Object lock = new Object();
    /**
     * Messenger for communicating with service.
     */
    Messenger mService = null;
    /**
     * Flag indicating whether we have called bind on the service.
     */
    boolean mIsBound;
    private View rootView;
    private Snackbar snackbar;
    private FloatingActionButton fab;
    private String filter = null;
    private ContentObserver messageContentObserver;
    private RecyclerView rvMessages;
    private RecyclerViewAdapter rvMessagesAdapter;
    private CreateGroupTask createGroupTask;
    private GroupsAddUsersTask groupsAddUsersTask;
    private GroupsSaveToDBTask groupsSaveToDBTask;
    private DeleteMsgsTask deleteMsgsTask;
    private MessageItem selectedItem;
    private Intent sharedIntent;
    private ContactItem contactItem;
    private NewBottomDialogFragment newBottomDialogFragment;
    private ArrayList<MessageItem> messageItems = new ArrayList<>();
    //    private FetchMessageThreadShalJoinCursorTask fetchMessageThreadShalJoinCursorTask;
    private int counter = 0;
    private HandlerThread looperThread;
    private boolean isMinusChat;
    private MessageItem messageItemToForward;
    private GetDraftsTask getDraftsTask;

    //    private String intellibitzId;
    private CreateDraftTask createDraftTask;
    private MessageItem messageItemToAdd;
    private PeopleTopicListener peopleTopicListener;
    private PeopleDetailListener peopleDetailListener;
    private TextView empty;
    /**
     * Class for interacting with the main interface of the service.
     */
    private ServiceConnection mConnection = new ServiceConnection() {
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            // This is called when the connection with the service has been
            // established, giving us the service object we can use to
            // interact with the service.  We are communicating with our
            // service through an IDL interface, so get a client-side
            // representation of that from the raw service object.
            mService = new Messenger(service);
//            mCallbackText.setText("Attached.");

            // We want to monitor the service for as long as we are
            // connected to it.
            try {
                Message msg = Message.obtain(null,
                        ChatService.MSG_REGISTER_CLIENT);
                msg.replyTo = mMessenger;
                mService.send(msg);

                // Give it some value as an example.
                msg = Message.obtain(null,
                        ChatService.MSG_SET_VALUE, this.hashCode(), 0);
                mService.send(msg);
            } catch (RemoteException e) {
                // In this case the service has crashed before we could even
                // do anything with it; we can count on soon being
                // disconnected (and then reconnected if it can be restarted)
                // so there is no need to do anything here.
            }

        }

        public void onServiceDisconnected(ComponentName className) {
            // This is called when the connection with the service has been
            // unexpectedly disconnected -- that is, its process crashed.
            mService = null;
//            mCallbackText.setText("Disconnected.");

        }
    };
    private ActionMode mActionMode;
    private ActionMode.Callback mActionModeCallback = new ActionMode.Callback() {

        // Called when the action mode is created; startActionMode() was called
        @Override
        public boolean onCreateActionMode(ActionMode mode, Menu menu) {
            // Inflate a menu resource providing context menu items
            MenuInflater inflater = mode.getMenuInflater();
            inflater.inflate(R.menu.menu_context_chatty, menu);
            return true;
        }

        // Called each time the action mode is shown. Always called after onCreateActionMode, but
        // may be called multiple times if the mode is invalidated.
        @Override
        public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
            return false; // Return false if nothing is done
        }

        // Called when the user selects a contextual menu item
        @Override
        public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
            switch (item.getItemId()) {
                case R.id.menu_delete:
                    deleteMessages();
//                    shareCurrentItem();
                    mode.finish(); // Action picked, so close the CAB
                    return true;
                case R.id.menu_moveto:
//                    shareCurrentItem();
                    mode.finish(); // Action picked, so close the CAB
                    return true;
                default:
                    return false;
            }
        }

        // Called when the user exits the action mode
        @Override
        public void onDestroyActionMode(ActionMode mode) {
            mActionMode = null;
        }
    };

    public static MsgsGrpDraftFragment newInstance(
            MessageItem messageItem, ContactItem user, MessageListener messageListener) {
        MsgsGrpDraftFragment fragment = new MsgsGrpDraftFragment();
//        PeopleDetailFragment detailFragment = new PeopleDetailFragment();
//        fragment.setFragmentContext(c);
        fragment.setUser(user);
        if (messageListener instanceof PeopleTopicListener)
            fragment.setPeopleTopicListener((PeopleTopicListener) messageListener);
        if (messageListener instanceof PeopleDetailListener)
            fragment.setPeopleDetailListener((PeopleDetailListener) messageListener);
        fragment.setViewModeListener(messageListener);
        Bundle args = new Bundle();
        args.putParcelable(MessageItem.TAG, messageItem);
        args.putParcelable(ContactItem.USER_CONTACT, user);
        fragment.setArguments(args);
        return fragment;
    }

    public void setSharedIntent(Intent sharedIntent) {
        this.sharedIntent = sharedIntent;
    }

    public void setPeopleDetailListener(PeopleDetailListener peopleDetailListener) {
        this.peopleDetailListener = peopleDetailListener;
    }

    private void showTyping(String toUid, String fromUid, String fromName, ContactItem user) {
        final MessageItem item = MainApplicationSingleton.getBaseItem(fromUid, messageItems);
        if (null == item) {

        } else {
            if (fromUid.equals(user.getDataId())) {
// if self is typing ignore..
//                shows typing only from other senders
            } else {
                item.setTyping(true);
                item.setTypingText(fromName + " is typing..");
                final int pos = messageItems.indexOf(item);
                rvMessagesAdapter.notifyItemChanged(pos);
//            restartLoader(null);
                onPeopleTyping(fromName + " is typing..");
//                                setToolBarShowTyping(name + " is typing..");
                final Handler delay = new Handler();
                delay.postDelayed(new Runnable() {
                    @Override
                    public void run() {
//                                        setToolBarSubTitle(toolbarSubTitle);
//                    name = null;
//                    restartLoader(null);
                        item.setTyping(false);
                        rvMessagesAdapter.notifyItemChanged(pos);
                        onPeopleTypingStopped("");
                    }
                }, 1000);
            }
        }
    }

    @Override
    public void onPeopleTyping(String text) {
        if (null == peopleDetailListener) {
// // TODO: 21-05-2016
//            listeners need to be saved, restored or recreated brand new every time
        } else {
            peopleDetailListener.onPeopleTyping(text);
//        getAppCompatActivity().getToolbar().setSubtitle(text);
//        toolbar.setSubtitleTextColor(Color.GREEN);
        }
    }

    @Override
    public void onPeopleTypingStopped(String text) {
        if (null == peopleDetailListener) {
// // TODO: 21-05-2016
//            listeners need to be saved, restored or recreated brand new every time
        } else {
            peopleDetailListener.onPeopleTypingStopped(text);
//        getAppCompatActivity().getToolbar().setSubtitle(text);
//        toolbar.setSubtitleTextColor(Color.WHITE);
        }
    }

    void doBindService() {
        // Establish a connection with the service.  We use an explicit
        // class name because there is no reason to be able to let other
        // applications replace our component.
        getAppCompatActivity().bindService(new Intent(getAppCompatActivity(),
                ChatService.class), mConnection, Context.BIND_AUTO_CREATE);
        mIsBound = true;
//        mCallbackText.setText("Binding.");
    }

    void doUnbindService() {
        if (mIsBound) {
            // If we have received the service, and hence registered with
            // it, then now is the time to unregister.
            if (mService != null) {
                try {
                    Message msg = Message.obtain(null,
                            ChatService.MSG_UNREGISTER_CLIENT);
                    msg.replyTo = mMessenger;
                    mService.send(msg);
                } catch (RemoteException e) {
                    // There is nothing special we need to do if the service
                    // has crashed.
                }
            }

            // Detach our existing connection.
            getAppCompatActivity().unbindService(mConnection);
            mIsBound = false;
//            mCallbackText.setText("Unbinding.");
        }
    }

    public void showEmpty() {
        this.empty.setVisibility(View.VISIBLE);
        empty.setText(R.string.empty_chat_account);
    }

    public void showEmpty(String msg) {
        this.empty.setVisibility(View.VISIBLE);
        empty.setText(msg);
    }

    public void hideEmpty() {
        if (empty != null)
            empty.setVisibility(View.GONE);
    }

    public View getRootView() {
        return rootView;
    }

    public void setUser(ContactItem user) {
        this.user = user;
    }

    public void setPeopleTopicListener(PeopleTopicListener peopleTopicListener) {
        this.peopleTopicListener = peopleTopicListener;
    }

    private void addUsersToGroups(String id, String name, String[] contacts) {
        groupsAddUsersTask = new GroupsAddUsersTask(id, name, contacts, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_GROUP_ADD_USERS);
        groupsAddUsersTask.setGroupsAddUsersTaskListener(this);
        groupsAddUsersTask.execute();
    }

    @Override
    public void setGroupsAddUsersTaskToNull() {
        groupsAddUsersTask = null;
    }

    private void createNewGroupChat(ContactItem contactItem) {
        contactItem.setGroup(true);
        contactItem.setType("GROUP");
        createGroupTask = new CreateGroupTask(contactItem, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_CREATE_GROUP);
        createGroupTask.setCreateGroupTaskListener(this);
        createGroupTask.execute();
    }

    @Override
    public void onPostCreateGroupExecuteFail(JSONObject response,
                                             String name, File file, String[] contacts,
                                             ContactItem contactItem) {
//                ERROR
        Log.e(TAG, "CONTACTS GET ERROR - " + response);

    }

    public void onPostCreateGroupExecute(JSONObject response,
                                         String name, File file, String[] contacts,
                                         ContactItem contactItem) {
        int status = 0;
        if (response != null)
            status = response.optInt("status");
        if (null == response || 99 == status || -1 == status) {
//            retries again..
            onPostCreateGroupExecuteFail(response, name, file, contacts, contactItem);
        } else {
            try {
                String id = response.getString("group_id");
                if (null == id || 0 == id.length()) {
//            retries again..
                    Log.e(TAG, "Groups save failed: id is null -" + id);
                    onPostCreateGroupExecuteFail(response, name, file, contacts, contactItem);
                } else {
//                    sets the saved group id returned by the cloud
//                    only the id is relevant, rest of the info already with the contact
                    contactItem.setDataId(id);
                    contactItem.setIntellibitzId(id);
                    contactItem.setTypeId(id);

//                    if (!TextUtils.isEmpty(name))
//                        contactItem.setName(name);
//                    if (file != null)
//                        contactItem.setProfilePic(file.getAbsolutePath());
                    savesGroupsInDB(contactItem, getAppCompatActivity().getApplicationContext());
/*
                    savesGroupInDB(name, file, contacts, id);
                    savesGroupInDB(name, file, id);
                    Log.e(TAG, " GROUPS Contacts - SUCCESS - ");
                    addUsersToGroups(id, name, contacts);
*/
                }
            } catch (JSONException e) {
                e.printStackTrace();
                Log.e(TAG, e.getMessage());
            }
        }
    }

/*
    public void savesGroupInDB(String name, File file, String[] contacts, String id) {
        ContactItem contactItem = new ContactItem();
        contactItem.setDataId(id);
        contactItem.setName(name);
        contactItem.setProfilePic(file.getAbsolutePath());
        if (contacts != null && contacts.length > 0) {
            Collection<ContactItem> items =
                    Collections.synchronizedSet(
                            new HashSet<ContactItem>(contacts.length));
            for (String contact : contacts) {
                ContactItem intellibitzContactItem = new ContactItem();
                intellibitzContactItem.setDataId(contact);
                intellibitzContactItem.setIntellibitzId(contact);
                items.add(intellibitzContactItem);
            }
            contactItem.setContactItems(items);
        }
        savesGroupsInDB(contactItem, getAppCompatActivity().getApplicationContext());
    }
*/

    private void savesGroupsInDB(ContactItem contactItem, Context context) {
        groupsSaveToDBTask = new GroupsSaveToDBTask(contactItem, context);
        groupsSaveToDBTask.setGroupsSaveToDBTaskListener(this);
        groupsSaveToDBTask.execute();
    }

    public void savesGroupInDB(String name, File file, String id) {
        ContactItem contactItem = new ContactItem();
        contactItem.setDataId(id);
        contactItem.setName(name);
        contactItem.setProfilePic(file.getAbsolutePath());
        Collection<ContactItem> contactItems = new ArrayList<>(1);
        contactItems.add(contactItem);
        savesGroupsInDB(contactItems, getAppCompatActivity().getApplicationContext());
    }

    private void savesGroupsInDB(Collection<ContactItem> contacts, Context context) {
        groupsSaveToDBTask = new GroupsSaveToDBTask(contacts, context);
        groupsSaveToDBTask.setGroupsSaveToDBTaskListener(this);
        groupsSaveToDBTask.execute();
    }

    @Override
    public void setGroupsSaveToDBTaskToNull() {
        groupsSaveToDBTask = null;
    }

    @Override
    public void onPostGroupsSaveToDBExecute(Uri uri, Collection<ContactItem> contacts) {
        if (contacts != null && !contacts.isEmpty()) {
            contactItem = contacts.iterator().next();
//            ContactItem contactItem = contacts.values().iterator().next();
//            contactItems.put(contactItem.getDataId(), contactItem);
            addUsersToGroups(contactItem);
            Log.e(TAG, " GROUPS Contacts - SUCCESS - " + uri);
        } else {
            Log.e(TAG, "Group Save has returned EMPTY contacts - PLEASE CHECK: " + uri);
        }
    }

    private void addUsersToGroups(ContactItem contactItem) {
        groupsAddUsersTask = new GroupsAddUsersTask(contactItem, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_GROUP_ADD_USERS);
        groupsAddUsersTask.setGroupsAddUsersTaskListener(this);
        groupsAddUsersTask.execute();
    }

    @Override
    public void onPostGroupsAddUsersExecuteFail(JSONObject response,
                                                String id, String name, String[] contacts,
                                                ContactItem contactItem) {
        Log.e(TAG, "onPostGroupsAddUsersExecuteFail: " + response);
    }

    @Override
    public void onPostGroupsAddUsersExecute(JSONObject response,
                                            String id, String name, String[] contacts,
                                            ContactItem contactItem) {
        int status = 0;
        if (response != null)
            status = response.optInt("status");
        if (null == response || 99 == status || -1 == status) {
            onPostGroupsAddUsersExecuteFail(response, id, name, contacts, contactItem);
//            retries again..
        } else {
//            createNewChat(contactItem, user, getAppCompatActivity().getApplicationContext());
            createNewChat(contactItem, user);
            Log.e(TAG, " GROUPS ADD USERS - SUCCESS - ");
        }
    }

    @Override
    public void setCreateGroupTaskToNull() {
        createGroupTask = null;
    }

    @Override
    public void onViewModeChanged() {
        if (viewModeListener != null) {
            viewModeListener.onViewModeChanged();
        }
        super.onViewModeChanged();
    }

    @Override
    public void onViewModeItem() {
        if (viewModeListener != null) {
            viewModeListener.onViewModeItem();
        }
        super.onViewModeItem();
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        doBindService();
//        peopleTopicListener = (PeopleTopicListener) context;
        messageContentObserver = new ContentObserver(new Handler()) {
            @Override
            public boolean deliverSelfNotifications() {
                return super.deliverSelfNotifications();
            }

            @Override
            public void onChange(boolean selfChange) {
                onChange(selfChange, null);
            }

            @Override
            public void onChange(boolean selfChange, Uri uri) {
                synchronized (lock) {
                    counter++;
                    looperThread = MainApplicationSingleton.performOnHandlerThread(new Runnable() {
                        @Override
                        public void run() {
                            try {
//                                sleeps 30 seconds.. let the rcv doc catch up
//                                Thread.sleep(30000);
                                Thread.sleep(500);
                            } catch (InterruptedException ignored) {
//                                e.printStackTrace();
                                Log.e(TAG, ignored.getMessage());
                            }
                            MsgsGrpDraftFragment.this.quitHandlerThread();
                        }
                    });
                }
            }
        };
        getAppCompatActivity().getContentResolver().registerContentObserver(
                MsgsGrpPeopleContentProvider.CONTENT_URI, true,
                messageContentObserver);
    }

    private void quitHandlerThread() {
        if (looperThread != null)
            looperThread.quit();
        if (counter > 1) {
            Log.d(TAG, "quitHandlerThread: counter - " + counter);
            counter--;
            return;
        }
        if (counter <= 1) {
            counter = 0;
            final Activity appCompatActivity = getAppCompatActivity();
            if (null == appCompatActivity) return;
            if (appCompatActivity.isFinishing()) return;
            if (MainApplicationSingleton.isAPI17()) {
                if (appCompatActivity.isDestroyed()) return;
            }
            restartLoader();
            Log.d(TAG, "quitHandlerThread: counter - " + counter);
        }
    }

    @Override
    public void onDestroy() {
        doUnbindService();
        getAppCompatActivity().getContentResolver().unregisterContentObserver(messageContentObserver);
        super.onDestroy();
    }

    public void onNewMenuClicked() {
        showNewMessageDialog();
    }

    public void onNewMenuDetailClicked() {
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        outState.putParcelable(ContactItem.USER_CONTACT, user);
//        outState.putParcelableArrayList(MessageItem.TAG, messageItems);
        super.onSaveInstanceState(outState);
    }

    @Override
    public void onViewStateRestored(@Nullable Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
        if (savedInstanceState != null) {
            user = savedInstanceState.getParcelable(ContactItem.USER_CONTACT);
/*
            messageItems = savedInstanceState.getParcelableArrayList(
                    MessageItem.TAG);
*/
        }
    }

    @Override
    public void onPostDraftsGetFromCloudExecute(JSONObject response) {
        Log.e(TAG, "onPostDraftsGetFromCloudExecute: " + response);
        int status = 0;
        if (response != null)
            status = response.optInt("status");
        if (null == response || -1 == status || 99 == status) {
//            retries again..
            onPostDraftsGetFromCloudExecuteFail(response);
        } else {
            JSONArray array = response.optJSONArray("drafts");
            if (null == array || 0 == array.length()) {
//            retries again..
                onPostDraftsGetFromCloudExecuteFail(response);
            } else {
                savesDraftsFromJson(array);
            }
        }
    }

    @Override
    public void onPostDraftsGetFromCloudExecuteFail(JSONObject response) {
        Log.e(TAG, "onPostDraftsGetFromCloudExecuteFail: " + response);
    }

    @Override
    public void setDraftsGetFromCloudTaskToNull() {
        getDraftsTask = null;
    }

    @Override
    public void onPostCreateDraftFromCloudExecute(JSONObject response, MessageItem messageItem) {
        Log.e(TAG, "onPostCreateDraftFromCloudExecute: " + response);
        int status = 0;
        if (response != null)
            status = response.optInt("status");
        if (null == response || -1 == status || 99 == status) {
//            retries again..
            onPostCreateDraftFromCloudExecuteFail(response, messageItem);
        } else {
//            draftItems.add(messageItem);
//            savesDraftsFromJson(messageThreadItem, getAppCompatActivity().getApplicationContext());
//            getDraftsFromCloud();
            try {
                String id = response.getString("draft_id");
                if (!TextUtils.isEmpty(id)) {
                    messageItem.setDataId(id);
                    savesDraft(messageItem);
                    restartLoader();
                    Log.d(TAG, "Draft saved Success: " + id);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onPostCreateDraftFromCloudExecuteFail(JSONObject response, MessageItem nestItem) {
        Log.e(TAG, "onPostCreateDrFromCloudExecuteFail: " + response);
    }

    @Override
    public void setCreateDraftFromCloudTaskToNull() {
        createDraftTask = null;
    }

    private void savesDraftsFromJson(JSONArray jsonArray) {
        try {
            MsgsGrpDraftContentProvider.savesMsgsGrpDraftFromJSON(
                    jsonArray, user, getAppCompatActivity());
        } catch (JSONException | IOException e) {
            e.printStackTrace();
            Log.e(TAG, e.getMessage());
        }
    }

    private void savesDraft(MessageItem messageItem) {
        MsgsGrpDraftContentProvider.savesMsgsGrpDraft(messageItem, getAppCompatActivity());
    }

    private void getDraftsFromCloud() {
        getDraftsTask = new GetDraftsTask(user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_GET_DRAFTS);
        getDraftsTask.setGetDraftsTaskListener(this);
        getDraftsTask.execute();
    }

    private void execCreateDraft(MessageItem item) {
        createDraftTask = new CreateDraftTask(item, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_CREATE_DRAFT);
        createDraftTask.setCreateDraftTaskListener(this);
        createDraftTask.execute();
    }

    private boolean isDraftsEmptyInDB() {
        return DatabaseHelper.isRowCountEmpty(
                MsgsGrpDraftContentProvider.RAW_CONTENT_URI,
                MsgsGrpDraftContentProvider.TABLE_MSGSGRPDRAFT,
                " WHERE " + MessageItemColumns.KEY_DOC_TYPE + " = 'DRAFT'",
                getAppCompatActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_msgsgrpdraft, container, false);
        return rootView;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (null == savedInstanceState) {
            user = getArguments().getParcelable(ContactItem.USER_CONTACT);
            messageItemToAdd = getArguments().getParcelable(MessageItem.TAG);
            if (isDraftsEmptyInDB()) {
//                refreshes contacts
//                gets contact from cloud logic
                getDraftsFromCloud();
            }
        }
/*
        if (getAppCompatActivity() != null) {
            getAppCompatActivity().setTvToolbarTitle(R.string.toolbar_messages_title);
        }
*/
        empty = (TextView) rootView.findViewById(R.id.tv_empty);
        empty.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startEmailListActivity();
            }
        });

        rvMessages = (RecyclerView) rootView.findViewById(R.id.recyclerview);
        setupSwipe(rootView);

        setupFAB(rootView);
        setupSnackBar(rootView);

        if (messageItemToAdd != null) {
            execCreateDraft((MessageItem) messageItemToAdd.cloneShal());
            messageItemToAdd = null;
        }
        restartLoader();
    }

    private void startEmailListActivity() {
        Intent intent = new Intent(getAppCompatActivity(), EmailAccountListActivity.class);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        startActivityForResult(intent, MainApplicationSingleton.ACTIVITY_EMAILACCOUNT_RQ_CODE);
    }

    public void restartFilterLoaders() {
        if (isMinusChat) {
            restartLoader();
        }
/*
        Bundle arguments = getArguments();
        if (null == arguments){
//            restartCacheLoader();
            return;
        } else {
            if (arguments.getBoolean("isMinusChat")){
                isMinusChat = true;
                restartLoader();
                return;
            }
        }
*/
//        restartCacheLoader();
    }

    public void setupSwipe(View rootView) {
        final SwipeRefreshLayout refreshLayout = (SwipeRefreshLayout)
                rootView.findViewById(R.id.swiperefresh);
        if (refreshLayout != null) {
            refreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
                private final Handler mHandler = new Handler();

                @Override
                public void onRefresh() {
                    // Post a delayed runnable to reset the refreshing state in 2 seconds
                    mHandler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            refreshLayout.setRefreshing(false);
                        }
                    }, 2000);
                }
            });
        }
    }

    private void restartLoader(Uri uri) {
        try {
            long id = ContentUris.parseId(uri);
/*
            if (MessagesContentProvider.AUTHORITY.equals(uri.getAuthority())) {
                Cursor cursor = getAppCompatActivity().getContentResolver().query(
                        uri, null, null, null, null);
                if (cursor != null && cursor.getCount() > 0) {
                    MessageItem messageThreadItem = new MessageItem();
                    MessagesContentProvider.createsMsgsGrpDraftFromCursor(
                            messageThreadItem, cursor);
                    cursor.close();
                    reloadRecycleAdapter(messageThreadItem);
                }
            }
*/
//            empties the list..
//            // TODO: 06-04-2016
//            to update only the changed item
            messageItems.clear();
            restartLoader();
        } catch (NumberFormatException e) {
//            ignore
        }
    }

    protected void restartLoader(String filter) {
        this.filter = filter;
        restartLoader();
    }

    private void restartCacheLoader() {
        ArrayList<? extends Object> objects =
                MainApplicationSingleton.getInstance(getAppCompatActivity()).getGlobalSBValueAsList(
                        MsgsGrpDraftFragment.TAG
                );
        if (null == objects || objects.isEmpty()) {
            restartLoader();
            return;
        }
        if (counter > 0) {
            counter = 0;
            restartLoader();
            Log.d(TAG, "quitHandlerThread: counter - " + counter);
            return;
        }
        this.messageItems = (ArrayList<MessageItem>) objects;
        createRecycleAdapter();
    }

/*
    @Override
    public void onFetchCursorTaskExecute(List<MessageItem> result) {
        if (null == result || result.isEmpty()) {
            onFetchCursorTaskExecuteFail(result);
            return;
        }
        messageItems = (ArrayList<MessageItem>) result;
        MainApplicationSingleton.getInstance(getAppCompatActivity()).putGlobalVariable(
                MsgsGrpPeopleFragment.TAG, messageItems
        );
        createRecycleAdapter();
    }

    @Override
    public void onFetchCursorTaskExecuteFail(List<MessageItem> result) {
        Log.e(TAG, "onFetchCursorTaskExecuteFail: " + result);
    }

    @Override
    public void setFetchCursorTaskToNull() {
        fetchMessageThreadShalJoinCursorTask = null;
    }
*/

    private void restartLoader() {
//        resets the view, only if the items are null
//        // TODO: 06-04-2016
//        for a specific item change.. implement other methods
        getAppCompatActivity().getSupportLoaderManager().restartLoader(
                MainApplicationSingleton.MSGSGRPDRAFT_LOADERID, null, this);
/*
        fetchMessageThreadShalJoinCursorTask = new FetchMessageThreadShalJoinCursorTask(
                filter, getAppCompatActivity());
        fetchMessageThreadShalJoinCursorTask.setFetchCursorTaskListener(this);
        fetchMessageThreadShalJoinCursorTask.execute();
*/
    }

    private void showActiveMessage() {
        if (processNewMessageFromSharedIntent()) {
            Log.d(TAG, "restartLoader:processNewMessageFromSharedIntent is true.. Loader skipped");
            return;
        }
/*
        if (intellibitzId != null) {
            showMessageThreadMessage(intellibitzId, user);
//                clears off the active chat
            intellibitzId = null;
        }
*/
    }

    private void createRecycleAdapter() {
        resetRecycleAdapter();
        showActiveMessage();
    }

    private void resetRecycleAdapter() {
        if (null == rvMessages && getView() != null) {
            rvMessages = (RecyclerView) rootView.findViewById(R.id.recyclerview);
        }
        if (null == rvMessages) {
            Log.e(TAG, "resetRecycleAdapter: recyclerview is NULL");
            return;
        }

        if (null == messageItems) return;
//        List<MessageItem> adapterList = new ArrayList<>(messageItems);
//            sorts messages by asc.. so the latest msg is at the bottom
        Collections.sort(messageItems, new MessageItem.MessageItemComparator(
                BaseItemComparator.SORT_MODE.DESC));

        rvMessagesAdapter =
                new RecyclerViewAdapter(messageItems);
        rvMessagesAdapter.setHasStableIds(true);
        rvMessages.setAdapter(rvMessagesAdapter);
//        rvMessages.scrollToPosition(rvMessagesAdapter.getItemCount() - 1);
//        processMessageToDraft();
    }

    private boolean processNewMessageFromSharedIntent() {
//        a new message can be send by clicking on a contact
//        a device contact, a intellibitz contact or a group contact
//        either an email or a chat message can be initiated based on the contact clicked
        if (null == sharedIntent) return false;
        if (null == sharedIntent.getExtras()) return false;
//            if it is not an individual contact.. then it must be a group
//            get the group contact info, that was shared through broadcast
        final ContactItem contactItem = sharedIntent.getParcelableExtra(ContactItem.TAG);
        if (null == contactItem) {
//                Log.e(TAG, "processNewMessageFromSharedIntent: MsgThreadContact is NULL");
        } else {
            MainApplicationSingleton.performOnUIHandlerThread(new Runnable() {
                @Override
                public void run() {
//            clears the shared intent
                    sharedIntent = null;
//                    getAppCompatActivity().selectMainTab();
//                        the contact will already have that info
//                        contactItem.setGroup(true);
//                        contactItem.setType("GROUP");
                    createNewChat(contactItem, user);
//                        removeSelf();
//                    getAppCompatActivity().nullSharedIntent();
                }
            });
            return true;
        }

        final ContactItem intellibitzContactItem = sharedIntent.getParcelableExtra(
                ContactItem.INTELLIBITZ_CONTACT);
        if (null == intellibitzContactItem) {
        } else {
            MainApplicationSingleton.performOnUIHandlerThread(new Runnable() {
                @Override
                public void run() {
//            clears the shared intent
                    sharedIntent = null;
//                    getAppCompatActivity().selectMainTab();
//                    ContactItem contactItem = new ContactItem();
                    ContactItem contactItem = new ContactItem(intellibitzContactItem);
//                    MsgsGrpPeopleFragment.this.contactItem.setDataId(contactItem.getIntellibitzId());
//                    MsgsGrpPeopleFragment.this.contactItem.setName(contactItem.getName());
//                    MsgsGrpPeopleFragment.this.contactItem.addContact(contactItem);
                    contactItem.setGroup(false);
                    contactItem.setType("USER");
                    createNewChat(contactItem, user);
//            processNewChatMessage(intellibitzId, name);
//                    removeSelf();
//                    getAppCompatActivity().nullSharedIntent();
                }
            });
            return true;
        }

        final ContactItem deviceContactItem = sharedIntent.getParcelableExtra(
                ContactItem.DEVICE_CONTACT);
        if (null == deviceContactItem) {

        } else {

        }
//            clears the shared intent
        sharedIntent = null;
        return false;
    }

    private MessageItem processNewChatMessage(ContactItem contactItem, Context context) {
        String id = contactItem.getDataId();
        if (id != null) {
            Log.d(TAG, "User ready for Chat: " + id);
            MessageItem item = null;
            if (messageItems != null && !messageItems.isEmpty()) {
                item = MainApplicationSingleton.getBaseItem(id, messageItems);
            }
            if (null == item) {
                item = new MessageItem();
//                    item.setDataId(id);
                item.setDataId(MessageItem.TAG);
            }
            item.setDocOwner(user.getDataId());
            item.setName(contactItem.getName());
//                creates a temp thread, with chat id as message id
//                // TODO: 16-05-2016
//                cloud will generate a brand new message id.. query local db with chatid to sync
            MessageChatContentProvider.createMessageChatThread(id, item);
            if (null == item.getName()) {
                item.setName(item.getDataId());
            }
            item.setContactItem(contactItem);
//                saves the message thread..
//                MessagesContentProvider.saveMessageThreadItemToDB(item, context);
            return item;
        }
        return null;
    }

    private void processNewChatMessage(String id, String name) {
        if (null == id) {
            Log.e(TAG, "processNewChatMessage: id is NULL - " + name);
            return;
        }
        contactItem = new ContactItem();
        contactItem.setDataId(id);
        contactItem.setName(name);
        createNewChat(contactItem, user);
/*
        if (id != null) {
            try {
                Log.d(TAG, "User ready for Chat: " + id);
                MessageItem item = null;
                if (messageThreadItemHashMap != null && !messageThreadItemHashMap.isEmpty()) {
                    item = messageThreadItemHashMap.get(id);
                }
                if (null == item) {
                    item = new MessageItem();
                }
//                creates a temp thread, with chat id as message id
//                // TODO: 16-05-2016
//                cloud will generate a brand new message id.. query local db with chatid to sync
                MessagesContentProvider.createChatMessageThread(id, item);
                item.setDocOwner(user.getDataId());
                item.setName(name);
                if (null == item.getName()) {
                    item.setName(item.getDataId());
                }
                item.setContactItem(contactItem);
                MessagesContentProvider.saveMessageThreadItemToDB(item, context);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
*/
    }

    private MessageItem processNewChatMessage(ContactItem contactItem) {
//        String id = contactItem.getDataId();
        if (null == contactItem) return null;
        String id = contactItem.getIntellibitzId();
        if (null == id) return null;
        Log.d(TAG, "User ready for Chat: " + id);
        MessageItem messageItem = null;
        if (messageItems != null && !messageItems.isEmpty()) {
            messageItem = MainApplicationSingleton.getBaseItem(id, messageItems);
        }
        if (null == messageItem) {
            messageItem = new MessageItem();
            messageItem.setDataId(MessageItem.TAG);
        }
        messageItem.setDocOwner(user.getDataId());
        messageItem.setName(contactItem.getName());
        if (null == messageItem.getName()) {
            messageItem.setName(messageItem.getDataId());
        }
//                creates a temp thread, with chat id as message id
//                // TODO: 16-05-2016
//                cloud will generate a brand new message id.. query local db with chatid to sync
        if (contactItem.isGroup()) {
            MessageChatGroupContentProvider.createMessageChatThread(id, messageItem);
        } else {
            MessageChatContentProvider.createMessageChatThread(id, messageItem);
        }
//            messageItem.setContactItem(contactItem);
//                saves the message thread..
//                MessagesContentProvider.saveMessageThreadItemToDB(item, context);
//        messageItem.setContactItem(contactItem);
        return messageItem;
    }

    private void createNewChat(ContactItem contactItem, ContactItem user) {
//        getAppCompatActivity().hideDetailFilters();
        MessageItem item = processNewChatMessage(contactItem);
        resetRecycleAdapter();
//        showMessageThreadMessage(contactItem, user);
        showMessageThreadMessage(item, user);
    }

    private void showMessageThreadMessage(String id, final ContactItem user) {
        if (id != null) {
            final MessageItem activeChat = MainApplicationSingleton.getBaseItem(id, messageItems);
            if (activeChat != null) {
                Handler handler = new Handler(Looper.getMainLooper());
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        showMessageThreadMessage(activeChat, user);
                    }
                });
            }
        }
    }

    private void setupSnackBar(View view) {
        if (null == view) return;
        snackbar = Snackbar.make(
                view, "Please Add Account to see Emails", Snackbar.LENGTH_LONG);
        snackbar.setAction("ADD EMAIL", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startEmailListActivity();
            }
        });
    }

    private void setupFAB(View view) {
        if (null == view) return;
        fab = (FloatingActionButton) view.findViewById(R.id.fab);
        assert fab != null;
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showNewMessageDialog();
            }
        });
    }

/*
    public boolean onBackPressed(Intent intent) {
//        handles hard back press, if details work flow is in progress
//        pop the last fragment, to restore state
*/
/*
        if (null == contactThreadDetailFragment) {
            return false;
        }
        contactThreadDetailFragment.onBackPressed();
        View view = getView();
        if (view != null) view.setVisibility(View.GONE);
//            hard press from detail.. no more childs
        getAppCompatActivity().removeFragment(contactThreadDetailFragment);
        contactThreadDetailFragment = null;
*//*

//            if (viewModeListener != null) viewModeListener.onViewModeItem();
        return true;
*/
/*
        if (VIEW_MODE.ITEM == viewMode) {
//            performNavigationClose();
        } else {
//            viewMode = VIEW_MODE.ITEM;
//            removes intellibitz contact fragment, workflow is in progress
            getAppCompatActivity().removeFragment(intellibitzContactSelectItemFragment);
        }
*//*

//        return false;
//        return true;
//        return false;
    }
*/

    public void showNewMessageDialog() {
        AppCompatActivity appCompatActivity = getAppCompatActivity();
        if (null == appCompatActivity) {
            Log.e(TAG, "showNewBottomDialogFragment: Activity NULL - cannot show new dialog");
            return;
        }
        newBottomDialogFragment = new NewBottomDialogFragment();
        newBottomDialogFragment.setNewBottomDialogListener(this);
        newBottomDialogFragment.show(
                appCompatActivity.getSupportFragmentManager(), "Create");
    }

    public boolean onBackPressed() {
//        Intent back = getAppCompatActivity().getBackIntent();
        Intent back = getAppCompatActivity().getIntent();
        boolean result;
        if (null == back) {
            result = true;
        } else {
            final String action = back.getAction();
//            getAppCompatActivity().setBackIntent(null);
            if (ContactSelectFragment.TAG.equals(action)) {
//                showContactThreadDetail();
                startMsgChatGrpContactsDetailActivity();
                result = false;
            } else {
                result = true;
            }
        }
        return result;
    }

    public void onMessageForward(Intent intent) {
        if (null == intent) {
            Log.e(TAG, " cancelled selected contacts by pressing back: ");
            getAppCompatActivity().onBackPressed();
            return;
        }
        messageItemToForward = intent.getParcelableExtra(MessageItem.TAG);
        String source = intent.getAction();
        if (null == messageItemToForward) {
            Log.e(TAG, " cancelled selected contacts by pressing back: ");
            getAppCompatActivity().onBackPressed();
            return;
        }
        if (PeopleDetailFragment.TAG.equals(source)) {
//            Log.d(TAG, "onMessageForward: "+messageItem);
//            getAppCompatActivity().hideDetailToolbar();
//            getAppCompatActivity().replaceContentFragment(this);
        }
    }

    public void showContactThreadDetail(Intent intent) {
        startMsgChatGrpContactsDetailActivity();
//        GroupsDetailFragment msgChatGrpContactsDetailFragment = showContactThreadDetail();
//        msgChatGrpContactsDetailFragment.onOkPressed(intent);
    }

    @Override
    public void onNewDialogClose(NewBottomDialogFragment newBottomDialogFragment) {
        this.newBottomDialogFragment.dismiss();
//        getAppCompatActivity().onBackPressed();
    }

    @Override
    public void onNewGroup(NewBottomDialogFragment newBottomDialogFragment) {
        onNewDialogClose(newBottomDialogFragment);
/*
        NewEmailDialogFragment.newMessageDialog(this, 0, user).show(
                getAppCompatActivity().getSupportFragmentManager(), "NewMessageDialog");
*/
        contactItem = new ContactItem();
        contactItem.setNewGroup(true);
        contactItem.setGroup(true);
//        showContactThreadDetail();
        startMsgChatGrpContactsDetailActivity();
    }

    @Override
    public void onNewChat(NewBottomDialogFragment newBottomDialogFragment) {
        // Create an instance of the dialog fragment and show it
//        // TODO: 25-04-2016
        onNewDialogClose(newBottomDialogFragment);
/*
        NewEmailDialogFragment.newMessageDialog(this, 0, user).show(
                getAppCompatActivity().getSupportFragmentManager(), "NewMessageDialog");
*/
        contactItem = new ContactItem();
        contactItem.setNewGroup(false);
        contactItem.setGroup(false);
//        showContactSelectItemFragment();
        startContactSelectActivity();
    }

    public void showContactSelectItemFragment() {
/*
        IntellibitzContactSelectItemFragment intellibitzContactSelectItemFragment =
                ContactSelectFragment.newInstance(
                        this, getAppCompatActivity(), twoPane, user, contactItem);
//        hideFilterToolbar();
        getAppCompatActivity().showDetailToolbar();
        getAppCompatActivity().removeFragment(intellibitzContactSelectItemFragment);
        getAppCompatActivity().replaceDetailFragment(intellibitzContactSelectItemFragment);
*/
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     */
    private void startContactSelectActivity() {
        Intent intent = new Intent(getAppCompatActivity(), ContactSelectActivity.class);
//        intent.setAction(ContactSelectFragment.TAG);
        intent.putExtra(ContactItem.TAG, (Parcelable) contactItem);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
//        NOTE: there is a significant difference between the following two calls

//        THIS WILL DELIVER THE RESULT, TO PARENT ACTIVITY AND THE PARENT ACTIVITY IF OVERRIDDEN
//        MUST CALL SUPER.STARTACTIVITYFORRESULT IN ITS OVERRIDDEN METHOD FOR THE RESULT
//        TO BE DELIVERED TO THIS FRAGMENT
        startActivityForResult(intent, MainApplicationSingleton.ACTIVITY_CONTACTSELECT_RQ_CODE);

//        THIS WILL DELIVER THE RESULT, TO PARENT ACTIVITY AND THE PARENT ACTIVITY IF OVERRIDDEN
//        MUST MANUALLY INVOKE THE FRAGMENTS IN ITS OVERRIDDEN METHOD FOR THE RESULT
//        TO BE DELIVERED TO THIS FRAGMENT
//        getAppCompatActivity().startActivityForResult(intent, MainApplicationSingleton.ACTIVITY_CONTACTSELECT_RQ_CODE);
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     */
    public void startMsgChatGrpContactsDetailActivity() {
        Intent intent = new Intent(getAppCompatActivity(), MsgChatGrpContactsDetailActivity.class);
        intent.putExtra(ContactItem.TAG, (Parcelable) contactItem);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        startActivityForResult(intent, MainApplicationSingleton.ACTIVITY_MSGCHATGRPCONTACTS_RQ_CODE);
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     *
     * @param requestCode
     * @param resultCode
     * @param data
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
        if (MainApplicationSingleton.ACTIVITY_CONTACTSELECT_RQ_CODE == requestCode) {
            if (Activity.RESULT_OK == resultCode) {
                if (data != null) {
//                    contacts selected for chat
                    ContactItem item = data.getParcelableExtra(ContactItem.TAG);
                    if (null == contactItem) contactItem = item;
                    final int size = contactItem.getSelectedContacts().size();
                    if (contactItem == item) {
                        Log.e(TAG, " Already selected contacts: " + size);
                    } else {
                        contactItem.setSelectedContacts(item.getSelectedContacts());
                    }
//            merges selected contacts into group contacts and clears selected contacts
                    contactItem.mergeSelectedContacts();
                    int count = contactItem.getContactItems().size();
                    if (1 == count) {
//            for a single chat, the intellibitz id of a contact becomes the id of msg contact
//            as well as msg thread contact
                        ContactItem selectedContactItemForChat =
                                contactItem.getContactItems().iterator().next();
                        contactItem.setDataId(selectedContactItemForChat.getIntellibitzId());
                        contactItem.setIntellibitzId(selectedContactItemForChat.getIntellibitzId());
                        contactItem.setTypeId(selectedContactItemForChat.getTypeId());
                        contactItem.setDeviceContactId(selectedContactItemForChat.getDeviceContactId());
                        contactItem.setName(selectedContactItemForChat.getName());
                        contactItem.setGroup(false);
                        contactItem.setEmailItem(false);
                        contactItem.setType("USER");
                        createNewChat(this.contactItem, user);
                    } else {
                        Log.e(TAG, "onActivityResult: Please select 1 contact - " + count);
                    }
                }
            } else if (Activity.RESULT_CANCELED == resultCode) {
                Log.e(TAG, "onActivityResult: 0 Contacts selected - ");
            }
        } else if (MainApplicationSingleton.ACTIVITY_MSGCHATGRPCONTACTS_RQ_CODE == requestCode) {
            if (Activity.RESULT_OK == resultCode) {
                if (data != null) {
//                    contacts selected for chat
                    ContactItem item = data.getParcelableExtra(ContactItem.TAG);
                    if (item != null) {
                        contactItem = item;
                    }
                    createNewChat(contactItem, user);
                }
            } else if (Activity.RESULT_CANCELED == resultCode) {
                Log.e(TAG, "onActivityResult: 0 Contacts selected - ");
            }
        }
    }

    public void onOkPressed(Intent intent) {
        if (null == intent) {
            Log.e(TAG, " cancelled selected contacts by pressing back: ");
            getAppCompatActivity().onBackPressed();
            return;
        }
        ContactItem item = intent.getParcelableExtra(ContactItem.TAG);
        String source = intent.getAction();
        if (null == item) {
            Log.e(TAG, " cancelled selected contacts by pressing back: ");
            if (ContactSelectFragment.TAG.equals(source)) {
//                new group workflow.. go back to the group screen, for selecting contacts again
                if (contactItem.isNewGroup()) {
                    showContactThreadDetail(intent);
                    return;
                }
            }
            Log.e(TAG, " cancelled group by pressing back: ");
//            getAppCompatActivity().onBackPressed();
            return;
        }
//        back button press.. will recreate state.. so the previously selected item , need to be
//        restored back from the back pressed intent from the clicked fragment
        if (null == contactItem) contactItem = item;
        final int size = contactItem.getSelectedContacts().size();
        if (ContactSelectFragment.TAG.equals(source)) {
            if (0 == size) {
                Log.e(TAG, " selected contacts is 0 by pressing ok.. cancelling : ");
                getAppCompatActivity().onBackPressed();
                return;
            }
        }
        if (contactItem == item) {
            Log.e(TAG, " Already selected contacts: " + size);
        } else {
            contactItem.setSelectedContacts(item.getSelectedContacts());
        }
//            merges selected contacts into group contacts and clears selected contacts
        contactItem.mergeSelectedContacts();
        int count = contactItem.getContactItems().size();
//        checks group workflow first.. so the selection can continue for the group
        if (ContactSelectFragment.TAG.equals(source)) {
            if (contactItem.isNewGroup()) {
                showContactThreadDetail(intent);
                return;
            } else {
                if (1 == count) {
//            for a single chat, the intellibitz id of a contact becomes the id of msg contact
//            as well as msg thread contact
                    ContactItem contactItem =
                            this.contactItem.getContactItems().iterator().next();
//            ContactItem intellibitzContactItem = contactItem.getIntellibitzContactItem();
                    this.contactItem.setDataId(contactItem.getIntellibitzId());
                    this.contactItem.setIntellibitzId(contactItem.getIntellibitzId());
                    this.contactItem.setTypeId(contactItem.getTypeId());
                    this.contactItem.setDeviceContactId(contactItem.getDeviceContactId());
                    this.contactItem.setName(contactItem.getName());
                    this.contactItem.setGroup(false);
                    this.contactItem.setType("USER");
                    createNewChat(this.contactItem, user);
                    return;
                }
//                existing group.. let the parent handle the hard back press
//                getAppCompatActivity().onBackPressed();
//                return;
            }
        }

//        create group workflow done
        if (1 == count) {
//        this will not happen for group, group is always more than 1..
//        if only single selection.. do a single chat
//            for a single chat, the intellibitz id of a contact becomes the id of msg contact
//            as well as msg thread contact
            ContactItem contactItem =
                    this.contactItem.getContactItems().iterator().next();
//            ContactItem intellibitzContactItem = contactItem.getIntellibitzContactItem();
            this.contactItem.setDataId(contactItem.getIntellibitzId());
            this.contactItem.setIntellibitzId(contactItem.getIntellibitzId());
            this.contactItem.setTypeId(contactItem.getTypeId());
            this.contactItem.setDeviceContactId(contactItem.getDeviceContactId());
            this.contactItem.setName(contactItem.getName());
            this.contactItem.setGroup(false);
            this.contactItem.setType("USER");
//            createNewChat(contactItem, user);
//            return;
        } else {
            String name = contactItem.getName();
            if (null == name || name.isEmpty()) {
                Log.e(TAG, "Name is empty - cannot group chat");
                getAppCompatActivity().onBackPressed();
                return;
            }
/*
            contactItem.setDataId(msgContactItem.getIntellibitzId());
            contactItem.setName(msgContactItem.getName());
*/
            contactItem.setGroup(true);
            contactItem.setType("GROUP");
//            createNewGroupChat(contactItem);
//            createNewChat(contactItem, user);
            Log.e(TAG, " selected contacts for Group chat: " + count);
//            getAppCompatActivity().onBackPressed();
//            return;
/*
            if (ContactSelectFragment.TAG.equals(source)) {
                if (contactItem.isNewGroup()) {
                    contactItem.setGroup(true);
                    contactThreadDetailFragment =
                            GroupsDetailFragment.newInstance(this, getAppCompatActivity(), twoPane,
                                    contactItem, user);
                    getAppCompatActivity().removeFragment(intellibitzContactSelectItemFragment);
                    getAppCompatActivity().removeFragment(contactThreadDetailFragment);
                    getAppCompatActivity().replaceDetailFragment(contactThreadDetailFragment);
                    return;
                } else {
//                existing group.. let the parent handle the hard back press
                    getAppCompatActivity().onBackPressed();
                    return;
                }
            }
*/

//                contactItem.setName(intellibitzContactItem.getName());
        }
/*
        Log.e(TAG, " selected contacts: " + count);
        getAppCompatActivity().onBackPressed();
*/
        createNewChat(contactItem, user);
        return;
    }

    @Override
    public void onNewEmail(NewBottomDialogFragment newBottomDialogFragment) {
        if (TextUtils.isEmpty(user.getEmail())) {
            UserEmailContentProvider.populateUserEmailsJoinById(user, getAppCompatActivity());
        }
        onNewDialogClose(newBottomDialogFragment);
        NewEmailDialogFragment.newMessageDialog(this, 0, user).show(
                getAppCompatActivity().getSupportFragmentManager(), "NewMessageDialog");
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        // Insert desired behavior here.
        onClick(view);
    }


/*
    private void showNewEmailMessage(MessageItem item, ContactItem user) {
        //        creates a message thread
        MessageItem messageThreadItem = new MessageItem();
        messageThreadItem.setDataId(MessageItem.TAG);
        messageThreadItem.setFrom(this.user.getName());
        messageThreadItem.setDocOwnerEmail(this.user.getEmail());
        messageThreadItem.setDocSenderEmail(this.user.getEmail());
        messageThreadItem.setSubject(item.getSubject());
        MessageItem.setMessageThreadEmailAddress(messageThreadItem,
                item.getTo(), item.getCc(), item.getBcc());
        showMessageThreadMessage(messageThreadItem, user);
    }

    private void showNewEmailMessage(String contact) {
        showMessageThreadMessage(MessageItem.TAG, contact);
    }

    private void showNewChatMessage(String contact) {
        showMessageThreadMessage(MessageItem.TAG, contact);
    }
*/

/*
    private void showMessageThreadMessage(String messageThreadId, String contact) {
        //        creates a message thread
        MessageItem messageThreadItem = new MessageItem();
        messageThreadItem.setDataId(messageThreadId);
        messageThreadItem.setFrom(user.getName());
        messageThreadItem.setDocOwnerEmail(user.getEmail());
        messageThreadItem.setDocSenderEmail(user.getEmail());
        MessageItem.setMessageThreadEmailAddress(messageThreadItem,
                contact, null, null);
        showMessageThreadMessage(messageThreadItem, user);
    }
*/

    @Override
    public void onClick(View v) {
        // Insert desired behavior here.
//        Log.d(TAG, "Item clicked: " + v);
        if (R.id.tv_empty == v.getId()) {
            startEmailListActivity();
            return;
        }
        TextView dataId = (TextView) v.findViewById(R.id.tv_id);
        String messageThreadId = dataId.getText().toString();
        MessageItem item = MainApplicationSingleton.getBaseItem(messageThreadId, messageItems);
        if (null == item) {
            showMessageThreadMessage(messageThreadId);
        } else {
            showMessageThreadMessage(item, user);
//            showMessageThreadMessage(item.getDataId());
        }
//        showMessageThreadMessage(messageThreadId);
    }

    private void showMessageThreadMessage(String messageThreadId) {
        //        creates a message thread
        MessageItem messageItem = new MessageItem();
        messageItem.setDataId(messageThreadId);
        showMessageThreadMessage(messageItem, user);
    }

    private void showMessageThreadMessage(ContactItem contactItem, final ContactItem user) {
        String id = contactItem.getDataId();
        showMessageThreadMessage(id, user);
    }

    private void showMessageThreadMessage(MessageItem messageItem, ContactItem user) {
        //        // TODO: 13-03-2016
//        loads the complete message thread, with all messages and all attachments
//        handles new
///*
        String id = messageItem.getDataId();
        if (id != null && !id.isEmpty() && !MessageItem.TAG.equals(id)) {
//            // TODO: 09-07-2016
//            chat or email
//            // TODO: 13-07-2016
//            the full joins are for the headers.. can be skipped and let the fragments take care
            if (messageItem.isEmailItem()) {
                MessageEmailContentProvider.queryMessageEmailThreadFullJoin(
                        messageItem, getAppCompatActivity());

            } else {
                if (messageItem.isGroup()) {
                    MessageChatGroupContentProvider.queryMessageChatThreadFullJoin(
                            messageItem, getAppCompatActivity());
                } else {
                    MessageChatContentProvider.queryMessageChatThreadFullJoin(
                            messageItem, getAppCompatActivity());
                }
            }
        }
//        // TODO: 17-07-2016
//        hack!! the doc type is getting changed from the above full join.. reset to draft
        messageItem.setDocType(MessageItem.DRAFT);
//*/
//        messageItem.pushMessageInStack(messageItemToForward);
        if (peopleTopicListener != null) {
//            // TODO: 21-05-2016
//            restores message topic listener from parent
            peopleTopicListener.onPeopleTopicClicked(messageItem, user);
        }
        onPeopleTopicClicked(messageItem, user);
    }

    public void onPeopleTopicClicked(MessageItem messageItem, ContactItem user) {
        final String type = messageItem.getType();
        if ("CHAT".equalsIgnoreCase(type)) {
            if ("USER".equalsIgnoreCase(messageItem.getToType())) {
                startPeopleDetailActivity(messageItem, user);
            } else {
//            chat group always lands in chat detail view
                startMessageChatGroupActivity(messageItem, user);
            }
        } else if ("EMAIL".equalsIgnoreCase(type)) {
//            checks if the device contact id.. has a chat id already
//            if chat id available, shows people details view
//            if chat id not available, shows clutter mails view
            long did = messageItem.getDeviceContactId();
            if (did > 0) {
                Cursor cursor = getAppCompatActivity().getContentResolver().query(
                        IntellibitzContactContentProvider.CONTENT_URI, null,
                        " ( " + ContactItemColumns.KEY_IS_EMAIL + " = 0 OR " +
                                ContactItemColumns.KEY_IS_EMAIL + " IS NULL ) AND ( " +
                                ContactItemColumns.KEY_IS_GROUP + " = 0 OR " +
                                ContactItemColumns.KEY_IS_GROUP + " IS NULL ) AND " +
                                ContactItemColumns.KEY_DEVICE_CONTACTID + " = ? ",
                        new String[]{String.valueOf(did)}, null);
                if (cursor != null && cursor.getCount() > 0) {
                    String id = cursor.getString(cursor.getColumnIndex(
                            ContactItemColumns.KEY_INTELLIBITZ_ID));
                    cursor.close();
                    if (TextUtils.isEmpty(id)) {
                        messageItem.setIntellibitzId(messageItem.getDocSenderEmail());
                        startClutterEmailsActivity(messageItem, user);
                    } else {
                        cursor = getAppCompatActivity().getContentResolver().query(
                                MessagesChatContentProvider.CONTENT_URI, null,
                                MessageItemColumns.KEY_CHAT_ID + " = ? ",
                                new String[]{id}, null
                        );
                        MessageItem chatMessage =
                                MessageChatContentProvider.fillsMessageItemFromCursor(cursor);
                        if (cursor != null) cursor.close();
                        if (null == chatMessage) {
//                            // TODO: 14-07-2016
//                            the chat id is available, but no chat has been initiated
//                            shows clutter view ..
//  to change to the people view (a brand new chat with existing emails)
                            messageItem.setIntellibitzId(messageItem.getDocSenderEmail());
                            startClutterEmailsActivity(messageItem, user);
                        } else {
                            startPeopleDetailActivity(chatMessage, user);
                        }
                    }
                }
                if (cursor != null) cursor.close();
            } else {
                messageItem.setIntellibitzId(messageItem.getDocSenderEmail());
                startClutterEmailsActivity(messageItem, user);
            }
//            onPeopleMessageClicked(messageItem, user);
        } else {
//            people message, is a group of chat + email threads
            startPeopleDetailActivity(messageItem, user);
//            onChatTopicClicked(messageItem, user);
        }
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     */
    public void startMessageChatGroupActivity(MessageItem messageItem, ContactItem user) {
        Intent intent = new Intent(getAppCompatActivity(), MessageChatGroupActivity.class);
        intent.putExtra(MessageItem.TAG, (Parcelable) messageItem);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        getAppCompatActivity().startActivityForResult(
                intent, MainApplicationSingleton.ACTIVITY_MESSAGECHATGROUP_RQ_CODE);
//        the following fails with not attached to activity
//        startActivityForResult(intent, MainApplicationSingleton.ACTIVITY_MESSAGECHATGROUP_RQ_CODE);
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     */
    public void startPeopleDetailActivity(MessageItem messageItem, ContactItem user) {
        Intent intent = new Intent(getAppCompatActivity(), PeopleDetailActivity.class);
        intent.putExtra(MessageItem.TAG, (Parcelable) messageItem);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        getAppCompatActivity().startActivityForResult(
                intent, MainApplicationSingleton.ACTIVITY_PEOPLEDETAIL_RQ_CODE);
    }

    /**
     * You are calling startActivityForResult() from your Fragment. When you do this,
     * the requestCode is changed by the Activity that owns the Fragment.
     * If you want to get the correct resultCode in your activity try this:
     * Change:
     * startActivityForResult(intent, 1);
     * To:
     * getActivity().startActivityForResult(intent, 1);
     * Just a note: if you use startActivityForResult in a fragment and expect the result from
     * onActivityResult in that fragment, just make sure you call super.onActivityResult in the
     * host activity (in case you override that method there).
     * This is because the activity's onActivityResult seems to call the fragment's onActivityResult.
     * Also, note that the request code, when it travels through the activity's onActivityResult,
     * is altered
     * "the requestCode is changed by the Activity that owns the Fragment" - Gotta love the Android design... –
     */
    public void startClutterEmailsActivity(MessageItem messageItem, ContactItem user) {
        Intent intent = new Intent(getAppCompatActivity(), ClutterEmailsActivity.class);
        intent.putExtra(MessageItem.EMAIL_MESSAGE, (Parcelable) messageItem);
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        getAppCompatActivity().startActivityForResult(
                intent, MainApplicationSingleton.ACTIVITY_CLUTTEREMAILS_RQ_CODE);
    }

    private void setSelectedItem(MessageItem mItem) {
        selectedItem = mItem;
    }

    private void execDeleteMsgsTask(String[] msgs) {
        DeleteMsgsTask deleteMsgsTask = new DeleteMsgsTask(msgs, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_DELETED_MSGS, getContext());
        deleteMsgsTask.setRequestTimeoutMillis(30000);
        deleteMsgsTask.setDeleteMsgsTaskListener(this);
        deleteMsgsTask.execute();
/*
        deleteMsgsTask = new DeleteMsgsTask(msgs, user.getDataId(), user.getToken(),
                user.getDevice(), user.getDeviceRef(), MainApplicationSingleton.AUTH_DELETED_MSGS);
        deleteMsgsTask.setDeleteMsgsTaskListener(this);
        deleteMsgsTask.execute();
*/
    }

    private void deleteMessages() {
        execDeleteMsgsTask(new String[]{selectedItem.getDataId()});
    }

    private void flagMessages() {
//        execFlagMsgsTask(new String[]{selectedItem.getDataId()});
    }

    @Override
    public void onPostDeleteMsgsResponse(JSONObject response, String[] item) {
        try {
            int status = response.getInt(MainApplicationSingleton.STATUS_PARAM);
//                ERROR
            if (1 == status) {
                Log.e(TAG, "Delete Msgs SUCCESS - " + response);
                try {
                    int count = MsgsGrpDraftContentProvider.deleteMsgs(item, getContext());
                    Log.e(TAG, "Delete in DB: " + count);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else if (-1 == status) {
                onPostDeleteMsgsErrorResponse(response, item);
            } else if (99 == status) {
                onPostDeleteMsgsErrorResponse(response, item);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onPostDeleteMsgsErrorResponse(JSONObject response, String[] item) {
        Log.e(TAG, "Delete Msgs FAIL - " + response + ": " + Arrays.toString(item));
    }

/*
    @Override
    public void setDeleteMsgsTaskToNull() {
        deleteMsgsTask = null;
    }
*/

    // The dialog fragment receives a reference to this Activity through the
    // Fragment.onAttach() callback, which it uses to call the following methods
    // defined by the NoticeDialogFragment.NoticeDialogListener interface
    @Override
    public void onDialogPositiveClick(DialogFragment dialog) {
        // User touched the dialog's positive button
//        // TODO: 16-03-2016
//        user = dialog.getArguments().getParcelable(ContactItem.TAG);
//        getAppCompatActivity().notifyUserBaseItemListeners();
        NewEmailDialogFragment newEmailDialogFragment = (NewEmailDialogFragment) dialog;
        if (newEmailDialogFragment.isChatMode()) {
            performNewChat(newEmailDialogFragment);
        } else {
            performNewEmail(newEmailDialogFragment);
        }
    }

    private void performNewEmail(NewEmailDialogFragment newEmailDialogFragment) {
        String email = user.getEmail();
        if (TextUtils.isEmpty(email)) {
            Log.e(TAG, "performNewEmail: User email is empty - No email account signed up");
            return;
        }
//        user must be signed into atleast one email account
        MessageItem messageItem = new MessageItem();
//        // TODO: 30-06-2016
        ContactItem contactThreadItem = messageItem.getContactItem();
        if (null == contactThreadItem) {
            contactThreadItem = new ContactItem();
            messageItem.setContactItem(contactThreadItem);
        }
//        new message.. sets id to a constant.. global new message id
        messageItem.setDataId(MessageItem.TAG);
        messageItem.setBaseType("THREAD");
        messageItem.setDocType("THREAD");
        messageItem.setType("EMAIL");
        messageItem.setDataRev("1");
        String name = user.getName();
        messageItem.setFrom(name);
        messageItem.setSubject(newEmailDialogFragment.getSubject());
        messageItem.setDocOwner(user.getDocOwner());
        messageItem.setDocSender(name);
        messageItem.setDocOwnerEmail(email);
        messageItem.setDocSenderEmail(email);
        messageItem.setTimestamp(System.currentTimeMillis());
        Rfc822Token[] to = newEmailDialogFragment.getTo();
        Rfc822Token[] cc = newEmailDialogFragment.getCc();
        Rfc822Token[] bcc = newEmailDialogFragment.getBcc();
//        adds from
        ContactItem contactItem = new ContactItem();
        contactItem.setDataId(email);
        contactItem.setTypeId(email);
        contactItem.setIntellibitzId(email);
        contactItem.setName(name);
        contactItem.setType("from");
        contactThreadItem.addContact(contactItem);
//        compose msg thread contact aka email group contact from the selected
        messageItem.compose(to, cc, bcc);
//        MessageItem.setMessageThreadEmailAddress(messageItem, to, cc, bcc);
        Intent intent = new Intent();
        if (newEmailDialogFragment.isChatMode()) {
            performNewChat(newEmailDialogFragment);
//            setCurrentItem(2);
            intent.setAction(MainApplicationSingleton.BROADCAST_NEW_CHAT_DIALOG_OK);
        } else {
//            performNewEmail(newEmailDialogFragment);
//            setCurrentItem(1);
            intent.setAction(MainApplicationSingleton.BROADCAST_NEW_EMAIL_DIALOG_OK);
            showMessageThreadMessage(messageItem, user);
        }
        intent.putExtra(ContactItem.USER_CONTACT, (Parcelable) user);
        intent.putExtra(MessageItem.TAG, (Parcelable) messageItem);
        LocalBroadcastManager.getInstance(getAppCompatActivity().getApplicationContext()).sendBroadcast(intent);
/*
        String to = newEmailDialogFragment.getTo();
        String cc = newEmailDialogFragment.getCc();
        String bcc = newEmailDialogFragment.getBcc();
*/
//        messageItem.setDocOwner(user.getDocOwner());
//        messageItem.setDocSender(user.getName());
//        messageItem.setDocOwnerEmail(user.getEmail());
//        messageItem.setDocSenderEmail(user.getEmail());
//        messageItem.setTimestamp(System.currentTimeMillis());

//        // TODO: 16-03-2016
//        retrieve the info from dialog
//        investigate .. user is not fully populated.. check dialog fragment life cycle
/*
        messageItem.setHasAttachments(1);
        messageItem.addContact(user.getEmail(), "Jobs", "from");
        messageItem.addContact("nishanth@intellibitz.com", "Nishi", "to");
        messageItem.addContact("jeff@intellibitz.com", "Jeffy", "to");
        MessageItem messageItem = null;
        try {
            messageItem = messageItem.addMessage(" DEMO Test Message");
            messageItem.addAttachments(messageItem.getAttachments());

        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }

        Intent intent = new Intent(this, EmailService.class);
        intent.setAction(EmailService.INTENT_ACTION_NEW_EMAIL_MESSAGE);
        intent.putExtra(ContactItem.TAG, (Parcelable) user);
        intent.putExtra(MessageItem.TAG, (Serializable) messageItem);
        startService(intent);
*/
    }

    private void performNewChat(NewEmailDialogFragment newEmailDialogFragment) {
        Rfc822Token[] to = newEmailDialogFragment.getTo();
        if (to != null && to.length > 0) {
            int i = 0;
            String[] sto = new String[0];
/*
            MessageItem messageThreadItem = new MessageItem();
//        new message.. sets id to a constant.. global new message id
            messageThreadItem.setDataId(MessageItem.TAG);
            messageThreadItem.setDocType("THREAD");
            messageThreadItem.setDataRev("1");
            messageThreadItem.setFrom(user.getName());
            messageThreadItem.setDocOwner(user.getDocOwner());
            messageThreadItem.setDocSender(user.getName());
            messageThreadItem.setDocOwnerEmail(user.getEmail());
            messageThreadItem.setDocSenderEmail(user.getEmail());
            messageThreadItem.setTimestamp(System.currentTimeMillis());
            messageThreadItem.setSubject(subject);
*/
            sto = new String[to.length];
            for (Rfc822Token s : to) {
                String address = s.getAddress();
                sto[i++] = address;
            }
            Log.d(TAG, Arrays.toString(sto));
            String subject = newEmailDialogFragment.getSubject();
//            the akcontact, selected for the message
            Map<String, ContactItem> intellibitzContacts =
                    newEmailDialogFragment.getIntellibitzContacts();
            if (1 == sto.length) {
//                single chat
                contactItem = new ContactItem();
                String id = sto[0];
                contactItem.setDataId(id);
                contactItem.setName(subject);
                ContactItem intellibitzContactItem = intellibitzContacts.get(id);
                if (intellibitzContactItem != null) {
                    ContactItem contactItem = new ContactItem(intellibitzContactItem);
                    this.contactItem.setName(contactItem.getName());
                    this.contactItem.addContact(contactItem);
                }
                contactItem.setGroup(false);
                createNewChat(contactItem, user);
            } else if (sto.length > 1) {
//                group chat
                contactItem = new ContactItem();
                contactItem.setName(subject);
//                contactItem.setProfilePic(file.getAbsolutePath());
                Collection<ContactItem> items =
                        Collections.synchronizedSet(
                                new HashSet<ContactItem>(sto.length));
                for (String contact : sto) {
//                    // TODO: 20-06-2016
//                    to fetch mobile
//                    MobileItem mobileItem = new MobileItem();
//                    mobileItem.setIntellibitzId(contact);
//                    // TODO: 30-06-2016
                    ContactItem intellibitzContactItem = new ContactItem(contact);
                    ContactItem contactItem = new ContactItem(intellibitzContactItem);
//                    contactItem.setIntellibitzId(contact);
//                    contactItem.setDataId(contact);
                    ContactItem item = intellibitzContacts.get(contact);
                    if (item != null) {
                        contactItem.setName(item.getName());
                    }
                    items.add(contactItem);
                }
                contactItem.setContactItems(items);
                createNewGroupChat(contactItem);
            }
        }

    }

    @Override
    public void onDialogNegativeClick(DialogFragment dialog) {
        // User touched the dialog's negative button
    }

    public boolean onDetailQueryTextSubmit(String query) {
        return false;
    }

    public boolean onDetailQueryTextChange(String newText) {
        return false;
    }

    public boolean onDetailClose() {
        return false;
    }

    public void minusChat() {
        isMinusChat = true;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        restartLoader(query);
        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText) {
        restartLoader(newText);
        return false;
    }

    @Override
    public boolean onClose() {
        restartLoader("");
        return false;
    }

    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        // This is called when a new Loader needs to be created.  This
        // sample only has one Loader, so we don't care about the ID.
        // First, pick the base URI to use depending on whether we are// currently filtering.
        if (MainApplicationSingleton.MSGSGRPDRAFT_LOADERID == id) {
            if (peopleTopicListener != null) {
                peopleTopicListener.onPeopleTopicsLoaded(0);
            }
            // Now createFileInES and return a CursorLoader that will take care of
            // creating a Cursor for the data being displayed.
//        // TODO: 19-02-2016
//        to set the context right, else the loader will fail from the calling activity
//        return new CursorLoader(context, messageThreadUri,
            String selection = " ( name IS NULL OR name like ? ) "
//                    + " AND ( " +
//                    MessageItemColumns.KEY_DOC_TYPE + " = 'DRAFT' ) "
                    ;
            String[] selArgs;
            if (filter != null && !filter.isEmpty()) {
                selArgs = new String[]{"%" + filter + "%"};
            } else {
                selArgs = new String[]{"%%"};
            }
//            Log.d(TAG, "FILTER: " + filter + " " + selArgs + " " + selection);
            return new CursorLoader(getAppCompatActivity().getApplicationContext(),
                    MsgsGrpDraftContentProvider.CONTENT_URI,
                    null,
                    selection, selArgs,
                    MessageItemColumns.KEY_TIMESTAMP +
                            " DESC");
        }
//        returns an empty dummy cursor.. for the cursor loader to play game
        return new CursorLoader(getAppCompatActivity(),
                Uri.withAppendedPath(MsgsGrpDraftContentProvider.CONTENT_URI, "0"),
                null,
                MessageItemColumns.KEY_DATA_ID + " = ? ",
                new String[]{"0"}, null);
    }

    @Override
    public void onLoadFinished(Loader<Cursor> loader, Cursor cursor) {
        // Swap the new cursor in.  (The framework will take care of closing the
        // old cursor once we return.)
        if (MainApplicationSingleton.MSGSGRPDRAFT_LOADERID == loader.getId()) {
            if (null == cursor) {
                messageItems.clear();
                createRecycleAdapter();
                showEmpty();
                return;
            }
            int count = cursor.getCount();
            if (peopleTopicListener != null) {
                peopleTopicListener.onPeopleTopicsLoaded(count);
            }
            if (0 == count) {
                cursor.close();
                messageItems.clear();
                createRecycleAdapter();
                showEmpty();
                return;
            }
            if (count > 0 && 0 == cursor.getPosition()) {
                hideEmpty();
                messageItems.clear();
                messageItems = MessageChatContentProvider.fillMessageItemsFromCursor(cursor);
                cursor.close();
                createRecycleAdapter();
            }
        }
    }

    public void onLoaderReset(Loader<Cursor> loader) {
        // This is called when the last Cursor provided to onLoadFinished()
        // above is about to be closed.  We need to make sure we are no
        // longer using it.
        if (MainApplicationSingleton.MSGSGRPDRAFT_LOADERID == loader.getId()) {
//            messageItems = null;
//            createRecycleAdapter();
        }
    }

    /**
     * Handler of incoming messages from service.
     */
    class IncomingHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case ChatService.MSG_SHOW_TYPING:
                    if (peopleDetailListener != null) {
                        try {
                            String obj = (String) msg.obj;
                            if (null != obj) {
                                JSONArray jsonArray = new JSONArray(obj);
                                JSONObject jsonObject = jsonArray.getJSONObject(0);
                                try {
                                    String toUid = jsonObject.getString("to_uid");
                                    String fromUid = jsonObject.getString("from_uid");
                                    String fromName = jsonObject.getString("from_name");
                                    showTyping(toUid, fromUid, fromName, user);
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }

                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                    break;
                default:
                    super.handleMessage(msg);
            }
        }
    }

    public class RecyclerViewAdapter
            extends RecyclerView.Adapter<RecyclerViewAdapter.ViewHolder> implements
            BitmapFromUrlTask.BitmapFromUrlTaskListener {

        private List<MessageItem> messageItems;
        private BitmapFromUrlTask bitmapFromUrlTask;

        public RecyclerViewAdapter(List<MessageItem> items) {
            super();
            this.messageItems = items;
        }

        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
//            bind to the message thread list item view
            View view = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.list_item_emailchat_topic, parent, false);
            return new ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(final ViewHolder holder, int position) {
            holder.mItem = messageItems.get(position);

            holder.tvId.setText(holder.mItem.getDataId());
//            sets from
            String val = holder.mItem.getSubject();
            if (holder.mItem.isChat()) {
                val = holder.mItem.getDataId();
            } else {
                if (null == val) {
                    val = holder.mItem.getDocOwner();
                }
            }
            if (holder.mItem.isChat()) {
                val = holder.mItem.getName();
            }
            holder.tvName.setText(val);


            String from = holder.mItem.getDocSender();
            if (null == from)
                from = holder.mItem.getFrom();
            String to = holder.mItem.getTo();
            String cc = holder.mItem.getCc();
            String val2 = MessageItem.getSingleAddress(from, to, cc,
                    user.getEmail(), user.getName());

            Drawable read = null;
            if (user.getDataId().equals(holder.mItem.getDocSenderEmail()) && !holder.mItem.isEmailItem()) {
                if (holder.mItem.isDelivered()) {
                    read = getDrawable(R.drawable.ic_done_all_black_18dp,
                            getAppCompatActivity().getTheme());
                } else if (holder.mItem.isRead()) {
                    read = getDrawable(R.drawable.ic_done_black_18dp,
                            getAppCompatActivity().getTheme());
                } else {
                    read = getDrawable(R.drawable.ic_restore_black_18dp,
                            getAppCompatActivity().getTheme());
                }
            }
            Drawable drawable = getDrawable(
                    R.drawable.ic_mail_outline_black_18dp, getAppCompatActivity().getTheme());
            if (holder.mItem.isChat()) {
                drawable = getDrawable(
                        R.drawable.ic_chat_bubble_outline_black_18dp, getAppCompatActivity().getTheme());
                if (holder.mItem.isGroupChat()) {
                    drawable = getDrawable(
                            R.drawable.ic_question_answer_black_18dp, getAppCompatActivity().getTheme());
                }
            }
            if (drawable != null) {
                drawable.setBounds(new Rect(0, 0, 20, 20));
                if (read != null) {
                    read.setBounds(new Rect(0, 0, 20, 20));
                }
                setCompoundDrawablesRelative(holder.tvMessage, drawable, null, null, read);
                setCompoundDrawablesRelative(holder.tvSubject, drawable, null, null, read);
            }

//            holder.tvFrom.setText(val);

//            sets message
            if (holder.mItem.isTyping()) {
                val = holder.mItem.getTypingText();
//                holder.tvMessage.setTextColor(Color.GREEN);
            } else {
                if (!TextUtils.isEmpty(val) && !TextUtils.isEmpty(val2) && val.equalsIgnoreCase(val2)) {
                    val = " " + holder.mItem.getLatestMessageText();
                } else {
                    val = val2 + ": " + holder.mItem.getLatestMessageText();
                }
                val = val.replace("\n", " ");
//                holder.tvMessage.setTextColor(Color.BLACK);
            }
            holder.tvMessage.setText(val);

//            sets subject
            holder.tvSubject.setText(val);

            if (holder.mItem.getHasAttachments()) {
                drawable = getDrawable(
                        R.drawable.ic_attach_file_black_18dp, getAppCompatActivity().getTheme());
                assert drawable != null;
                drawable.setBounds(new Rect(0, 0, 20, 20));
//                holder.tvSubject.setCompoundDrawablesRelative(drawable, null, null, null);
                holder.ivAttachment.setVisibility(View.VISIBLE);
            } else {
                holder.ivAttachment.setVisibility(View.INVISIBLE);
            }

//            sets timestamp
//                    converts to milliseconds, for correct date conversion
            long createDate = holder.mItem.getTimestamp() * 1000;
            Timestamp timestamp = new Timestamp(createDate);
            long now = System.currentTimeMillis();
            DateFormat df = new SimpleDateFormat("MMM dd", Locale.getDefault());
            if ((now - createDate) < 1000 * 60 * 60 * 24) {
                df = new SimpleDateFormat("hh mm a", Locale.getDefault());
            }
            String dt = df.format(timestamp.getTime());
            holder.tvTimestamp.setText(dt);

//            sets sender
            ColorGenerator generator = ColorGenerator.MATERIAL; // or use DEFAULT
// generate random color
//                    int color1 = generator.getRandomColor();
// generate color based on a key (same key returns the same color), useful for list/grid views
            val = holder.mItem.getFrom();
            if (val == null || val.isEmpty()) val = holder.mItem.getSubject();
            if ("CHAT".equals(holder.mItem.getType())) {
                if (val == null || val.isEmpty()) val = "C";
            } else {
                if (val == null || val.isEmpty()) val = "E";
            }
            int color2 = generator.getColor(val);

// declare the builder object once.
            TextDrawable.IBuilder builder = TextDrawable.builder()
                    .beginConfig()
                    .withBorder(4)
                    .endConfig()
                    .round();
// reuse the builder specs to createFileInES multiple drawables
//                    TextDrawable ic1 = builder.build("A", color1);
            TextDrawable ic2 = builder.build(val.substring(0, 1), color2);
//            ic2.setBounds(new Rect(0, 0, 30, 30));

            String pic = holder.mItem.getProfilePic();
            if (null == pic || pic.isEmpty()) {
                holder.tvSender.setImageDrawable(ic2);

/*
                TextDrawable textDrawable = ColorGenerator.getTextDrawable(name);
                textDrawable.setBounds(new Rect(0, 0, 100, 100));
                holder.tvTo.setCompoundDrawablesRelative(
                        textDrawable, null, null, null);
*/
            } else if (pic.startsWith("http")) {
                bitmapFromUrlTask = new BitmapFromUrlTask(
                        holder.tvSender, pic, getAppCompatActivity().getApplicationContext());
                bitmapFromUrlTask.setBitmapFromUrlTaskListener(this);
                bitmapFromUrlTask.execute();
/*
                    new AsyncGettingBitmapFromUrl(
                            holder.tvTo, pic, getAppCompatActivity().getApplicationContext()).execute();
*/
            } else {
//                    Uri uri = Uri.parse(pic);
                Bitmap bitmap = null;
                try {
                    bitmap = MainApplicationSingleton.getBitmapDecodeAnyUri(pic, getContext());
                    if (null == bitmap) {
// reuse the builder specs to createFileInES multiple drawables
//                    TextDrawable ic1 = builder.build("A", color1);
//                        TextDrawable ic2 = builder.build(val.substring(0, 1), color2);
//            ic2.setBounds(new Rect(0, 0, 30, 30));
                        holder.tvSender.setImageDrawable(ic2);
                    } else {
                        Bitmap croppedBitmap = NetworkImageView.getCroppedBitmap(bitmap, 100);
                        BitmapDrawable bitmapDrawable = new BitmapDrawable(getResources(), croppedBitmap);
                        bitmapDrawable.setBounds(new Rect(0, 0, 100, 100));
                        holder.tvSender.setImageDrawable(bitmapDrawable);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
/*
            val = holder.userEmailItem.getType();
            holder.ivAttachment.setText(val);
*/

//            sets unread count
            generator = ColorGenerator.MATERIAL; // or use DEFAULT
//                    int color2 = generator.getColor(R.id.email_unread_count);
// generate random color
//                    int color1 = generator.getRandomColor();
// generate color based on a key (same key returns the same color), useful for list/grid views
            int anInt = holder.mItem.getUnreadCount();
            if (0 == anInt) {
                holder.ivUnreadCount.setVisibility(View.INVISIBLE);
                holder.mView.setBackgroundResource(R.drawable.selectable_item_bg);
            } else {
                holder.mView.setBackgroundResource(R.drawable.item_gray_bg_layer);
                val = String.valueOf(anInt);

// declare the builder object once.
                builder = TextDrawable.builder()
                        .beginConfig()
                        .withBorder(4)
                        .endConfig()
                        .roundRect(20);

// reuse the builder specs to createFileInES multiple drawables
//                    TextDrawable ic1 = builder.build("A", color1);
//                    TextDrawable ic2 = builder.build(string.substring(0, 1), color2);
                ic2 = builder.build(val, Color.RED);
                holder.ivUnreadCount.setImageDrawable(ic2);
                holder.ivUnreadCount.setVisibility(View.VISIBLE);
            }

        }

        @Override
        public long getItemId(int position) {
            return messageItems.get(position).get_id();
        }

        @Override
        public int getItemCount() {
            return messageItems.size();
        }

        @Override
        public void onPostBitmapFromUrlExecute(Bitmap bitmap, View view, Context context) {
            if (null == context) return;
            Resources resources = context.getResources();
            if (null == resources) return;
            if (null == bitmap) {
// declare the builder object once.
                TextDrawable.IBuilder builder = TextDrawable.builder()
                        .beginConfig()
                        .withBorder(4)
                        .endConfig()
                        .round();
                ColorGenerator generator = ColorGenerator.MATERIAL; // or use DEFAULT
                TextDrawable ic2 = builder.build("EC", generator.getColor("EC"));
                ((ImageView) view).setImageDrawable(ic2);
            } else {
                Bitmap croppedBitmap = NetworkImageView.getCroppedBitmap(bitmap, 100);
                setImageDrawable(view, croppedBitmap);
            }
        }

        @Override
        public void onPostBitmapFromUrlExecuteFail(Bitmap bitmap) {
            Log.e(TAG, "On Post Bitmap From URL Exec ERROR: " + bitmap);
        }

        @Override
        public void setBitmapFromUrlTaskToNull() {
            bitmapFromUrlTask = null;
        }

        public class ViewHolder extends
                RecyclerView.ViewHolder implements
                View.OnLongClickListener {
            //            the root view
            public final View mView;
            //            the list item views
            public final TextView tvId;
            public final TextView tvName;
            public final TextView tvSubject;
            public final TextView tvFrom;
            public final TextView tvMessage;
            public final TextView tvTimestamp;
            public final ImageView tvSender;
            public final ImageView ivUnreadCount;
            public final ImageView ivAttachment;
            //            the data
            public MessageItem mItem;


            public ViewHolder(View view) {
                super(view);
                mView = view;
                view.setOnLongClickListener(this);
                mView.setOnClickListener(MsgsGrpDraftFragment.this);
                tvId = (TextView) view.findViewById(R.id.tv_id);
                tvName = (TextView) view.findViewById(R.id.tv_name);
                tvSubject = (TextView) view.findViewById(R.id.tv_subject);
                tvFrom = (TextView) view.findViewById(R.id.tv_from);
                tvMessage = (TextView) view.findViewById(R.id.tv_text);
                tvTimestamp = (TextView) view.findViewById(R.id.tv_timestamp);
                tvSender = (ImageView) view.findViewById(R.id.tv_sender);
                ivUnreadCount = (ImageView) view.findViewById(R.id.iv_unread_count);
                ivAttachment = (ImageView) view.findViewById(R.id.iv_attach);
            }

            @Override
            public String toString() {
                return super.toString() + " '" + tvMessage.getText() + "'";
            }

            @Override
            public boolean onLongClick(View v) {
                setSelectedItem(mItem);
                if (null == mActionMode) {
                    // Start the CAB using the ActionMode.Callback defined above
                    mActionMode = getAppCompatActivity().startSupportActionMode(mActionModeCallback);
//                view.setSelected(true);
                    v.setSelected(!v.isSelected());
                    return true;
                }
                v.setSelected(!v.isSelected());
                return false;
            }
        }
    }


}
