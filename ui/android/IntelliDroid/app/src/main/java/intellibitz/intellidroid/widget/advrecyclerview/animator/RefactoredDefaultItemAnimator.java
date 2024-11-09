

package intellibitz.intellidroid.widget.advrecyclerview.animator;

import android.view.View;

import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.AddAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ChangeAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemAddAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemChangeAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemMoveAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemRemoveAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.MoveAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.RemoveAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.AddAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ChangeAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemAddAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemChangeAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemMoveAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.ItemRemoveAnimationManager;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.MoveAnimationInfo;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.RemoveAnimationInfo;

import androidx.core.view.ViewCompat;
import androidx.core.view.ViewPropertyAnimatorCompat;
import androidx.recyclerview.widget.RecyclerView;
import intellibitz.intellidroid.widget.advrecyclerview.animator.impl.AddAnimationInfo;

public class RefactoredDefaultItemAnimator extends GeneralItemAnimator {

    @Override
    protected void onSetup() {
        setItemAddAnimationsManager(new DefaultItemAddAnimationManager(this));
        setItemRemoveAnimationManager(new DefaultItemRemoveAnimationManager(this));
        setItemChangeAnimationsManager(new DefaultItemChangeAnimationManager(this));
        setItemMoveAnimationsManager(new DefaultItemMoveAnimationManager(this));
    }

    @Override
    protected void onSchedulePendingAnimations() {
        schedulePendingAnimationsByDefaultRule();
    }

    /**
     * Item Animation manager for ADD operation  (Same behavior as DefaultItemAnimator class)
     */
    protected static class DefaultItemAddAnimationManager extends ItemAddAnimationManager {

        public DefaultItemAddAnimationManager(BaseItemAnimator itemAnimator) {
            super(itemAnimator);
        }

        @Override
        protected void onCreateAnimation(AddAnimationInfo info) {
            final ViewPropertyAnimatorCompat animator = ViewCompat.animate(info.holder.itemView);

            animator.alpha(1);
            animator.setDuration(getDuration());

            startActiveItemAnimation(info, info.holder, animator);
        }

        @Override
        protected void onAnimationEndedSuccessfully(AddAnimationInfo info, RecyclerView.ViewHolder item) {
        }

        @Override
        protected void onAnimationEndedBeforeStarted(AddAnimationInfo info, RecyclerView.ViewHolder item) {
            ViewCompat.setAlpha(item.itemView, 1);
        }

        @Override
        protected void onAnimationCancel(AddAnimationInfo info, RecyclerView.ViewHolder item) {
            ViewCompat.setAlpha(item.itemView, 1);
        }

        @Override
        public boolean addPendingAnimation(RecyclerView.ViewHolder item) {
            endAnimation(item);

            ViewCompat.setAlpha(item.itemView, 0);

            enqueuePendingAnimationInfo(new AddAnimationInfo(item));

            return true;
        }
    }

    /**
     * Item Animation manager for REMOVE operation  (Same behavior as DefaultItemAnimator class)
     */
    protected static class DefaultItemRemoveAnimationManager extends ItemRemoveAnimationManager {

        public DefaultItemRemoveAnimationManager(BaseItemAnimator itemAnimator) {
            super(itemAnimator);
        }

        @Override
        protected void onCreateAnimation(RemoveAnimationInfo info) {
            final ViewPropertyAnimatorCompat animator = ViewCompat.animate(info.holder.itemView);

            animator.setDuration(getDuration());
            animator.alpha(0);

            startActiveItemAnimation(info, info.holder, animator);
        }

        @Override
        protected void onAnimationEndedSuccessfully(RemoveAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            ViewCompat.setAlpha(view, 1);
        }

        @Override
        protected void onAnimationEndedBeforeStarted(RemoveAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            ViewCompat.setAlpha(view, 1);
        }

        @Override
        protected void onAnimationCancel(RemoveAnimationInfo info, RecyclerView.ViewHolder item) {
        }

        @Override
        public boolean addPendingAnimation(RecyclerView.ViewHolder holder) {
            endAnimation(holder);

            enqueuePendingAnimationInfo(new RemoveAnimationInfo(holder));
            return true;
        }
    }

    /**
     * Item Animation manager for CHANGE operation  (Same behavior as DefaultItemAnimator class)
     */
    protected static class DefaultItemChangeAnimationManager extends ItemChangeAnimationManager {
        public DefaultItemChangeAnimationManager(BaseItemAnimator itemAnimator) {
            super(itemAnimator);
        }

        @Override
        protected void onCreateChangeAnimationForOldItem(ChangeAnimationInfo info) {
            final ViewPropertyAnimatorCompat animator = ViewCompat.animate(info.oldHolder.itemView);

            animator.setDuration(getDuration());
            animator.translationX(info.toX - info.fromX);
            animator.translationY(info.toY - info.fromY);
            animator.alpha(0);

            startActiveItemAnimation(info, info.oldHolder, animator);
        }


        @Override
        protected void onCreateChangeAnimationForNewItem(ChangeAnimationInfo info) {
            final ViewPropertyAnimatorCompat animator = ViewCompat.animate(info.newHolder.itemView);

            animator.translationX(0);
            animator.translationY(0);
            animator.setDuration(getDuration());
            animator.alpha(1);

            startActiveItemAnimation(info, info.newHolder, animator);
        }

        @Override
        protected void onAnimationEndedSuccessfully(ChangeAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            ViewCompat.setAlpha(view, 1);
            ViewCompat.setTranslationX(view, 0);
            ViewCompat.setTranslationY(view, 0);
        }

        @Override
        protected void onAnimationEndedBeforeStarted(ChangeAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            ViewCompat.setAlpha(view, 1);
            ViewCompat.setTranslationX(view, 0);
            ViewCompat.setTranslationY(view, 0);
        }

        @Override
        protected void onAnimationCancel(ChangeAnimationInfo info, RecyclerView.ViewHolder item) {
        }

        @Override
        public boolean addPendingAnimation(RecyclerView.ViewHolder oldHolder, RecyclerView.ViewHolder newHolder, int fromX, int fromY, int toX, int toY) {
            final float prevTranslationX = ViewCompat.getTranslationX(oldHolder.itemView);
            final float prevTranslationY = ViewCompat.getTranslationY(oldHolder.itemView);
            final float prevAlpha = ViewCompat.getAlpha(oldHolder.itemView);

            endAnimation(oldHolder);

            final int deltaX = (int) (toX - fromX - prevTranslationX);
            final int deltaY = (int) (toY - fromY - prevTranslationY);

            // recover prev translation state after ending animation
            ViewCompat.setTranslationX(oldHolder.itemView, prevTranslationX);
            ViewCompat.setTranslationY(oldHolder.itemView, prevTranslationY);
            ViewCompat.setAlpha(oldHolder.itemView, prevAlpha);

            if (newHolder != null) {
                // carry over translation values
                endAnimation(newHolder);
                ViewCompat.setTranslationX(newHolder.itemView, -deltaX);
                ViewCompat.setTranslationY(newHolder.itemView, -deltaY);
                ViewCompat.setAlpha(newHolder.itemView, 0);
            }

            enqueuePendingAnimationInfo(new ChangeAnimationInfo(oldHolder, newHolder, fromX, fromY, toX, toY));

            return true;
        }
    }

    /**
     * Item Animation manager for MOVE operation  (Same behavior as DefaultItemAnimator class)
     */
    protected static class DefaultItemMoveAnimationManager extends ItemMoveAnimationManager {

        public DefaultItemMoveAnimationManager(BaseItemAnimator itemAnimator) {
            super(itemAnimator);
        }

        @Override
        protected void onCreateAnimation(MoveAnimationInfo info) {
            final View view = info.holder.itemView;
            final int deltaX = info.toX - info.fromX;
            final int deltaY = info.toY - info.fromY;

            if (deltaX != 0) {
                ViewCompat.animate(view).translationX(0);
            }
            if (deltaY != 0) {
                ViewCompat.animate(view).translationY(0);
            }

            final ViewPropertyAnimatorCompat animator = ViewCompat.animate(view);

            animator.setDuration(getDuration());

            startActiveItemAnimation(info, info.holder, animator);
        }

        @Override
        protected void onAnimationEndedSuccessfully(MoveAnimationInfo info, RecyclerView.ViewHolder item) {
        }

        @Override
        protected void onAnimationEndedBeforeStarted(MoveAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            ViewCompat.setTranslationY(view, 0);
            ViewCompat.setTranslationX(view, 0);
        }

        @Override
        protected void onAnimationCancel(MoveAnimationInfo info, RecyclerView.ViewHolder item) {
            final View view = item.itemView;
            final int deltaX = info.toX - info.fromX;
            final int deltaY = info.toY - info.fromY;

            if (deltaX != 0) {
                ViewCompat.animate(view).translationX(0);
            }
            if (deltaY != 0) {
                ViewCompat.animate(view).translationY(0);
            }

            if (deltaX != 0) {
                ViewCompat.setTranslationX(view, 0);
            }
            if (deltaY != 0) {
                ViewCompat.setTranslationY(view, 0);
            }
        }

        @Override
        public boolean addPendingAnimation(RecyclerView.ViewHolder item, int fromX, int fromY, int toX, int toY) {
            final View view = item.itemView;

            fromX += ViewCompat.getTranslationX(item.itemView);
            fromY += ViewCompat.getTranslationY(item.itemView);

            endAnimation(item);

            final int deltaX = toX - fromX;
            final int deltaY = toY - fromY;

            final MoveAnimationInfo info = new MoveAnimationInfo(item, fromX, fromY, toX, toY);

            if (deltaX == 0 && deltaY == 0) {
                dispatchFinished(info, info.holder);
                info.clear(info.holder);
                return false;
            }

            if (deltaX != 0) {
                ViewCompat.setTranslationX(view, -deltaX);
            }
            if (deltaY != 0) {
                ViewCompat.setTranslationY(view, -deltaY);
            }

            enqueuePendingAnimationInfo(info);

            return true;
        }
    }
}
