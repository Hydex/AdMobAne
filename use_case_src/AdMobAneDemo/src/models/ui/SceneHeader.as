package models.ui
{
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	
	/** 
	 * Scene Header Class<br/>
	 * The class will construct and manage the Scene Header
	 * 
	 * @author Code Alchemy
	 **/
	public class SceneHeader extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[SceneHeader] ';
		
		/** 
		 * SceneHeader constructor
		 * 
		 **/
		public function SceneHeader()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Create the Sphere Logo
			var admobLogo:Image = new Image(Root.assets.getTexture(Constants.IMG_ADMOB_LOGO));
			addChild(admobLogo);
			
			// Create the Kanji Label
			var codeAlchemy:Image = new Image(Root.assets.getTexture(Constants.IMG_CODE_ALCHEMY));
			codeAlchemy.x = Constants.STAGE_WIDTH - codeAlchemy.width;
			addChild(codeAlchemy);
			
			// Disable Interaction
			touchable = false;
		}
	}
}