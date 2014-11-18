package models.ui
{
	// Flash Includes
	import flash.text.TextFormat;
	
	// Feathers Includes
	import feathers.controls.ScrollText;
	import feathers.layout.AnchorLayoutData;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	
	// Game Utils Includes
	import utils.SpriteUtl;
	
	/** 
	 * Console Log Class<br/>
	 * The class will construct and manage the Console Log Window
	 * 
	 * @author Code Alchemy
	 **/
	public class ConsoleLog extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[ConsoleLog] ';
		
		// Log Type Constants
		static public const NORM:uint	= 0;
		static public const WARN:uint	= 1;
		static public const ERROR:uint = 2;
		
		// Console instance
		private var mLogContent:ScrollText;
		
		/** 
		 * Console Log constructor
		 * 
		 **/
		public function ConsoleLog()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Create the Background Image
			var console:Image = new Image(Root.assets.getTexture(Constants.IMG_CONSOLE_WIN));
			// Disable Interaction for the background
			console.touchable = false
			// Add the Background
			addChild(console);
			SpriteUtl.setPosition(this,24,67,false);
			// Scroll text Initialization
			mLogContent = new ScrollText();
			mLogContent.textFormat = new TextFormat(Constants.FONT_NAME,Constants.FONT_SIZE_SMALL,Constants.COL_WHITE);
			mLogContent.isHTML = true;
			mLogContent.width = console.width-20;
			mLogContent.height = console.height-20;
			SpriteUtl.setPosition(mLogContent,10,10,false);
			mLogContent.layoutData = new AnchorLayoutData (0,0,0,0);
			addChild(mLogContent);
		}
		
		/** 
		 * Add a line message to the console log
		 * 
		 * @param line Log message to be added
		 * @param type Type of log message (ConsoleLog.NORM, ConsoleLog.WARN or ConsoleLog.ERROR).<br>
		 * Optional, default = ConsoleLog.NORM
		 **/
		public function add(line:String,type:uint = 0):void
		{
			// Skyp invalid lines
			if (line == null) return;
			if (line == Constants.SYS_STR_EMPTY) return;
			
			// Normalize type
			if (isNaN(type)) type = NORM;
			if (type < 0 || type > 2) type = NORM;
			
			// htmltext, well...
			var htmlStyleOp:String = "<font color=\"#ffffff\">";
			var htmlStyleCl:String = "</font>";		
			if(type == WARN) htmlStyleOp = "<font color=\"#e6cc1c\">";
			else if(type == ERROR) htmlStyleOp = "<font color=\"#f72e2e\">";
			
			// Add the log line
			mLogContent.text += htmlStyleOp+line+htmlStyleCl;
			//mLogContent.text += line;

			// Add a line break
			mLogContent.text += Constants.SYS_LINEBREAK;
			// Scroll the log to the bottom
			mLogContent.scrollToPosition(NaN,mLogContent.maxVerticalScrollPosition);
		}
		
		/** 
		 * Clear the content of the console log
		 * 
		 **/
		public function clear():void
		{ mLogContent.text = ""; }
	}
}