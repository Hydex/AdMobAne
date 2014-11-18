package scenes
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game UI Models Includes
	import models.ui.PopUp;
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	
	// Starling Includes
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.DeviceManager;
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/**
	 * Game Scene Class<br/>
	 * The class will construct and manage the Game Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class GameScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[GameScene] ';
		
		// If the Interstitial fails to load we retry for a limited number of times
		private const MAX_RETRY:int = 4;
		
		// Flying stuff instances
		private var mBird:Image;
		private var mDevice:Image;
		
		// Game state and popup instances
		private var mGamePopUp:PopUp;
		private var mHasWon:Boolean = false;

		// Interstitial availability state
		private var hasInterstitial:Boolean = false;
		// Current Interstitial retry attempt
		private var currRetry:int = 0;
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Game Scene constructor
		 * 
		 **/
		public function GameScene()
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
			// start background Music
			SoundManager.bgm.start(Constants.SND_BGM_GAME);
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
			
			// Remove the Interstitial if exist
			AdsManager.removeInterstitial();
			// Remove all the event listeners
			removeAdEventsListeners();
			removeEventListeners();
			// start background Music
			SoundManager.bgm.start(Constants.SND_BGM_MENU);
		}
		
		/** 
		 * Initialize the Game Scene
		 *   
		 **/
		private function init():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Initializing...");
			
			// Add the Ad Event Lsteners
			addAdEventsListeners();
			// Create the Interstitial but don:t show it
			AdsManager.createInterstitial(false);
			
			// Add the Scene Background
			var sceneBackground:SceneBackground = new SceneBackground();
			addChild(sceneBackground);
			
			// Add the Scene Header
			var sceneHeader:SceneHeader = new SceneHeader();
			addChild(sceneHeader);
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.activateAppBanner();
			
			if(!AdsManager.isSupported || !AdsManager.hasConnection){
				// Create the game rules popup
				mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_RULES),onGameStart);
				addChild(mGamePopUp);
			}else{
				// Create the Loading popup (mostly used for the Interstitial loading time)
				mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_LOADING),null,false);
				addChild(mGamePopUp);
			}
			
			// Create the bird!
			mBird = new Image(Root.assets.getTexture(Constants.IMG_MAGE));
			SpriteUtl.setPivot(mBird,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mBird,Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2);
			mBird.addEventListener(TouchEvent.TOUCH, onBirdTouched);
			
			// Create the device logo!
			var isIos:Boolean = DeviceManager.isIos;
			mDevice = new Image(Root.assets.getTexture(Constants.IMG_VIRUS));
			SpriteUtl.setPivot(mDevice,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mDevice,Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2);
			mDevice.addEventListener(TouchEvent.TOUCH, onLogoTouched);
		}
		
		// =================================================================================================
		//	Operation Functions
		// =================================================================================================
		
		/** 
		 * Move the bird
		 * Create the bird loop tween
		 *   
		 **/
		private function moveBird():void
		{
			// Set Random Scale
			var scale:Number = Math.random() * 0.8 + 0.2;
			
			// Create the Bird Tween
			Starling.juggler.tween(mBird, Math.random() * 0.2 + 0.2, {
				x: Math.random() * Constants.STAGE_WIDTH,
				y: 80+(Math.random() * (Constants.STAGE_HEIGHT-150)),
				scaleX: scale,
				scaleY: scale,
				rotation: Math.random() * deg2rad(180) - deg2rad(90),
				transition: Transitions.EASE_IN_OUT,
				onComplete: moveBird
			});
		}
		
		/** 
		 * Move the logo
		 * Create the logo loop tween
		 *   
		 **/
		private function moveLogo():void
		{
			// Set Random Scale
			var scale:Number = Math.random() * 0.8 + 0.4;
			
			// Create the Logo Tween
			Starling.juggler.tween(mDevice, Math.random() * 0.8 + 0.8, {
				x: Math.random() * Constants.STAGE_WIDTH,
				y: 80+(Math.random() * (Constants.STAGE_HEIGHT-150)),
				scaleX: scale,
				scaleY: scale,
				rotation: Math.random() * deg2rad(180) - deg2rad(90),
				transition: Transitions.EASE_IN_OUT,
				onComplete: moveLogo
			});
		}
		
		// =================================================================================================
		//	Game Events Functions
		// =================================================================================================
		
		/** 
		 * onGameStart Event Listener
		 * 
		 **/
		private function onGameStart():void
		{
			// Dispose the popup if already exist
			if (mGamePopUp)mGamePopUp.removeFromParent(true);
			
			// Add the bird and start it
			addChild(mBird);
			moveBird();
			// Add the logo and start it
			addChild(mDevice);
			moveLogo();
		}
		/** 
		 * onGameEnd Event Listener
		 * 
		 **/
		private function onGameEnd():void
		{
			if (mHasWon){
				// Dispatch The Scene Change Event for refresh the current scene
				dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
			}else{
				if (hasInterstitial){
					/* If we hae the Inter. we show it */
					// Show the Interstitial
					AdsManager.showInterstitial();
				}else{
					/* Otherwise... go home. */
					// Dispatch The Scene Change Event for refresh the current scene
					dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
				}
			}
		}

		/** 
		 * onBirdTouched Event Listener
		 * 
		 * @param event TouchEvent Instance  
		 **/
		private function onBirdTouched(event:TouchEvent):void
		{
			if (event.getTouch(mBird, TouchPhase.BEGAN))
			{
				// Play the button Sound
				SoundManager.se.start(Constants.SND_BTN_CLICK);
				// Remove the Tweens from the Juggler
				Starling.juggler.removeTweens(mBird);
				Starling.juggler.removeTweens(mDevice);
				// Dispose the flying stuff
				mBird.removeFromParent(true);
				mDevice.removeFromParent(true);
				// Dispose the popup if already exist
				if (mGamePopUp)mGamePopUp.removeFromParent(true);
				// Add the Winning result
				mHasWon = true;
				mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_WIN),onGameEnd);
				addChild(mGamePopUp);
			}
		}

		/** 
		 * onLogoTouched Event Listener
		 * 
		 * @param event TouchEvent Instance  
		 **/
		private function onLogoTouched(event:TouchEvent):void
		{
			if (event.getTouch(mDevice, TouchPhase.BEGAN))
			{
				// Play the button Sound
				SoundManager.se.start(Constants.SND_BTN_CLICK);
				// Remove the Tweens from the Juggler
				Starling.juggler.removeTweens(mBird);
				Starling.juggler.removeTweens(mDevice);
				// Dispose the flying stuff
				mBird.removeFromParent(true);
				mDevice.removeFromParent(true);
				// Dispose the popup if already exist
				if (mGamePopUp)mGamePopUp.removeFromParent(true);
				// Add the Losing result
				mHasWon = false;
				mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_LOSE),onGameEnd);
				addChild(mGamePopUp);
			}
		}

		// =================================================================================================
		//	Interstitial Events Functions
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
			// Update Interstitial state
			hasInterstitial = true;
			// Update Current retry count
			currRetry = 0;
			// Dispose the popup if already exist
			if (mGamePopUp)mGamePopUp.removeFromParent(true);
			// Create the game rules popup
			mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_RULES),onGameStart);
			addChild(mGamePopUp);
		}
		
		/**
		 * onInterstitialFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onInterstitialFailedToLoad(e:AdMobEvent):void
		{
			// Update Interstitial state
			hasInterstitial = false;
			if (currRetry<MAX_RETRY){
				// Re try to create the Interstitial 
				AdsManager.createInterstitial(false);
				// Update Current retry count
				currRetry ++;
			}else{
				// Give up on trying and start the game
				// Create the game rules popup
				mGamePopUp = new PopUp(Root.getMsg(Constants.MSG_RULES),onGameStart);
				addChild(mGamePopUp);
			}
		
		}
		
		/**
		 * onInterstitialAdClosed Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onInterstitialAdClosed(e:AdMobEvent):void
		{
			// Dispatch The Scene Change Event for refresh the current scene
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
		}
	}
}