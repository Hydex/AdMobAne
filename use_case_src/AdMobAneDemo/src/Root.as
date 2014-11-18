package
{
	// Flash Includes
	import flash.filesystem.File;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game Data Models Includes
	import models.data.Config;
	
	// Game Scenes Includes
	import scenes.ConfigScene;
	import scenes.GameScene;
	import scenes.HomeScene;
	import scenes.InterstitialScene;
	import scenes.MoveBannerScene;
	import scenes.MultiBannerScene;
	import scenes.RotateBannerScene;
	import scenes.SingleBannerScene;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.LanguageManager;
	import utils.SoundManager;
	import utils.TimerUtil;
	
	/**
	 * Game Root Class<br/>
	 * The class will construct and manage the Game Root
	 * 
	 * @author Code Alchemy
	 **/
	public class Root extends Sprite
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[Root] ';
		
		// Asset Manager Instance
		static private var mAssets:AssetManager;
		// Language Object Instance
		static private var mLangObject:Object;
		// Main Active scene Instance
		static private var mActiveScene:Sprite;
		// Game Config Instance
		static private var mConfig:Config;
		
		// Background instances
		private var mBackground:Image;
		
		/**
		 * Game Assets Instance
		 **/
		static public function get assets():AssetManager
		{ return mAssets; }
		
		/**
		 * Game Language Object Istance
		 **/
		static public function get langObject():Object
		{ return mLangObject; }
		static public function set langObject(lang:Object):void
		{ mLangObject = lang}

		/**
		 * Game Active Scene Instance
		 **/
		static public function get activeScene():Sprite
		{ return mActiveScene; }
		
		/**
		 * Game Configuration Instance
		 **/
		static public function get config():Config
		{
			// Return the existing instance if available or create a new one
			if (mConfig == null) mConfig = new Config();
			return mConfig;
		}
		
		/**
		 * Game Root constructor
		 **/
		public function Root()
		{
			// Add the game states change listener 
			addEventListener(GameEvent.GAME_STATE_CHANGE, onChangeState);
		}
		
		/**
		 * Main Game Start
		 * Executed at the first Game start
		 *
		 * @param background Main Background
		 * @param assets Game Asset Manager
		 **/
		public function start(background:Texture, assets:AssetManager):void
		{
			// Set the root assets
			mAssets = assets;
			// Set the main Background and add it to the stage for avoid blank screen
			mBackground = new Image(background);
			addChild(mBackground);
			
			// Load Assets
			loadAssets();
		}
		
		/**
		 * Load Game Main Assets
		 * Executed When all assets are available in the device
		 **/
		private function loadAssets():void
		{
			// Update the language manager acording to the user config
			LanguageManager.locale = config.lang;
			// Enqueue common assets
			preloadData(formatString("lang/{0}.json", LanguageManager.locale));
			preloadTextures("base");
			preloadTextures("game");
			preloadSounds("");
			
			// Load Assets Queue
			assets.loadQueue(function onProgress(ratio:Number):void
				{
					// Check if the load is completed
					if (ratio == 1)
					{
						// start background Music
						SoundManager.bgm.start(Constants.SND_BGM_MENU);
						// Update language object
						mLangObject = assets.getObject(LanguageManager.locale);
						assets.removeObject(LanguageManager.locale);
						// Banners Manager initialization
						AdsManager.init(true,assets.verbose); // Debug Mode
						//AdsManager.init(false,false); // Production Mode
						// Load the boot Game scene
						mActiveScene = new HomeScene();
						addChild(mActiveScene);

						// Dispose of the Background
						if (mBackground) mBackground.removeFromParent(true);
					}
				}
			);
		}
		
		/**
		 * Event listener for Game States Changes
		 * Handle the navitation between game states
		 *
		 * @param e Event Object
		 * @param state Name of the target state
		 **/
		private function onChangeState(e:Event, state:Object):void
		{
			// Add the background
			addChild(mBackground);
			
			// Switch for the state to be loaded
			if (state == GameState.STATE_HOME)					showScene(HomeScene);
			else if (state == GameState.STATE_GAME)				showScene(GameScene);
			else if (state == GameState.STATE_SINGLE_BANNER)	showScene(SingleBannerScene);
			else if (state == GameState.STATE_MULTI_BANNER)		showScene(MultiBannerScene);
			else if (state == GameState.STATE_MOVE_BANNER)		showScene(MoveBannerScene);
			else if (state == GameState.STATE_ROTATE_BANNER)	showScene(RotateBannerScene);
			else if (state == GameState.STATE_INTERSTITIAL)		showScene(InterstitialScene);
			else if (state == GameState.STATE_CONFIG)			showScene(ConfigScene);
		}
		
		/**
		 * Scene Switcher Function
		 * The function will completly dispose the current scene and load the new one
		 *
		 * @param screen Target Scene to be constructed
		 * @param data Scene Data Object. Otional, default = null
		 **/
		private function showScene(screen:Class):void
		{
			// Remove the existing scene if available
			if (mActiveScene) mActiveScene.removeFromParent();
			// Create the new Scene and add it to the stage
			mActiveScene = new screen();
			addChild(mActiveScene);
			// Dispose of the Background
			if (mBackground) mBackground.removeFromParent();
		}

		/**
		 * Enqueue new assets to the AssetsManager
		 *
		 * @param type Tyepe of assets to be loaded
		 * @param path Target path to be laoded
		 **/
		static private function enqueue(type:String, path:String):void
		{
			var appDir:File = File.applicationDirectory;
			mAssets.enqueue(appDir.resolvePath(formatString("{0}/{1}", type, path)));
		}
		
		/**
		 * Preload texture assets to the AssetManager
		 *
		 * @param path Target path to be laoded
		 **/
		static public function preloadTextures(path:String):void
		{ enqueue(formatString("textures/{0}x", mAssets.scaleFactor), path); }
		
		/**
		 * Preload Audio assets to the AssetManager
		 *
		 * @param path Target path to be laoded
		 **/
		static public function preloadSounds(path:String):void
		{ enqueue("audio", path); }
		
		/**
		 * Purge all Sounds from the AssetManager
		 *
		 **/
		static public function purgeSounds():void
		{
			var list:Vector.<String> = Root.assets.getSoundNames();
			for each (var name:String in list)
			{ Root.assets.removeSound(name); }
			list = null;
		}
		
		/**
		 * Preload Data assets to the AssetManager
		 *
		 * @param path Target path to be laoded
		 **/
		static public function preloadData(path:String):void
		{ enqueue("datas", path); }
		
		/**
		 * Purge all Object Data from the AssetManager
		 * Language data will be always preserved 
		 **/
		static public function purgeData():void
		{
			var list:Vector.<String> = Root.assets.getObjectNames();
			for each (var name:String in list)
			{
				if (name != LanguageManager.locale) Root.assets.removeObject(name);
			}
			list = null;
		}
		
		/**
		 * Load the current AssetManager Queue
		 *
		 * @param onComplete Callback function
		 **/
		static public function loadQueue(onComplete:Function):void
		{
			mAssets.loadQueue(function(ratio:Number):void
				{
					if (ratio < 1.0) return;
					if (onComplete != null) onComplete();
				});
		}
		
		/**
		 * Retrieve a message string from the current locale for the given id
		 *
		 * @param messageId Message id to be retrieved
		 *
		 * @return Localized Message
		 **/
		static public function getMsg(messageId:String):String
		{
			// Return an error label if the language object is not available
			if (!mLangObject) return "NO_LANG_OBJ";
			
			// Return the message ID if the requested message is not available
			if (!mLangObject[messageId]) return messageId;
			
			// Return the localized string for the requested message
			return mLangObject[messageId];
		}
		
		/**
		 * Log Debug messages if in Debug Mode
		 *
		 * @param msg Message to be logged
		 * @param args Further args to be included in the log
		 **/
		static public function log(msg:String, ... args):void
		{
			// Trace the message if in debug mode
			if (Root.assets.verbose) trace('['+TimerUtil.dateFormat(TimerUtil.nowLocal)+ ']',msg, args);
		}
	}
}
