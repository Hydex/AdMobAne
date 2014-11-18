package utils
{
	// Starling Includes
	import starling.display.DisplayObject;

	/**
	 * Sprites Utility Class<br/>
	 * Utilities for Sprite Management
	 * 
	 * @author Code Alchemy
	 **/
	public class SpriteUtl
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[SpriteUtl] ';
		
		// Alignment static constants
		static public const SAME:String			= "same";
		static public const CENTER:String		= "center";
		static public const BOTTOM:String		= "bottom";
		static public const TOP:String			= "top";
		static public const LEFT:String			= "left";
		static public const RIGHT:String		= "right";
		static public const TOPLEFT:String		= "topLeft";
		static public const TOPRIGHT:String		= "topRight";
		static public const BOTTOMLEFT:String	= "bottomLeft";
		static public const BOTTOMRIGHT:String	= "bottomRight";
		
		/** 
		 * SpriteUtl Constructor 
		 *  
		 **/
		public function SpriteUtl() {}
		
		/**
		 * Set the Pivot according to the given position
		 *  
		 * @param targetObj Target object 
		 * @param targetPivot Pivot destination
		 **/
		static public function setPivot(targetObj:DisplayObject,targetPivot:String):void
		{
			// Adjust the Pivot position acording to the target type
			switch (targetPivot)
			{
				case CENTER:
					targetObj.pivotX = int(targetObj.width/2);
					targetObj.pivotY = int(targetObj.height/2);
					break;
				case BOTTOM:
					targetObj.pivotX = int(targetObj.width/2);
					targetObj.pivotY = targetObj.height;
					break;
				case TOP:
					targetObj.pivotX = targetObj.width/2;
					targetObj.pivotY = 0;
					break;
				case LEFT:
					targetObj.pivotX = 0;
					targetObj.pivotY = int(targetObj.height/2);
					break;
				case RIGHT:
					targetObj.pivotX = targetObj.width;
					targetObj.pivotY = int(targetObj.height/2);
					break;
				case TOPLEFT:
					targetObj.pivotX = targetObj.pivotY = 0;
					break;
				case TOPRIGHT:
					targetObj.pivotX = targetObj.width;
					targetObj.pivotY = 0;
					break;
				case BOTTOMLEFT:
					targetObj.pivotX = 0;
					targetObj.pivotY = targetObj.height;
					break;
				case BOTTOMRIGHT:
					targetObj.pivotX = targetObj.width;
					targetObj.pivotY = targetObj.height;
					break;
			}
		}			
		
		/**
		 * Set the Position of an object according to the given parameters
		 *  
		 * @param targetObj DisplayObject to be positioned
		 * @param x X coordinate. Default value: 0
		 * @param y Y coordinate. Default value: 0
		 * @param toScale Indicate if the position is base in real scale (960x640). Optional, Default value: true
		 * @param scaleFact Scale Factor for the coordinate. Optional, Default value: 2
		 * @param allowFloat Indicate if float pixel values are allowed. Optional, Default value: false<br>
		 * (floats value are not really good for performance and pixelperfet positions)
		 **/
		static public function setPosition(targetObj:DisplayObject,x:Number = 0,y:Number = 0,toScale:Boolean = true,scaleFact:int = 2, allowFloat:Boolean = false):void
		{
			// Set the default scale
			var scale:int = 1;
			// Update the scale if needed
			if(toScale) scale = scaleFact;
			// Update the target position
			if(allowFloat){
				targetObj.x = x/scale;
				targetObj.y = y/scale;
			}else{
				targetObj.x = int(x/scale);
				targetObj.y = int(y/scale);
			}
		}

		/**
		 * Align the Source Object to the Target Object
		 * TODO: Check the operation, is not working really well
		 * 
		 * @param sourceObj DisplayObject to be aligned
		 * @param targetObj Reference DisplayObject
		 * @param targetPivot Pivot destination. Optional, Default Value: "same" which will simply place the object in the same coordinate
		 **/
		static public function alignTo(sourceObj:DisplayObject,targetObj:DisplayObject,targetPivot:String = SAME):void
		{
			// Check if the display object should be align to the same Pivot
			if (targetPivot != SAME)
			{
				// Calculate pivot offsets
				var clearX:Number = targetObj.x;
				var clearY:Number = targetObj.y;
				var offsetX:Number;
				var offsetY:Number;

				clearX = targetObj.x;
				clearY = targetObj.y;
				if (targetObj.pivotX != 0){
					offsetX = targetObj.width - targetObj.pivotX;
					clearX -= offsetX;
				}
				if (targetObj.pivotY != 0){
					offsetY = targetObj.height - targetObj.pivotY;
					clearY -= offsetY;
				}
				
				// Update the displayobject position acording to the target pivot
				switch (targetPivot)
				{
					case CENTER:
						sourceObj.x = int(clearX + (targetObj.width/2));
						sourceObj.y = int(clearY + (targetObj.height/2));
						break;
					case BOTTOM:
						sourceObj.x = int(clearX + (targetObj.width/2));
						sourceObj.y = clearY + targetObj.height;
						break;
					case TOP:
						sourceObj.x = int(clearX + (targetObj.width/2));
						sourceObj.y = clearY;
						break;
					case LEFT:
						sourceObj.x = clearX;
						sourceObj.y = int(clearY + (targetObj.height/2));
						break;
					case RIGHT:
						sourceObj.x = clearX + targetObj.width;
						sourceObj.y = int(clearY + (targetObj.height/2));
						break;
					case TOPLEFT:
						sourceObj.x = clearX;
						sourceObj.y = clearY;
						break;
					case TOPRIGHT:
						sourceObj.x = clearX + targetObj.width;
						sourceObj.y = clearY;
						break;
					case BOTTOMLEFT:
						sourceObj.x = clearX;
						sourceObj.y = clearY + targetObj.height;
						break;
					case BOTTOMRIGHT:
						sourceObj.x = clearX + targetObj.width;
						sourceObj.y = clearY + targetObj.height;
						break;
				
				}
			}else{
				// Update the displayobject position
				sourceObj.x = targetObj.x;
				sourceObj.y = targetObj.y;
			}
		}			
	}
}