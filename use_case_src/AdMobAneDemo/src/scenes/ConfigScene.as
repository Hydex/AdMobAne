package scenes
{
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game UI Models Includes
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.BackButton;
	import models.ui.controls.SelectorButton;
	import models.ui.controls.SliderButton;
	import models.ui.controls.ToggleButton;
	
	// Starling Includes
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.formatString;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.LanguageManager;
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/**
	 * Config Scene Class<br/>
	 * The class will construct and manage the Config Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class ConfigScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[ConfigScene] ';
		
		// Class private proprierties
		private var bgmEnable:Boolean	= false;
		private var bgmVolume:int		= 0;
		private var seEnable:Boolean	= false;
		private var seVolume:int		= 0;
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Config Scene constructor
		 * 
		 **/
		public function ConfigScene()
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
			
			// Save user configuration
			Root.config.bgmVolume	= bgmVolume;
			Root.config.bgmEnable	= bgmEnable;
			Root.config.seVolume	= seVolume;
			Root.config.seEnable	= seEnable;
			Root.config.save();
			
			// Remove all the event listeners
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Config Scene
		 *   
		 **/
		private function init():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Initializing...");
			
			// Load the current configuration
			loadConfig();
			
			// Add the Scene Background
			var sceneBackground:SceneBackground = new SceneBackground();
			addChild(sceneBackground);
			
			// Add the Scene Header
			var sceneHeader:SceneHeader = new SceneHeader();
			addChild(sceneHeader);
			
			// Add the Back Button
			var BackBtn:BackButton = new BackButton();
			addChild(BackBtn);
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.activateAppBanner();
			
			// Create and Add the Main Console
			var mainConsole:Sprite = createMainConsole();
			SpriteUtl.setPivot(mainConsole,SpriteUtl.CENTER);
			var posY:uint = sceneHeader.height+((Constants.STAGE_HEIGHT-50-sceneHeader.height)/2);
			SpriteUtl.setPosition(mainConsole,Constants.STAGE_WIDTH/2,posY,false);
			addChild(mainConsole);
		}
		
		/** 
		 * Create the Scene main Console
		 *   
		 * @return Main context Sprite instance
		 **/
		private function createMainConsole():Sprite
		{
			// Debug Logger
			Root.log(LOG_TAG,"createMainConsole");

			// Offsets Constants
			const OFFSET_X:uint		= 25;
			const OFFSET_Y:uint		= 10;

			// Create Container Elements
			var container:Sprite = new Sprite();

			// Create Background Music Controls
			var bgmTitle:TextField		= createLabel(Root.getMsg(Constants.MSG_LABEL_BGM));
			bgmTitle.fontName = Constants.FONT_NAME;
			var bgmToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_ENABLE),bgmEnable,toggleBgm);
			var bgmSlider:SliderButton	= new SliderButton(Root.getMsg(Constants.MSG_VOLUME),bgmVolume,volumeBgm,volumeBgm);
			
			// Create Sound Effects Controls
			var seTitle:TextField = createLabel(Root.getMsg(Constants.MSG_LABEL_FX));
			seTitle.fontName = Constants.FONT_NAME;
			var seToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_ENABLE),seEnable,toggleSe);
			var seSlider:SliderButton	= new SliderButton(Root.getMsg(Constants.MSG_VOLUME),seVolume,volumeSe,volumeSe);
			
			// Create Language Selector Controls
			var langTitle:TextField = createLabel(Root.getMsg(Constants.MSG_LABEL_LANG));
			langTitle.fontName = Constants.FONT_NAME;
			// TODO, Json?
			var selectorOptions:Array = new Array(
				{key:"sys",	label:Root.getMsg(Constants.MSG_LANG_SYS)},
				{key:"en",	label:Root.getMsg(Constants.MSG_LANG_EN)},
				{key:"it",	label:Root.getMsg(Constants.MSG_LANG_IT)}
			);
			var langSelector:SelectorButton	= new SelectorButton(Root.config.lang,selectorOptions,selectLanguage);
			
			// Set Background Music Controls Positions
			SpriteUtl.setPosition(bgmTitle,0,0);
			SpriteUtl.setPosition(bgmToggle,bgmTitle.x,bgmTitle.y+bgmTitle.height,false);
			SpriteUtl.setPosition(bgmSlider,bgmToggle.x+bgmToggle.width+OFFSET_X,bgmToggle.y,false);
			
			// Set Sound Effects Controls Positions
			SpriteUtl.setPosition(seTitle,bgmToggle.x,bgmToggle.y+bgmToggle.height+OFFSET_Y,false);
			SpriteUtl.setPosition(seToggle,seTitle.x,seTitle.y+seTitle.height,false);
			SpriteUtl.setPosition(seSlider,seToggle.x+seToggle.width+OFFSET_X,seToggle.y,false);
			
			// Set Language Selector Controls Positions
			SpriteUtl.setPosition(langTitle,seToggle.x,seToggle.y+seToggle.height+OFFSET_Y,false);
			SpriteUtl.setPosition(langSelector,langTitle.x,langTitle.y+langTitle.height+OFFSET_Y,false);
			
			// Add container Children
			container.addChild(bgmTitle);
			container.addChild(bgmToggle);
			container.addChild(bgmSlider);
			container.addChild(seTitle);
			container.addChild(seToggle);
			container.addChild(seSlider);
			container.addChild(langTitle);
			container.addChild(langSelector);

			// Return the Container
			return container;
		}

		/** 
		 * Create the Label Textfield Object
		 *   
		 * @param text Text to be used for the label
		 * 
		 * @return Textfield Object for the Label
		 **/
		private function createLabel(text:String):TextField
		{
			// Create The Label
			var label:TextField = new TextField(200, 24, text);
			label.fontSize		= Constants.FONT_SIZE_LABEL;
			label.color			= Constants.COL_FONT_LIGHT;
			label.hAlign		= HAlign.LEFT;
			label.vAlign		= VAlign.BOTTOM;
			label.touchable		= false;
			return label;
		}
		
		/** 
		 * Load the current config data
		 * 
		 **/
		private function loadConfig():void
		{
			// Update Bgm music according to current settings
			bgmEnable = Root.config.bgmEnable;
			bgmVolume = Root.config.bgmVolume;
			SoundManager.bgm.enable = bgmEnable;
			SoundManager.bgm.volume = bgmVolume;
			
			// Update Sound Effects according to current settings
			seEnable = Root.config.seEnable;
			seVolume = Root.config.seVolume;
			SoundManager.se.enable = seEnable;
			SoundManager.se.volume = seVolume;
		}
		
		// =================================================================================================
		//	Console Functions
		// =================================================================================================
		
		/** 
		 * Language Select button event Listener
		 *   
		 * @param langId Selected Language Id
		 **/
		private function selectLanguage(langId:String):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Selected Language:", langId);
			
			// Set the new language in the config
			Root.config.lang = langId;
			// Remove all the previous language objects
			for each (var lang:String in LanguageManager.allowed) Root.assets.removeObject(lang);
			
			// Load the new Language Data
			Root.preloadData(formatString("lang/{0}.json", LanguageManager.locale));
			Root.loadQueue(function():void
				{
					Root.langObject = Root.assets.getObject(LanguageManager.locale);
					// Dispatch The Scene Change Event for refresh the current scene
					dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_CONFIG);
				}
			);
		}
		
		/** 
		 * Background Music Toggle button event Listener
		 *   
		 * @param toggle Toggle State
		 **/
		private function toggleBgm(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"BGM toggle:", toggle);
			// Update setting value
			bgmEnable = toggle;
			// Update Sound Manager
			SoundManager.bgm.enable = bgmEnable;
		}
		
		/** 
		 * Background Music Volume Slider event Listener
		 *   
		 * @param value New Volume Slider value
		 **/
		private function volumeBgm(value:uint):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"BGM volume:", value);
			// Update setting value
			bgmVolume = value;
			// Update Sound Manager
			SoundManager.bgm.volume = bgmVolume;
		}
		
		/** 
		 * Sound effects Toggle button event Listener
		 *   
		 * @param toggle Toggle State
		 **/
		private function toggleSe(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"SE toggle:", toggle);
			// Update setting value
			seEnable = toggle;
			// Update Sound Manager
			SoundManager.se.enable = seEnable;
		}
		
		/** 
		 * Sound effects Volume Slider event Listener
		 *   
		 * @param value New Volume Slider value
		 **/
		private function volumeSe(value:uint):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"SE volume:", value);
			// Update setting value
			seVolume = value;
			// Update Sound Manager
			SoundManager.se.volume = seVolume;
		}
	}
}