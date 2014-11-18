package utils
{
	// Flash Includes
	import flash.events.Event;
	
	/**
	 * Net Status Monitor Event Class<br/>
	 * The class will manage the Network Status change event
	 * 
	 * @author Code Alchemy
	 **/
	public class NetStatusMonitorEvent extends Event
	{
		// Tag Constant for log
		static private const LOG_TAG:String					='[NetStatusMonitorEvent] ';
		
		// Static event definition constant
		static public const  NETWORK_STATUS_CHANGED:String	= "networkStatusChanged";
		
		// Network state Instance
		public var state:Boolean;
		
		/** 
		 * NetStatusMonitorEvent Constructor 
		 *  
		 * @param type The type of event.
		 * @param state Network State.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow. Optional, Default = false
		 * @param cancelable Determines whether the Event object can be canceled. Optional, Default = false
		 **/
		public function NetStatusMonitorEvent(type:String, newState:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			// Updtae the connection state state
			state = newState;
			// Initialize event
			super(type, bubbles, cancelable);
		}
	}
}