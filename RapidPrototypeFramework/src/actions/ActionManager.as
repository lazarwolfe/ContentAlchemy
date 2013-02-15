package actions {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * This manages a queue of ActionQueues.  Hah.
	 * An ActionQueue created by this manager will be updated every tick.  Once a queue is empty,
	 * it will be destroyed.  Tags can be set to define groups of ActionQueues for controlling them.
	 * The intended purpose is to set a tag for a specific scene, and then when the scene closes to
	 * destroy all queues related to that scene.
	 * 
	 * @author CSteiner
	 */
	public class ActionManager {
		//# STATIC CONST
		public static const TICK_TENTH_SECOND:int = 100;
		public static const TICK_HALF_SECOND:int = 500;
		public static const TICK_ONE_SECOND:int = 1000;
		
		//# PUBLIC
		
		//# PRIVATE/PROTECTED/INTERNAL
		/** List of ActionQueue objects */
		private var _queueList:Array;
		/** List of tags to apply to new ActionQueue objects. */
		private var _currentTags:Array;
		/** Target to listen to for ENTER_FRAME events */
		private var _root:DisplayObject;
		
		/** Dictionary of TimedUpdatableLists, each with their own timer. */
		private var _timerList:Dictionary;
		/** Object containing Dictionaries that are referenced by the event type.
		 *  The Dictonaries associate dispatchers with EventUpdatableLists */
		private var _eventList:Object;
		
		public var timeScalar:Number = 1.0;
		
		//# PROPERTIES
		public function get root():DisplayObject { return _root; }
		public function get numQueues():int { if (_queueList == null) { return 0; } else { return _queueList.length; } }

		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Creates an ActionQueueManager object.
		 * This might end up being a singleton.
		 */
		public function ActionManager() {
			_queueList = [];
			_currentTags = [];
			_timerList = new Dictionary(true);
			_eventList = new Object();
		} // constructor
		
		/**
		 * Initializes the ActionQueueManager object.
		 * @param newRoot The target to listen to for ENTER_FRAME events.
		 */
		public function init(newRoot:DisplayObject):void {
			// Start listening to ENTER_FRAME
			_root = newRoot;
			var enterFrameList:EventUpdatableList = new EventUpdatableList();
			enterFrameList.init(root, Event.ENTER_FRAME);
		} // function init
		
		/**
		 * Releases all memory.
		 * Calls destroy on every queue.
		 */
		public function destroy():void {
			var queue:ActionQueue = _queueList.pop();
			while (queue) {
				queue.destroy();
				queue = _queueList.pop();
			}
			_queueList = [];
			
			_currentTags.length = 0;
			_currentTags = [];
		} // function destroy
		
		//# PUBLIC
		
		/**
		 * Starts calling onUpdateEvent(event) on the IUpdatableByEvent every time the dispatcher dispatches the specific event.
		 * @param event The event to listen for.
		 * @param dispatcher The EventDispatcher to listen to.
		 * @param callback The function to call on each event.  The event will be passed as the only parameter.
		 */
		public function updateOnEvent(event:String, dispatcher:EventDispatcher, callback:Function):void {
			if ((dispatcher != root) && (event.localeCompare(Event.ENTER_FRAME) == 0)) {
				trace("WARNING: Use updateEveryFrame for listening to Event.ENTER_FRAME.");
			}
			var dispatcherDict:Dictionary;
			var eventUpdatableList:EventUpdatableList;
			if (_eventList.hasOwnProperty(event)) {
				dispatcherDict = _eventList[event];
			}
			else {
				dispatcherDict = new Dictionary(true);
				_eventList[event] = dispatcherDict;
			}
			eventUpdatableList = dispatcherDict[dispatcher];
			if (eventUpdatableList == null) {
				eventUpdatableList = new EventUpdatableList();
				eventUpdatableList.init(dispatcher,event);
				dispatcherDict[dispatcher] = eventUpdatableList;
			}
			eventUpdatableList.addCallback(callback);
		}

		/**
		 * Starts calling onUpdateEvent(event) on the IUpdatableByEvent on every ENTER_FRAME event.
		 * @param callback The function to call each frame.  The enter frame event will be passed as the only parameter.
		 */
		public function updateEveryFrame(callback:Function):void {
			updateOnEvent(Event.ENTER_FRAME, root, callback);
		}
		
		/**
		 * Starts calling onUpdateTick(delta) on the IUpdatableByTime every delay milliseconds.
		 * @param delay Number of milliseconds between ticks.
		 * @param callback The function to call on each tick.  The time delta will be passed as the only parameter.
		 */
		public function updateOnTick(delay:Number, callback:Function):void {
			var timedUpdatableList:TimedUpdatableList = _timerList[delay];
			if (timedUpdatableList == null) {
				timedUpdatableList = new TimedUpdatableList();
				timedUpdatableList.init(delay);
				_timerList[delay] = timedUpdatableList;
			}
			timedUpdatableList.addCallback(callback);
		}
		
		/**
		 * Stops calling onUpdateEvent(event) on the IUpdatableByEvent every time the dispatcher dispatches the specific event.
		 * @param event The event being listened for.
		 * @param dispatcher The EventDispatcher being listened to.
		 * @param callback The function to stop calling.
		 */
		public function stopUpdatingOnEvent(event:String, dispatcher:EventDispatcher, callback:Function):void {
			var dispatcherDict:Dictionary;
			var eventUpdatableList:EventUpdatableList;
			if (!_eventList.hasOwnProperty(event)) {
				return;
			}
			dispatcherDict = _eventList[event];
			eventUpdatableList = dispatcherDict[dispatcher];
			if (eventUpdatableList == null) {
				return;
			}
			eventUpdatableList.removeCallback(callback);
			if (eventUpdatableList._callbackList.length == 0) {
				eventUpdatableList.destroy();
				dispatcherDict[dispatcher] = null;
			}
		}
		
		/**
		 * Stops calling onUpdateEvent(event) on the IUpdatableByEvent on every ENTER_FRAME event.
		 * @param callback The function to stop calling.
		 */
		public function stopUpdatingEveryFrame(callback:Function):void {
			stopUpdatingOnEvent(Event.ENTER_FRAME, root, callback);
		}
		
		/**
		 * Stops calling onUpdateTick(delta) on the IUpdatableByTime every delay milliseconds.
		 * @param delay Number of milliseconds the timer is set for.
		 * @param callback The function to stop calling.
		 */
		public function stopUpdatingOnTick(delay:Number, callback:Function):void {
			var timedUpdatableList:TimedUpdatableList = _timerList[delay];
			if (timedUpdatableList == null) {
				return;
			}
			timedUpdatableList.removeCallback(callback);
		}
		
		/**
		 * Calls a function on the next frame.
		 * @param callback The function to call.
		 * @param params Optoinal parameters to pass to the function.
		 */
		public function callNextFrame(callback:Function, ...params):void {
			var action:Action;
			var queue:ActionQueue = createQueue([]);
			queue.waitFrames(1);
			action = queue.call(callback) as Action;
			if (params != null) {
				action.executeParameters = params;
			}
			queue.run();
		}
		
		/**
		 * Creates a new ActionQueue.
		 * @return an ActionQueue with all current tags.
		 */
		public function createQueue(tags:Array):ActionQueue {
			var queue:ActionQueue = new ActionQueue(this, _currentTags.concat(tags));
			_queueList.push(queue);
			return queue;
		} // function createQueue
		
		/**
		 * Calls destroy on all ActionQueues that contain this tag.
		 * @param tag Tag to use in reference to a collection of queues. 
		 */
		public function destroyQueues(tag:String):void {
			if (tag == null) {
				return;
			}
			var i:int = 0;
			while (i < _queueList.length) {
				var queue:ActionQueue = _queueList[i];
				if (queue.hasTag(tag)) {
					queue.destroy();
					_queueList.splice(i,1);
				} else {
					++i;
				}
			}
		} // function destroyQueues
		
		/**
		 * Calls run on all ActionQueues that contain this tag.
		 * @param tag Tag to use in reference to a collection of queues. 
		 */
		public function runQueues(tag:String):void {
			if (tag == null) {
				return;
			}
			var i:int = 0;
			while (i < _queueList.length) {
				var queue:ActionQueue = _queueList[i];
				if (queue.hasTag(tag)) {
					queue.run();
				}
				++i;
			}
		} // function runQueues
		
		/**
		 * Calls pause on all ActionQueues that contain this tag.
		 * @param tag Tag to use in reference to a collection of queues. 
		 */
		public function pauseQueues(tag:String):void {
			if (tag == null) {
				return;
			}
			var i:int = 0;
			while (i < _queueList.length) {
				var queue:ActionQueue = _queueList[i];
				if (queue.hasTag(tag)) {
					queue.pause();
				}
				++i;
			}
		} // function pauseQueues
		
		/**
		 * Calls resume on all ActionQueues that contain this tag.
		 * @param tag Tag to use in reference to a collection of queues. 
		 */
		public function resumeQueues(tag:String):void {
			if (tag == null) {
				return;
			}
			var i:int = 0;
			while (i < _queueList.length) {
				var queue:ActionQueue = _queueList[i];
				if (queue.hasTag(tag)) {
					queue.resume();
				}
				++i;
			}
		} // function resumeQueues
		
	} // class ActionQueueManager
} // package