package models.data
{
	// Flash Includes
	import flash.display.StageOrientation;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	// Game Includes
	import utils.DeviceManager;
	import utils.LanguageManager;
	
	/** 
	 * Config Class<br/>
	 * The class will construct and manage the Game configuration
	 * 
	 * @author Code Alchemy
	 **/
	public class Config
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[Config] ';
		
		// Config Proprierties constants
		private const PROP_SO:String					= "AdMobAneDemo_configuration";
		private const PROP_ORIENTATION:String			= "orientation";
		private const PROP_LANGUAGE:String				= "language";
		private const PROP_BGM_ENABLE:String			= "bgmEnable";
		private const PROP_BGM_VOLUME:String			= "bgmVolume";
		private const PROP_SE_ENABLE:String				= "seEnable";
		private const PROP_SE_VOLUME:String				= "seVolume";
		
		// Default Values
		private const DEFAULT_VOL_VALUE:uint		= 50;
		private const DEFAULT_LANGUAGE_VALUE:String	= "sys";
		
		// Shared Object Instance
		private var mSo:SharedObject;
		
		/** 
		 * Shared Object
		 **/
		private function get so():SharedObject
		{ return mSo; }

		/** 
		 * Background Music enable state
		 **/
		public function get bgmEnable():Boolean
		{ return so.data.bgmEnable; }
		public function set bgmEnable(bgmEnable:Boolean):void
		{ so.data.bgmEnable = bgmEnable; }
		
		/** 
		 * Background Music Volume Value
		 **/
		public function get bgmVolume():uint
		{ return so.data.bgmVolume; }
		public function set bgmVolume(bgmVolume:uint):void
		{ so.data.bgmVolume = bgmVolume; }
		
		/** 
		 * Sound Effects enable state
		 **/
		public function get seEnable():Boolean
		{ return so.data.seEnable; }
		public function set seEnable(seEnable:Boolean):void
		{ so.data.seEnable = seEnable; }
		
		/** 
		 * Sound Effects Volume Value
		 **/
		public function get seVolume():uint
		{ return so.data.seVolume; }
		public function set seVolume(seVolume:uint):void
		{ so.data.seVolume = seVolume; }
		
		/** 
		 * Device orientation value
		 **/
		public function get orientation():uint
		{
			// If there is not proprerty yet, return the default value
			if (!so.data.hasOwnProperty(PROP_ORIENTATION)) orientation = DeviceManager.AUTO;
			
			// Return the saved orientation value
			return so.data.orientation;
		}
		public function set orientation(orientation:uint):void
		{ so.data.orientation = orientation; }
		
		/** 
		 * Current language id
		 **/
		public function get lang():String
		{
			// If there is not proprerty yet, return the default value
			if (!so.data.hasOwnProperty(PROP_LANGUAGE)) return DEFAULT_LANGUAGE_VALUE;
			// Return the saved language value
			return so.data.language;
		}
		public function set lang(lang:String):void
		{
			// Set the given language
			so.data.language = lang;
			// Update language manager locale
			LanguageManager.locale = lang;
		}
		
		/** 
		 * Config Constructor<br/>
		 * 
		 */
		public function Config()
		{
			// Create new shared object if not available
			if (!so) mSo = SharedObject.getLocal(PROP_SO);
			
			// Set default Background music state if not available
			if (!so.data.hasOwnProperty(PROP_BGM_ENABLE)) bgmEnable	= true;
			
			// Set default Background music volume if not available
			if (!so.data.hasOwnProperty(PROP_BGM_VOLUME)) bgmVolume	= DEFAULT_VOL_VALUE;
			
			// Set default Sound Effects state if not available
			if (!so.data.hasOwnProperty(PROP_SE_ENABLE)) seEnable	= true;
			
			// Set default Sound Effects volume if not available
			if (!so.data.hasOwnProperty(PROP_SE_VOLUME)) seVolume	= DEFAULT_VOL_VALUE;
		}
		
		/** 
		 * Get the current device orientation
		 * 
		 * @return current device orientation value
		 **/
		public function getOrientation():String
		{
			if(orientation == DeviceManager.PORTRAIT)			return StageOrientation.DEFAULT;
			else if(orientation == DeviceManager.ROTATED_LEFT)	return StageOrientation.ROTATED_LEFT;
			else if(orientation == DeviceManager.ROTATED_RIGHT)	return StageOrientation.ROTATED_RIGHT;
			else												return DeviceManager.orientation;
		}
	
		/**
		 * Save the Config Property Data
		 * 
		 * @return Success state of the save
		 **/
		public function save():Boolean
		{
			// Save the data locally and retrieve the result
			var saveResult:String = so.flush();
			
			// Check if the data saving was completed
			if(saveResult == SharedObjectFlushStatus.FLUSHED) {
				// Debug Logger
				Root.log(LOG_TAG,"save successful");
				return true;
			}else{
				// Debug Logger
				Root.log(LOG_TAG,"save failed");
				return false;
			}
		}
	}
}
