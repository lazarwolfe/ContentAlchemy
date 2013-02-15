package actions {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Holds a queue of Actions that get updated by time.  Each TickSpeedQueue object has a specific frequency
	 * and contains all Actions that get update on that frequency.
	 * @author CSteiner
	 */
	internal class TimedUpdatableList {
		//# STATIC CONST
		
		//# PUBLIC
		
		//# PRIVATE/PROTECTED/INTERNAL
		/** The functions to call each tick. */
		internal var _callbackList:Vector.<Function>;
		/** The duration of each timer tick in milliseconds */
		internal var _frequency:Number;
		/** The maximum a tick will register as.  By default, twice the frequency */
		internal var _maxDelta:Number;
		/** Timer for this list */
		private var _timer:Timer;
		/** Time of the last tick */
		private var _lastTickTime:Number = 0;
		/** True if the timer has been started */
		internal var _active:Boolean;
		
		//# PROPERTIES
		
		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Creates a TickSpeedQueue object.
		 */
		public function TimedUpdatableList() {
			_active = false;
		}// constructor
		
		/**
		 * Sets the frequency of updates and makes sure the action list is created.
		 * @param frequency Number of miliseconds between each update call.
		 */
		public function init(frequency:Number):void {
			destroy();
			_frequency = frequency;
			_maxDelta = frequency*10;
			_callbackList = new Vector.<Function>();
			_timer = new Timer(frequency);
		} // function init
		
		/**
		 * Cleans up all references and calls destory() on all actions.
		 */
		public function destroy():void {
			if (_timer != null) {
				_active = false;
				_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
				_timer.stop();
				_timer = null;
			}
			
			if (_callbackList != null) {
				_callbackList.length = 0;
				_callbackList = null;
			}
		} // function destroy
		
		//# PUBLIC

		/**
		 * Adds an action from the list.
		 * @param callback Function to be added.
		 */
		public function addCallback(callback:Function):void {
			if (callback == null || _callbackList == null) {
				return;
			}
			var i:int = _callbackList.indexOf(callback);
			if (i != -1) {
				return;
			}
			if (!_active) {
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
				_active = true;
			}
			_callbackList.push(callback);
		} // function addUpdatable
		
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
				_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
				_timer.stop();
			}
		} // function removeUpdatable
		
		//# PRIVATE/PROTECTED/INTERNAL
		
		/**
		 * Updates based on ammount of time passed.
		 * @param event The timer event.
		 */
		private function onTimerTick(event:TimerEvent):void {
			var time:Number = new Date().getTime();
			var d:Number = time - _lastTickTime;
			var delta:Number = Math.min(time - _lastTickTime, _maxDelta);
			delta *= Core.actions.timeScalar;
			_lastTickTime = time;	
			var i:int = 0;
			while (i < _callbackList.length) {
				var callback:Function = _callbackList[i];
				callback(delta);
				++i;
			}
		} // function onTimerTick
	}
}