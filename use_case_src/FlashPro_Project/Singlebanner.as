package
{
	// Ane Extension Imports
	import com.codealchemy.ane.admobane.AdMobEvent;
	import com.codealchemy.ane.admobane.AdMobManager;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	
	// Flash Imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/** 
	 * Singlebanner Class<br/>
	 * The class will construct The Single Banner Example
	 *
	 **/
	public class Singlebanner extends Sprite
	{
		private const BANNER_ID = "myBanner";
		private var adMobManager:AdMobManager;
		private var dispatcher:EventDispatcher;
		private var isShow:Boolean = false;
		
		// =================================================================================================
		//	Constructor / Deconstructors
		// =================================================================================================
		
		/** 
		 * Singlebanner Constructor
		 *
		 **/
		public function Singlebanner()
		{
			// Init Sprite
			super();
			
			// Get the AdMobManager instance
			adMobManager = AdMobManager.manager;
			// Check if the Extension is supported
			if(adMobManager.isSupported){
				// Get the dispatcher instance
				dispatcher = adMobManager.dispatcher;
				// Set Operation settings
				adMobManager.verbose = true;
				adMobManager.operationMode = AdMobManager.TEST_MODE;
				adMobManager.testDeviceID = "Place_Here_Your_Device_ID";
				
				// Set AdMobId settings
				adMobManager.bannersAdMobId = "Place_Here_Your_AdMobID";
				
				// Add Event Listeners
				addBannersListeners();
				createBtn.addEventListener(MouseEvent.CLICK,onCreate);
				showBtn.addEventListener(MouseEvent.CLICK,onShow);
				hideBtn.addEventListener(MouseEvent.CLICK,onHide);
				destroyBtn.addEventListener(MouseEvent.CLICK,onDestroy);
				
				// Disable all Button by default until the banner is loaded
				disableButtons();
				
				// Create The Banner
				adMobManager.createBanner(AdMobSize.BANNER,AdMobPosition.MIDDLE_CENTER,BANNER_ID, null, true);
			}	
		}
		
		/** 
		 * Enable the console buttons
		 *
		 **/
		private function enableButtons():void
		{
				createBtn.enabled = true;
				createBtn.alpha = 1;
				showBtn.enabled = true;
				showBtn.alpha = 1;
				hideBtn.enabled = true;
				hideBtn.visible = true;
				destroyBtn.enabled = true;
				destroyBtn.alpha = 1;
		}
		
		/** 
		 * Disable the console buttons
		 *
		 **/
		private function disableButtons():void
		{
				createBtn.enabled = false;
				createBtn.alpha = 0.5;
				showBtn.enabled = false;
				showBtn.alpha = 0.5;
				hideBtn.enabled = false;
				hideBtn.visible = false;
				destroyBtn.enabled = false;
				destroyBtn.alpha = 0.5;
		}
		
		/** 
		 * Add all the event Listeners for the banners
		 * 
		 */
		private function addBannersListeners():void
		{
			// onBannerLoaded Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.BANNER_LOADED))
				dispatcher.addEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			
			// onBannerFailedToLoad Event Listener
			if (!dispatcher.hasEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD))
				dispatcher.addEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		/** 
		 * Remove all the event Listeners for the banners
		 * 
		 */
		private function removeBannersListeners():void
		{
			// onBannerLoaded Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.BANNER_LOADED))
				dispatcher.removeEventListener(AdMobEvent.BANNER_LOADED, onBannerLoaded);
			
			// onBannerFailedToLoad Event Listener
			if (dispatcher.hasEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD))
				dispatcher.removeEventListener(AdMobEvent.BANNER_FAILED_TO_LOAD, onBannerFailedToLoad);
		}
		
		// =================================================================================================
		//	Events Management
		// =================================================================================================
		
		/** 
		 * onCreate button trigged Event Listener
		 *
		 * @param e Event Object
		 **/
		private function onCreate(e:Event):void
		{
			// Create the Banner
			if(adMobManager.isSupported) adMobManager.createBanner(AdMobSize.BANNER,AdMobPosition.MIDDLE_CENTER,BANNER_ID, null, true);
			// Update banner state
			isShow = false;
			// Disable all buttons
			disableButtons();
		}
		
		/** 
		 * onShow button trigged Event Listener
		 *
		 * @param e Event Object
		 **/
		private function onShow(e:Event):void
		{
			// Show the Banner
			if(adMobManager.isSupported) adMobManager.showBanner(BANNER_ID);
			// Update banner state
			isShow = true;
			// Disable all buttons
			disableButtons();
			// Enable the Hide and Destroy button
			hideBtn.enabled = true;
			hideBtn.visible = true;
			hideBtn.alpha = 1;
			destroyBtn.enabled = true;
			destroyBtn.alpha = 1;
		}
		
		/** 
		 * onHide button trigged Event Listener
		 *
		 * @param e Event Object
		 **/
		private function onHide(e:Event):void
		{
			// Hide the Banner
			if(adMobManager.isSupported) adMobManager.hideBanner(BANNER_ID);
			// Update banner state
			isShow = false;
			// Disable all buttons
			disableButtons();
			// Enable the Show and Destroy button
			showBtn.enabled = true;
			showBtn.alpha = 1;
			destroyBtn.enabled = true;
			destroyBtn.alpha = 1;
		}
		
		/** 
		 * onDesroy button trigged Event Listener
		 *
		 * @param e Event Object
		 **/
		private function onDestroy(e:Event):void
		{
			// Destroy the Banner
			if(adMobManager.isSupported) adMobManager.removeBanner(BANNER_ID);
			// Disable all buttons
			disableButtons();
			// Enable the Create button
			createBtn.enabled = true;
			createBtn.alpha = 1;
		}
		
		/**
		 * onBannerLoaded Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerLoaded(e:AdMobEvent):void
		{
			// Update banner state
			isShow = true;
			// Enable the buttons
			enableButtons();
			// Disable the Create button
			createBtn.enabled = false;
			createBtn.alpha = 0.5;
		}
		
		/**
		 * onBannerFailedToLoad Event listener
		 * 
		 * @param e AdMobEvent Object
		 **/
		private function onBannerFailedToLoad(e:AdMobEvent):void
		{
			// Update banner state
			isShow = false;
			// Disable all buttons
			disableButtons();
			// Enable the Destroy button
			destroyBtn.enabled = true;
			destroyBtn.alpha = 1;
		}
	}
}