/**
 * Copyright (C) IntelliBitz Technologies.,  Muthu Ramadoss
 * 168, Medavakkam Main Road, Madipakkam, Chennai 600091, Tamilnadu, India.
 * http://www.intellibitz.com
 * training@intellibitz.com
 * +91 44 2247 5106
 * http://groups.google.com/group/etoe
 * http://sted.sourceforge.net
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * STED, Copyright (C) 2007 IntelliBitz Technologies
 * STED comes with ABSOLUTELY NO WARRANTY;
 * This is free software, and you are welcome
 * to redistribute it under the GNU GPL conditions;
 *
 * Visit http://www.gnu.org/ for GPL License terms.
 */

/**
 * $Id:LoadFontMapAction.java 55 2007-05-19 05:55:34Z sushmu $
 * $HeadURL: svn+ssh://sushmu@svn.code.sf.net/p/sted/code/FontTransliterator/trunk/src/intellibitz/sted/actions/LoadFontMapAction.java $
 */

package intellibitz.sted.actions;

import intellibitz.sted.event.FontMapChangeEvent;
import intellibitz.sted.event.FontMapChangeListener;
import intellibitz.sted.launch.STEDGUI;
import intellibitz.sted.ui.STEDWindow;

import javax.swing.event.InternalFrameEvent;
import javax.swing.event.InternalFrameListener;
import javax.swing.event.TableModelEvent;
import java.awt.event.ActionEvent;

public class LoadFontMapAction
        extends TableModelListenerAction
        implements FontMapChangeListener,
        InternalFrameListener
{
    public LoadFontMapAction()
    {
        super();
    }

    /**
     * This fine grain notification tells listeners the exact range of cells,
     * rows, or columns that changed.
     */
    public void tableChanged(TableModelEvent e)
    {
        setEnabled(
                getSTEDWindow().getDesktop()
                        .getFontMap().isReloadable());
    }

    /**
     * Invoked when the target of the listener has changed its state.
     *
     * @param e a ChangeEvent object
     */
    public void stateChanged(FontMapChangeEvent e)
    {
        setEnabled(e.getFontMap().isReloadable());
    }

    public void actionPerformed(ActionEvent e)
    {
        final STEDWindow stedWindow = getSTEDWindow();
        STEDGUI.busy();
        stedWindow.getDesktop().reloadFontMap();
        fireStatusPosted("FontMap Re-Loaded");
        STEDGUI.relax();
    }

    public void internalFrameActivated(InternalFrameEvent e)
    {

    }

    public void internalFrameClosed(InternalFrameEvent e)
    {

    }

    public void internalFrameClosing(InternalFrameEvent e)
    {
        setEnabled(false);
    }

    public void internalFrameDeactivated(InternalFrameEvent e)
    {

    }

    public void internalFrameDeiconified(InternalFrameEvent e)
    {

    }

    public void internalFrameIconified(InternalFrameEvent e)
    {

    }

    public void internalFrameOpened(InternalFrameEvent e)
    {

    }

}
