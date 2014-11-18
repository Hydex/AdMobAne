package
{
	// Starling Includes
	import starling.errors.AbstractClassError;
	
	/**
	 * Game Constants Class<br/>
	 * The class will construct and manage the Game Constants
	 * 
	 * @author Code Alchemy
	 **/
	public class Constants
	{
		// Define Main Game Constants
		static public const CODEALCHEMY_SITE:String			= "http://www.code-alchemy.com/";

		// AdMob Ids Constants
		static public const ADMOB_TEST_ID_AND:String		= "Add_here_the_test_device_id_for_Andoid";
		static public const ADMOB_TEST_ID_IOS:String		= "Add_here_the_test_device_id_for_iOS";
		static public const ADMOB_BANNER_AND:String			= "Add_here_the_Banner_AdMobID_for_Andoid";
		static public const ADMOB_BANNER_IOS:String			= "Add_here_the_Banner_AdMobID_for_iOS";
		static public const ADMOB_INTERSTITIAL_AND:String	= "Add_here_the_Interstitial_AdMobID_for_Andoid";
		static public const ADMOB_INTERSTITIAL_IOS:String	= "Add_here_the_Interstitial_AdMobID_for_iOS";
		
		// Localization Messages Map Constants
		static public const MSG_NO_INTERNET:String			= "NOCONNEC";
		static public const MSG_UNSUPPORTED:String			= "UNSUPPOR";
		static public const MSG_MENU_FUNC:String			= "MMENU00";
		static public const MSG_BACK_BTN:String				= "MMENUBCK";
		static public const MSG_ENABLE:String				= "ST000001";
		static public const MSG_VOLUME:String				= "ST000002";
		static public const MSG_AUTOSHOW:String				= "ST000003";
		static public const MSG_APPLYALL:String				= "ST000004";
		static public const MSG_RELPOS:String				= "ST000005";
		static public const MSG_SMARTB:String				= "ST000006";
		static public const MSG_ANIMATE:String				= "ST000007";
		static public const MSG_FUNC_CREATE:String			= "FUNC0001";
		static public const MSG_FUNC_SHOW:String			= "FUNC0002";
		static public const MSG_FUNC_HIDE:String			= "FUNC0003";
		static public const MSG_FUNC_DESTROY:String			= "FUNC0004";
		static public const MSG_FUNC_UP:String				= "FUNC0005";
		static public const MSG_FUNC_DOWN:String			= "FUNC0006";
		static public const MSG_FUNC_LEFT:String			= "FUNC0007";
		static public const MSG_FUNC_RIGHT:String			= "FUNC0008";
		static public const MSG_FUNC_INC:String				= "FUNC0009";
		static public const MSG_FUNC_DEC:String				= "FUNC0010";
		static public const MSG_LABEL_BGM:String			= "ST000010";
		static public const MSG_LABEL_FX:String				= "ST000020";
		static public const MSG_LABEL_LANG:String			= "ST000050";
		static public const MSG_LANG_SYS:String				= "LANG0001";
		static public const MSG_LANG_EN:String				= "LANG0002";
		static public const MSG_LANG_IT:String				= "LANG0003";
		static public const MSG_COMBO_DEFAULT:String		= "CMB00001";
		static public const MSG_COMBO_NEW:String			= "CMB00002";
		static public const MSG_COMBO_B_BANNER:String		= "CMB00003";
		static public const MSG_COMBO_B_SIZE:String			= "CMB00004";
		static public const MSG_COMBO_B_POS:String			= "CMB00005";
		static public const MSG_LARGE_BANNER:String			= "CMBVAL10";
		static public const MSG_BANNER:String				= "CMBVAL11";
		static public const MSG_MEDIUM_RECTANGLE:String		= "CMBVAL12";
		static public const MSG_FULL_BANNER:String			= "CMBVAL13";
		static public const MSG_LEADERBOARD:String			= "CMBVAL14";
		static public const MSG_WIDE_SKYSCRAPER:String		= "CMBVAL15";
		static public const MSG_SMART_BANNER:String			= "CMBVAL16";
		static public const MSG_SMART_BANNER_PORT:String	= "CMBVAL17";
		static public const MSG_SMART_BANNER_LAND:String	= "CMBVAL18";
		static public const MSG_TOP_LEFT:String				= "CMBVAL21";
		static public const MSG_TOP_CENTER:String			= "CMBVAL22";
		static public const MSG_TOP_RIGHT:String			= "CMBVAL23";
		static public const MSG_MIDDLE_LEFT:String			= "CMBVAL24";
		static public const MSG_MIDDLE_CENTER:String		= "CMBVAL25";
		static public const MSG_MIDDLE_RIGHT:String			= "CMBVAL26";
		static public const MSG_BOTTOM_LEFT:String			= "CMBVAL27";
		static public const MSG_BOTTOM_CENTER:String		= "CMBVAL28";
		static public const MSG_BOTTOM_RIGHT:String			= "CMBVAL29";
		static public const MSG_WIN:String					= "GAME0001";
		static public const MSG_LOSE:String					= "GAME0002";
		static public const MSG_OK:String					= "GAME0003";
		static public const MSG_LOADING:String				= "GAME0004";
		static public const MSG_RULES:String				= "GAME0005";
		static public const MSG_NODEMO:String				= "GAME0006";
		static public const LOG_SUPPORT:String				= "LOG00000";
		static public const LOG_AUTOSHOW_ENABLE:String		= "LOG00100";
		static public const LOG_APPLYALL_ENABLE:String		= "LOG00200";
		static public const LOG_RELATIVE_ENABLE:String		= "LOG00300";
		static public const LOG_SMART_ENABLE:String			= "LOG00400";
		static public const LOG_BANNER_NO_SIZE:String		= "LOG00500";
		static public const LOG_BANNER_NO_POS:String		= "LOG00501";
		static public const LOG_BANNER_X_NONUMBER:String	= "LOG00502";
		static public const LOG_BANNER_Y_NONUMBER:String	= "LOG00503";
		static public const LOG_BANNER_CREATE:String		= "LOG00504";
		static public const LOG_BANNER_SHOW:String			= "LOG00505";
		static public const LOG_BANNER_SHOWSEL:String		= "LOG00506";
		static public const LOG_BANNER_SHOWALL:String		= "LOG00507";
		static public const LOG_BANNER_HIDE:String			= "LOG00508";
		static public const LOG_BANNER_HIDESEL:String		= "LOG00509";
		static public const LOG_BANNER_HIDEALL:String		= "LOG00510";
		static public const LOG_BANNER_DESTROY:String		= "LOG00511";
		static public const LOG_BANNER_DESTROYSEL:String	= "LOG00512";
		static public const LOG_BANNER_DESTROYALL:String	= "LOG00513";
		static public const LOG_BANNER_LOADED:String		= "LOG00514";
		static public const LOG_BANNER_FAILED:String		= "LOG00515";
		static public const LOG_INTER_LOADED:String			= "LOG00600";
		static public const LOG_INTER_FAILED:String			= "LOG00601";
		static public const LOG_INTER_CLOSE:String			= "LOG00602";
		static public const LOG_INTER_DESTROY:String		= "LOG00603";
		
		// Colors Map Constants
		static public const COL_WHITE:uint					= 0xFFFFFF;
		static public const COL_BLACK:uint					= 0x000000;
		static public const COL_BACKGROUND:uint				= 0x202020;
		static public const COL_FONT_DARK:uint				= 0xaa0101;
		static public const COL_FONT_LIGHT:uint				= 0xebebeb;
		static public const COL_HIGHLIGHT_RED:uint			= 0xb62929;
		
		// Image Name Map Constants
		static public const IMG_BTN_BACK_UP:String			= "ButtonBack_Up";
		static public const IMG_BTN_BACK_DOWN:String		= "ButtonBack_Down";
		static public const IMG_BTN_BIG_UP:String			= "ButtonBig_Up";
		static public const IMG_BTN_BIG_DOWN:String			= "ButtonBig_Down";
		static public const IMG_BTN_SMALL_UP:String			= "ButtonSmall_Up";
		static public const IMG_BTN_SMALL_DOWN:String		= "ButtonSmall_Down";
		static public const IMG_SEL_BKG:String				= "selectorBkg";
		static public const IMG_SEL_FRAME:String			= "selectorFrame";
		static public const IMG_SEL_FRAME_BKG:String		= "selectorFrameBkg";
		static public const IMG_SLIDE_FILL:String			= "sliderFill";
		static public const IMG_SLIDE_BKG:String			= "sliderBkg";
		static public const IMG_SLIDE_BTM:String			= "sliderBtn";
		static public const IMG_INPUT_BKG:String			= "InputBox";
		static public const IMG_INPUT_FOC:String			= "InputBoxFoc";
		static public const IMG_TOGGLE_BKG:String			= "toggleBkg";
		static public const IMG_TOGGLE_BTN:String			= "toggleBtn";
		static public const IMG_COMBOBOX:String				= "comboBox";
		static public const IMG_COMBOFIELD:String			= "comboField";
		static public const IMG_AD_FRAME:String				= "adFrame";
		static public const IMG_AD_OFFLINE:String			= "adOffline";
		static public const IMG_CONSOLE_WIN:String			= "ConsoleLog";
		static public const IMG_ADMOB_LOGO:String			= "AdMobLogo";
		static public const IMG_CODE_ALCHEMY:String			= "CodeAlchemy";
		static public const IMG_MAGE:String					= "Mage";
		static public const IMG_VIRUS:String				= "Virus";
		
		// Sounds Name Map Constants
		static public const SND_BGM_MENU:String				= "menuBgm";
		static public const SND_BGM_GAME:String				= "gameBgm";
		static public const SND_BTN_CLICK:String			= "buttonClick";
		
		// Fonts Constants
		static public const FONT_NAME:String				= "Barrett";
		static public const FONT_SIZE_BIG:uint				= 24;
		static public const FONT_SIZE_SMALL:uint			= 12;
		static public const FONT_SIZE_BACK:uint				= 15;
		static public const FONT_SIZE_LABEL:uint			= 18;
		
		// System Constants
		static public const SYS_LINEBREAK:String			= "\n";
		static public const SYS_STR_EMPTY:String			= "";
		
		// Stage Dimensions
		static public const STAGE_WIDTH:int					= 320;
		// Variable Stage Height (yes, i know... it is not a constant...)
		static public var STAGE_HEIGHT:int					= 480;

		/**
		 * Constants Construictor
		 * @throws AbstractClassError Abstarct class Istances cannot be created
		 **/
		public function Constants() { throw new AbstractClassError(); }
	}
}