

package intellibitz.intellidroid.widget.advrecyclerview.touchguard;

import android.util.Log;
import android.view.MotionEvent;
import android.view.ViewConfiguration;

import androidx.annotation.NonNull;
import androidx.core.view.MotionEventCompat;
import androidx.recyclerview.widget.RecyclerView;

/**
 * Hooks touch events to avoid unexpected scrolling.
 */
public class RecyclerViewTouchActionGuardManager {
    private static final String TAG = "ARVTouchActionGuardMgr";

    private static final boolean LOCAL_LOGV = false;
    private static final boolean LOCAL_LOGD = false;

    private RecyclerView.OnItemTouchListener mInternalUseOnItemTouchListener;
    private RecyclerView mRecyclerView;
    private boolean mGuarding;
    private int mInitialTouchY;
    private int mLastTouchY;
    private int mTouchSlop;
    private boolean mEnabled;
    private boolean mInterceptScrollingWhileAnimationRunning;

    /**
     * Constructor.
     */
    public RecyclerViewTouchActionGuardManager() {
        mInternalUseOnItemTouchListener = new RecyclerView.OnItemTouchListener() {
            @Override
            public boolean onInterceptTouchEvent(RecyclerView rv, MotionEvent e) {
                return RecyclerViewTouchActionGuardManager.this.onInterceptTouchEvent(rv, e);
            }

            @Override
            public void onTouchEvent(RecyclerView rv, MotionEvent e) {
                RecyclerViewTouchActionGuardManager.this.onTouchEvent(rv, e);
            }

            @Override
            public void onRequestDisallowInterceptTouchEvent(boolean disallowIntercept) {
            }
        };
    }

    private static boolean isAnimationRunning(RecyclerView rv) {
        final RecyclerView.ItemAnimator itemAnimator = rv.getItemAnimator();
        return (itemAnimator != null) && (itemAnimator.isRunning());
    }

    /**
     * Indicates this manager instance has released or not.
     *
     * @return True if this manager instance has released
     */
    public boolean isReleased() {
        return (mInternalUseOnItemTouchListener == null);
    }

    /**
     * Attaches {@link RecyclerView} instance.
     *
     * @param rv The {@link RecyclerView} instance
     */
    public void attachRecyclerView(@NonNull RecyclerView rv) {
        if (isReleased()) {
            throw new IllegalStateException("Accessing released object");
        }

        if (mRecyclerView != null) {
            throw new IllegalStateException("RecyclerView instance has already been set");
        }

        mRecyclerView = rv;
        mRecyclerView.addOnItemTouchListener(mInternalUseOnItemTouchListener);

        mTouchSlop = ViewConfiguration.get(rv.getContext()).getScaledTouchSlop();
    }

    /**
     * Detach the {@link RecyclerView} instance and release internal field references.
     * <p/>
     * This method should be called in order to avoid memory leaks.
     */
    public void release() {
        if (mRecyclerView != null && mInternalUseOnItemTouchListener != null) {
            mRecyclerView.removeOnItemTouchListener(mInternalUseOnItemTouchListener);
        }
        mInternalUseOnItemTouchListener = null;
        mRecyclerView = null;
    }

    /*package*/ boolean onInterceptTouchEvent(RecyclerView rv, MotionEvent e) {
        if (!mEnabled) {
            return false;
        }

        final int action = MotionEventCompat.getActionMasked(e);

        if (LOCAL_LOGV) {
            Log.v(TAG, "onInterceptTouchEvent() action = " + action);
        }

        switch (action) {
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                handleActionUpOrCancel();
                break;

            case MotionEvent.ACTION_DOWN:
                handleActionDown(e);
                break;

            case MotionEvent.ACTION_MOVE:
                if (handleActionMove(rv, e)) {
                    return true;
                }
                break;
        }

        return false;
    }

    /*package*/ void onTouchEvent(RecyclerView rv, MotionEvent e) {
        if (!mEnabled) {
            return;
        }

        final int action = MotionEventCompat.getActionMasked(e);

        if (LOCAL_LOGV) {
            Log.v(TAG, "onTouchEvent() action = " + action);
        }

        switch (action) {
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                handleActionUpOrCancel();
                break;
        }
    }

    private boolean handleActionMove(RecyclerView rv, MotionEvent e) {
        if (!mGuarding) {
            mLastTouchY = (int) (e.getY() + 0.5f);

            final int distance = mLastTouchY - mInitialTouchY;

            if (mInterceptScrollingWhileAnimationRunning && (Math.abs(distance) > mTouchSlop) && isAnimationRunning(rv)) {
                // intercept vertical move touch events while animation is running
                mGuarding = true;
            }
        }

        return mGuarding;
    }

    private void handleActionUpOrCancel() {
        mGuarding = false;
        mInitialTouchY = 0;
        mLastTouchY = 0;
    }

    private void handleActionDown(MotionEvent e) {
        mInitialTouchY = mLastTouchY = (int) (e.getY() + 0.5f);
        mGuarding = false;
    }

    /**
     * Checks whether the touch guard feature is enabled.
     *
     * @return True for currently touch guard feature is enabled, otherwise false
     */
    public boolean isEnabled() {
        return mEnabled;
    }

    /**
     * Sets whether to use touch guard feature. If set false, all touch event interceptions will be disabled.
     *
     * @param enabled enabled / disabled
     */
    public void setEnabled(boolean enabled) {
        if (mEnabled == enabled) {
            return;
        }
        mEnabled = enabled;

        if (!mEnabled) {
            handleActionUpOrCancel();
        }
    }

    /**
     * Sets whether to use interception of "vertical scroll while animation running".
     *
     * @param enabled enabled / disabled
     */
    public void setInterceptVerticalScrollingWhileAnimationRunning(boolean enabled) {
        mInterceptScrollingWhileAnimationRunning = enabled;
    }

    /**
     * Checks whether the interception of "vertical scroll while animation running" is enabled.
     *
     * @return enabled / disabled
     */
    public boolean isInterceptScrollingWhileAnimationRunning() {
        return mInterceptScrollingWhileAnimationRunning;
    }
}
