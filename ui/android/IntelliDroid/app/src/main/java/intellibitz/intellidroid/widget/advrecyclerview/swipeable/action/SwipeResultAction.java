

package intellibitz.intellidroid.widget.advrecyclerview.swipeable.action;

import androidx.recyclerview.widget.RecyclerView;

import intellibitz.intellidroid.widget.advrecyclerview.swipeable.SwipeableItemAdapter;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.SwipeableItemAdapter;

public abstract class SwipeResultAction {
    private final int mResultAction;

    protected SwipeResultAction(int resultAction) {
        mResultAction = resultAction;
    }

    public int getResultActionType() {
        return mResultAction;
    }

    public final void performAction() {
        onPerformAction();
    }

    public final void slideAnimationEnd() {
        onSlideAnimationEnd();
        onCleanUp();
    }

    /**
     * This method is called immediately after returning from the {@link SwipeableItemAdapter#onSwipeItem(RecyclerView.ViewHolder, int, int)} method.
     * You can modify data set and call notifyXXX() methods of adapter in this method.
     */
    protected void onPerformAction() {
    }

    /**
     * This method is called when item slide animation has completed.
     */
    protected void onSlideAnimationEnd() {
    }

    /**
     * This method is called after the {@link #onSlideAnimationEnd()} method. Clear fields to avoid memory leaks.
     */
    protected void onCleanUp() {
    }
}
