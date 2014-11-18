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
	 * Multi Banner Demo Scene Class<br/>
	 * The class will construct and manage the Multi Banner Demo Scene
	 * 
	 * @author Code Alchemy
	 **/
	public class MultiBannerScene extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[MultiBannerScene] ';
		
		// Banner States Constants
		private const AD_NONE:uint			= 0;
		private const AD_LOAD:uint			= 1;
		private const AD_ERROR:uint			= 2;
		private const AD_SHOW:uint			= 3;
		private const AD_HIDE:uint			= 4;
		
		// Dimension instances
		private var mScreenSize:ScreenSize;
		private var mBannerSize:AdSize;
		private var mBannerScaleFactor:Number = 1;
		
		// Console instances
		private var mConsole:Sprite;
		private var mConsoleLog:ConsoleLog;
		private var mAutoShow:Boolean = true;
		private var mApplyAll:Boolean = true;
		private var mRelativePos:Boolean = true;
		private var mSmartBanner:Boolean = true;
		private var mBannerCombo:ComboBox;
		private var mSizeCombo:ComboBox;
		private var mPosCombo:ComboBox;
		private var mPosInput:PosInput;
		private var mCreateBtn:FuncButton;
		private var mShowBtn:FuncButton;
		private var mHideBtn:FuncButton;
		private var mDestroyBtn:FuncButton;
		
		// Banner counter for banner id composition
		private var mBannerID:uint = 0
		// Selected Banner Instance
		private var mSelBanner:String;

		// Data instances
		private var mBannerData:Array;
		private var mBannerSizeData:Array;
		private var mBannerPosData:Array;
		
		// =================================================================================================
		//	Constructors Functions
		// =================================================================================================
		
		/** 
		 * Multi Banner Demo Scene constructor
		 * 
		 **/
		public function MultiBannerScene()
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
			mBannerID		= 0;
			mSelBanner		= null;
			mBannerData		= null;
			mBannerSizeData	= null;
			mBannerPosData	= null;
			
			// Remove all the event listeners
			removeAdEventsListeners();
			removeEventListeners();
		}
		
		/** 
		 * Initialize the Multi Banner Demo Scene
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
			
			// Add the offline banner instance and dispose the application banner
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
			var cFrame:Quad = new Quad(270,130);
			cFrame.alpha = 0;
			mConsole.addChild(cFrame);
			
			// Button left offeset for the uper console 
			var btnOffset:uint = 15;
			
			// Create the Autoshow Option Toggle
			var autoShowToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_AUTOSHOW), mAutoShow,toggleAutoShow);
			autoShowToggle.x = btnOffset;
			mConsole.addChild(autoShowToggle);
			
			// Create the Relative Position Option Toggle
			var applyAllToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_APPLYALL), mApplyAll,toggleApplyAllPos);
			SpriteUtl.setPosition(applyAllToggle,btnOffset+70,0,false);
			mConsole.addChild(applyAllToggle);
			
			// Create the Relative Position Option Toggle
			var relativePosToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_RELPOS), mRelativePos,toggleRelativePos);
			SpriteUtl.setPosition(relativePosToggle,btnOffset+140,0,false);
			mConsole.addChild(relativePosToggle);
			
			// Create the Smart Banner Option Toggle
			var smartBannerToggle:ToggleButton	= new ToggleButton(Root.getMsg(Constants.MSG_SMARTB), mSmartBanner,toggleSmartBanner);
			SpriteUtl.setPosition(smartBannerToggle,btnOffset+210,0,false);
			mConsole.addChild(smartBannerToggle);
			
			// Add the Banner Selection Combo Box
			mBannerCombo = new ComboBox(Root.getMsg(Constants.MSG_COMBO_B_BANNER),mBannerData);
			mBannerCombo.prompt = Root.getMsg(Constants.MSG_COMBO_NEW);
			mBannerCombo.pList.addEventListener(Event.CHANGE,onBannerSelection);
			SpriteUtl.setPosition(mBannerCombo,btnOffset+0,45,false);
			mBannerCombo.enable = !mApplyAll;
			mConsole.addChild(mBannerCombo);
			
			// Add the Size Selection Combo Box
			mSizeCombo = new ComboBox(Root.getMsg(Constants.MSG_COMBO_B_SIZE),mBannerSizeData);
			SpriteUtl.setPosition(mSizeCombo,btnOffset+0,66,false);
			mSizeCombo.enable = !mSmartBanner;
			mConsole.addChild(mSizeCombo);
			
			// Add the Position Selection Combo Box
			mPosCombo = new ComboBox(Root.getMsg(Constants.MSG_COMBO_B_POS),mBannerPosData);
			SpriteUtl.setPosition(mPosCombo,btnOffset+0,87,false);
			mPosCombo.visible = mRelativePos;
			mConsole.addChild(mPosCombo);
			
			// Add the Position input control
			mPosInput = new PosInput();
			SpriteUtl.setPosition(mPosInput,btnOffset+0,87,false);
			mPosInput.visible = !mRelativePos;
			mPosInput.enableX = !mSmartBanner;
			mConsole.addChild(mPosInput);
			
			// Create the Create Banner button
			mCreateBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_CREATE),onCreate);
			SpriteUtl.setPivot(mCreateBtn,SpriteUtl.BOTTOMLEFT);
			SpriteUtl.setPosition(mCreateBtn,0,cFrame.height,false);
			mCreateBtn.enabled = AdsManager.isSupported;
			mConsole.addChild(mCreateBtn);
			
			// Create the Show Banner button
			mShowBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_SHOW),onShow);
			SpriteUtl.setPivot(mShowBtn,SpriteUtl.BOTTOMLEFT);
			SpriteUtl.setPosition(mShowBtn,76,cFrame.height,false);
			mShowBtn.enabled = false;
			mConsole.addChild(mShowBtn);
			
			// Create the Hide Banner button
			mHideBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_HIDE),onHide);
			SpriteUtl.setPivot(mHideBtn,SpriteUtl.BOTTOM);
			SpriteUtl.setPosition(mHideBtn,190,cFrame.height,false);
			mHideBtn.enabled = false;
			mConsole.addChild(mHideBtn);
			
			// Create the Remove Banner button
			mDestroyBtn = new FuncButton(Root.getMsg(Constants.MSG_FUNC_DESTROY),onDestroy);
			SpriteUtl.setPivot(mDestroyBtn,SpriteUtl.BOTTOMRIGHT);
			SpriteUtl.setPosition(mDestroyBtn,305,cFrame.height,false);
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
		 * Event listener for Apply to All Toggle Button
		 * 
		 * @param toggle New Toggle state
		 **/
		private function toggleApplyAllPos(toggle:Boolean):void
		{
			// Debug Logger
			Root.log(LOG_TAG,"ApplyAll toggle:", toggle);
			// Update setting value
			mApplyAll = toggle;
			// Update Banner controller
			mBannerCombo.enable = !mApplyAll;
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_APPLYALL_ENABLE)+mApplyAll);
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
			// Update Smart controller
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
			// Create the New Banner ID
			var bannerID:String = "Banner "+mBannerID;
			// Banner update state
			var bannerUpdated:Boolean;

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
				// Add the new Banner to the data
				addBannerData(bannerID);
				// Update the banner state
				bannerUpdated = updateBannerState(mSelBanner,AD_LOAD);
				// If the banner state has been updated we can process the call
				if (bannerUpdated) AdsManager.createBanner(adSize,adPosition,bannerID,mAutoShow);
			}else{
				var maxValue:Number;
				if(!validateValue(mPosInput.xValue,"x")){
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_X_NONUMBER),ConsoleLog.ERROR);
					maxValue = mScreenSize.width - (mBannerSize.width*mBannerScaleFactor);
					mConsoleLog.add("Maximum available position for x: "+maxValue,ConsoleLog.WARN);
					return;
				}
				if(!validateValue(mPosInput.yValue,"y")){
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_Y_NONUMBER),ConsoleLog.ERROR);
					maxValue = mScreenSize.height - (mBannerSize.height*mBannerScaleFactor);
					mConsoleLog.add("Maximum available position for y: "+maxValue,ConsoleLog.WARN);
					return;
				}
				// Set the coordinates
				var posX:Number = Number(mPosInput.xValue);
				var posY:Number = Number(mPosInput.yValue);
				
				// Add the new Banner to the data
				addBannerData(bannerID);
				// Update the banner state
				bannerUpdated = updateBannerState(mSelBanner,AD_LOAD);
				// If the banner state has been updated we can process the call
				if (bannerUpdated) AdsManager.createBannerAbsolute(adSize,posX,posY,bannerID,mAutoShow);
			}
			// Console Logger
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_CREATE));
			
			// Update the currently selected Banner
			mSelBanner = bannerID;
			// Update the bunner Ids count
			mBannerID ++;
			// Update the banner combo data
			updateBannerComboData();
			// Update the console
			updateConsole();
		}
		
		/** 
		 * Event listener for onShow Button
		 * Show the Banner according to its current state
		 * 
		 **/
		private function onShow():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onShow");
			
			// Check if we need to operate a specific banner or all
			if (mApplyAll){
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_SHOWALL));
				// Call Native Function
				AdsManager.showAllBanners();
				// Update all the banner states
				updateAllBannersState(AD_SHOW);
			}else{
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_SHOWSEL)+mSelBanner);
				// Update the banner state
				var bannerUpdated:Boolean = updateBannerState(mSelBanner,AD_SHOW);
				// If the banner state has been updated we can process the call
				if (bannerUpdated) AdsManager.showBanner(mSelBanner);
			}
			// Update the console
			updateConsole();
		}
		
		/** 
		 * Event listener for onHide Button
		 * Hide the Banner according to its current state
		 * 
		 **/
		private function onHide():void
		{
			// Debug Logger
			Root.log(LOG_TAG,"onHide");
			
			// Check if we need to operate a specific banner or all
			if (mApplyAll){
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_HIDEALL));
				// Call Native Function
				AdsManager.hideAllBanners();
				// Update all the banner states
				updateAllBannersState(AD_HIDE);
			}else{
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_HIDESEL)+mSelBanner);
				// Update the banner state
				var bannerUpdated:Boolean = updateBannerState(mSelBanner,AD_HIDE);
				// If the banner state has been updated we can process the call
				if (bannerUpdated) AdsManager.hideBanner(mSelBanner);
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
			// Check if we need to operate a specific banner or all
			if (mApplyAll){
				// Console Logger
				mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_DESTROYALL));
				// Call Native Function
				AdsManager.removeAllBanners();
				// Clear all banner data
				clearBannerData();
				// Reset the selected banner
				mSelBanner = null;
			}else{
				// Remove the banner from the data
				var bannerRemoved:Boolean = removeBannerData(mSelBanner);
				// If the banner data has been removed we can process the call
				if (bannerRemoved){
					// Console Logger
					mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_DESTROYSEL)+mSelBanner);
					// Call Native Function
					AdsManager.removeBanner(mSelBanner);
					// Reset the selected banner
					mSelBanner = null;
				}
			}
			// Update the banner combo data
			updateBannerComboData();
			// Update the console
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

		/** 
		 * Event listener for onBannerSelection
		 * Update the currently selected banner instance
		 * 
		 * @param e Event instance
		 **/
		private function onBannerSelection(e:Event):void
		{
			// do not process if there is no data in the BannerData
			if (mBannerData.length == 0) return;
			// Check if the item is actually available
			if(mBannerCombo.pList.selectedItem){
				// Updtae the selected banner instance
				mSelBanner = mBannerCombo.pList.selectedItem.label;
				// Update the console
				updateConsole();
			}
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
			
			// Set banner Data
			/* For now an empty array, it will be populate on user operation */
			mBannerData = new Array();
			
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
		 * Add a specific banner from the bannerData
		 * 
		 * @param id Banner id to be added
		 **/
		private function addBannerData(id:String):void
		{
			// Create the new Banner Data
			var bannerData:Object = new Object();
			bannerData.label = id;
			bannerData.state = AD_NONE;
			mBannerData.push(bannerData);		
		}
		
		/** 
		 * Remove a specific banner from the bannerData
		 * 
		 * @param id Banner id to be removed
		 **/
		private function removeBannerData(id:String):Boolean
		{
			// Set defaulet check result
			var result:Boolean = false;
			// Search the banner to be removed and remove it 
			for (var i:uint = 0; i < mBannerData.length; i++) 
			{ 
				// Skip invalid data
				if (!mBannerData[i].hasOwnProperty("label")) continue;
				// Skip not matching banners
				if (!mBannerData[i].label == id) continue;
				// Skip invalid data
				if (!mBannerData[i].hasOwnProperty("state")) continue;
				// Call Native Function
				AdsManager.removeBanner(mSelBanner);
				// Remove the banner from the data
				mBannerData.splice(i,1);
				// Update the result
				result = true;
				break;
			}
			// return the result
			return result;
		}

		/** 
		 * Clear all data in the bannerData instance
		 * 
		 **/
		private function clearBannerData():void
		{
			mBannerData = new Array();
			mBannerID = 0;
		}
		
		/** 
		 * Get the banner state for a spcific banner in the BannerData
		 * 
		 * @param id Banner id to be retrieved
		 * @return banner state or null if not found
		 **/
		private function getBannerState(id:String):uint
		{
			// Search the banner to update and update it
			for each (var banData:Object in mBannerData)
			{
				// Skip invalid data
				if (!banData.hasOwnProperty("label")) continue;
				// Skip not matching banners
				if (!banData.label == id) continue;
				// Skip invalid data
				if (!banData.hasOwnProperty("state")) continue;
				// Return the found state
				return banData.state;
			}
			// return null if nothing was found
			return null;
		}
		
		/** 
		 * Get the number of banners available in the banner data for the given state
		 * 
		 * @param state Banner state to be count
		 * @return number of banner found for the given state
		 **/
		private function getCountForState(state:uint):uint
		{
			// Set default result value 
			var result:uint = 0;
			
			// Search the banner to update and update it
			for each (var banData:Object in mBannerData)
			{
				// Skip invalid data
				if (!banData.hasOwnProperty("state")) continue;
				// Increment the counter for match found
				if (banData.state == state) result++;
			}
			// return the result
			return result;
		}
		
		/** 
		 * Update the banner state in the banner Data
		 * If the state is correctly updated will return true
		 * otherwise false
		 * 
		 * @param id Banner id to be updated
		 * @param state new state to be set for the given banner id
		 **/
		private function updateBannerState(id:String,state:uint):Boolean
		{
			// Set defaulet check result
			var result:Boolean = false;
			// Search the banner to update and update it
			for each (var banData:Object in mBannerData)
			{
				// Skip invalid data
				if (!banData.hasOwnProperty("label")) continue;
				// Skip not matching banners
				if (!banData.label == id) continue;
				// Skip invalid data
				if (!banData.hasOwnProperty("state")) continue;
				// Update the banner state
				banData.state = state;
				// Update the result
				result = true;
				// now we can stop the search and update
				break;
			}
			// return the result
			return result;
		}
		
		/** 
		 * Update the banner state for all banners in the banner Data
		 * 
		 * @param state new state to be set for the given banner id
		 **/
		private function updateAllBannersState(state:uint):void
		{
			// Process each banner in the data
			for each (var banData:Object in mBannerData)
			{
				// Skip invalid data
				if (!banData.hasOwnProperty("state")) continue;
				// Update the banner state
				banData.state = state;
			}
		}
		
		/** 
		 * Update the Data in the Banner combo selection
		 * 
		 **/
		private function updateBannerComboData():void
		{ mBannerCombo.data = mBannerData; }
		
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
		 * according to the current banner states and banner selection
		 * 
		 **/
		private function updateConsole():void
		{
			// Disable all by default.
			// We will enable only what is needed
			disableConsole();
			mBannerCombo.enable	= false;
			mSizeCombo.enable	= false;
			mPosCombo.visible	= false;
			mPosInput.visible	= false;
			mCreateBtn.enabled	= false;
			mShowBtn.enabled	= false;
			mHideBtn.enabled	= false;
			mDestroyBtn.enabled	= false;
			
			// Create button is alvays available unless not supported or no internet connection
			mCreateBtn.enabled = AdsManager.isSupported && AdsManager.hasConnection;
			
			/* First we check the AD functional buttons (Create/show/hide and destroy)*/
			// Are we working on all banners?
			if(mApplyAll){
				// There are created banners?
				if(mBannerData.length > 0){
					// There are banner currently visible?
					if (getCountForState(AD_LOAD)>0) mShowBtn.enabled = true;
					if (getCountForState(AD_HIDE)>0) mShowBtn.enabled = true;
					// There are banner currently hiden?
					if (getCountForState(AD_SHOW)>0) mHideBtn.enabled = true;
					// We have banner ergo we can destroy!
					mDestroyBtn.enabled = true;
				}
			}else{
				// Get the banner state for the currently selected banner
				var BannerState:uint = getBannerState(mSelBanner);
				// Hide/Show check
				if(BannerState == AD_SHOW)		mHideBtn.enabled = true;
				else if(BannerState == AD_HIDE)	mShowBtn.enabled = true;
				// We have banner ergo we can destroy!
				mDestroyBtn.enabled = true;
			}

			/* Then we check the option controls states and update their states*/
			mBannerCombo.enable	= !mApplyAll;
			mSizeCombo.enable	= !mSmartBanner;
			mPosCombo.visible	= mRelativePos;
			mPosInput.visible	= !mRelativePos;
			
			// Now we can enable the console for user operation (unless a banner is loading)
			if(BannerState != AD_LOAD) enableConsole();
		}
		
		/** 
		 * Validate if the given value can be used
		 * TODO: check if the banner can banner fit...
		 * That's why i added the coord param...
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
			// Update the banner State according to the autoshow setting
			if(mAutoShow)	updateBannerState(mSelBanner,AD_SHOW);
			else			updateBannerState(mSelBanner,AD_HIDE);

			// Set the last entry as selected item in the banner combo box
			mBannerCombo.pList.selectedIndex = mBannerCombo.pList.dataProvider.length-1;
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
			mConsoleLog.add(Root.getMsg(Constants.LOG_BANNER_FAILED),ConsoleLog.ERROR);
			// Update the banner State
			updateBannerState(mSelBanner,AD_ERROR);
			// Update the Console
			updateConsole();
		}
	}
}