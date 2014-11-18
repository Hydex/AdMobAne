package scenes
{
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Game UI Models Includes
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.FuncButton;
	
	// Starling Includes
	import starling.display.Sprite;
	import starling.events.Event;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.SpriteUtl;
	
	/**
	 * Home Scene Class<br/>
	 * The class will construct and manage the Home Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class HomeScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[HomeScene] ';
		
		/** 
		 * Home Scene constructor
		 * 
		 **/
		public function HomeScene()
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
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Home Scene
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
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.activateAppBanner();
			
			// Add the Scene Context
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
			
			// Console proprierty
			var container:Sprite = new Sprite();
			var label:String;
			var yPos:uint = 0;
			var yOffset:uint = 2;
			
			// Create Each Button
			for (var i:uint = 1; i <= 6; i++) 
			{ 
				// Create the button
				var button:FuncButton = new FuncButton(Root.getMsg(Constants.MSG_MENU_FUNC+i),null,true,SpriteUtl.TOPLEFT);
				SpriteUtl.setPosition(button,0,yPos,false);
				// Enable the button according to function lock state
				button.name = i.toString();
				button.addEventListener(Event.TRIGGERED,onButtonTrigged);
				container.addChild(button);
				// Update next button Position
				yPos += button.height+yOffset;
			}

			// Return the Container
			return container;
		}

		/** 
		 * onButtonTrigged Event Listener
		 *   
		 * @param e Event Object
		 **/
		private function onButtonTrigged(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onButtonTrigged");

			// Get the button Instance
			var button:FuncButton = e.target as FuncButton;
			// Get the Function Destination
			var destination:String;
			if (button.name == "1") destination			= GameState.STATE_GAME;
			else if (button.name == "2") destination	= GameState.STATE_SINGLE_BANNER;
			else if (button.name == "3") destination	= GameState.STATE_MULTI_BANNER;
			else if (button.name == "4") destination	= GameState.STATE_MOVE_BANNER;
			else if (button.name == "5") destination	= GameState.STATE_ROTATE_BANNER;
			else if (button.name == "6") destination	= GameState.STATE_INTERSTITIAL;
			else if (button.name == "7") destination	= GameState.STATE_CONFIG;
			else return;
			
			// Dispatch Scene Change Event
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, destination);
		}
	}
}