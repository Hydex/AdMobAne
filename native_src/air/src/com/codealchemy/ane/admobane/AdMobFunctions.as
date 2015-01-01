//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 Code Alchemy inc. All rights reserved.
//

package com.codealchemy.ane.admobane
{	
	/**
	 * AdMobFunctions Class
	 * The class will construct and manage the AdMob Functions
	 *
	 * @author Code Alchemy
	 **/
	public class AdMobFunctions
	{
		// Banner Position Constants
        public static const BANNER_CREATE:String			= "createBanner";
        public static const BANNER_CREATE_ABSOLUTE:String	= "createBannerAbsolute";
        public static const BANNER_SHOW:String				= "showBanner";
        public static const BANNER_HIDE:String				= "hideBanner";
        public static const BANNER_REMOVE:String			= "removeBanner";
        public static const INTERSTITIAL_CREATE:String		= "createInterstitial";
        public static const INTERSTITIAL_REMOVE:String		= "removeInterstitial";
        public static const INTERSTITIAL_SHOW:String		= "showInterstitial";
        public static const INTERSTITIAL_CACHE:String		= "cacheInterstitial";
        public static const INTERSTITIAL_IS_LOADED:String	= "isInterstitialLoaded";
        public static const SET_MODE:String					= "setMode";
        public static const SET_TEST_DEVICE_ID:String		= "setTestDeviceID";
        public static const SET_VERBOSE:String				= "setVerbose";
        public static const SET_GENDER:String				= "setGender";
        public static const SET_BIRTHYEAR:String			= "setBirthYear";
        public static const SET_BIRTHMONTH:String			= "setBirthMonth";
        public static const SET_BIRTHDAY:String				= "setBirthDay";
        public static const SET_CDT:String					= "setCDT";
	}
}