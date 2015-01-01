Admob ANE Release Notes
=========
##Version 1.8.0
Improvement:<br>
- General performance<br>
- Added auto retry on failed requests<br>

Core Updates:<br>
- Updated iOS SDK to 6.12.2<br>

Bug fixes:<br>
- Fixed "iOS 8 compatibility" Bug

##Version 1.7.9
Core Updates:<br>
- Updated iOS SDK to 6.12.0<br>

Bug fixes:<br>
- Fixed "iOS 8 compatibility" Bug

##Version 1.7.8
Enhancement:<br>
- Disable the use of "SMART_BANNER_LAND" and "SMART_BANNER_PORT" in Android<br>
In android these formats are not supported, they will be automatically replaced with "SMART_BANNER"
- Disable the use of "WIDE_SKYSCRAPER"<br>
It is not supported by AdMob and it is only available in limited mediation networks
- Removed intimidating log messages
- Removed duplicated Native Logs.

Bug fixes:<br>
- Fixed "Inter Failed to Load" Bug

##Version 1.7.7
New Features:<br>
- Move Banner Function<br>
Now the banner can be move programmatically, which allow also to create small animation
- Added support for the new Large Banner (320x100)<br>
The new Banner size is now available. Please note that this size has been added on the latest SDK (after 6.8 for iOS) therefor this banner is not available in the ANE build compatible with iOS4.3.
- Get banner dimensions<br>
Get the banner dimension (actual pixel dimension in the device)
- Get Device Screen dimensions<br>
Get the accurate screen size, particularly helpful for `move` and `createAbsolute` methods
- Set Render mode (Hardware/Software/None) *Android Only<br>
This simple setting allow to solve a very sensitive performance aspect.<br>
You can now set, directly from the application in which Layer type you wish to render the banner, the types are none/hardware or software.<br>
The default render mode is hardware, but this may be in conflict with some 3D accelerated application.<br>
With the open setting you can now adjust the layer specifically for the application you are developing.<br>
Please note that Render acceleration is only available in Android from ver.3.0. in application before 3.0 the setting will not be applied since it is not available.<br>
<br>
Core Updates:<br>
- Updated iOS SDK to 6.11.1<br>
<br>
Bug fixes:<br>
- Fixed Compatibility bug with iOS from ver 6.x after introduction of TestDeviceID
- Added TestDeviceID Proprierty #31 (19bebb5439d2b1d4e10a86520b6e53452012b1d2)
- Fixed issue Interstitial Ads crashes on iOS 7.x #24  (3490e7f31853a03274d71b7d155e46d8af2da7a3)
- Fixed compatibility issue with Android 2.3 (c9bdf315d768a5e81befe3fb66e12c5bcdc47528)


##Version 1.7.5
- Fixed Interstitial Show Method in iOS
Now Interstitial can be create and show manually when needed.


##Version 1.7.0
- Updated Android SDK to Google Play Services ver.5.0
- Updated iOS SDK to 6.9.3
- Added RemoveInterstitial Method
- Fixed Unresponsive touch on iOS banners/interstitial
- Fixed CreateAbsolute Banner method


##Version 1.6.0
- Updated Android SDK to Google Play Services ver.4.3
- Updated iOS SDK to 6.8.0
- Added Multibanner Management


##Version 1.0.0
First Release.
- Android SDK: 6.4.1
- iOS SDK: 6.2.0

