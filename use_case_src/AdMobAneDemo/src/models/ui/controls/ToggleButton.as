package models.ui.controls
{
	// Flash Includes
	import flash.geom.Point;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	// Game Utils Includes
	import utils.SoundManager;
	import utils.SpriteUtl;
	
	/** 
	 * Toggle Button Class<br/>
	 * The class will construct and manage the Toggle Button
	 * 
	 * @author Code Alchemy
	 **/
	public class ToggleButton extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[ToggleButton] ';
		
		// Button Instance
		private var mTtoggleButton:Sprite;
		
		/**
		 * Toggle Button Enable State
		 **/
		public function set enable(state:Boolean):void
		{
			// Update the touchable state
			mTtoggleButton.touchable = state;
			// Update the alpha value
			if (state)	mTtoggleButton.alpha = 1;
			else		mTtoggleButton.alpha = 0.5;
		}
		
		/** 
		 * ToggleButton constructor
		 *   
		 * @param label Toggle Button Label
		 * @param toggle Toggle Initial state
		 * @param listener Button Event Listener Function. Optional, default = null
		 **/
		public function ToggleButton(label:String,toggle:Boolean,listener:Function = null)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");

			// Set button Label
			var toggleLabel:TextField = createLabel(label);
			toggleLabel.touchable = false;
			
			// Create the button
			mTtoggleButton = createSprite(toggle, listener);
			
			// Set Label position
			SpriteUtl.setPivot(toggleLabel,SpriteUtl.TOP);
			SpriteUtl.setPosition(toggleLabel,mTtoggleButton.width/2,0,false);
			
			// Set button position
			mTtoggleButton.y = toggleLabel.y+toggleLabel.height;
			
			// Add the button to the stage
			addChild(toggleLabel);
			addChild(mTtoggleButton);
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
			var label:TextField	= new TextField(1, 24, text);
			label.autoSize		= TextFieldAutoSize.HORIZONTAL;
			label.fontName		= Constants.FONT_NAME;
			label.fontSize		= Constants.FONT_SIZE_SMALL;
			label.color			= Constants.COL_FONT_LIGHT;
			label.hAlign		= HAlign.LEFT;
			label.vAlign		= VAlign.BOTTOM;
			label.touchable		= false;
			return label;
		}
		
		/** 
		 * Create the Toggle button Sprite Object
		 *   
		 * @param toggle Current toggle state
		 * @param listener Function to be executed when the button is toggled
		 * 
		 * @return Sprite Object of the Toggle Button
		 **/
		private function createSprite(toggle:Boolean, listener:Function):Sprite
		{
			// Set Toggle Button offsets
			const OFFSET_X:Number = 15;

			// Create the toggle bar Sprite
			var toggleSprite:Sprite = new Sprite();
			
			// Create the toggle On-State label and image
			var toggleBkg:Image = new Image(Root.assets.getTexture(Constants.IMG_TOGGLE_BKG));
			toggleSprite.addChild(toggleBkg);

			// On and Off X Local coordinate 
			const ON_X_LOC:Number	= toggleBkg.x + OFFSET_X;
			const OFF_X_LOC:Number	= toggleBkg.x + toggleBkg.width - OFFSET_X;
			
			// Create the toggle Button Background
			var toggleBtnBg:Quad = new Quad(30, 50);
			toggleBtnBg.alpha = 0;
			var toggleBtnImg:Image = new Image(Root.assets.getTexture(Constants.IMG_TOGGLE_BTN));
			toggleBtnImg.x = (toggleBtnBg.width - toggleBtnImg.width) * .5;
			toggleBtnImg.y = (toggleBtnBg.height - toggleBtnImg.height) * .5;
			
			// Create the toggle Button
			var toggleBtn:Sprite = new Sprite();
			toggleBtn.addChild(toggleBtnBg);
			toggleBtn.addChild(toggleBtnImg);
			toggleBtn.pivotX = toggleBtn.width * 0.5;
			toggleBtn.pivotY = Math.abs(toggleBtn.height - toggleSprite.height) * 0.5;
			toggleSprite.addChild(toggleBtn);
			
			// Create the toggle Button
			toggleSprite.addChild(toggleBtn);
			
			// Update button according to its state
			if (!toggle) toggleBtn.x	= OFF_X_LOC;
			else toggleBtn.x			= ON_X_LOC;

			// Button update parameters
			var beganX:Number = 0;

			// Create event listener for the toggle action
			toggleBtn.addEventListener(TouchEvent.TOUCH, function onTouch(e:TouchEvent):void
			{
				// toggle Background Global Position
				var globalPoint:Point	= toggleBkg.localToGlobal(new Point(0,0));				
				// On X Global coordinate 
				const ON_X_GLO:Number		= globalPoint.x + OFFSET_X;
				
				// Instance touch began state
				var began:Touch = e.getTouch(stage, TouchPhase.BEGAN);
				// Process if the touch is in began state
				if (began)
				{
					// Get touch began position (in local scale)
					beganX = began.globalX - ON_X_GLO;
				}
				
				// Instance touch moved state
				var moved:Touch = e.getTouch(stage, TouchPhase.MOVED);
				// Process if the touch is in moved state
				if (moved)
				{
					// Get moved position position (in local scale)
					var movedX:Number = moved.globalX - ON_X_GLO;
					// Update button position acording to the movment
					if		(movedX < ON_X_LOC)		toggleBtn.x = ON_X_LOC;
					else if (movedX > OFF_X_LOC)	toggleBtn.x = OFF_X_LOC;
					else							toggleBtn.x = movedX;
					return;
				}
				
				// Instance touch ended state
				var ended:Touch = e.getTouch(stage, TouchPhase.ENDED);
				// Process if the touch is in ended state
				if (ended)
				{
					// Get moved position position (in local scale)
					var endedX:Number = ended.globalX - ON_X_GLO;

					// Get Middle Point
					const MID_X:Number = OFF_X_LOC - ON_X_LOC - (OFFSET_X/2);
					
					// Update toggle button position
					if (endedX < MID_X)	toggleBtn.x = ON_X_LOC;
					else				toggleBtn.x = OFF_X_LOC;

					// Valuate the Toggle State
					var toggle:Boolean = toggleBtn.x == ON_X_LOC;
					
					// Play the button Sound 
					SoundManager.se.start(Constants.SND_BTN_CLICK);
					// Run toggle button specific function
					listener(toggle);
					return;
				}
			});

			// Return the toggle Sprite
			return toggleSprite;
		}
	}
}