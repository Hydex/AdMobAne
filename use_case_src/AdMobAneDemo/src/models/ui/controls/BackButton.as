package models.ui.controls
{
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Starling Includes
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	// Game Utils Includes
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/** 
	 * Back Button Class<br/>
	 * The class will construct and manage the Back Button
	 * 
	 * @author Code Alchemy
	 **/
	public class BackButton extends Button
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[BackButton] ';
		
		// Button Label Instance
		private var mLabel:String;
		// Listener instance
		private var mListener:Function;
		
		// Font colors
		private var mFontColorUp:Number		= Constants.COL_BLACK;
		private var mFontColorDown:Number	= Constants.COL_BLACK;
		
		/** 
		 * BackButton constructor
		 *   
		 * @param listener Button Event Listener Function. Optional, default = null
		 * @param pivot Button pivot point. Optional, default = CENTER
		 **/
		public function BackButton(listener:Function = null, pivot:String = SpriteUtl.CENTER)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Update instances
			mLabel = Root.getMsg(Constants.MSG_BACK_BTN);
			mListener = listener;
			// Construct the ImageButton with the given parameters
			super(Root.assets.getTexture(Constants.IMG_BTN_BACK_UP),mLabel,Root.assets.getTexture(Constants.IMG_BTN_BACK_DOWN));
			// update the button parameters
			fontName		= Constants.FONT_NAME;
			fontSize		= Constants.FONT_SIZE_BACK;
			fontColor		= mFontColorUp;
			var posY:uint	= Constants.STAGE_HEIGHT-52-(this.height/2);
			SpriteUtl.setPivot(this,pivot)
			SpriteUtl.setPosition(this,Constants.STAGE_WIDTH/2,posY,false);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/** 
		 * Button Touch Event Listener
		 *   
		 * @param event Touch Event Object
		 **/
		private function onTouch(event:TouchEvent):void
		{
			// Get the touch Istance
			var touch:Touch = event.getTouch(this);
			// Stop processing if the instance is not available or if the button is not enable
			if (!enabled || touch == null) return;
			
			// Change the button font color according to the touch state
			if (touch.phase == TouchPhase.BEGAN)
			{ fontColor = mFontColorDown; }
			else if (touch.phase == TouchPhase.ENDED)
			{ 
				// Play the button Sound 
				SoundManager.se.start(Constants.SND_BTN_CLICK);
				fontColor = mFontColorUp;
				// Check if we have a listener
				if(mListener != null)
				{
					// Process the given listener
					mListener();
				}else{
					// Default operatio, Dispatch Scene Change Event
					dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
				}
			}
		}
	}
}