

package intellibitz.intellidroid.widget.advrecyclerview.utils;

import android.view.View;

import intellibitz.intellidroid.widget.advrecyclerview.swipeable.RecyclerViewSwipeManager;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.SwipeableItemViewHolder;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemReactions;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemResults;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemStateFlags;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.RecyclerViewSwipeManager;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.SwipeableItemViewHolder;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemReactions;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemResults;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.annotation.SwipeableItemStateFlags;

import androidx.recyclerview.widget.RecyclerView;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.RecyclerViewSwipeManager;
import intellibitz.intellidroid.widget.advrecyclerview.swipeable.SwipeableItemViewHolder;

public abstract class AbstractSwipeableItemViewHolder extends RecyclerView.ViewHolder implements SwipeableItemViewHolder {
    @SwipeableItemStateFlags
    private int mSwipeStateFlags;
    @SwipeableItemResults
    private int mSwipeResult = RecyclerViewSwipeManager.RESULT_NONE;
    @SwipeableItemReactions
    private int mAfterSwipeReaction = RecyclerViewSwipeManager.AFTER_SWIPE_REACTION_DEFAULT;
    private float mHorizontalSwipeAmount;
    private float mVerticalSwipeAmount;
    private float mMaxLeftSwipeAmount = RecyclerViewSwipeManager.OUTSIDE_OF_THE_WINDOW_LEFT;
    private float mMaxUpSwipeAmount = RecyclerViewSwipeManager.OUTSIDE_OF_THE_WINDOW_TOP;
    private float mMaxRightSwipeAmount = RecyclerViewSwipeManager.OUTSIDE_OF_THE_WINDOW_RIGHT;
    private float mMaxDownSwipeAmount = RecyclerViewSwipeManager.OUTSIDE_OF_THE_WINDOW_BOTTOM;

    public AbstractSwipeableItemViewHolder(View itemView) {
        super(itemView);
    }

    @Override
    @SwipeableItemStateFlags
    public int getSwipeStateFlags() {
        return mSwipeStateFlags;
    }

    @Override
    public void setSwipeStateFlags(@SwipeableItemStateFlags int flags) {
        mSwipeStateFlags = flags;
    }

    @Override
    @SwipeableItemResults
    public int getSwipeResult() {
        return mSwipeResult;
    }

    @Override
    public void setSwipeResult(@SwipeableItemResults int result) {
        mSwipeResult = result;
    }

    @Override
    @SwipeableItemReactions
    public int getAfterSwipeReaction() {
        return mAfterSwipeReaction;
    }

    @Override
    public void setAfterSwipeReaction(@SwipeableItemReactions int reaction) {
        mAfterSwipeReaction = reaction;
    }

    @Override
    public float getSwipeItemVerticalSlideAmount() {
        return mVerticalSwipeAmount;
    }

    @Override
    public void setSwipeItemVerticalSlideAmount(float amount) {
        mVerticalSwipeAmount = amount;
    }

    @Override
    public float getSwipeItemHorizontalSlideAmount() {
        return mHorizontalSwipeAmount;
    }

    @Override
    public void setSwipeItemHorizontalSlideAmount(float amount) {
        mHorizontalSwipeAmount = amount;
    }

    @Override
    public abstract View getSwipeableContainerView();

    @Override
    public float getMaxLeftSwipeAmount() {
        return mMaxLeftSwipeAmount;
    }

    @Override
    public void setMaxLeftSwipeAmount(float amount) {
        mMaxLeftSwipeAmount = amount;
    }

    @Override
    public float getMaxUpSwipeAmount() {
        return mMaxUpSwipeAmount;
    }

    @Override
    public void setMaxUpSwipeAmount(float amount) {
        mMaxUpSwipeAmount = amount;
    }

    @Override
    public float getMaxRightSwipeAmount() {
        return mMaxRightSwipeAmount;
    }

    @Override
    public void setMaxRightSwipeAmount(float amount) {
        mMaxRightSwipeAmount = amount;
    }

    @Override
    public float getMaxDownSwipeAmount() {
        return mMaxDownSwipeAmount;
    }

    @Override
    public void setMaxDownSwipeAmount(float amount) {
        mMaxDownSwipeAmount = amount;
    }

    @Override
    public void onSlideAmountUpdated(float horizontalAmount, float verticalAmount, boolean isSwiping) {
    }
}
