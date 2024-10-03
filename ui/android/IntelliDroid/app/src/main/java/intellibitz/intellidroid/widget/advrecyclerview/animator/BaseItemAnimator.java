

package intellibitz.intellidroid.widget.advrecyclerview.animator;

import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.SimpleItemAnimator;

public abstract class BaseItemAnimator extends SimpleItemAnimator {
    private ItemAnimatorListener mListener;

    /**
     * Internal only:
     * Sets the listener that must be called when the animator is finished
     * animating the item (or immediately if no animation happens). This is set
     * internally and is not intended to be set by external code.
     *
     * @param listener The listener that must be called.
     */
    public void setListener(ItemAnimatorListener listener) {
        mListener = listener;
    }

    @Override
    public final void onAddStarting(RecyclerView.ViewHolder item) {
        onAddStartingImpl(item);
    }

    @Override
    public final void onAddFinished(RecyclerView.ViewHolder item) {
        onAddFinishedImpl(item);

        if (mListener != null) {
            mListener.onAddFinished(item);
        }
    }

    @Override
    public final void onChangeStarting(RecyclerView.ViewHolder item, boolean oldItem) {
        onChangeStartingItem(item, oldItem);
    }

    @Override
    public final void onChangeFinished(RecyclerView.ViewHolder item, boolean oldItem) {
        onChangeFinishedImpl(item, oldItem);

        if (mListener != null) {
            mListener.onChangeFinished(item);
        }
    }

    @Override
    public final void onMoveStarting(RecyclerView.ViewHolder item) {
        onMoveStartingImpl(item);
    }

    @Override
    public final void onMoveFinished(RecyclerView.ViewHolder item) {
        onMoveFinishedImpl(item);

        if (mListener != null) {
            mListener.onMoveFinished(item);
        }
    }

    @Override
    public final void onRemoveStarting(RecyclerView.ViewHolder item) {
        onRemoveStartingImpl(item);
    }

    @Override
    public final void onRemoveFinished(RecyclerView.ViewHolder item) {
        onRemoveFinishedImpl(item);

        if (mListener != null) {
            mListener.onRemoveFinished(item);
        }
    }

    @SuppressWarnings("EmptyMethod")
    protected void onAddStartingImpl(RecyclerView.ViewHolder item) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onAddFinishedImpl(RecyclerView.ViewHolder item) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onChangeStartingItem(RecyclerView.ViewHolder item, boolean oldItem) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onChangeFinishedImpl(RecyclerView.ViewHolder item, boolean oldItem) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onMoveStartingImpl(RecyclerView.ViewHolder item) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onMoveFinishedImpl(RecyclerView.ViewHolder item) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onRemoveStartingImpl(RecyclerView.ViewHolder item) {
    }

    @SuppressWarnings("EmptyMethod")
    protected void onRemoveFinishedImpl(RecyclerView.ViewHolder item) {
    }

    public boolean dispatchFinishedWhenDone() {
        if (!isRunning()) {
            dispatchAnimationsFinished();
            return true;
        } else {
            return false;
        }
    }

    public boolean debugLogEnabled() {
        return false;
    }

    /**
     * The interface to be implemented by listeners to animation events from this
     * ItemAnimator. This is used internally and is not intended for developers to
     * create directly.
     */
    public interface ItemAnimatorListener {
        void onRemoveFinished(RecyclerView.ViewHolder item);

        void onAddFinished(RecyclerView.ViewHolder item);

        void onMoveFinished(RecyclerView.ViewHolder item);

        void onChangeFinished(RecyclerView.ViewHolder item);
    }
}
