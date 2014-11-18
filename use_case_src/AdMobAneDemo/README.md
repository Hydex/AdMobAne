Admob Native Extension - Demo Application
=========

##Note
If you wish to directly try the demo application for the the ANE functionality, you can find all the pre-build packages here:
- https://github.com/Code-Alchemy/AdMobAne/tree/master/sample_application

##Description
This is the full AdMobANE Demo Application source code.

The demo source code offer a complete use case of AdMobANE extension in a Air Game/Application.<br>
This demo do not cover yet all the capabilities and features of AdMobANE, but only the Major ones:
- Event Interstitial<br>
Pre-load and cash a Interstitial and show it on a specific event.<br>
In the case of this demo it happen when you lose the game in the Application mini-game
- Interstitial Management<br>
Create, show, and dispose the Interstitial on demand interactively by the user interface.
- Move Banner Demo<br>
Move an existing banner to a specific position or animate the banner to fly in the screen.
- Single Banner Demo<br>
Create, show, hide and dispose the Banner on demand interactively by the user interface.<br>
Creation features:<br>
1) Auto show on/off<br>
2) Smart banner on/off<br>
3) Relative position on/off<br>
4) Selection of banner sizes from the combo-box<br>
5) Selection of banner relative Positions from the combo-box<br>
6) Input of specific absolute position coordinates.<br>
- Multiple Banners Demo<br>
Create, show, hide and dispose the Banner on demand interactively by the user interface.<br>
Creation features:<br>
Apply to all on/off (show/hide and destroy function will apply to all currently created banners)<br>
1) Auto-show on/off<br>
2) Smart banner on/off<br>
3) Relative position on/off<br>
4) Selection of banner from the combo-box (list of currently created banners)<br>
5) Selection of banner sizes from the combo-box<br>
6) Selection of banner relative Positions from the combo-box<br>
7) Input of specific absolute position coordinates.<br>

In the Application source code, beside from the AdMob banner implementation example there are also several utility classes, UI control Classe and Data control classes that I'm sure may offer good development hints on game and application development.<br>
I truly hope you find it useful on your application and games.<br>
These feature are:<br>
Utility and manager controls:<br>
- AdsManager<br>
an Utility class for call the native extension methods.
- Sound manager<br>
Manager for Background Music and sound effects with multi channel support
- Localization manager<br>
Manager for application localization using JSON data as locale source
- Device manager<br>
Manager for device application. type of device and orientation
- Network Status Monitor<br>
Utility for track and be updated on network state changes (get/lose/resume network connection)
- SpriteUtl<br>
An utility for simply set objects pivot, position and alignments.
- TimerUtil<br>
An simple timer utility class<br>

UI models:
- Toggle button
- ComboBox
- Input fields
- Gauge filler
- Scroller
- Slide Selector
- Multi function button

I often have the request of showing a complete implementation of AdMobAne in order to practically see how to handle the extension.<br>
I truly hope this App Demo will answer any question and give opportunity for self improvement.

Contribution on the evolution of this Application are welcome from any one!<br>
Please feel free to send a pull request if you wish to contribute on the app quality.

##Notes on importing and compiling the Project
1) Update the Constants class with the Valid AdMob IDs (Flash Builder and FlashDevelop)<br>
2) Update the batch files (.bat) with your environment local paths (FlashDevelop only)<br>
3) Check and update IDE configuration according to your environment (Flash Builder and FlashDevelop)<br>
4) Add/Create the application certificate required for application building (Flash Builder and FlashDevelop)<br>
5) Other Project setting and check may be required or confirmed  (Flash Builder and FlashDevelop)<br>
6) Not really sure, but Flashevelop may require additional setting checks

##Development credits and notes
Application Design & Development<br>
Code Alchemy<br>
(The Mini game is based on scaffold_mobile project by Daniel. Thank you Daniel)<br>
<br>
Project compatibility IDE<br>
Flash Builder 4.7<br>
FlashDevelop 4.6.2<br>
<br>
Game Engine used<br>
Starling 1.5.1 by Gamua<br>
<br>
Additional Libraries used<br>
Feathers 1.3.1 by Josh Tynjala<br>
<br>
Native Extensions used<br>
AdMobAne by Code Alchemy<br>
<br>
Development Tools used<br>
TexturePacker by CodeAndWeb<br>
ATF Tools by Adobe<br>
<br>
Artwork (well, Art...)<br>
Code Alchemy<br>
<br>
Special Thanks<br>
Starling Community<br>
GitHub Community<br>
Stack Overflow Community<br>
and most of all...<br>
My wife and son for their patience and inspiration<br>

##Open Todo:
- Fix the position of the pop-up list to be more "combo-box style" (see ComboBox Class)
- Fix the input box focus bug on hardware accelerated application (see InputBox Class)
- Fine tune the alignment of object (see SpriteUtl Class)
