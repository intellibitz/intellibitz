

These are the instructions about the sample application:
 
This is only if you decide to use the sample application the way it is:
Edit settings.php:
- change $fromfield
- set $tofield (very important!) to email address of your own (you'll get copy of every invite sent, either ways you need to set this!)
- change $iscript to be something else if you don't want yahoo to be the default one 


Edit email.html:
- This is the message that will be sent. You can use any html editor to change it 
(it must be in html, no plain text).

- You can use [[[sender]]] in the html message and the subject line which will
be replaced by the email address of the user sending the invites. 

Edit emailsubject.txt:
- This must be one line. If it's more than one line it won't work. It's just the subject line for the message. You can use [[[sender]]] here as well.  

import.php is the main file. So if you would like to test it as is on your webserver just copy everything keeping the file structure the way it is to your webserver. Then navigate to import.php from your browser. 
For instance let's say you put the whole import folder in the public_html folder on your server (or www, whatever your public folder is), then from your browser you should navigate to url similar to this: 
 
http://yourserver.com/import/import.php 
 
form.php is the form where you put your username and password, it's included through import.php so you do not really need to worry about it (accessing it directly will not do much).
 
settings.php is also included through import.php (it lets import.php know what scripts are available and what links to print out in the Select: line on top). You do not need to access settings.php directly, except to edit it. 
 
form.html is not used. you can completely delet it.
 
emailsubject.txt and email.html are explained above.
 
So, really to test it you just need to put everything on your server and navigate to import.php from your browser (without changing anything). Import contacts but do not send invites (at least for the test, otherwise you'll need to change the setting)  
