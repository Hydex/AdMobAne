package utils
{
	// Flash Includes
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;

	// Air net Includes
	import air.net.URLMonitor;
	
	/**
	 * Network Status Monitor Class<br/>
	 * The class will check and manage the Network Connection State
	 * 
	 * @author Code Alchemy
	 **/
	[Event(name="networkStatusChanged", type="flash.events.Event")]
	public class NetStatusMonitor extends EventDispatcher
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[NetStatusMonitor] ';
		
		// url monitor Instance
		private var mUrlMonitor:URLMonitor;
		// test url
		private var mUrl:String;
		
		/** 
		 * NetStatusMonitor Constructor 
		 *  
		 * @param url Url to be used for network check. Optional, Default = CODEALCHEMY_SITE
		 **/
		public function NetStatusMonitor(url:String = Constants.CODEALCHEMY_SITE)
		{
			// Construct the event dispatcher
			super();

			// Set the url instance
			mUrl = url;

			// Add network Change Event Listener
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
		}
		
		/** 
		 * Check the current network state
		 * if capable of internet connection 
		 *  
		 **/
		public function checkConnection():void
		{
			// Create the new monitor instance
			mUrlMonitor = new URLMonitor(new URLRequest(mUrl));
			// Add the Status change event listener
			mUrlMonitor.addEventListener(StatusEvent.STATUS, onNetworkStatusChange);
			// If the monitor is not already running start it
			if(!mUrlMonitor.running) mUrlMonitor.start();
		}
		
		/** 
		 * Dispose of the Monitor instance
		 *  
		 **/
		private function dispose():void
		{
			// if the monitor is not anymore available return
			if(mUrlMonitor == null) return;
			// Stop the monitor if is running
			if(mUrlMonitor.running) mUrlMonitor.stop();
			// clear the monitor instance
			mUrlMonitor = null;
		}
		
		/** 
		 * On Network Change Listener 
		 *  
		 * @param e Event Object
		 **/
		private function onNetworkChange(e:Event):void
		{ checkConnection(); }       
		
		/** 
		 * On Network Status Change Listener 
		 *  
		 * @param e Status Event Object
		 **/
		private function onNetworkStatusChange(e:StatusEvent):void
		{
			// Cehck if the monitor still available
			if (!mUrlMonitor) {
				Root.log(LOG_TAG,"mUrlMonitor is NULL");
				return;
			}
			
			// Remove expired event listener
			mUrlMonitor.removeEventListener(StatusEvent.STATUS, onNetworkStatusChange);
			// get the current network state
			var state:Boolean = mUrlMonitor.available;
			// Dispatch the event for internal use
			dispatchEvent(new NetStatusMonitorEvent(NetStatusMonitorEvent.NETWORK_STATUS_CHANGED,state));
			// Dispose of the monitor
			dispose();
		}
	}
}