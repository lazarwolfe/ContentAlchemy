package actions {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Holds a queue of Actions that get updated by a specific event on a specific object.
	 * @author CSteiner
	 */
	internal class EventUpdatableList {
		//# STATIC CONST
		
		//# PUBLIC
		
		//# PRIVATE/PROTECTED/INTERNAL
		internal var _callbackList:Vector.<Function>;
		/** Event type to listen for */
		internal var _event:String;
		/** EventDispatcher to listen on */
		internal var _dispatcher:EventDispatcher;
		/** True if the listener has been added */
		internal var _active:Boolean;
		
		//# PROPERTIES
		
		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Creates a EventActionQueue object.
		 */
		public function EventUpdatableList() {
			_active = false;
		}// constructor
		
		/**
		 * Sets the frequency of updates and makes sure the action list is created.
		 * @param frequency Number of miliseconds between each update call.
		 */
		public function init(dispatcher:EventDispatcher, event:String):void {
			destroy();
			_event = event;
			_dispatcher = dispatcher;
			_callbackList = new Vector.<Function>();
		} // function init
		
		/**
		 * Cleans up all references.
		 */
		public function destroy():void {
			if (_active) {
				_active = false;
				_dispatcher.removeEventListener(_event, onUpdateEvent, false);
				_dispatcher = null;
			}
			
			if (_callbackList != null) {
				_callbackList.length = 0;
				_callbackList = null;
			}
		} // function destroy
		
		/**
		 * Updates based on ammount of time passed.
		 * @param delta The time since the last update.
		 */
		public function onUpdateEvent(event:Event):void {
			var i:int = 0;
			while (i < _callbackList.length) {
				var callback:Function = _callbackList[i];
				callback(event);
				++i;
			}
		} // function onUpdateEvent
		
		//# PUBLIC
		
		/**
		 * Adds an action from the list.
		 * @param callback Function to be added.
		 */
		public function addCallback(callback:Function):void {
			if (callback == null || _callbackList == null) {
				return;
			}
			if (!_active) {
				_active = true;
				_dispatcher.addEventListener(_event, onUpdateEvent, false, 0, true);
			}
			var i:int = _callbackList.indexOf(callback);
			if (i != -1) {
				return;
			}
			_callbackList.push(callback);
		} // function addCallback
		
		/**
		 * Removes an action from the list, if it exists.
		 * @param callback Function to be removed.
		 */
		public function removeCallback(callback:Function):void {
			if (callback == null || _callbackList == null) {
				return;
			}
			var i:int = _callbackList.indexOf(callback);
			if (i != -1) {
				_callbackList.splice(i,1);
			}
			if (_callbackList.length == 0) {
				_active = false;
				_dispatcher.removeEventListener(_event, onUpdateEvent, false);
			}
		} // function removeCallback
	}
}