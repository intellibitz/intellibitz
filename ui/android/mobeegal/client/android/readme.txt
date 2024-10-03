///////////////////////////////////////////
Mobile Dating - Dating made mobile.
http://www.intellibitz.com
168, Medavakkam Main Road,
Madipakkam, Chennai -91.
+91 44 2247 6750
///////////////////////////////////////////

Mobeegal (Find stuff closer)

Steps to follow

After getting matches from the server, user can chat his mathces in his own way. To chat, you should
add the library smack.jar in your project. Smack3.0.4.zip is currently available in 
https://ns1/help/downloads/android/smak-%20xmpp/. Download and extract in your system then add in
your project.

Location Broadcast:

Inorder to work location broadcast, you need kml.xml, properties.txt which you can find in 
https://ns1/help/downloads/android/mock%20locationprovider/  because right now for chennai there is
no GPS. 

Download and do the following:

1. Run adb shell, then cd data -> cd misc -> cd location -> mkdir mobeegal
2. Run the mobeegal project.
3. Open DDMS
4. Go to data -> misc -> location -> mobeegal
5. Push into emulator kml.xml and properties.txt 
6. close the emulator and run again
that is it.

