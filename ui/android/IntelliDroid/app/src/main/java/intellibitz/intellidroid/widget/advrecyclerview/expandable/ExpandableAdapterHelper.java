

package intellibitz.intellidroid.widget.advrecyclerview.expandable;

import androidx.recyclerview.widget.RecyclerView;

class ExpandableAdapterHelper {
    public static final long NO_EXPANDABLE_POSITION = 0xffffffffffffffffL;
    /*package*/ static final int VIEW_TYPE_FLAG_IS_GROUP = 0x80000000;
    private static final long LOWER_32BIT_MASK = 0x00000000ffffffffL;
    private static final long LOWER_31BIT_MASK = 0x000000007fffffffL;

    private ExpandableAdapterHelper() {
    }

    public static long getPackedPositionForChild(int groupPosition, int childPosition) {
        return ((long) childPosition << 32) | (groupPosition & LOWER_32BIT_MASK);
    }

    public static long getPackedPositionForGroup(int groupPosition) {
        return ((long) RecyclerView.NO_POSITION << 32) | (groupPosition & LOWER_32BIT_MASK);
    }

    public static int getPackedPositionChild(long packedPosition) {
        return (int) (packedPosition >>> 32);
    }

    public static int getPackedPositionGroup(long packedPosition) {
        return (int) (packedPosition & LOWER_32BIT_MASK);
    }

    public static long getCombinedChildId(long groupId, long childId) {
        return ((groupId & LOWER_31BIT_MASK) << 32) | (childId & LOWER_32BIT_MASK);
    }

    public static long getCombinedGroupId(long groupId) {
        //noinspection PointlessBitwiseExpression
        return ((groupId & LOWER_31BIT_MASK) << 32) | (RecyclerView.NO_ID & LOWER_32BIT_MASK);
    }

    public static boolean isGroupViewType(int rawViewType) {
        return ((rawViewType & VIEW_TYPE_FLAG_IS_GROUP) != 0);
    }

    public static int getGroupViewType(int rawViewType) {
        return (rawViewType & (~VIEW_TYPE_FLAG_IS_GROUP));
    }

    public static int getChildViewType(int rawViewType) {
        return (rawViewType & (~VIEW_TYPE_FLAG_IS_GROUP));
    }
}
