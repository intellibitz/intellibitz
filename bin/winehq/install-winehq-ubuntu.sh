#https://wiki.winehq.org/Ubuntu

#If your system is 64 bit, enable 32 bit architecture (if you haven't already):
sudo dpkg --add-architecture i386

#Download and add the repository key:
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key

sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update

#Stable branch
sudo apt install --install-recommends winehq-stable
#Development branch
sudo apt install --install-recommends winehq-devel
#Staging branch
sudo apt install --install-recommends winehq-staging

#if apt complains about missing dependencies, install them, then
# repeat the last two steps (update and install).

#To create a 32-bit WINE prefix on a 64-bit Ubuntu system, you need to open a
# terminal and run the following command:

WINEPREFIX="$HOME/.wine32" WINEARCH=win32 wine wineboot

#    Where WINEPREFIX is the directory for the prefix
#    This directory must not already exist or you will get an error!
#    Please do not manually create it in Nautilus or with mkdir./

#https://wiki.winehq.org/FAQ

#6.5 Wineprefixes
#6.5.1 Where is my C: drive?
#
#Wine uses a virtual C: drive instead of your real C: drive. The directory in
# which this is located is called a 'wineprefix.'
#By default, it's in your home directory's .wine/drive_c subdirectory. (On
# macOS, see the macOS FAQ for how to find this.)
#See also the WINEPREFIX environment variable; if this is set, wine uses it to find the wineprefix.

#6.5.2 Can I store the virtual Windows installation somewhere other than ~/.wine?
#
#Yes: ~/.wine is just the default wineprefix (a.k.a. "configuration directory" or "bottle").
#You can change which prefix Wine uses by changing the WINEPREFIX environment
# variable (outside Wine). To do this, run something like the following in a terminal:
export WINEPREFIX=~/.wine-new
wine winecfg
#Wine will then create a new prefix in ~/.wine-new.
#To use the default prefix, use the command unset WINEPREFIX . Or just set WINEPREFIX to ~/.wine.
#Alternatively, you can specify the wine prefix in each command, e.g.
WINEPREFIX=path_to_wineprefix wine winecfg
#You can rename, move, copy and delete prefixes without affecting others, and
# each prefix has its own wineserver instance.
#Wherever you see ~/.wine or $HOME/.wine in this Wiki, you can usually replace it with $WINEPREFIX.

#6.5.3 How do I create a 32 bit wineprefix on a 64 bit system?
#At present there are some significant bugs that prevent many 32 bit
# applications from working in a 64 bit wineprefix. To work around this,
# you can create a new 32 bit wineprefix using the WINEARCH environment variable. In a terminal, type:
WINEARCH=win32 WINEPREFIX=path_to_wineprefix winecfg
#(use the actual path to the wineprefix) Do not use an existing directory for the new wineprefix: Wine must create it.
#Once a 32 bit wineprefix is created, you no longer have to specify WINEARCH in
# the command line to use it, as the architecture of an existing wineprefix
# cannot be changed. Note that if the wineprefix is not the default (~/.wine,
# you do have to specify the WINEPREFIX variable when installing anything (including winetricks) to it:
WINEPREFIX=path_to_wineprefix wine start /unix path_to_installer

#6.5.4 Why aren't versions of Windows prior to XP available in 64 bit wineprefixes?
#Short answer: because there were no 64 bit versions of Windows prior to XP.
#If you are on a 64 bit system, you will have to create a 32 bit wineprefix to
# be able to select a version of Windows older than XP in winecfg.

#https://forum.winehq.org/viewtopic.php?t=33963
#Re: How to install powershell on Wine?
#
#You can trick/fool the installer; it checks for the version of pwrshplugin.dll
# (a dll that wine doesn`t provide)
#
#Trick/fool the installer with some dll:
#
cp -rf ~/.wine/drive_c/windows/system32/msxml3.dll ~/.wine/drive_c/windows/system32/pwrshplugin.dll
cp -rf ~/.wine/drive_c/windows/syswow64/msxml3.dll ~/.wine/drive_c/windows/syswow64/pwrshplugin.dll
#
#Now the installer starts and completes. Then do "wine start pwsh.exe"
