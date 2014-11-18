package scenes
{
	// AdMob ANE Includes
	import com.codealchemy.ane.admobane.AdMobEvent;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	import com.codealchemy.ane.admobane.AdSize;
	import com.codealchemy.ane.admobane.ScreenSize;
	
	// Game Events Includes
	import events.GameEvent;
	import events.GameState;
	
	// Feathers Includes
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	
	// Game UI Models Includes
	import models.ui.ConsoleLog;
	import models.ui.PosInput;
	import models.ui.SceneBackground;
	import models.ui.SceneHeader;
	import models.ui.controls.BackButton;
	import models.ui.controls.ComboBox;
	import models.ui.controls.FuncButton;
	import models.ui.controls.ToggleButton;
	
	// Starling Includes
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	// Game Utils Includes
	import utils.AdsManager;
	import utils.DeviceManager;
	import utils.SpriteUtl;
	
	/**
	 * Single Banner Demo Scene Class<br/>
	 * The class will construct and manage the Single Banner Demo Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class SingleBannerScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[SingleBannerScene] ';
		
		// Unique banner id for the sigle banner demo
		private const BANNERID:String ='DemoSingleBanner';
		
		// Banner States Constants
		private const AD_NONE:uint			= 0;
		private const AD_LOAD:uint			= 1;
		private const AD_ERROR:uint			= 2;
		private const AD_SHOW:uint			= 3;
		private const AD_HIDE:uint			= 4;
		
		// Banner State Instance
		private var BannerState:uint		= AD_NONE;
		
		// Dimension instances
		private var mScreenSize:ScreenSize;
		private var mBannerSize:AdSize;
		private var mBannerScaleFactor:Number = 1;
		
		// Console instances
		private var mConsole:Sprite;
		private var mConsoleLog:ConsoleLog;
		private var mAutoShow:Boolean = true;
		private var mRelativePos:Boolean = true;
		private var mSmartBanner:Boolean = true;
		private var mSizeCombo:ComboBox;
		private var mPosCombo:ComboBox;
		private var mPosInput:PosInput;
		private var mCreateBtn:FuncButton;
		private var mMultiBtn:FuncButton;
		private var mDestroyBtn:FuncButton;
		
		// Data instances
		private var mBannerSizeData:Array;
		private var mBannerPosData:Array;
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Single Banner Demo Scene constructor
		 * 
		 **/
		public function SingleBannerScene()
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Add loading and unloading event listeners
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		/** 
		 * Event listener for Scene added to stage <br/>
		 *   
		 * @param e Event Object
		 **/
		private function onAddedToStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onAddedToStage");
			
			// Remove unnecessary event listeners
			removeEventListeners(Event.ADDED_TO_STAGE);
			// Init the scene
			init();
		}
		
		/** 
		 * Event listener for Scene removed from stage <br/>
		 *  
		 * @param e Event Object
		 **/
		private function onRemovedFromStage(e:Event):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onRemovedFromStage");
			
			// Restore Feathers defaultTextRendererFactory
			/* This because it was changed on combobox control which is use in this scene,
				If we dont restore it the render of any Feathers related control/class will be compromised.
				(For example the Credit scene)
			*/
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{ return new BitmapFontTextRenderer() }

			// Clear Data
			BannerState		= 0;
			mBannerSizeData	= null;
			mBannerPosData	= null;
			
			// Remove all the event listeners
			removeAdEventsListeners();
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Single Banner Demo Scene
		 *   
		 **/
		private function init():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"Initializing...");
			
			// Set the banner and position Data
			setData();
			
			// Add the Scene Background
			var sceneBackground:SceneBackground = new SceneBackground();
			addChild(sceneBackground);
			
			// Add the Scene Header
			var sceneHeader:SceneHeader = new SceneHeader();
			addChild(sceneHeader);
			
			// Add the Back Button
			var BackBtn:BackButton = new BackButton(onBack);
			addChild(BackBtn);
			
			// Add the Back Button
			mConsoleLog = new ConsoleLog();
			addChild(mConsoleLog);
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_SUPPORT)+AdsManager.isSupported);
			
			// Add the offline banner instance and activate the banner
			addChild(AdsManager.offlineBanner);
			AdsManager.disposeAppBanner();
			
			// Update the screens Size
			mScreenSize =  AdsManager.getScreenSize();
			/* 
			 * Get the Banner scale fator
			 * By default is set to 1.
	 		 * we change id only for Android devices (no tabled)
			 * (It is correct?)
			 */
			if(!DeviceManager.isTablet && DeviceManager.isAndroid) mBannerScaleFactor = Root.assets.scaleFactor;
			
			// Add the Scene Context
			createMainConsole();
			SpriteUtl.setPivot(mConsole,SpriteUtl.CENTER);
			SpriteUtl.setPosition(mConsole,Constants.STAGE_WIDTH/2,Constants.STAGE_HEIGHT*0.7,false);
			addChild(mConsole);
			
			// Add the Ad Event Lsteners
			addAdEventsListeners();
		}
		
		/** 
		 * Create the Scene main Console
		 *   
		 **/
		private function createMainConsole():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"createMainConsole");
			
			// Console proprierty
			mConsole = new Sprite();
			
			// Create the console frame
			var cFrame:Quad = new Quad(270,115);
			cFrame.alpha = 0;
			mConsole.addChild(cFrame);
			
			// Create the Autoshow Option Toggle
			var autoShowToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_AUTOSHOW), mAutoShow,toggleAutoShow);
			mConsole.addChild(autoShowToggle);
			
			// Create the Relative Position Option Toggle
			var relativePosToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_RELPOS), mRelativePos,toggleRelativePos);
			SpriteUtl.setPivot(relativePosToggle,SpriteUtl.TOP);
			SpriteUtl.setPosition(relativePosToggle,cFrame.width/2,0,false);
			mConsole.addChild(relativePosToggle);
			
			// Create the Smart Banner Option Toggle
			var smartBannerToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_SMARTB), mSmartBanner,toggleSmartBanner);
			SpriteUtl.setPivot(smartBannerToggle,SpriteUtl.TOPRIGHT);
			SpriteUtl.setPosition(smartBannerToggle,cFrame.width,0,false);
			mConsole.addChild(smartBannerToggle);
			
			// Add the Size Selection Combo Box
			mSizeCombo = new ComboBox(Root.getMsg(Constants.MSG_COMBO_B_SIZE),mBannerSizeData);
			SpriteUtl.setPosition(mSizeCombo,0,46,false);
			mSizeCombo.enable = !mSmartBanner;
			mConsole.addChild(mSizeCombo);
			
			// Add the Position Selection Combo Box
			mPosCombo = new ComboBox(Root.getMsg(Constants.MSG_COMBO_B_POS),mBannerPosData);
			SpriteUtl.setPosition(mPosCombo,0,70,false);
			mPosCombo.visible = mRelativePos;
			mConsole.addChild(mPosCombo);
			
			// Add the Position input control
			mPosInput = new PosInput();
			SpriteUtl.setPosition(mPosInput,0,70,false);
			mPosInput.visible = !mRelativePos;
			mPosInput.enableX = !mSmartBanner;
			mConsole.addChild(mPosInput);
			
			// Create the Create Banner button
			mCreateBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_CREATE),onCreate);
			SpriteUtl.setPivot(mCreateBtn,SpriteUtl.BOTTOMLEFT);
			SpriteUtl.setPosition(mCreateBtn,0,cFrame.height,false);
			mCreateBtn.enabled = AdsManager.isSupported;
			mConsole.addChild(mCreateBtn);
			
			// Create the multifunction button (Show/Hide)
			mMultiBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_HIDE),onMulti);
			SpriteUtl.setPivot(mMultiBtn,SpriteUtl.BOTTOM);
			SpriteUtl.setPosition(mMultiBtn,cFrame.width/2,cFrame.height,false);
			mMultiBtn.enabled = false;
			mConsole.addChild(mMultiBtn);
			
			// Create the Remove Banner button
			mDestroyBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_DESTROY),onDestroy);
			SpriteUtl.setPivot(mDestroyBtn,SpriteUtl.BOTTOMRIGHT);
			SpriteUtl.setPosition(mDestroyBtn,cFrame.width,cFrame.height,false);
			mDestroyBtn.enabled = false;
			mConsole.addChild(mDestroyBtn);
		}
		
		// =================================================================================================
		//	Console Functions
		// =================================================================================================
		
		/** 
		 * Event listener for Auto Show Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleAutoShow(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"AutoShow toggle:", toggle);
			// Update setting value
			mAutoShow = toggle;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_AUTOSHOW_ENABLE)+mAutoShow);
		}
		
		/** 
		 * Event listener for Relative Position Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleRelativePos(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"RelativePos toggle:", toggle);
			// Update setting value
			mRelativePos = toggle;
			// Update Position controller
			mPosCombo.visible = mRelativePos;
			mPosInput.visible = !mRelativePos;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_RELATIVE_ENABLE)+mRelativePos);
		}
		
		/** 
		 * Event listener for Smart Banner Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleSmartBanner(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"SmartBanner toggle:", toggle);
			// Update setting value
			mSmartBanner = toggle;
			mSizeCombo.enable = !mSmartBanner;
			mPosInput.enableX = !mSmartBanner;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_SMART_ENABLE)+mSmartBanner);
		}
		
		/** 
		 * Event listener for onCreate Button
		 * Create the Banner
		 * 
		 **/
		private function onCreate():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onCreate");

			// adSize instance
			var adSize:int;
			
			// Check if we are using a smart banner or a specific size
			if(mSmartBanner){
				// Update the adSize
				adSize = AdMobSize.SMART_BANNER;
			}else{
				// Check if the size was actually seleted
				if(mSizeCombo.pList.selectedIndex<0){
					// Console Logger
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_NO_SIZE),ConsoleLog.WARN);
					return;
				}else{
					// Update the adSize
					adSize = mBannerSizeData[mSizeCombo.pList.selectedIndex].value;
				}
			}
			
			// Check if we creating in relative or absolute
			if(mRelativePos){
				// Check if the size was actually seleted
				if(mPosCombo.pList.selectedIndex<0){
					// Console Logger
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_NO_POS),ConsoleLog.WARN);
					return;
				}else{
					// Update the adSize
					var adPosition:int = mBannerPosData[mPosCombo.pList.selectedIndex].value;
				}
				// Call Native Function
				AdsManager.createBanner(adSize,adPosition,BANNERID,mAutoShow);
			}else{
				var maxValue:Number;
				if(!validateValue(mPosInput.xValue,"x")){
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_X_NONUMBER),ConsoleLog.NORM);
					maxValue = mScreenSize.width - (mBannerSize.width*mBannerScaleFactor);
					mConsoleLog.add("Maximum available position for x: "+maxValue,ConsoleLog.WARN);
					return;
				}
				if(!validateValue(mPosInput.yValue,"y")){
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_Y_NONUMBER),ConsoleLog.NORM);
					maxValue = mScreenSize.height - (mBannerSize.height*mBannerScaleFactor);
					mConsoleLog.add("Maximum available position for y: "+maxValue,ConsoleLog.WARN);
					return;
				}
				// Set the coordinates
				var posX:Number = Number(mPosInput.xValue);
				var posY:Number = Number(mPosInput.yValue);
				
				// Call Native Function
				AdsManager.createBannerAbsolute(adSize,posX,posY,BANNERID,mAutoShow);
			}
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_CREATE));
			
			// Update the banner State and console
			BannerState = AD_LOAD;
			updateConsole();
		}
		
		/** 
		 * Event listener for onMulti Button
		 * Show or Hide the Banner according to its current state
		 * 
		 **/
		private function onMulti():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onMulti");
			
			// Get the current button label
			var currFunc:String = mMultiBtn.label;
			
			// Process the button function
			if (currFunc == Root.getMsg(Constants.MSG_FUNC_SHOW)){
				/* Show Function */
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_SHOW));
				// Call Native Function
				AdsManager.showBanner(BANNERID);
				// Update the banner State
				BannerState = AD_SHOW;
			}else{
				/* Hide Function */
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_HIDE));
				// Call Native Function
				AdsManager.hideBanner(BANNERID);
				// Update the banner State
				BannerState = AD_HIDE;
			}
			
			// Update the console
			updateConsole();
		}
		
		/** 
		 * Event listener for onDestroy Button
		 * Destroy the Banner
		 * 
		 **/
		private function onDestroy():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onDestroy");
			// Call Native Function
			AdsManager.removeBanner(BANNERID);
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_DESTROY));
			// Update the banner State and console
			BannerState = AD_NONE;
			updateConsole();
		}
		
		/** 
		 * Event listener for onBack Button
		 * Destroy all Banners
		 * 
		 **/
		private function onBack():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onBack");
			
			// Remove all existing banners
			AdsManager.removeAllBanners();
			
			// Dispatch Scene Change Event
			dispatchEventWith(GameEvent.GAME_STATE_CHANGE, true, GameState.STATE_HOME);
		}

		// =================================================================================================
		//	Operarion Functions
		// =================================================================================================
		
		/** 
		 * Set the Data array for the combo selection
		 *   
		 **/
		private function setData():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"setData");
			
			// Define the banner sizes acording devices
			var commonBannerSize:Array =
				[
					{value:AdMobSize.BANNER,			label:Root.getMsg(Constants.MSG_BANNER)},
					{value:AdMobSize.LARGE_BANNER,		label:Root.getMsg(Constants.MSG_LARGE_BANNER)},
					{value:AdMobSize.MEDIUM_RECTANGLE,	label:Root.getMsg(Constants.MSG_MEDIUM_RECTANGLE)}
				];
			var tabletBannerSize:Array =
				[
					{value:AdMobSize.FULL_BANNER,		label:Root.getMsg(Constants.MSG_FULL_BANNER)},
					{value:AdMobSize.LEADERBOARD,		label:Root.getMsg(Constants.MSG_LEADERBOARD)}
				];
			var andSmartBannerSize:Array =
				[
					{value:AdMobSize.SMART_BANNER,		label:Root.getMsg(Constants.MSG_SMART_BANNER)}
				];
			var iosSmartBannerSize:Array =
				[
					{value:AdMobSize.SMART_BANNER_PORT,	label:Root.getMsg(Constants.MSG_SMART_BANNER_PORT)},
					{value:AdMobSize.SMART_BANNER_LAND,	label:Root.getMsg(Constants.MSG_SMART_BANNER_LAND)}
				];

			// Set banner Size Data according to the devie in use
			// Commons are always there
			mBannerSizeData = commonBannerSize;
			// Add the tablet banner is needed
			if (DeviceManager.isTablet) mBannerSizeData = mBannerSizeData.concat(tabletBannerSize);
			// Add the device Specific Banners
			if (DeviceManager.isAndroid){
				mBannerSizeData = mBannerSizeData.concat(andSmartBannerSize);
			}else{
				mBannerSizeData = mBannerSizeData.concat(iosSmartBannerSize);
			}
			
			// Set banner Position Data
			mBannerPosData =
				[
					{value:AdMobPosition.TOP_LEFT,		label:Root.getMsg(Constants.MSG_TOP_LEFT)},
					{value:AdMobPosition.TOP_CENTER,	label:Root.getMsg(Constants.MSG_TOP_CENTER)},
					{value:AdMobPosition.TOP_RIGHT,		label:Root.getMsg(Constants.MSG_TOP_RIGHT)},
					{value:AdMobPosition.MIDDLE_LEFT,	label:Root.getMsg(Constants.MSG_MIDDLE_LEFT)},
					{value:AdMobPosition.MIDDLE_CENTER,	label:Root.getMsg(Constants.MSG_MIDDLE_CENTER)},
					{value:AdMobPosition.MIDDLE_RIGHT,	label:Root.getMsg(Constants.MSG_MIDDLE_RIGHT)},
					{value:AdMobPosition.BOTTOM_LEFT,	label:Root.getMsg(Constants.MSG_BOTTOM_LEFT)},
					{value:AdMobPosition.BOTTOM_CENTER,	label:Root.getMsg(Constants.MSG_BOTTOM_CENTER)},
					{value:AdMobPosition.BOTTOM_RIGHT,	label:Root.getMsg(Constants.MSG_BOTTOM_RIGHT)}
				];
		}
		
		/** 
		 * Enable the Main Console
		 * 
		 **/
		private function enableConsole():void
		{
			// Do not process if already enable
			if (mConsole.touchable) return;
			// Enable the Console
			mConsole.touchable = true;
			mConsole.alpha = 1;
		}
		
		/** 
		 * Disable the Main Console
		 * 
		 **/
		private function disableConsole():void
		{
			// Do not process if already disable
			if (!mConsole.touchable) return;
			// Disable the Console
			mConsole.touchable = false;
			mConsole.alpha = 0.5;
		}
		
		/** 
		 * Update the Main Console
		 * Enable/Disable toggle button and button labels
		 * according to the current banner state
		 * 
		 **/
		private function updateConsole():void
		{
			// Disable all by default.
			// We will enable only what is needed
			disableConsole();
			mSizeCombo.enable	= false;
			mPosCombo.visible	= false;
			mPosInput.visible	= false;
			mCreateBtn.enabled	= false;
			mMultiBtn.enabled	= false;
			mDestroyBtn.enabled	= false;
			
			// Create button is alvays available unless not supported or no internet connection
			mCreateBtn.enabled = AdsManager.isSupported && AdsManager.hasConnection;
			// Disable the create banner if we already have a banner
			if (BannerState>AD_NONE) mCreateBtn.enabled = false;
			
			// Hide/Show check
			if(BannerState == AD_SHOW){
				mMultiBtn.enabled = true;
				mMultiBtn.label = Root.getMsg(Constants.MSG_FUNC_HIDE);
				mDestroyBtn.enabled = true;
			}else if(BannerState == AD_HIDE){
				mMultiBtn.enabled = true;
				mMultiBtn.label = Root.getMsg(Constants.MSG_FUNC_SHOW);
				mDestroyBtn.enabled = true;
			}else if(BannerState == AD_ERROR){
				mDestroyBtn.enabled = true;
			}

			/* Then we check the option controls states and update their states*/
			mSizeCombo.enable	= !mSmartBanner;
			mPosCombo.visible	= mRelativePos;
			mPosInput.visible	= !mRelativePos;
			
			// Now we can enable the console for user operation (unless a banner is loading)
			if(BannerState != AD_LOAD) enableConsole();
		}
		
		/** 
		 * Validate if the given value can be used
		 * 
		 * @param value Value to be checked
		 * @param coord Coordinate of the value ("x" or "y")
		 **/
		private function validateValue(value:String,coord:String):Boolean
		{
			// Debug Logger
			Root.log(LOG_TAG,"validateValue:", value);
			
			// State instance
			var isValid:Boolean = false;
			
			// Sanity check
			if(coord == null){
				Root.log(LOG_TAG,"missing coordinate");
				return isValid;
			}else if(coord != "x" && coord != "y"){
				Root.log(LOG_TAG,"incorrect coordinate");
				return isValid;
			}
			
			// Check if the value is a number
			var num:Number = Number(value);
			isValid = !isNaN(num);
			
			// If the value is 0 we can return true unconditionally e avoid further processing
			if(isValid && num == 0) return isValid;
			
			/* Check if the Banner fits in the given position */
			
			// Get the currently selected banner size
			mBannerSize =  AdsManager.getBannerSize(mBannerSizeData[mSizeCombo.pList.selectedIndex].value);
			
			// Max posioton value instance
			var maxValue:Number;
			
			// Check which coord we are processing
			if (coord == "x"){
				// Get the maximum value for x
				maxValue = mScreenSize.width - (mBannerSize.width*mBannerScaleFactor);
			}else{
				// Get the maximum value for y
				maxValue = mScreenSize.height - (mBannerSize.height*mBannerScaleFactor);
			}
			// compare the values
			if (num>maxValue) isValid = false;

			// Return the result
			return isValid;
		}
		
		// =================================================================================================
		//	Events Functions
		// =================================================================================================
		
		/** 
		 * Add the Banner events Listeners
		 * 
		 */
		private function addAdEventsListeners():void
		{
			AdsManager.dispatcher.addEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			AdsManager.dispatcher.addEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		/** 
		 * Remove the Banner events Listeners
		 * 
		 */
		private function removeAdEventsListeners():void
		{
			AdsManager.dispatcher.removeEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			AdsManager.dispatcher.removeEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		/**
		 * onBannerLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerLoaded(e:AdMobEvent):void
		{
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_LOADED));
			// Update the banner State and console according to the autoshow setting
			if(mAutoShow)	BannerState = AD_SHOW;
			else			BannerState = AD_HIDE;

			// Update the Console
			updateConsole();
		}
		
		/**
		 * onBannerFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerFailedToLoad(e:AdMobEvent):void
		{
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_FAILED),ConsoleLog.NORM);
			// Update the banner State and console
			BannerState = AD_ERROR;
			// Update the Console
			updateConsole();
		}
	}
}