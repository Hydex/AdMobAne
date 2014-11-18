package models.ui.controls
{
	// Starling Includes
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	// Game Utils Includes
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/** 
	 * Function Button Class<br/>
	 * The class will construct and manage the Function Button
	 * 
	 * @author Code Alchemy
	 **/
	public class FuncButton extends Button
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[FuncButton] ';
		
		// Listener instance
		private var mListener:Function;
		
		// Font colors
		private var mFontColorUp:Number		= Constants.COL_FONT_LIGHT;
		private var mFontColorDown:Number	= Constants.COL_FONT_DARK;
		
		/**
		 * Button Label
		 **/
		public function get label():String
		{return text;}
		public function set label(label:String):void
		{text = label;}
		
		/** 
		 * FuncButton constructor
		 *   
		 * @param label Button Label
		 * @param listener Button Event Listener Function. Optional, default = null
		 * @param isLarge Button type. Optional, default = false (false = Std Button, true = Large Button)
		 * @param pivot Button pivot point. Optional, default = CENTER
		 **/
		public function FuncButton(label:String, listener:Function = null, isLarge:Boolean=false, pivot:String = SpriteUtl.CENTER)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Update listener instance
			mListener = listener;
			
			// Set button type and its font size
			var fntSize:uint;
			var imgUpState:String;
			var imgDownState:String;
			if (isLarge){
				fntSize			= Constants.FONT_SIZE_BIG;
				imgUpState		= Constants.IMG_BTN_BIG_UP;
				imgDownState	= Constants.IMG_BTN_BIG_DOWN;
			}else{
				fntSize			= Constants.FONT_SIZE_SMALL;
				imgUpState		= Constants.IMG_BTN_SMALL_UP;
				imgDownState	= Constants.IMG_BTN_SMALL_DOWN;
			}
			// Construct the ImageButton with the given parameters
			super(Root.assets.getTexture(imgUpState),label,Root.assets.getTexture(imgDownState));
			// Update the button parameters
			fontName	= Constants.FONT_NAME;
			fontSize	= fntSize;
			fontColor	= mFontColorUp;
			SpriteUtl.setPivot(this,pivot)
			// Add button event listener
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/** 
		 * button Touch Event Listener
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
				if(mListener != null) mListener();
			}
		}
	}
}