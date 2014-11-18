package events
{
	/**
	 * Game State Class<br/>
	 * The class will define the Game States
	 * 
	 * @author Code Alchemy
	 **/
	public class GameState
	{
		// Game States
		public static const STATE_HOME:String			= "stateHome";
		public static const STATE_GAME:String			= "stateGame";
		public static const STATE_SINGLE_BANNER:String	= "stateSingleBanner";
		public static const STATE_MULTI_BANNER:String	= "stateMultiBanner";
		public static const STATE_MOVE_BANNER:String	= "stateMoveBanner";
		public static const STATE_ROTATE_BANNER:String	= "stateRotateBanner";
		public static const STATE_INTERSTITIAL:String	= "stateInterstitial";
		public static const STATE_CONFIG:String			= "stateConfig";
		
		/** Constructor */
		public function GameState(){}
	}
}