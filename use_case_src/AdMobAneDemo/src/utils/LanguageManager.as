package utils
{
	// Flash Includes
	import flash.system.Capabilities;
	
	/** 
	 * LanguageManager Class<br/>
	 * The class will construct and manage the Language Manager
	 * 
	 * @author Code Alchemy
	 **/
	public class LanguageManager
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[LanguageManager] ';
		
		// Allowed languages Array
		static public const allowed:Array = new Array("it","en");
		
		// System locale instance
		static private var mLocale:String = Capabilities.language;
		
		/**
		 * Locale Language code
		 **/
		static public function get locale():String
		{
			// Get the current locale, if not supported return the default value
			if (allowed.indexOf(mLocale) < 0) return "en";
			// return the locale
			return mLocale;
		}
		static public function set locale(locale:String):void
		{
			if (allowed.indexOf(locale) < 0)	mLocale = Capabilities.language;
			else								mLocale = locale;
		}

		/**
		 * Language Manager Constructor
		 **/
		public function LanguageManager() {}
	}
}