package utils
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	import com.codealchemy.ane.admobane.AdMobManager;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	import com.codealchemy.ane.admobane.AdSize;
	import com.codealchemy.ane.admobane.ScreenSize;
	
	// Flash Includes
	import flash.events.EventDispatcher;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	/**
	 * AdsManager Class<br/>
	 * The class will construct and manage the adMob ANE Extension
	 * 
	 * @author Code Alchemy
	 **/
	public class AdsManager
	{
		// Tag Constant for log
		static private const LOG_TAG:String			= "[AdsManager] ";
		
		// Tag Constant for log
		static private const APP_BANNER:String		='AppBanner';
		
		// Ad Properties
		static private var mAdMobManager:AdMobManager;
		// Network Status Monitor Instance
		static private var mNetStatusMonitor:NetStatusMonitor;
		// Network Connection state
		static public var hasConnection:Boolean;

		// Offline Banner Instance
		static private var mOfflineBanner:Sprite;
		
		// Banner States Constants
		static private const AD_NONE:uint			= 0;
		static private const AD_LOAD:uint			= 1;
		static private const AD_ERROR:uint			= 2;
		static private const AD_SHOW:uint			= 3;
		static private const AD_HIDE:uint			= 4;
		
		// Application Banner State Instance
		static private var appBannerState:uint		= AD_NONE;
		// Application banner loading management
		static private var willShow:Boolean			= true;
		
		// =================================================================================================
		//	Getters/Setters
		// =================================================================================================
		
		/**
		 * AdsManager instance
		 **/
		static private function get adMobManager():AdMobManager
		{ return mAdMobManager; }
		
		/**
		 * Extension event dispatcher instance
		 **/
		static public function get dispatcher():EventDispatcher
		{ return adMobManager.dispatcher; }
		
		/**
		 * Offline Banner instance
		 **/
		static public function get offlineBanner():Sprite
		{ return mOfflineBanner; }
		
		/**
		 * Is Supported state
		 **/
		static public function get isSupported():Boolean
		{
			// Check if the device is iOS
			if(adMobManager.isSupported) return true;
			// Return false if it is not
			return false;
		}
		
		/**
		 * Is iOS state
		 **/
		static private function get isIOS():Boolean
		{
			// Check if the device is iOS
			if(adMobManager.device == AdMobManager.IOS) return true;
			// Return false if it is not
			return false;
		}
		
		// =================================================================================================
		//	Constructor / Deconstructors
		// =================================================================================================
		
		/** 
		 * Manager initializer
		 * If a context is not available a new context will be created
		 * 
		 * @param testMode true if test mode, false if production mode. Optional, Default = true
		 * @param verbose When activated, the class will trace information about the operation. Optional, Default = true
		 */
		static public function init(testMode:Boolean = true, verbose:Boolean = true):void
		{
			// get the manager instance
			mAdMobManager = AdMobManager.manager;
			// Initialize the ANE Extension if it is supported
			if(adMobManager.isSupported){
				// Create the Network Status Monitor
				mNetStatusMonitor = new NetStatusMonitor();
				// Add network State Change listener
				mNetStatusMonitor.addEventListener(NetStatusMonitorEvent.NETWORK_STATUS_CHANGED, onNetworkChanged);
				// Check the current connection state
				mNetStatusMonitor.checkConnection();
				
				// Set The Rendering Mode (Android Only)
				//adMobManager.renderLayerType = AdMobManager.RENDER_TYPE_NONE;
				//adMobManager.renderLayerType = AdMobManager.RENDER_TYPE_SOFTWARE;
				adMobManager.renderLayerType = AdMobManager.RENDER_TYPE_HARDWARE;
				
				// Set te vebose mode
				adMobManager.verbose = verbose;
				// Set Operation mode
				if (testMode)	adMobManager.operationMode = AdMobManager.TEST_MODE;
				else			adMobManager.operationMode = AdMobManager.PROD_MODE;
				
				// Set AdMobId settings
				if (isIOS){
					adMobManager.testDeviceID			= Constants.ADMOB_TEST_ID_IOS;
					adMobManager.bannersAdMobId			= Constants.ADMOB_BANNER_IOS;
					adMobManager.interstitialAdMobId	= Constants.ADMOB_INTERSTITIAL_IOS;
				}else{
					adMobManager.testDeviceID			= Constants.ADMOB_TEST_ID_AND;
					adMobManager.bannersAdMobId			= Constants.ADMOB_BANNER_AND;
					adMobManager.interstitialAdMobId	= Constants.ADMOB_INTERSTITIAL_AND;
				}
				
				// Create the Offline Banner for no connection (even if we have connection, is just for pre-creation)
				createOfflineBanner();
				// Add the event listeners
				addEventsListeners();
			}else{
				// Create the Offline Banner for unsupported Extension
				createOfflineBanner(true);
				//showOfflineBanner(true);
				Root.log(LOG_TAG,"AdMob Is not Supported");
			}
		}
		
		/** 
		 * Get the Screen Native Dimensions
		 * 
		 * @return Screen Dimension Object. Null if the given size is incorrect
		 */
		static public function getScreenSize():ScreenSize
		{
			// Debug Logger
			Root.log(LOG_TAG,"getScreenSize");
			
			var size:ScreenSize;
			// Call the native method
			if(adMobManager.isSupported)
				size = adMobManager.getScreenSize();
			// Retrn the recieved size
			return size;
		}
		
		// =================================================================================================
		//	Application Banners Methods
		// =================================================================================================
		
		/** 
		 * Activate the Application banner
		 * The result should be a visible banner.
		 * The function will consider any application state for show the banner
		 * or an Offline Banner
		 * 
		 */
		static public function activateAppBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"activateAppBanner");
			// Check if the Extension is supported
			if(adMobManager.isSupported){
				// Check we have internet connection
				if(hasConnection){
					// In which state our banner is?
					if (appBannerState == AD_NONE){
						// Update the showing state
						willShow = true;
						// Create the Banner and udate its state
						createBanner(AdMobSize.SMART_BANNER,AdMobPosition.BOTTOM_CENTER,APP_BANNER);
						appBannerState = AD_LOAD;
						// Note: I coud have used autoshow here, however for the app banner i do prefer to manage it manually on the load event
						// since we may call activate and deactivate repeatatly (that's why willShow state)
					}else if (appBannerState == AD_LOAD){
						// If is already loading, lets update the state for be certain it will show up (in case also the deactivate method)
						// Was called while loading
						// Update the showing state
						willShow = true;
					}else if (appBannerState == AD_ERROR){
						// If the banner is in error state better dispose of it and recreate it.
						disposeAppBanner();
						// Update the showing state
						willShow = true;
						// Create the Banner and udate its state
						createBanner(AdMobSize.SMART_BANNER,AdMobPosition.BOTTOM_CENTER,APP_BANNER);
						appBannerState = AD_LOAD;
						// Note: I coud have used autoshow here, however for the app banner i do prefer to manage it manually on the load event
						// since we may call activate and deactivate repeatatly (that's why willShow state)
					}else if (appBannerState == AD_HIDE){
						// Remove the offline banner (if any)
						hideOfflineBanner();
						// Show the Banner and update the state
						showBanner(APP_BANNER);
						appBannerState = AD_SHOW;
					}else if (appBannerState == AD_SHOW){
						// If the banner is already visible, then nothing to do...						
					}
				}else{
					// If we don't have connection dispose of the banner just in case (if the banner do not exist yet the ANE will handle the issue)
					disposeAppBanner();
					// Add the offline banner
					showOfflineBanner();
				}
			}else{
				// Debug Logger
				Root.log(LOG_TAG,"AdMob Is not Supported");
				// Add the offline banner
				showOfflineBanner();
			}
		}
		
		/** 
		 * Deactivate the Application banner
		 * 
		 */
		static public function deativateAppBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"deativateAppBanner");
			// Check if the Extension is supported
			if(adMobManager.isSupported){
				// Check we have internet connection
				if(hasConnection){
					// In which state our banner is?
					if (appBannerState == AD_NONE){
						// No banner? then nothing to do...
					}else if (appBannerState == AD_LOAD){
						// If the banner is loading we may want to eep it loading without showing it.
						// Update the showing state so once loaded will stay hidden ()
						willShow = false;
					}else if (appBannerState == AD_ERROR){
						// If the banner is in error state better just dispose of it
						disposeAppBanner();
					}else if (appBannerState == AD_HIDE){
						// If the banner is already hidden, then nothing to do...						
					}else if (appBannerState == AD_SHOW){
						// Hide the Banner and update the state
						hideBanner(APP_BANNER);
						appBannerState = AD_HIDE;
					}
				}else{
					// If we don't have connection dispose of the banner just in case (if the banner do not exist yet the ANE will handle the issue)
					disposeAppBanner();
					// Add the offline banner
					showOfflineBanner();
				}
			}else{
				// Debug Logger
				Root.log(LOG_TAG,"AdMob Is not Supported");
				// Add the offline banner
				showOfflineBanner();
			}
		}
		
		/** 
		 * Dispose the Application Banner
		 * 
		 */
		static public function disposeAppBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"disposeAppBanner");
			// Remove the Banner and udate its state
			removeBanner(APP_BANNER);
			appBannerState = AD_NONE;
		}
		
		/** 
		 * Create the Offline Banner
		 * 
		 * @param unsupported if true the banner willl show the message ANE unsupported, if false will show the message no connection<br>
		 * Optional, Default = false
		 */
		static private function createOfflineBanner(unsupported:Boolean = false):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createOfflineBanner");
			
			// Create the new Instance
			mOfflineBanner = new Sprite();
			// Banner Y Position
			const posY:uint = Constants.STAGE_HEIGHT-25;
			
			// Create the Ad Frame
			var adFrame:Image = new Image(Root.assets.getTexture(Constants.IMG_AD_FRAME));
			mOfflineBanner.addChild(adFrame);
			
			// Create the Offline Banner Text
			var msgID:String = Constants.MSG_NO_INTERNET;
			if(unsupported) msgID = Constants.MSG_UNSUPPORTED;
			var adsText:TextField = new TextField(adFrame.width-10, adFrame.height, Root.getMsg(msgID));
			adsText.fontName = Constants.FONT_NAME;
			adsText.fontSize = Constants.FONT_SIZE_BIG;
			adsText.color = Constants.COL_FONT_LIGHT;
			adsText.hAlign = HAlign.CENTER;
			adsText.autoScale = true;
			SpriteUtl.setPivot(adsText, SpriteUtl.CENTER);
			SpriteUtl.setPosition(adsText, adFrame.width/2, adFrame.height/2, false);
			mOfflineBanner.addChild(adsText);
			
			// Set Offline Ad Position			
			SpriteUtl.setPivot(mOfflineBanner,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mOfflineBanner,Constants.STAGE_WIDTH/2,Constants.STAGE_HEIGHT-25,false);
			
			// Disable Interaction
			mOfflineBanner.touchable = false;
			// Set the banner visibility. If the extension is unsupported, then it will be always visible
			// In the case of no connection the visibility will be set by the network event
			mOfflineBanner.visible = unsupported;
		}
		
		/** 
		 * Add the Offline Banner
		 * 
		 */
		static private function showOfflineBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"showOfflineBanner");
			
			// Set offline banner visibility
			mOfflineBanner.visible = true;
		}
		
		/** 
		 * Remove the Offline Banner
		 * 
		 */
		static private function hideOfflineBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"hideOfflineBanner");
			
			// Set offline banner visibility
			mOfflineBanner.visible = false;
		}
		
		/** 
		 * onNetworkChanged Event Listener
		 * Switch from online banner and offline banner according to the network state
		 * 
		 */
		static private function onNetworkChanged(e:NetStatusMonitorEvent):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onNetworkChanged");
			
			// Update the Connection state
			hasConnection = e.state;
			
			// Check the resulted state
			if(hasConnection){
				// We have internet!
				activateAppBanner();
			}else{
				// We don't have internet :(
				deativateAppBanner();
			}
		}
		
		// =================================================================================================
		//	Banners Methods
		// =================================================================================================
		
		/** 
		 * Get the Banner Dimension (Base Dimensions) For measure already created banners use getExistingBannerSize instead.
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * 
		 * @return Banner Dimension Object. Null if the given size is incorrect
		 */
		static public function getBannerSize(adSize:int):AdSize
		{
			// Debug Logger
			Root.log(LOG_TAG,"getBannerSize");
			
			var size:AdSize;
			// Create the Banner
			if(adMobManager.isSupported)
				size = adMobManager.getBannerSize(adSize);
			
			return size;
		}
		
		/** 
		 * Get the Banner Dimension for an existing Banner For get the standard banner size use getBannerSize instead.
		 * 
		 * @param bannerId Unique Banner Id identifier
		 * 
		 * @return Banner Dimension Object. Null if the given banner is incorrect
		 */
		static public function getExistingBannerSize(bannerId:String):AdSize
		{
			// Debug Logger
			Root.log(LOG_TAG,"getExistingBannerSize");
			
			var size:AdSize;
			// Create the Banner
			if(adMobManager.isSupported)
				size = adMobManager.getExistingBannerSize(bannerId);
			
			return size;
		}
		
		/** 
		 * Create the adMob Banner in a given relative position<br/>
		 * @see AdmobPosition
		 * @see AdMobSize
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * @param adPosition Banner Position to be used
		 * @param bannerId Unique Banner Id identifier
		 * @param autoShow Automatic visualization. Optional, Default = false<br/>
		 */
		static public function createBanner(adSize:int,adPosition:int,bannerId:String,autoShow:Boolean=false):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createBanner");
			
			// Create the Banner
			if(adMobManager.isSupported)
				adMobManager.createBanner(adSize,adPosition,bannerId,null,autoShow);
		}
		
		/** 
		 * Create the adMob Banner in a given absolute position
		 * 
		 * @param adSize Banner AdmobSize to be used
		 * @param posX Banner x coordinate Position
		 * @param posY Banner y coordinate Position
		 * @param bannerId Unique Banner Id identifier
		 * @param autoShow Automatic visualization. Optional, Default = false<br/>
		 */
		static public function createBannerAbsolute(adSize:int,posX:Number,posY:Number,bannerId:String,autoShow:Boolean=false):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createBanner");
			
			// Create the Banner
			if(adMobManager.isSupported)
				adMobManager.createBannerAbsolute(adSize,posX,posY,bannerId,null,autoShow);
		}
		
		/**
		 * Move the Banner
		 * 
		 * @param posX Banner x coordinate Position
		 * @param posY Banner y coordinate Position
		 */
		static public function moveBanner(bannerId:String,posX:Number,posY:Number):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"moveBanner");
			
			// Show the Banner
			if(adMobManager.isSupported) adMobManager.moveBanner(bannerId,posX,posY);
		}
		
		/**
		 * Rotate the Banner
		 * 
		 * @param angle Angle in degrees in which the must must be rotated
		 */
		static public function rotateBanner(bannerId:String,angle:Number):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"rotateBanner");
			
			// Show the Banner
			if(adMobManager.isSupported) adMobManager.rotateBanner(bannerId,angle);
		}
		
		/**
		 * Show the Banner
		 * 
		 * @param adId Banner Unique Id
		 */
		static public function showBanner(adId:String):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"showBanner");
			
			// Show the Banner
			if(adMobManager.isSupported) adMobManager.showBanner(adId);
		}
		
		/**
		 * Hide the Banner
		 * 
		 * @param adId Banner Unique Id
		 */
		static public function hideBanner(adId:String):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"hideBanner");

			// Hide the Banner
			if(adMobManager.isSupported) adMobManager.hideBanner(adId);
		}
		
		/**
		 * Remove the Banner
		 * 
		 * @param adId Banner Unique Id
		 */
		static public function removeBanner(adId:String):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"removeBanner");

			// Destroy the Banner
			if(adMobManager.isSupported) adMobManager.removeBanner(adId);
		}

		/** 
		 * Show all existing Banners
		 */
		static public function showAllBanners():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"showAllBanners");
			// Show all the Banners
			if(adMobManager.isSupported) adMobManager.showAllBanner();
		}
		
		/** 
		 * Hide all existing Banners
		 */
		static public function hideAllBanners():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"hideAllBanners");

			// Hide all the Banners
			if(adMobManager.isSupported) adMobManager.hideAllBanner();
		}
		
		/** 
		 * Remove all existing Banners
		 */
		static public function removeAllBanners():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"removeAllBanners");
			
			// Remove all the Banners
			if(adMobManager.isSupported) adMobManager.removeAllBanner();
		}

		// =================================================================================================
		//	Interstitial Methods
		// =================================================================================================

		/** 
		 * Create the Interstitial Ad
		 */
		static public function createInterstitial(autoshow:Boolean = true):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createInterstitial");

			// Create the Interstitial
			if(adMobManager.isSupported) adMobManager.createInterstitial(null,autoshow);
		}
		
		/** 
		 * Show the Interstitial Ad
		 * 
		 */
		static public function showInterstitial():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"showInterstitial");

			// Show the Interstitial
			if(adMobManager.isSupported) adMobManager.showInterstitial();
		}
		
		/** 
		 * Remove the Interstitial Ad
		 * 
		 */
		static public function removeInterstitial():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"removeInterstitial");

			// Remove the Interstitial
			if(adMobManager.isSupported) adMobManager.removeInterstitial();
		}
		
		// =================================================================================================
		//	Events Management
		// =================================================================================================
		
		/** 
		 * Add all the event Listeners
		 * 
		 */
		static private function addEventsListeners():void
		{
			// onBannerLoaded Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.BANNER_LOADED))
				dispatcher.addEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			
			// onBannerFailedToLoad Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD))
				dispatcher.addEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
			
			// onInterstitialLoaded Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.INTERSTITIAL_LOADED))
				dispatcher.addEventListener(AdMobEvent.INTERSTITIAL_LOADED, onInterstitialLoaded);
			
			// onInterstitialFailedToLoad Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD))
				dispatcher.addEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD, onInterstitialFailedToLoad);
		}
		
		/** 
		 * Remove all the event Listeners
		 * 
		 */
		static private function removeEventsListeners():void
		{
			// onBannerLoaded Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.BANNER_LOADED))
				dispatcher.removeEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			
			// onBannerFailedToLoad Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD))
				dispatcher.removeEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
			
			// onInterstitialLoaded Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.INTERSTITIAL_LOADED))
				dispatcher.removeEventListener(AdMobEvent.INTERSTITIAL_LOADED, onInterstitialLoaded);
			
			// onInterstitialFailedToLoad Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD))
				dispatcher.removeEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD, onInterstitialFailedToLoad);
		}
		
		/**
		 * onBannerLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		static private function onBannerLoaded(e:AdMobEvent):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBannerLoaded");
			
			// Check if the event was trigged by the AppBanner
			if(e.data == APP_BANNER){
				// Remove the offline banner (if any)
				hideOfflineBanner();
				// can we show the banner?
				if(willShow){
					// Show the Banner and update the state
					showBanner(APP_BANNER);
					appBannerState = AD_SHOW;
				}else{
					// Update the state
					appBannerState = AD_HIDE;
				}
			}
		}
		
		/**
		 * onBannerFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		static private function onBannerFailedToLoad(e:AdMobEvent):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBannerFailedToLoad");
			
			// Check if the event was trigged by the AppBanner
			if(e.data == APP_BANNER){
				// Remove the offline banner (if any)
				hideOfflineBanner();
				// Update the state
				appBannerState = AD_ERROR;
			}
		}
		
		/**
		 * onInterstitialLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		static private function onInterstitialLoaded(e:AdMobEvent):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onInterstitialLoaded");
		}
		
		/**
		 * onInterstitialFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		static private function onInterstitialFailedToLoad(e:AdMobEvent):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onInterstitialFailedToLoad");
		}
	}
}