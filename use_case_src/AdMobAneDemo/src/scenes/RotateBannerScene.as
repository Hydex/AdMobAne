package scenes
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Feathers Includes
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	
	// Game UI Models Includes
	import models.ui.PopUp;
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.BackButton;
	import models.ui.controls.FuncButton;
	import models.ui.controls.ToggleButton;
	
	// Starling Includes
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.SpriteUtl;
	
	/**
	 * Rotate Banner Demo Scene Class<br/>
	 * The class will construct and manage the Rotate Banner Demo Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class RotateBannerScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[RotateBannerScene] ';
		
		// Unique banner id for the sigle banner demo
		private const BANNERID:String ='DemoRotateBanner';
		
		// Amount of banner movement (in degree)
		private const MANUAL_MOVEMENT:Number = 10;
		
		// Banner Animation Constatns
		private const ANIMATION_MOVEMENT:Number = 2.5; // Amunt of rotation
		private const ANIMATION_SPEED:Number = 0.1; // amount of time in wich the banner is rotated
		
		// Console instances
		private var mConsole:Sprite;
		private var mAnimate:Boolean = false;
		private var mAnimateToggle:ToggleButton;
		private var mUpBtn:FuncButton;
		private var mDownBtn:FuncButton;
		private var mScenePopUp:PopUp;
		
		// Benner movement Instances
		private var mRotation:Number;
		
		// Benner Animation Instances
		private var mBannerAni:IAnimatable;		
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Rotate Banner Demo Scene constructor
		 * 
		 **/
		public function RotateBannerScene()
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
			
			// Restore Feathers defaultTextRendererFactory
			/* This because it was changed on combobox control which is use in this scene,
			If we dont restore it the render of any Feathers related control/class will be compromised.
			(For example the Credit scene)
			*/
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{ return new BitmapFontTextRenderer() }
			
			// Rest the Banner
			resetBanner();
			
			// Remove all the event listeners
			removeAdEventsListeners();
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Single Banner Demo Scene
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
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.disposeAppBanner();
			
			// Add the Scene Context
			createMainConsole();
			SpriteUtl.setPivot(mConsole,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mConsole,Constants.STAGE_WIDTH/2,Constants.STAGE_HEIGHT*0.7,false);
			addChild(mConsole);
			
			// Add the Ad Event Lsteners
			addAdEventsListeners();
			
			// Add the essage popups
			if(!AdsManager.isSupported || !AdsManager.hasConnection){
				// Create the game rules popup
				mScenePopUp = new PopUp(Root.getMsg(Constants.MSG_NODEMO),onNoDemo);
				addChild(mScenePopUp);
			}else{
				// Create the Loading popup (mostly used for the Interstitial loading time)
				mScenePopUp = new PopUp(Root.getMsg(Constants.MSG_LOADING),null,false);
				addChild(mScenePopUp);
			}
			// disable the Console
			disableConsole();
			
			// Create the banner
			AdsManager.createBanner(AdMobSize.BANNER,AdMobPosition.MIDDLE_CENTER,BANNERID,true);
			// Init default rotation
			mRotation = 0;
		}
		
		/** 
		 * Create the Scene main Console
		 *   
		 **/
		private function createMainConsole():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createMainConsole");
			
			// Console proprierty
			mConsole = new Sprite();
			
			// Create the console frame
			var cFrame:Quad = new Quad(270,115);
			cFrame.alpha = 0;
			mConsole.addChild(cFrame);
			
			// Create the Rotate Banner Down button
			mDownBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_DEC),onDown);
			SpriteUtl.setPivot(mDownBtn,SpriteUtl.LEFT);
			SpriteUtl.setPosition(mDownBtn,0,cFrame.height/2,false);
			mConsole.addChild(mDownBtn);
			
			// Create the Rotate Banner Up button
			mUpBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_INC),onUp);
			SpriteUtl.setPivot(mUpBtn,SpriteUtl.RIGHT);
			SpriteUtl.setPosition(mUpBtn,cFrame.width,cFrame.height/2,false);
			mConsole.addChild(mUpBtn);
			
			// Create the Animate Option Toggle
			mAnimateToggle = new ToggleButton(Root.getMsg(Constants.MSG_ANIMATE), mAnimate,toggleAnimate);
			SpriteUtl.setPivot(mAnimateToggle,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mAnimateToggle,cFrame.width/2,cFrame.height/2,false);
			mConsole.addChild(mAnimateToggle);
		}
		
		/** 
		 * Enable the console
		 * 
		 **/
		private function enableConsole():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"enableConsole");
			// Enable all buttons
			mAnimateToggle.enable	= true;
			mUpBtn.enabled			= true;
			mDownBtn.enabled		= true;
		}
		
		/** 
		 * Disable the console
		 * 
		 **/
		private function disableConsole():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"disableConsole");
			// Disable all buttons
			mAnimateToggle.enable	= false;
			mUpBtn.enabled			= false;
			mDownBtn.enabled		= false;
		}
		
		/** 
		 * Animate the banner
		 * 
		 **/
		private function animateBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"animateBanner");
			
			// Create the new Banner Animation
			mBannerAni = Starling.juggler.repeatCall(onProgress,ANIMATION_SPEED);
			
			// On Animation Progress Function
			function onProgress():void
			{
				mRotation += ANIMATION_MOVEMENT;
				AdsManager.rotateBanner(BANNERID,mRotation);
			}
		}
		
		/** 
		 * Reset the banner after animation
		 * 
		 **/
		private function resetBanner():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"resetBanner");
			
			// Stop the Juggler Animation (if we have it)
			if (mBannerAni != null){
				Starling.juggler.remove(mBannerAni);
				mBannerAni = null;
			}
			
			// Back to original position
			mRotation = 0;
			
			// Rotate the banner to the original position
			AdsManager.rotateBanner(BANNERID,mRotation);
		}
		
		// =================================================================================================
		//	Console Functions
		// =================================================================================================
		
		/** 
		 * Event listener for on no demo condition
		 * 
		 * @param toggle New Toggle state
		 **/
		private function onNoDemo():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onNoDemo");
			// Dispatch The Scene Change Event for refresh the current scene
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
		}
		
		/** 
		 * Event listener for Animate Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleAnimate(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Animate toggle:", toggle);
			// Update setting value
			mAnimate = toggle;
			// Update the console acording to the togge value
			if(mAnimate){
				// Before start the animation reset the position of the banner
				resetBanner();
				// Disable the manual movement console during animation
				disableConsole();
				animateBanner();
			}else{
				// Enable the manual movement console during animation
				enableConsole();
				resetBanner();
			}
			// The toggle is always enable
			mAnimateToggle.enable = true;
		}
		
		/** 
		 * Event listener for onUp Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function onUp():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onUp");
			// Rotate the banner
			mRotation += MANUAL_MOVEMENT;
			AdsManager.rotateBanner(BANNERID,mRotation);
		}
		
		/** 
		 * Event listener for onDown Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function onDown():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onDown");
			
			// Rotate the banner
			mRotation -= MANUAL_MOVEMENT;
			AdsManager.rotateBanner(BANNERID,mRotation);
		}
		
		/** 
		 * Event listener for onBack Button
		 * Destroy all Banners
		 * 
		 **/
		private function onBack():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBack");
			
			// Remove all existing banners
			AdsManager.removeAllBanners();
			
			// Dispatch Scene Change Event
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
		}
		
		// =================================================================================================
		//	Events Functions
		// =================================================================================================
		
		/** 
		 * Add the Banner events Listeners
		 * 
		 */
		private function addAdEventsListeners():void
		{
			AdsManager.dispatcher.addEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			AdsManager.dispatcher.addEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		/** 
		 * Remove the Banner events Listeners
		 * 
		 */
		private function removeAdEventsListeners():void
		{
			AdsManager.dispatcher.removeEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			AdsManager.dispatcher.removeEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		/**
		 * onBannerLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerLoaded(e:AdMobEvent):void
		{
			// Update the current banner rotation
			mRotation = 0;

			// Dispose the popup
			if (mScenePopUp)mScenePopUp.removeFromParent(true);
			// Enable the Console
			enableConsole();
		}
		
		/**
		 * onBannerFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerFailedToLoad(e:AdMobEvent):void
		{
			// Dispose the popup if already exist
			if (mScenePopUp)mScenePopUp.removeFromParent(true);
			// Create the game rules popup
			mScenePopUp = new PopUp(Root.getMsg(Constants.MSG_NODEMO),onNoDemo);
			addChild(mScenePopUp);
		}
	}
}