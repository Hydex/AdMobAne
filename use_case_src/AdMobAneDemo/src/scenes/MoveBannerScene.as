package scenes
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	import com.codealchemy.ane.admobane.AdSize;
	import com.codealchemy.ane.admobane.ScreenSize;
	
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
	 * Move Banner Demo Scene Class<br/>
	 * The class will construct and manage the Move Banner Demo Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class MoveBannerScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[MoveBannerScene] ';
		
		// Unique banner id for the sigle banner demo
		private const BANNERID:String ='DemoMoveBanner';

		// Amount of banner movement (in Pixel)
		private const MANUAL_MOVE_SIZE:Number = 10;
		
		// Banner Animation Constatns
		private const ANIMATION_MOVEMENT:Number = 5; // Amunt of movement
		private const ANIMATION_SPEED:Number = 0.1; // amount of time in wich the banner is moved
		
		// Console instances
		private var mConsole:Sprite;
		private var mAnimate:Boolean = false;
		private var mAnimateToggle:ToggleButton;
		private var mUpBtn:FuncButton;
		private var mDownBtn:FuncButton;
		private var mLeftBtn:FuncButton;
		private var mRightBtn:FuncButton;
		private var mScenePopUp:PopUp;
		
		// Dimension instances
		private var mScreenSize:ScreenSize;
		private var mBannerSize:AdSize;
		
		// Benner movement Instances
		private var mOriX:Number;
		private var mOriY:Number;
		private var mCurrX:Number;
		private var mCurrY:Number;
		private var mMaxX:Number;
		private var mMaxY:Number;
		private var mIsIncreasingX:Boolean=true;
		private var mIsIncreasingY:Boolean=true;
		
		// Benner Animation Instances
		private var mBannerAni:IAnimatable;		
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * move Banner Demo Scene constructor
		 * 
		 **/
		public function MoveBannerScene()
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
			
			// Update the screens Size
			mScreenSize =  AdsManager.getScreenSize();
			
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
			
			// Create the Move Banner Up button
			mUpBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_UP),onUp);
			SpriteUtl.setPivot(mUpBtn,SpriteUtl.TOP);
			SpriteUtl.setPosition(mUpBtn,cFrame.width/2,0,false);
			mConsole.addChild(mUpBtn);
			
			// Create the Move Banner Down button
			mDownBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_DOWN),onDown);
			SpriteUtl.setPivot(mDownBtn,SpriteUtl.BOTTOM);
			SpriteUtl.setPosition(mDownBtn,cFrame.width/2,cFrame.height,false);
			mConsole.addChild(mDownBtn);
			
			// Create the Move Banner Left button
			mLeftBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_LEFT),onLeft);
			SpriteUtl.setPivot(mLeftBtn,SpriteUtl.LEFT);
			SpriteUtl.setPosition(mLeftBtn,0,cFrame.height/2,false);
			mConsole.addChild(mLeftBtn);
			
			// Create the Move Banner Right button
			mRightBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_RIGHT),onRight);
			SpriteUtl.setPivot(mRightBtn,SpriteUtl.RIGHT);
			SpriteUtl.setPosition(mRightBtn,cFrame.width,cFrame.height/2,false);
			mConsole.addChild(mRightBtn);
			
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
			mLeftBtn.enabled		= true;
			mRightBtn.enabled		= true;
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
			mLeftBtn.enabled		= false;
			mRightBtn.enabled		= false;
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
				// Can we go down or Up?
				if (mIsIncreasingY){
					// Going Down...
					mCurrY += ANIMATION_MOVEMENT;
					// We will need to change vertical direction after?
					if(mCurrY>=mMaxY) mIsIncreasingY = false;
				}else{
					// Going Up...
					mCurrY -= ANIMATION_MOVEMENT;
					// We will need to change vertical direction after?
					if(mCurrY<=0) mIsIncreasingY = true;
				}
				
				// Can we go left or Right?
				if (mIsIncreasingX){
					// Going Left...
					mCurrX += ANIMATION_MOVEMENT;
					// We will need to change vertical direction after?
					if(mCurrX>=mMaxX) mIsIncreasingX = false;
				}else{
					// Going Right...
					mCurrX -= ANIMATION_MOVEMENT;
					// We will need to change vertical direction after?
					if(mCurrX<=0) mIsIncreasingX = true;
				}

				// Move the banner to the new position
				AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
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
			mCurrX = mOriX;
			mCurrY = mOriY;
			
			// Move the banner to the original position
			AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
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
			
			// Update the new current Y position
			mCurrY -= MANUAL_MOVE_SIZE;
			// Move the banner
			AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
			// Disable the button if we dont have any more space to move up
			if(mCurrY<=0) mUpBtn.enabled = false;
			// Since we did move up, it means that we will be able to move down, enable the movedown button if it was disable
			mDownBtn.enabled = true;
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
			
			// Update the new current Y position
			mCurrY += MANUAL_MOVE_SIZE;
			// Move the banner
			AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
			// Disable the button if we dont have any more space to move down
			if(mCurrY>=mMaxY) mDownBtn.enabled = false;
			// Since we did move down, it means that we will be able to move us, enable the moveup button if it was disable
			mUpBtn.enabled = true;
		}
		
		/** 
		 * Event listener for onLeft Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function onLeft():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onLeft");
			
			// Update the new current X position
			mCurrX -= MANUAL_MOVE_SIZE;
			// Move the banner
			AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
			// Disable the button if we dont have any more space to move left
			if(mCurrX<=0) mLeftBtn.enabled = false;
			// Since we did move left, it means that we will be able to move right, enable the moveright button if it was disable
			mRightBtn.enabled = true;
		}
		
		/** 
		 * Event listener for onRight Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function onRight():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onRight");

			// Update the new current X position
			mCurrX += MANUAL_MOVE_SIZE;
			// Move the banner
			AdsManager.moveBanner(BANNERID,mCurrX,mCurrY);
			// Disable the button if we dont have any more space to move right
			if(mCurrX>=mMaxX) mRightBtn.enabled = false;
			// Since we did move right, it means that we will be able to move left, enable the moveleft button if it was disable
			mLeftBtn.enabled = true;
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
			// Get the banner Dimensions
			mBannerSize = AdsManager.getExistingBannerSize(BANNERID);
			// Update the current banner Position (it was created on center screen)
			mOriX = mCurrX = (mScreenSize.width/2)-(mBannerSize.width/2);
			mOriY = mCurrY = (mScreenSize.height/2)-(mBannerSize.height/2);
			// Set the maximum movement values
			mMaxX = mScreenSize.width - mBannerSize.width;
			mMaxY = mScreenSize.height - mBannerSize.height;
			
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