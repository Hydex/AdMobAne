//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 Code Alchemy inc. All rights reserved.
//

package com.codealchemy.ane.admobane
{
	import flash.events.Event;
	public class AdMobEvent extends Event
	{
        public static const BANNER_LOADED:String					= "onBannerLoaded";
        public static const BANNER_FAILED_TO_LOAD:String			= "onBannerFailedToLoad";
        public static const BANNER_AD_OPENED:String					= "onBannerAdOpened";
        public static const BANNER_LEFT_APPLICATION:String			= "onBannerLeftApplication";
        public static const INTERSTITIAL_LOADED:String				= "onInterstitialLoaded";
        public static const INTERSTITIAL_FAILED_TO_LOAD:String		= "onInterstitialFailedToLoad";
        public static const INTERSTITIAL_AD_CLOSED:String			= "onInterstitialAdClosed";
        public static const INTERSTITIAL_LEFT_APPLICATION:String	= "onInterstitialLeftApplication";
	}
}