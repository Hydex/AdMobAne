package models.ui
{
	// Starling Includes
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/** 
	 * Scene Background Class<br/>
	 * The class will construct and manage the Scene Background
	 * 
	 * @author Code Alchemy
	 **/
	public class SceneBackground extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[SceneBackground] ';

		/** 
		 * SceneBackground constructor
		 * 
		 **/
		public function SceneBackground()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Create the Background Image
			var background:Quad = new Quad(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT,Constants.COL_BACKGROUND);
			// Add the Background
			addChild(background);
			// Disable Interaction
			touchable = false;
		}
	}
}