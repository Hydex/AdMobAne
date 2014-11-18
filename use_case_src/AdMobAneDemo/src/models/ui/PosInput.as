package models.ui
{
	// Game UI Models Includes
	import models.ui.controls.InputBox;
	
	// Starling Includes
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	// Game Utls Includes
	import utils.SpriteUtl;
	
	/** 
	 * Position Input Class<br/>
	 * The class will construct and manage the Position Input
	 * 
	 * @author Code Alchemy
	 **/
	public class PosInput extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[PosInput] ';
		
		// Position Input instances
		private var mXInput:InputBox;
		private var mYInput:InputBox;
		
		/**
		 * Currently entered X value
		 **/
		public function get xValue():String
		{ return mXInput.value; }
		
		/**
		 * Currently entered Y value
		 **/
		public function get yValue():String
		{ return mYInput.value; }
		
		/**
		 * X field enable state
		 **/
		public function set enableX(val:Boolean):void
		{
			// Update the enable state
			mXInput.enable = val;
			// Update text and alpha value according the given state
			if(val){
				mXInput.value = "";
				mXInput.alpha = 1;
			}else{
				mXInput.value = "0";
				mXInput.alpha = 0.5;
			}
		}
		
		/** 
		 * Position Input constructor
		 * 
		 **/
		public function PosInput()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Create the control Label
			var inputLabel:TextField = createLabel(Root.getMsg(Constants.MSG_COMBO_B_POS));
			addChild(inputLabel);
			
			// Create the x cord. input field
			mXInput = new InputBox("x:");
			SpriteUtl.setPosition(mXInput,105,0,false);
			addChild(mXInput);
			
			// Create the y cord. input field
			mYInput = new InputBox("y:");
			SpriteUtl.setPosition(mYInput,201,0,false);
			addChild(mYInput);
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
			label.vAlign		= VAlign.TOP;
			label.touchable		= false;
			return label;
		}
	}
}