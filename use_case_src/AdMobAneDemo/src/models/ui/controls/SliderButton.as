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
	import utils.SpriteUtl;
	
	/** 
	 * Slider Button Class<br/>
	 * The class will construct and manage the Slider Button
	 * 
	 * @author Code Alchemy
	 **/
	public class SliderButton extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[SliderButton] ';
		
		/** 
		 * SliderButton constructor
		 *   
		 * @param label Slider label
		 * @param value Slider Initial value
		 * @param moveListener Slider on moving Event Listener Function. Optional, default = null
		 * @param endListener Button on end move Event Listener Function. Optional, default = null
		 **/
		public function SliderButton(label:String,value:uint,moveListener:Function = null,endListener:Function = null)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Set button Label
			var sliderLabel:TextField = createLabel(label);
			// Create the button
			var sliderSprite:Sprite = createSprite(value,moveListener,endListener);
			
			// Set Label position
			SpriteUtl.setPivot(sliderLabel,SpriteUtl.TOP);
			SpriteUtl.setPosition(sliderLabel,sliderSprite.width/2,0,false);
			
			// Set button position
			sliderSprite.y = sliderLabel.y+sliderLabel.height+3;
			
			// Add the button to the stage
			addChild(sliderLabel);
			addChild(sliderSprite);
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
		 * Create the Slider Sprite Object
		 *   
		 * @param value Slider Initial value
		 * @param moveListener Slider on moving Event Listener Function. Optional, default = null
		 * @param endListener Button on end move Event Listener Function. Optional, default = null
		 * 
		 * @return Sprite Object of the Slider Sprite
		 **/
		private function createSprite(value:uint,moveListener:Function = null,endListener:Function = null):Sprite
		{
			// Create Slider Gauge fill
			var sliderBar:Gauge = new Gauge(Root.assets.getTexture(Constants.IMG_SLIDE_FILL));
			// Create Slider Background
			var sliderBkg:Image = new Image(Root.assets.getTexture(Constants.IMG_SLIDE_BKG));
			sliderBar.addChildAt(sliderBkg, 0);
			
			// Create slider button
			var sliderBtnBg:Quad = new Quad(50, 50);
			sliderBtnBg.alpha = 0;
			var sliderBtnImg:Image = new Image(Root.assets.getTexture(Constants.IMG_SLIDE_BTM));
			sliderBtnImg.x = (sliderBtnBg.width - sliderBtnImg.width) * .5;
			sliderBtnImg.y = (sliderBtnBg.height - sliderBtnImg.height) * .5;
			var sliderBtn:Sprite = new Sprite();
			sliderBtn.addChild(sliderBtnBg);
			sliderBtn.addChild(sliderBtnImg);
			sliderBtn.pivotX = sliderBtn.width * 0.5;
			sliderBtn.pivotY = (sliderBtn.height - sliderBkg.height) * 0.5;
			sliderBar.addChild(sliderBtn);
			
			// Set the max slider width
			var maxX:Number = sliderBkg.width;
			// Add the slider event listeners
			sliderBtn.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void
			{
				// Slider Bar Background Global Position
				var globalPoint:Point	= sliderBar.localToGlobal(new Point(0,0));				
				// Set the minimum slider global position
				const VOL_MIN_GLO:Number = globalPoint.x+20;
				
				// Instance touch moved state
				var moved:Touch = e.getTouch(stage, TouchPhase.MOVED);
				// Process if the touch is in moving state
				if (moved)
				{
					// Update slider button position (in local scale)
					var movedX:Number = moved.globalX - VOL_MIN_GLO;
					if (movedX < 0) sliderBtn.x = 0;
					else if (movedX > maxX) sliderBtn.x = maxX;
					else sliderBtn.x = movedX;
					// Update Volume Bar ration
					sliderBar.ratio = sliderBtn.x / maxX;
					// Run bar specific function
					if(moveListener != null) moveListener(Math.floor(sliderBar.ratio * 100));
					return;
				}
				
				// Instance touch ended state
				var ended:Touch = e.getTouch(stage, TouchPhase.ENDED);
				// Process if the touch is in ended state
				if (ended)
				{
					// Update slider button position (in local scale)
					var endedX:Number = ended.globalX - VOL_MIN_GLO;
					if (endedX < 0) sliderBtn.x = 0;
					else if (endedX > maxX) sliderBtn.x = maxX;
					else sliderBtn.x = endedX;
					// Update Volume Bar ration
					sliderBar.ratio = sliderBtn.x / maxX;
					// Run bar specific function
					if(endListener != null) endListener(Math.floor(sliderBar.ratio * 100));
					return;
				}
			});
			
			// Set Volume Bar ration
			sliderBar.ratio = value / 100;
			// Set slider button position
			sliderBtn.x = value / 100 * maxX;
			// Add the Volue Bar
			return sliderBar;
		}
	}
}