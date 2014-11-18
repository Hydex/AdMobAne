package
{
	// Flash Includes
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game Data Models Includes
	import models.data.Config;
	
	// Game Scenes Includes
	import scenes.HomeScene;

	// Starling Includes
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.DeviceManager;
	import utils.SoundManager;
	
	/**
	 * Admob ANE Demo Main Class<br/>
	 * The class will construct and manage the Main Game
	 * 
	 * @author Code Alchemy
	 **/
	[SWF(frameRate="60", backgroundColor="#202020")] // Set base frame rate and backgropund color
	public class AdMobAneDemo extends Sprite
	{
		// Embed Fonts assets 
		[Embed(source="/fonts/Barrett.ttf", embedAsCFF="false", fontFamily="Barrett")]
		static private const BarrettRegular:Class;
		
		// Embed Splash Screen assets 
		[Embed(source="/startup.png")] // Standard
		static private var Background:Class;
		[Embed(source="/startupHD.png")] // Retina
		static private var BackgroundHD:Class;
		[Embed(source="/startupHD@568.png")] // iPhone5
		static private var BackgroundHD568:Class;
		
		// Tag Constant for log
		private const LOG_TAG:String ='[AdMobAneDemo] ';
		
		// Starling Definition
		private var mStarling:Starling;
		
		/** 
		 *  Admob ANE Demo Constructor
		 * 
		 **/
		public function AdMobAneDemo()
		{
			// Enable device multitouch
			Starling.multitouchEnabled = true;
			// Disable lost content management for iOS application
			Starling.handleLostContext = !DeviceManager.isIos;
			
			// Update stage height if the Game is running on iPhone5
			if((stage.fullScreenHeight / stage.fullScreenWidth) >= 1.775)
				Constants.STAGE_HEIGHT = 568;
			
			// Create the viewport for screen size adjustment
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, Constants.STAGE_WIDTH, Constants.STAGE_HEIGHT), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL
			);
			
			// Get current scale factor
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;
			
			// Create the asset Manager for handle all required assets according to the scale factor
			var assets:AssetManager = new AssetManager(scaleFactor);
			// Disable Mipmaps handling
			assets.useMipMaps = false;
			// Enable AssetManager trace information in debug enviorement
			assets.verbose = Capabilities.isDebugger;
			
			// Create and initialize a background during Stage3D initialization to avoid blank screen
			var background:Bitmap;
			if (scaleFactor == 1){
				background = new Background();
			}else{
				background = Constants.STAGE_HEIGHT == 568 ? new BackgroundHD568() : new BackgroundHD();
			}
			BackgroundHD568			= BackgroundHD = Background = null; // No longer needed
			background.x			= viewPort.x;
			background.y			= viewPort.y;
			background.width		= viewPort.width;
			background.height		= viewPort.height;
			background.smoothing	= true;
			addChild(background);
			
			// Create and initialize Starling
			mStarling = new Starling(Root, stage, viewPort);
			mStarling.stage.stageWidth		= Constants.STAGE_WIDTH;
			mStarling.stage.stageHeight		= Constants.STAGE_HEIGHT;
			mStarling.simulateMultitouch	= false;
			// Enable Starling tracing on debug enviorements ans stats if in debug mode
			mStarling.enableErrorChecking	= Capabilities.isDebugger;
			// mStarling.showStats = Capabilities.isDebugger;
			
			// When the root is created start the Game
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:Root):void
				{
					// Remove event listener
					mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					// Add event listener fo handle Device buttons and application activation/deactivation
					NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate);
					NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeatctivate);
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					// Remove the previous background
					removeChild(background);
					// Define the background texture
					var bgTexture:Texture = Texture.fromBitmap(background, false, false, scaleFactor);
					// Pass the assets and background to the root and start the applicartion
					app.start(bgTexture, assets);
					// Start Starling
					mStarling.start();
				}
			);
		}
		
		/** 
		 * OnActivate Event Handler
		 * Trigged when the game is reactivated (ex. from sleep mode) 
		 * 
		 * @param e Event Object
		 **/
		private function onActivate(e:flash.events.Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onActivate");
			
			// Resume Starling
			mStarling.start();
			
			// Enable the background music
			if(Root.config){
				SoundManager.bgm.volume = Root.config.bgmVolume;
			}else{
				SoundManager.bgm.volume = new Config().bgmVolume;
			}

			// Activate the application banner
			if (Root.activeScene != null) {
				AdsManager.activateAppBanner();
			}
		}
		
		/** 
		 * onDeatctivate Event Handler
		 * Trigged when the game is deactivated (ex. go to sleep mode) 
		 * 
		 * @param e Event Object
		 **/
		private function onDeatctivate(e:flash.events.Event):void
		{
			Root.log(LOG_TAG,"onDeatctivate");
			// Deactivate the application banner
			AdsManager.deativateAppBanner();
			// Disable the background music
			SoundManager.bgm.volume = 0;
			// Resume Stop
			mStarling.stop();
		}
		
		/** 
		 * onKeyDown Event Handler
		 * Trigged a device keyboard button is trigged 
		 * 
		 * @param e Keyboard Event Object
		 **/
		private function onKeyDown(e:KeyboardEvent):void
		{
			// Switch for the pressed key button
			switch (e.keyCode)
			{
				case Keyboard.MENU:
					Root.log(LOG_TAG,"onKeyDown: Menu");
					// Do something
					break;
				case Keyboard.SEARCH:
					Root.log(LOG_TAG,"onKeyDown: Search");
					// Do something
					break;
				case Keyboard.BACK:
					Root.log(LOG_TAG,"onKeyDown: Back");
					// Prevent the System Default
					e.preventDefault();
					// Stop if already in home scene
					if (Root.activeScene is HomeScene) break;
					// Return to home cscene
					Root.activeScene.dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
					break;
			}
		}
	}
}