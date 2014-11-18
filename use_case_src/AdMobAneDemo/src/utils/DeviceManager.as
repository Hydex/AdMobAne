package utils
{
	// Flash Includes
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.system.Capabilities;
	
	// Starling Includes
	import starling.core.Starling;
	
	/** 
	 * Device Manager Class<br/>
	 * The class will construct and manage the Device Manager Utility
	 * 
	 * @author Code Alchemy
	 **/
	public class DeviceManager
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[DeviceManager] ';
		
		// Device types constants
		static public const DEVICE_IOS:String		= "iOS";
		static public const DEVICE_ANDROID:String	= "Android";
		
		// Orientation types constants
		static public const ROTATED_RIGHT:uint	= 1;
		static public const PORTRAIT:uint		= 2;
		static public const ROTATED_LEFT:uint	= 3;
		static public const AUTO:uint			= 4;
		
		// Orientation reference sprite
		static private var _orientObject:Sprite;
		
		/**
		 * iOS Device State
		 **/
		static public function get isIos():Boolean
		{ return Capabilities.manufacturer.indexOf(DEVICE_IOS) != -1; }
		
		/**
		 * Android Device State
		 **/
		static public function get isAndroid():Boolean
		{ return Capabilities.manufacturer.indexOf(DEVICE_ANDROID) != -1; }
		
		/**
		 * Tablet Device State
		 **/
		static public function get isTablet():Boolean
		{ return ((Capabilities.screenResolutionX / Capabilities.screenDPI) > 5 ? true : false); }
		
		/**
		 * Orientation value
		 **/
		static public function get orientation():String
		{
			// Check if the Orientation instance is already available
			if (!_orientObject)
			{
				// Create the new orientation sprite
				_orientObject = new Sprite();
				// Add the sprite to the native overlay
				Starling.current.nativeOverlay.addChild(_orientObject);
			}
			
			// Get the current device orientation
			var orient:String = _orientObject.stage.deviceOrientation;
			
			// Return the result
			switch (orient)
			{
				case StageOrientation.ROTATED_LEFT: 
				case StageOrientation.ROTATED_RIGHT: 
				case StageOrientation.UPSIDE_DOWN: 
					return orient;
					
				default: 
					return StageOrientation.DEFAULT;
			}
		}
	}
}