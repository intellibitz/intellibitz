

package intellibitz.intellidroid.widget.advrecyclerview.expandable;

import intellibitz.intellidroid.widget.advrecyclerview.expandable.annotation.ExpandableItemStateFlags;
import intellibitz.intellidroid.widget.advrecyclerview.expandable.annotation.ExpandableItemStateFlags;

import androidx.recyclerview.widget.RecyclerView;

/**
 * <p>Interface which provides required information for expanding item.</p>
 * <p>Implement this interface on your sub-class of the {@link RecyclerView.ViewHolder}.</p>
 */
public interface ExpandableItemViewHolder {
    /**
     * Gets the state flags value for expanding item
     *
     * @return Bitwise OR of these flags;
     * - {@link ExpandableItemConstants#STATE_FLAG_IS_GROUP}
     * - {@link ExpandableItemConstants#STATE_FLAG_IS_CHILD}
     * - {@link ExpandableItemConstants#STATE_FLAG_IS_EXPANDED}
     * - {@link ExpandableItemConstants#STATE_FLAG_IS_UPDATED}
     */
    @ExpandableItemStateFlags
    int getExpandStateFlags();

    /**
     * Sets the state flags value for expanding item
     *
     * @param flags Bitwise OR of these flags;
     *              - {@link ExpandableItemConstants#STATE_FLAG_IS_GROUP}
     *              - {@link ExpandableItemConstants#STATE_FLAG_IS_CHILD}
     *              - {@link ExpandableItemConstants#STATE_FLAG_IS_EXPANDED}
     *              - {@link ExpandableItemConstants#STATE_FLAG_IS_UPDATED}
     */
    void setExpandStateFlags(@ExpandableItemStateFlags int flags);
}
