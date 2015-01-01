ANE Packages (Google Play Services Library not included)
=========

These packages does not includes the Google Play Service Library.<br>
Please use these packages exclusively on the occasion when another ANE using the Google Play Services Library is in the project.<br>
<br>
Since two ANE with the same library will not compile it is possible to add one ANE with the Library and one without. Then both ANE will use the shared library.<br>
<br>
Please Note:
- AdMobANE requires the Google Play Service Library to work. If a project do not have already the Google Play Service Library, please use the standard Packages.
- The meta data:
```xml
<meta-data android:name="com.google.android.gms.version" android:value="4452000"/>
```
Needs to be declared only once, please use the meta-data setting according to the ANE instruction which includes the Google Play Library.<br>
AdMob is compatible with any version of Google Play Library from 4.3 (4323000).
- Since AdMobANE does not includes the Google Play Library, declare the inclusion of the ANE after the other ANE as been included.
Example:
```xml
<application android:hardwareAccelerated="true">
	<service android:name="com.codealchemy.ane.APKExpansion.BaseDownloaderService" />
	<receiver android:name="com.codealchemy.ane.APKExpansion.AlarmReceiver" />
	<!-- Google Play Services Library version control (according to the Library used) -->
	<meta-data android:name="com.google.android.gms.version" android:value="4323000"/>
	
	<!-- Other ANE activities... -->
	<activity android:name="com.codealchemy.ane.InAppPurchase.BillingActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" android:background="#30000000" />
	<activity android:name=...  />
	<activity android:name=...  />
	...
	<!-- Then AdMobANE activity declaration -->
	<activity android:name="com.google.android.gms.ads.AdActivity" android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize" />
</application>

....

<extensions>
	<!-- Other ANE extensions... -->
	<extensionID>com.codealchemy.ane.InAppPurchase</extensionID>
    	<extensionID>com.codealchemy.ane.APKExpansion</extensionID>
    	<extensionID>...</extensionID>

	<!-- Then AdMobANE extension -->
  	<extensionID>com.codealchemy.ane.admobane</extensionID>
</extensions>

```


All packages are update to the last build (version 1.8.0)
- SDK Used:<br>
Android: (not included)<br>
iOS: Admob SDK 6.12.2<br>
<br>
This version is not compatible with iOS 4.3.<br>
<br>
For application targeting iOS 4.3 and above please use the packages in:<br>
/For_iOS_4.3<br>
The functionality and release version is exactly the same.<br>
The only difference is that the build uses AdMob SDK 6.8.0 for iOS which preserve compatibility with iOS 4.3<br>
PLEASE NOTE THAT THE 4.3 RELEASE PACKAGE IT IS NOT COMPATIBLE WITH IOS 8<br>
<br>
Please see: https://developers.google.com/mobile-ads-sdk/docs/rel-notes#ios<br>
for further details.
