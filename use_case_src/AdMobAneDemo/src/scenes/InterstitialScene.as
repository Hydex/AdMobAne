package scenes
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game UI Models Includes
	import models.ui.ConsoleLog;
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.BackButton;
	import models.ui.controls.FuncButton;
	import models.ui.controls.ToggleButton;
	
	// Starling Includes
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.SpriteUtl;
	
	/**
	 * Interstitial Demo Scene Class<br/>
	 * The class will construct and manage the Interstitial Demo Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class InterstitialScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[InterstitialScene] ';
		
		// Console instances
		private var mConsoleLog:ConsoleLog;
		private var mAutoShow:Boolean = false;
		private var mCreateBtn:FuncButton;
		private var mShowBtn:FuncButton;
		private var mDestroyBtn:FuncButton;
		
		// =================================================================================================
		//	Constructors Function
		// =================================================================================================
		
		/** 
		 * Interstitial Demo Scene constructor
		 * 
		 **/
		public function InterstitialScene()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Add loading and unloading event listeners
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		/** 
		 * Event listener for Scene added to stage <br/>
		 *   
		 * @param e Event Object
		 **/
		private function onAddedToStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onAddedToStage");
			
			// Remove unnecessary event listeners
			removeEventListeners(Event.ADDED_TO_STAGE);
			// Init the scene
			init();
		}
		
		/** 
		 * Event listener for Scene removed from stage <br/>
		 *  
		 * @param e Event Object
		 **/
		private function onRemovedFromStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onRemovedFromStage");
			
			// Remove all the event listeners
			removeAdEventsListeners();
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Interstitial Demo Scene
		 *   
		 **/
		private function init():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Initializing...");
			
			// Add the Scene Background
			var sceneBackground:SceneBackground = new SceneBackground();
			addChild(sceneBackground);
			
			// Add the Scene Header
			var sceneHeader:SceneHeader = new SceneHeader();
			addChild(sceneHeader);
			
			// Add the Back Button
			var BackBtn:BackButton = new BackButton(onBack);
			addChild(BackBtn);
			
			// Add the Back Button
			mConsoleLog = new ConsoleLog();
			addChild(mConsoleLog);
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_SUPPORT)+AdsManager.isSupported);

			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.activateAppBanner();
			
			// Add the Scene Context
			var mainConsole:Sprite = createMainConsole();
			SpriteUtl.setPivot(mainConsole,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mainConsole,Constants.STAGE_WIDTH/2,Constants.STAGE_HEIGHT*0.7,false);
			addChild(mainConsole);
			
			// Add the Ad Event Lsteners
			addAdEventsListeners();
		}
		
		/** 
		 * Create the Scene main Console
		 *   
		 * @return Main console Sprite instance
		 **/
		private function createMainConsole():Sprite
		{
			// Debug Logger
			Root.log(LOG_TAG,"createMainConsole");
			
			// Console proprierty
			var container:Sprite = new Sprite();
			
			// Create the console frame
			var cFrame:Quad = new Quad(540/2,230/2);
			cFrame.alpha = 0;
			container.addChild(cFrame);
			
			// Create the Autoshow Option Toggle
			var autoShowToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_AUTOSHOW), mAutoShow,toggleAutoShow);
			SpriteUtl.setPivot(autoShowToggle,SpriteUtl.TOP);
			SpriteUtl.setPosition(autoShowToggle,cFrame.width/2,0,false);
			container.addChild(autoShowToggle);
			
			// Create the Create Interstitial button
			mCreateBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_CREATE),onCreate);
			SpriteUtl.setPosition(mCreateBtn,76,153);
			mCreateBtn.enabled = AdsManager.isSupported;
			container.addChild(mCreateBtn);
			
			// Create the Create Interstitial button
			mShowBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_SHOW),onShow);
			SpriteUtl.setPosition(mShowBtn,272,153);
			mShowBtn.enabled = false;
			container.addChild(mShowBtn);
			
			// Create the Create Interstitial button
			mDestroyBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_DESTROY),onDestroy);
			SpriteUtl.setPosition(mDestroyBtn,468,153);
			mDestroyBtn.enabled = false;
			container.addChild(mDestroyBtn);
			
			// Return the Container
			return container;
		}
		
		// =================================================================================================
		//	Console Function
		// =================================================================================================

		/** 
		 * Event listener for Auto Show Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleAutoShow(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"AutoShow toggle:", toggle);
			// Update setting value
			mAutoShow = toggle;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_AUTOSHOW_ENABLE)+mAutoShow);
		}
		
		/** 
		 * Event listener for onCreate Button
		 * Create the Interstitial
		 * 
		 **/
		private function onCreate():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onCreate");
			// Call Native Function
			AdsManager.createInterstitial(mAutoShow);
			// Update Console
			mCreateBtn.enabled = false;
		}
		
		/** 
		 * Event listener for onShow Button
		 * Show the Interstitial
		 * 
		 **/
		private function onShow():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onShow");
			// Call Native Function
			AdsManager.showInterstitial();
			// Update Console
			mCreateBtn.enabled = false;
			mShowBtn.enabled = false;
			mDestroyBtn.enabled = true;
		}
		
		/** 
		 * Event listener for onDestroy Button
		 * Destroy the Interstitial
		 * 
		 **/
		private function onDestroy():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onDestroy");
			// Call Native Function
			AdsManager.removeInterstitial();
			// Update Console
			mCreateBtn.enabled = true;
			mShowBtn.enabled = false;
			mDestroyBtn.enabled = false;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_INTER_DESTROY));
		}

		/** 
		 * Event listener for onBack Button
		 * Destroy the Interstitial
		 * 
		 **/
		private function onBack():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBack");
			
			// Remove the Interstitial if exist
			AdsManager.removeInterstitial();
			
			// Dispatch Scene Change Event
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
		}
		
		// =================================================================================================
		//	Events Functions
		// =================================================================================================
		
		/** 
		 * Add the Interstitial events Listeners
		 * 
		 */
		private function addAdEventsListeners():void
		{
			AdsManager.dispatcher.addEventListener(AdMobEvent.INTERSTITIAL_LOADED, onInterstitialLoaded);
			AdsManager.dispatcher.addEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD, onInterstitialFailedToLoad);
			AdsManager.dispatcher.addEventListener(AdMobEvent.INTERSTITIAL_AD_CLOSED, onInterstitialAdClosed);
		}
		
		/** 
		 * Remove the Interstitial events Listeners
		 * 
		 */
		private function removeAdEventsListeners():void
		{
			AdsManager.dispatcher.removeEventListener(AdMobEvent.INTERSTITIAL_LOADED, onInterstitialLoaded);
			AdsManager.dispatcher.removeEventListener(AdMobEvent.INTERSTITIAL_FAILED_TO_LOAD, onInterstitialFailedToLoad);
			AdsManager.dispatcher.removeEventListener(AdMobEvent.INTERSTITIAL_AD_CLOSED, onInterstitialAdClosed);
		}
		
		/**
		 * onInterstitialLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onInterstitialLoaded(e:AdMobEvent):void
		{
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_INTER_LOADED));
			// Update Console
			mShowBtn.enabled = true;
			mDestroyBtn.enabled = true;
		}
		
		/**
		 * onInterstitialFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onInterstitialFailedToLoad(e:AdMobEvent):void
		{
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_INTER_FAILED),ConsoleLog.ERROR);
			// Update Console
			mShowBtn.enabled = false;
			mDestroyBtn.enabled = true;
		}
		
		/**
		 * onInterstitialAdClosed Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onInterstitialAdClosed(e:AdMobEvent):void
		{
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_INTER_CLOSE));
			AdsManager.removeInterstitial();
			// Update Console
			mCreateBtn.enabled = true;
			mShowBtn.enabled = false;
			mDestroyBtn.enabled = false;
		}
	}
}