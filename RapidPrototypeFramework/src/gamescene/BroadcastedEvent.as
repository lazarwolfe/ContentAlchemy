package gamescene {
	import flash.events.Event;
	
	/**
	 * Represents an event being broadacasted by a component
	 * */
	public class BroadcastedEvent extends Event {
		//Optional data parameter, could be any kind of information relevant to the particular event type
		private var _data:Object;
		public function get Data():Object {
			return _data;
		}
		
		/**
		 * Constructor
		 * */
		public function BroadcastedEvent(type:String, data:Object = null) {
			super(type, false, false);
			_data = data;
		}
	}
}