//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 Code Alchemy inc. All rights reserved.
//

package com.codealchemy.ane.admobane
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	public class AdMobManager extends EventDispatcher
	{
		static private const LOG_TAG:String				= 'AdMobAne_AS3';
		static public const TEST_MODE:Boolean			= false;
		static public const GENDER_UNDEFINED:int		= 0;
		static public const GENDER_MALE:int				= 1;
		static public const GENDER_FEMALE:int			= 2;
		static public const IOS:String					= "iOS";
		static public const ANDROID:String				= "Android";
		private const ID_TEST_MODE:String				= "Testing Mode";
		private const ID_PROD_MODE:String				= "Production Mode";
		static private var mManager:AdMobManager		= null;
		private var mCtx:ExtensionContext				= null;
		private var mDispatcher:EventDispatcher			= null;
		private var mBannersAdMobId:String				= null;
		private var mInterstitialAdMobId:String			= null;
		private var mTestDeviceID:String				= null;
		private var mDevice:String						= null;
		private var mBannersDic:Dictionary				= null;
		private var mIsInterstitialCreated:Boolean		= false;
		private var mInterstitialAutoShow:Boolean		= false;
		private var mGender:int							= 0;
		private var mBirthYear:int						= 0;
		private var mBirthMonth:int						= 0;
		private var mBirthDay:int						= 0;
		private var mIsCDT:Boolean						= false;
		static public function get manager():AdMobManager
		{
			return mManager;
		}
		public function get dispatcher():EventDispatcher
		{
			if(!mDispatcher) { mDispatcher = new EventDispatcher(); }
			return mDispatcher;
		}
		private function get ctx():ExtensionContext
		{return mCtx;}
		public function get bannersAdMobId():String
		{ return mBannersAdMobId; }
		public function set bannersAdMobId(id:String):void
		{ mBannersAdMobId = id; }
		public function get interstitialAdMobId():String
		{ return mInterstitialAdMobId; }
		public function set interstitialAdMobId(id:String):void
		{ mInterstitialAdMobId = id; }
		public function get operationMode():Boolean
		{ return mOperationMode; }
		public function set operationMode(mode:Boolean):void
		{
			mOperationMode = mode;
			log(LOG_TAG, "Native SetMode Call Performed!");
            ctx.call(AdMobFunctions.SET_MODE, mOperationMode);
		}
		public function get verbose():Boolean
		{ return mVerbose; }
		public function set verbose(mode:Boolean):void
		{
            ctx.call(AdMobFunctions.SET_VERBOSE, mVerbose);
		}
		public function get isSupported():Boolean
		{
			return false;
		}
		private function get isInterstitialCreated():Boolean
		{return mIsInterstitialCreated;}
		private function get interstitialAutoShow():Boolean
		{return mInterstitialAutoShow;}
		public function get device():String
		{
			if (!mDevice) {
				if(Capabilities.manufacturer.indexOf(ID_IOS) > -1)		mDevice = ID_IOS;
				if(Capabilities.manufacturer.indexOf(ID_ANDROID) > -1)	mDevice = ID_ANDROID;
			}
			return mDevice;
		}
		private function get bannersDic():Dictionary
		{
			if (!mBannersDic) mBannersDic = new Dictionary();
			return mBannersDic;
		}
		public function get bannersQuantity():int
		{
			return n;
		}
		public function get testDeviceID():String
		{ return mTestDeviceID; }
		public function get gender():int
		{ return mGender; }
		public function set gender(sex:int):void
		{
			mGender = sex;
			ctx.call(AdMobFunctions.SET_GENDER, mGender);
		}
		public function get birthDay():int
		{ return mBirthDay; }
		public function set birthDay(day:int):void
		{
			mBirthDay = day;
            ctx.call(AdMobFunctions.SET_BIRTHDAY, mBirthDay);
		}
		
		public function get isCDT():Boolean
		{ return mIsCDT; }
		public function set isCDT(val:Boolean):void
		{
			mIsCDT = val;
            ctx.call(AdMobFunctions.SET_CDT, mIsCDT);
		}
        public function AdMobManager()
		{
            ctx.addEventListener(StatusEvent.STATUS, onStatus);
        }
        public function dispose():void{
            mManager = null;
        }
        public function createBanner(adSize:int,adPosition:int,bannerId:String=null,adMobId:String=null,autoShow:Boolean=false):void
		{
			if (adMobId == null) adMobId = bannersAdMobId;
			if (adMobId == null) {
				log(LOG_TAG, "Cannot create the banner, the AdMobId is not set. Please pass an Id during banner creation or set the common Id");
				return;
			}
			validateTestMode();
			var positionType:int = AdMobBanner.POS_RELATIVE;
			var position:Array = new Array(adPosition);
			var banner:AdMobBanner = new AdMobBanner(adSize,positionType,position,bannerId,adMobId,autoShow);
			bannersDic[bannerId] = banner;
            ctx.call(AdMobFunctions.BANNER_CREATE, bannerId, adMobId, adSize, positionType, adPosition);
        }
        public function createBannerAbsolute(adSize:int,posX:Number,posY:Number,bannerId:String=null,adMobId:String=null,autoShow:Boolean=false):void
		{
			if (!adMobId) adMobId = bannersAdMobId;
			if (!adMobId) {
				log(LOG_TAG, "Cannot create the banner, the AdMobId is not set. Please pass an Id during banner creation or set the common Id");
				return;
			}
			var positionType:int = AdMobBanner.POS_ABSOLUTE;
			var position:Array = new Array(posX,posY);
			var banner:AdMobBanner = new AdMobBanner(adSize,positionType,position,bannerId,adMobId,autoShow);
            ctx.call(AdMobFunctions.BANNER_CREATE_ABSOLUTE, bannerId, adMobId, adSize, positionType, posX, posY);
        }
        public function showBanner(bannerId:String):void
		{
			ctx.call(AdMobFunctions.BANNER_SHOW, bannerId);
        }
        public function hideBanner(bannerId:String):void
		{
			ctx.call(AdMobFunctions.BANNER_HIDE,bannerId);
        }
        public function removeBanner(bannerId:String):void
		{
			ctx.call(AdMobFunctions.BANNER_REMOVE,bannerId);
        }
        public function showAllBanner():void
		{
			showBanner(banner.bannerId);
        }
        public function hideAllBanner():void
		{
			hideBanner(banner.bannerId);
        }
        public function removeAllBanner():void
		{
			removeBanner(banner.bannerId);
        }
        public function createInterstitial(adMobId:String=null,autoShow:Boolean=false):void
		{
			validateTestMode();
			mIsInterstitialCreated = true;
			mInterstitialAutoShow = autoShow;
			ctx.call(AdMobFunctions.INTERSTITIAL_CREATE, adMobId);
        }
        public function removeInterstitial():void
		{
			ctx.call(AdMobFunctions.INTERSTITIAL_REMOVE);
        }
        public function cacheInterstitial(adMobId:String=null):void
		{
			ctx.call(AdMobFunctions.INTERSTITIAL_CACHE, adMobId);
        }
        public function isInterstitialLoaded():Boolean
		{
			return ctx.call(AdMobFunctions.INTERSTITIAL_IS_LOADED);
        }
        public function showInterstitial():void
		{
			ctx.call(AdMobFunctions.INTERSTITIAL_SHOW);
        }
		private function onStatus(event:StatusEvent):void
		{
			var e:AdMobEvent = null;
			
			// Swhich according the recieved even level
			switch(event.code)
			{
				case AdMobEvent.BANNER_LOADED:
				{
					e = new AdMobEvent(AdMobEvent.BANNER_LOADED, event.level);
					break;
				}
				case AdMobEvent.BANNER_FAILED_TO_LOAD:
				{
					e = new AdMobEvent(AdMobEvent.BANNER_FAILED_TO_LOAD, event.level);
					break;
				}
				case AdMobEvent.BANNER_LEFT_APPLICATION:
				{
					e = new AdMobEvent(AdMobEvent.BANNER_LEFT_APPLICATION, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_LOADED:
				{
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_LOADED, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_AD_CLOSED:
				{
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_AD_CLOSED, event.level);
					break;
				}
				case AdMobEvent.INTERSTITIAL_LEFT_APPLICATION:
				{
					e = new AdMobEvent(AdMobEvent.INTERSTITIAL_LEFT_APPLICATION, event.level);
					break;
				}
			}
			dispatcher.dispatchEvent(e);
		}		
        private function validateTestMode():void
		{
			if (mTestDeviceID == null) {
				log(LOG_TAG, "IMPORTANT ALLER: You are using the Test mode, however a test device id was not given!");
				log(LOG_TAG, "Please set the proprierty '.testDeviceID' correctly, in the current state google will register the impression done by the device");
				log(LOG_TAG, "and you may risk to have your account banned!");
				return;
			}
			if (mTestDeviceID == "") {
				log(LOG_TAG, "IMPORTANT ALLER: You are using the Test mode, however a test device id is blank!");
				log(LOG_TAG, "Please set the proprierty '.testDeviceID' correctly, in the current state google will register the impression done by the device");
				log(LOG_TAG, "and you may risk to have your account banned!");
				return;
			}
			log(LOG_TAG, "Test Mode correctly running on device: " + mTestDeviceID);
        }
        public function getBannerId():String
		{
			var id:String = generateBannerId();
			return id;
        }
        public function generateBannerId():String
		{
			var id:String = "BannerID";
			var num:int = randomRange(0, 1000000);
			id += num;
			return id;
        }
		private function randomRange(minNum:int, maxNum:int):int
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		private function log(msg:String, ... args):void
		{
			var now:Number = new Date().getTime();
			trace('['+LOG_TAG+ ']',msg, args);
		}
	}
}