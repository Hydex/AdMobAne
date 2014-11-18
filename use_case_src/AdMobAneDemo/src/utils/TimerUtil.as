package utils
{
	// Starling Includes
	import starling.utils.formatString;
	
	/** 
	 * TimerUtil Class<br/>
	 * The class will construct and manage the Timer Utility
	 * 
	 * @author Code Alchemy
	 **/
	public class TimerUtil
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[TimerUtil] ';
		
		/** 
		 * Current Local time<br/>
		 * Note: The resulted time is based in device time settings
		 * 
		 * @return local time in millesecond
		 **/
		static public function get nowLocal():Number
		{ return new Date().getTime() * 0.001; }
		
		/** 
		 * Current UTC time<br/>
		 * Note: The resulted time is based in device time settings (time/timezone)
		 * 
		 * @return UTC time in millesecond
		 **/
		static public function get nowUTC():Number
		{
			// Get the current time
			var zoneOffset:Number = new Date().getTimezoneOffset() * 60;
			// Add the timezone offset
			return nowLocal + zoneOffset;
		}

		/**
		 * Convert epoch to human readable time
		 * 
		 * @param time Epoch time to be converted
		 * @param format Format to be used. Optional, Default = "{0}:{1}:{2}" [{0} = hour, {1} = minute, {2} = second]
		 * @param padding Format padding to be used. Optional, Default = "00"
		 * 
		 * @return Human readable formatted time
		 **/
		static public function format(time:Number, format:String = "{0}:{1}:{2}", padding:String = "00"):String
		{
			// Set the keta value
			var keta:Number = !padding ? 0 : padding.length;
			
			// Set the tme value
			var hour:String = String(Math.floor(time / 3600));
			var minute:String = String(Math.floor(time % 3600 / 60));
			var second:String = String(Math.floor(time % 60));
			
			// Return the formatted string
			return formatString(format, //
				!padding ? hour : (padding + hour).substr(-keta), //
				!padding ? minute : (padding + minute).substr(-keta), //
				!padding ? second : (padding + second).substr(-keta));
		}
		
		/**
		 * Convert epoch to human readable local date and time
		 * 
		 * @param time Epoch time to be converted
		 * @param format Format to be used. Optional, Default = "{0}-{1}-{2} {3}:{4}:{5}.{6}"
		 * @param padding Format padding to be used. Optional, Default = "00"
		 * 
		 * @return Human readable formatted Local date and time
		 **/
		static public function dateFormat(time:Number, format:String = "{0}-{1}-{2} {3}:{4}:{5}.{6}", padding:String = "00"):String
		{
			// Set the keta value
			var keta:Number = !padding ? 0 : padding.length;
			// Create a new date  from the given time
			var date:Date = new Date();
			date.setTime(time * 1000);
			
			// Get time values
			var year:String = String(date.getFullYear());
			var month:String = String(date.getMonth() + 1);
			var day:String = String(date.getDate());
			var hour:String = String(date.getHours());
			var minute:String = String(date.getMinutes());
			var second:String = String(date.getSeconds());
			var milliseconds:String = String(date.getMilliseconds());
			
			// Return the formatted string
			return formatString(format, //
				!padding ? year : (padding + year).substr(-keta), //
				!padding ? month : (padding + month).substr(-keta), //
				!padding ? day : (padding + day).substr(-keta), //
				!padding ? hour : (padding + hour).substr(-keta), //
				!padding ? minute : (padding + minute).substr(-keta), //
				!padding ? second : (padding + second).substr(-keta),
				!padding ? milliseconds : milliseconds);
		}
	}
}