package models.ui.controls
{
	// Flash Includes
	import flash.geom.Point;

	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/** 
	 * Gauge Class<br/>
	 * The class will construct and manage the Gauge
	 * 
	 * @author Code Alchemy
	 **/
	public class Gauge extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[FuncButton] ';
		
		// Ratio and Image instances
		private var mImage:Image;
		private var mRatio:Number;
		
		/**
		 * Gauge ratio instance
		 **/
		public function get ratio():Number
		{ return mRatio; }
		public function set ratio(value:Number):void
		{
			mRatio = Math.max(0.0, Math.min(1.0, value));
			update();
		}
		
		/**
		 * Gauge color instance
		 **/
		public function get color():uint
		{ return mImage.color; }
		public function set color(color:uint):void
		{ mImage.color = color; }
		
		/** 
		 * Gauge constructor
		 *   
		 * @param texture Gauge Texture
		 **/
		public function Gauge(texture:Texture)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Update Instances
			mRatio = 1.0;
			mImage = new Image(texture);
			// Add the Image
			addChild(mImage);
		}
		
		/** 
		 * Update the image according thecurrent ratio
		 *   
		 **/
		private function update():void
		{
			mImage.scaleX = mRatio;
			mImage.setTexCoords(1, new Point(mRatio, 0.0));
			mImage.setTexCoords(3, new Point(mRatio, 1.0));
		}
	}
}