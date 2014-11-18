package models.ui
{
	// Game UI Models Includes
	import models.ui.controls.FuncButton;
	
	// Starling Includes
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	// Game Utils Includes
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/** 
	 * PopUp Window Class<br/>
	 * The class will construct and manage the PopUp Window
	 * 
	 * @author Code Alchemy
	 **/
	public class PopUp extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[PopUp] ';

		// PopUp instances
		private var mWindow:Sprite;
		private var mListener:Function;
		private var mHasButton:Boolean;
		private var mWinBtn:FuncButton;
		
		/** 
		 * PopUp Window constructor
		 * 
		 * @param message window message
		 * @param listener Function to be executed on closure button trigged
		 * @param hasButton true if the window include the function button
		 **/
		public function PopUp(message:String,listener:Function,hasButton:Boolean = true)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Update the instances
			mListener = listener;
			mHasButton = hasButton;
			
			// Create the Semi transparent Background Frame
			var screenFrame:Quad = new Quad(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT,Constants.COL_BACKGROUND);
			screenFrame.alpha = 0.5;
			addChild(screenFrame);
			
			// Create the Window
			mWindow = new Sprite();
			
			// Create the Window Border
			var winFrame:Quad = new Quad(305,170,Constants.COL_HIGHLIGHT_RED);
			winFrame.touchable = false;
			mWindow.addChild(winFrame);
			
			// Create the Window Background
			var winBkg:Quad = new Quad(295,160,Constants.COL_BACKGROUND);
			winBkg.touchable = false;
			winBkg.x = winBkg.y = 5;
			mWindow.addChild(winBkg);

			// Create the Window Message
			var winMessage:TextField = createLabel(message);
			SpriteUtl.setPivot(winMessage,SpriteUtl.CENTER);
			SpriteUtl.setPosition(winMessage,(winBkg.width / 2)+5,(winBkg.height / 2)-20, false);
			winMessage.touchable = false;
			mWindow.addChild(winMessage);
			
			// Create the Create Interstitial button
			if(hasButton){
				mWinBtn = new FuncButton(Root.getMsg(Constants.MSG_OK),onBtnTrigged);
				SpriteUtl.setPivot(mWinBtn, SpriteUtl.TOP)
				SpriteUtl.setPosition(mWinBtn,winMessage.x,winMessage.y+(winMessage.height/2)+20, false);
				mWinBtn.enabled = false;
				mWindow.addChild(mWinBtn);
			}
			
			// Add the Window
			SpriteUtl.setPivot(mWindow,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mWindow,screenFrame.width / 2,screenFrame.height / 2, false);
			mWindow.scaleX = mWindow.scaleY = 0; 
			addChild(mWindow);

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
			
			// Animate the Popup window
			Starling.juggler.tween( mWindow, 0.5, {
				scaleX: 1,
				scaleY: 1,
				onComplete: enableInter
			})
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
			Starling.juggler.removeTweens(mWindow);
			removeEventListeners();
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
			var label:TextField	= new TextField(1, 80, text);
			label.autoSize		= TextFieldAutoSize.BOTH_DIRECTIONS;
			label.fontName		= Constants.FONT_NAME;
			if(text.length>15){
				label.fontSize		= Constants.FONT_SIZE_BACK;
			}else{
				label.fontSize		= Constants.FONT_SIZE_BIG;
			}
			label.color			= Constants.COL_FONT_LIGHT;
			label.hAlign		= HAlign.LEFT;
			label.vAlign		= VAlign.TOP;
			label.touchable		= false;
			return label;
		}
	
		/** 
		 * Enable button interaction
		 * 
		 **/
		private function enableInter():void
		{
			// do not process if there is no button
			if (!mHasButton) return;
			// Debug Logger
			Root.log(LOG_TAG,"enableInter");
			// Enable the button
			mWinBtn.enabled = true;
		}
		/** 
		 * Event listener for on Button Trigged
		 * 
		 **/
		private function onBtnTrigged():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBtnTrigged");
			// Play the button Sound 
			SoundManager.se.start(Constants.SND_BTN_CLICK);
			// Process the listener
			if(mListener != null) mListener();
		}
	}
}