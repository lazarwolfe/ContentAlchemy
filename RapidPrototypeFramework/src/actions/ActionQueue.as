package actions {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * This represents a control flow of Actions that have a single purpose.  As each Action completes
	 * it is removed from the queue.  Any Action throwing an error will cancel the entire queue.  When
	 * the queue is empty, the done callback will be called, then the queue will be removed from the
	 * ActionQueueManager.
	 * 
	 * @author CSteiner
	 */
	public class ActionQueue {
		//# STATIC CONST
		public static const ERROR_QUEUE_ALREADY_STARTED:String = "Attempting to run a queue after execution began.";
		public static const ERROR_ADDING_ACTION_AFTER_START:String = "Attempting to add an action after execution began.";
		public static const ERROR_NOT_YET_IMPLIMENTED:String = "Recursive ActionQueues are not yet implimented.";
		
		//# PUBLIC
		
		//# PRIVATE/PROTECTED/INTERNAL
		private var _actionManager:ActionManager;
		/** True if the queue has started executing. */
		internal var _started:Boolean = false;
		/** True if the queue has been paused. */
		internal var _paused:Boolean = true;
		/** List of actions to execute. */
		internal var _actionList:Array = [];
		/** List of tags that apply to this queue. */
		internal var _tags:Array = [];
		/** Function to call when execution completes successfully. */
		internal var _doneCallback:Function;
		/** Parameters to pass to the done callback. */
		internal var _doneParameters:Array;
		/** Function to call when an error is thrown. */
		internal var _errorCallback:Function;
		/** Parameters to pass to the error callback after the Error object. */
		internal var _errorParameters:Array;
		/** Our record of listeners, and which actions care about the messages. */
		private var _waitDataList:Vector.<ActionEventData>;
		/** True if currently inside thr check progress loop */
		private var _checkingProgress:Boolean = false;
		private var _observableSubscriptions:Vector.<Object> = new Vector.<Object>;
		
		//# PROPERTIES
		/**
		 * The ActionManager this queue is a part of.
		 */
		public function get actionManager():ActionManager {
			return _actionManager;
		} // function get actionManager
		
		/** True if there are no more actions to perform in this queue. */
		public function get complete():Boolean {
			return (_actionList == null || _actionList.length == 0);
		} // function get complete
		/** The number of actions currently in the queue */
		public function get numActions():int { if (_actionList == null) { return 0; } else { return _actionList.length; } }
		/** True if the queue has been paused. */
		public function get paused():Boolean { return _paused; }
		
		//# CONSTRUCTOR/INIT/DESTROY

		/**
		 * Creates an ActionQueue object.
		 */
		public function ActionQueue(manager:ActionManager, tags:Array) {
			var i:int = 0;
			
			_actionManager = manager;
			while (i < tags.length) {
				_tags.push(tags[i]);
				++i;
			}
		} // constructor
		
		/**
		 * Releases all memory.
		 * Cancels all actions currently executing and empties the queue.
		 * @note This does not make the queue available again.  Adding actions to the queue after this
		 * is called will throw an error.
		 */
		public function destroy():void {
			_started = true;
			_paused = true;
			_tags.length = 0;
			_tags = null;
			
			var action:Action = _actionList.pop();
			
			while (action) {
				action.destroy();
				action = _actionList.pop();
			}
			
			_actionList = null;
			
			this._observableSubscriptions = null;
		} // function destroy
		
		//# PUBLIC
		
		//# INTERFACE BEGIN IObserver

		/**
		 * Updates the Observer instance.
		 * 
		 * @param	withKey			The key by which updates are gated to this Observer.
		 * @param	...parameters	An arguments object passing arbitrary parameters.
		 **/
		public function notify(withKey:String="", ...parameters):void {
			if (_paused) {
				return;
			}
			var data:ActionEventData = getActionEventData(null, withKey);
			if (data == null) {
				return;
			}
			var i:int = 0;
			while (i < data.actionList.length) {
				var action:Action = data.actionList[i];
				if (action != null) {
					if (action.isWaitAction && action.executeFunction != null) {
						if (parameters != null) {
							action.executeParameters = parameters.concat();
							action.executeParameters.unshift(withKey);
						} else {
							action.executeParameters[0] = withKey;
							action.executeParameters.length = 1;
						}
					}
					action.execute();
				} else {
					++data.noActionCount;
				}
				++i;
			}
			
			for (i = 0; i < this._observableSubscriptions.length; i++) {
				if (this._observableSubscriptions[i]["key"] == withKey) {
					this._observableSubscriptions[i] = null;
					break;
				}
			}
			
			checkProgress();
		}
		
		//# INTERFACE END IObserver
		
		/**
		 * If an action associated with this event is non-null, it will be executed.  If not, the
		 * ActionEventData will increase noActionCount.  When an action is associated with this event, it
		 * will be executed once for each noActionCount until the action is complete.
		 * @param event The event we just received.
		 */
		public function onUpdateEvent(event:Event):void {
			if (_paused) {
				return;
			}
			var data:ActionEventData = getActionEventData(event.target, event.type);
			var i:int = 0;
			while (i < data.actionList.length) {
				var action:Action = data.actionList[i];
				if (action != null) {
					action.onUpdateEvent(event);
				} else {
					++data.noActionCount;
				}
				++i;
			}
			checkProgress();
		}
		
		/**
		 * Starts the queue executing.  Each action in the queue will execute in order.
		 * @note Adding actions to the queue after this is called will throw an error.
		 */
		public function run():void {
			if (_started) {
				throw(new Error(ERROR_QUEUE_ALREADY_STARTED));
			}
			_started = true;
			_paused = false;
			checkProgress();
		} // function run
		
		/**
		 * Pauses the execution of the actions in the queue.
		 */
		public function pause():void {
			if (_started) {
				_paused = true;
			}
		} // function pause
		
		/**
		 * Resumes execution of the actions in the queue.
		 */
		public function resume():void {
			if (_started) {
				_paused = false;
			}
			checkProgress();
		} // function resume
		
		/**
		 * Calls a function once.  After this action completes, it will be removed from the queue.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.
		 * @return The Action created that represents this call.
		 */
		public function call(func:Function, ...params):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.setFunction(func, params);
			action.executeImmediately = true;
			addAction(action);
			return action;
		} // function call
		
		/**
		 * Calls a function every frame.  Execution will continue past this action until a wait action is reached.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.
		 * @return The Action created that represents this call.  Call completeAction(action) to stop this action from executing.
		 * @note The following code will simulate dragging and dropping of a game piece.
		 * 		var queue:ActionQueue = aqm.createQueue();
		 * 		var followAction:Action = queue.callEveryFrame(followMouse,gamePiece);
		 * 		queue.waitForEvent(gameBoard,MouseEvent.MOUSE_UP);
		 * 		queue.completeAction(followAction);
		 * 		queue.call(placeGamePiece,gamePiece);
		 * 		queue.run();
		 */
		public function callEveryFrame(func:Function, ...params):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = actionManager.root;
			action.messageTypes = [Event.ENTER_FRAME];
			action.setFunction(func, params);
			action.executeCount = -1;
			addAction(action);
			return action;
		} // function callEveryFrame
		
		/**
		 * Calls a function once every delay milliseconds.  Execution will continue past this action until a wait action is reached.
		 * @param delay Milliseconds to wait in between each call.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.  The time delta will be prepended to the parameters.
		 * @return The Action created that represents this call.  Call completeAction(action) to stop this action from executing.
		 */
		public function callEvery(delay:int, func:Function, ...params):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.executeFunction = func;
			if (params == null) {
				params = [null];
			}
			else {
				params.unshift(null);
			}
			action.executeParameters = params;
			action.executeCount = -1;
			action.tickTime = delay;
			addAction(action);
			return action;
		} // function callEvery
		
		/**
		 * Calls a function once every time a specified event is received.  Execution will continue past this action until a wait
		 * action is reached.
		 * @param dispatcher Target to listen to for the event.
		 * @param event Event to listen for.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.  The event will be prepended to the parameters.
		 * @return The Action created that represents this call.  Call completeAction(action) to stop this action from executing.
		 */
		public function callEveryEvent(dispatcher:EventDispatcher, event:String, func:Function, ...params):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = dispatcher;
			action.messageTypes = [event];
			action.executeFunction = func;
			if (params == null) {
				params = [null];
			}
			else {
				params.unshift(null);
			}
			action.executeParameters = params;
			action.executeCount = -1;
			addAction(action);
			return action;
		} // function callEveryEvent
		
		/**
		 * Begins listening for an event, then calls a function that may cause this event.  This is meant to be used with waitForEvent.
		 * @param dispatcher Target to listen to for the event.
		 * @param event Event to listen for.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.  The event will be prepended to the parameters.
		 * @return The Action created that represents this call.  Call completeAction(action) to stop this action from executing.
		 */
		public function callAndListenForEvent(dispatcher:EventDispatcher, event:String, func:Function, ...params):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = dispatcher;
			action.messageTypes = [event];
			action.setFunction(func, params);
			action.executeCount = 1;
			action.executeImmediately = true;
			addAction(action);
			return action;
		} // function callAndListenForEvent
		
		/**
		 * Sets an action as completed.  This removes the action from this action queue.
		 * @param action Action to set as complete.
		 */
		public function completeAction(action:Action):void {
			var i:int = _actionList.indexOf(action);
			if (i >= 0) {
				var internalAction:Action = _actionList[i];
				internalAction.destroy(); 
				_actionList.splice(i,1);
			}
		} // function completeAction
		
		/**
		 * Starts listening for a specific event.
		 * this is other waitForEvent actions.
		 * @param dispatcher Target to listen to for the event.
		 * @param event Event to listen for.
		 */
		public function listenForEvent(dispatcher:EventDispatcher, event:String):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = dispatcher;
			action.messageTypes = [event];
			action.executeImmediately = true;
			addAction(action);
			return action;
		} // function waitForEvent
		
		/**
		 * Blocks execution of actions past this action until delay milliseconds have passed.
		 * @param milliseconds Number of milliseconds to block execution.
		 */
		public function wait(delay:int):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.executeCount = 1;
			action.tickTime = delay;
			action.isWaitAction = true;
			addAction(action);
			return action;
		} // function wait
		
		/**
		 * Blocks execution of actions past this action until num frames have passed.
		 * @param num Number of frames to block execution.
		 */
		public function waitFrames(num:int):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = actionManager.root;
			action.messageTypes = [Event.ENTER_FRAME];
			action.executeCount = num;
			action.isWaitAction = true;
			addAction(action);
			return action;
		} // function waitFrames
		
		/**
		 * Blocks execution of actions past this action until a specific event is received.  The exception to
		 * this is other waitForEvent actions.
		 * @param dispatcher Target to listen to for the event.
		 * @param event Event to listen for.
		 * @param onEvent An optional function to receive the events being waited for.
		 * @return The Action created that represents this call.  Call completeAction(action) to remove this wait.
		 */
		public function waitForEvent(dispatcher:EventDispatcher, event:String, onEvent:Function=null):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = dispatcher;
			action.messageTypes = [event];
			action.isWaitAction = true;
			if (onEvent != null) {
				action.setFunction(onEvent, null);
			}
			addAction(action);
			return action;
		} // function waitForEvent
		
		/**
		 * Blocks execution of actions past this action until one of the specified events is received.  The exception to
		 * this is other wait actions.
		 * @param dispatcher Target to listen to for the event.
		 * @param events array of events to listen for.
		 * @param onEvent An optional function to receive the events being waited for.
		 * @return The Action created that represents this call.  Call completeAction(action) to remove this wait.
		 */
		public function waitForOneOfEvent(dispatcher:EventDispatcher, events:Array, onEvent:Function=null):Action {
			if (_started) {
				throw(new Error(ERROR_ADDING_ACTION_AFTER_START));
			}
			var action:Action = new Action();
			action.dispatcher = dispatcher;
			action.messageTypes = events;
			action.isWaitAction = true;
			if (onEvent != null) {
				action.setFunction(onEvent, null);
			}
			addAction(action);
			return action;
		} // function waitForOneOfEvent
		
		/**
		 * Starts executing an ActionQueue.  The new queue will have no impact on the execution of this queue.
		 * @param queue ActionQueue to begin.
		 * @note Not fully speced, not implimented.
		 */
		public function startQueue(queue:ActionQueue):void {
			throw(new Error(ERROR_NOT_YET_IMPLIMENTED));
		} // function startQueue
		
		/**
		 * Executes an ActionQueue.  This acts as a wait, blocking execution of actions past this action until the new
		 * queue completes.
		 * @param queue ActionQueue to begin.
		 * @note Not fully speced, not implimented.
		 */
		public function doAllOfQueue(queue:ActionQueue):void {
			throw(new Error(ERROR_NOT_YET_IMPLIMENTED));
		} // function doAllOfQueue
		
		/**
		 * Specifies a function to call when the queue completes.
		 * @param doneCallback Function to call when the queue has finished executing all actions.  I.E. the queue
		 * was executing and now has no actions remaining.
		 * @param params Parameters to pass to the function.
		 */
		public function done(doneCallback:Function, ...params):void {
			_doneCallback = doneCallback;
			_doneParameters = params;
		} // function done
		
		/**
		 * Specifies a function to call when an action in the queue throws an error.
		 * @param errorCallback Function to call when an error is thrown.  The first parameter of errorCallback must
		 * be error:Error.  Custom params will follow the error parameter.
		 * @param params Parameters to pass to the function after the error parameter.
		 */
		public function error(errorCallback:Function, ...params):void {
			_errorCallback = errorCallback;
			if (params == null || params.length == 0) {
				_errorParameters = [0];
			}
			else {
				_errorParameters = params;
				_errorParameters.unshift(0);
			}
		} // function error
		
		//# PRIVATE/PROTECTED/INTERNAL
		
		/**
		 * Adds an action to the queue.
		 * @param action Action to be added.
		 */
		private function addAction(action:Action):void {
			action.queue = this;
			_actionList.push(action);
		}

		/**
		 * Returns if this queue has the referenced tag.
		 * @param tag Tag to use in reference to a collection of queues. 
		 * @return True if the tag is set for this queue.
		 */
		internal function hasTag(tag:String):Boolean {
			var i:int = _tags.indexOf(tag);
			return (i != -1);
		} // function hasTag
		
		/**
		 * Removes all actions that have _completed set to true from _actionList.
		 */
		private function removeCompletedActions():void {
			var action:Action;
			var i:int = 0;
			while (i < _actionList.length) {
				action = _actionList[i];
				if (action.hasCompleted) {
					action.destroy();
					_actionList.splice(i,1);
				} else {
					++i;
				}
			}
		}
		
		/**
		 * Checks the progress of the queue.  This removes completed actions, starts the next action if nonw are active,
		 * and calls setQueueDone if no actions remain.
		 */
		internal function checkProgress():void {
			if (_checkingProgress) {
				return;
			}
			_checkingProgress = true;
			var action:Action;
			removeCompletedActions();
			if (_actionList.length > 0) {
				// If the first action has not started, then we should start something.
				action = _actionList[0];
				if (!action.hasStarted) {
					startNextAction();
				}
			}
			_checkingProgress = false;
			removeCompletedActions();
			// If there are no actions left, we are done.
			if (_actionList.length == 0) {
				setQueueDone();
				return;
			}
		}
		
		/**
		 * Starts the next action or series of actions.  Each action in turn will be started until a wait action is encountered.
		 * Any wait actions immediately following the first wait action will also be started, until an action is encountered that
		 * is not a wait action.
		 */
		internal function startNextAction():void {
			if (_actionList.length == 0) {
				setQueueDone();
				return;
			}
			var foundWaitAction:Boolean = false;
			var foundReoccuringAction:Boolean = false;
			var action:Action;
			var type:String;
			var i:int = 0;
			while (i < _actionList.length) {
				action = _actionList[i];
				if (action.hasCompleted) {
					// Skip actions that have already completed.
					continue;
				}
				// Check to see if we've hit the end of a wait list.
				if (foundWaitAction && !action.isWaitAction) {
					return;
				}
				// Start the action.
				action.start();
				var receivingAction:Action;
				if (action.executeImmediately) {
					// If we are executing immediately, then we are not waiting for an event or notify.  Instead,
					// We are starting to listen for it, and a wait function will attach itself to the listener later.
					receivingAction = null;
				} else {
					receivingAction = action;
				}
				if (action.messageTypes != null) {
					for each (type in action.messageTypes) {
						if (action.dispatcher) {
							startListeningForEvent(action.dispatcher, type, receivingAction);
						}
					}
				}
				if (action.executeImmediately) {
					action.execute();
				}
				if (action.tickTime > 0) {
					actionManager.updateOnTick(action.tickTime,action.onUpdateTick);

				}
				if (!action.hasCompleted) {
					foundWaitAction = action.isWaitAction;
				}
				++i;
			}
		}
		
		/**
		 * Sets the queue to done and calls the done callback if one has been specified.
		 */
		internal function setQueueDone():void {
			if (_doneCallback != null) {
				if (_doneParameters) {
					_doneCallback.apply(this,_doneParameters);
				} else {
					_doneCallback();
				}
				_doneCallback = null;
				_doneParameters = null;
			}
		}
		
		public function onError(error:Error):void {
			if (_errorCallback != null) {
				if (_errorParameters) {
					_errorParameters[0] = error;
					_errorCallback.apply(this,_errorParameters);
				} else {
					_errorCallback();
				}
				_paused = true;
			}
		}
		
		/**
		 * If an action associated with this key is non-null, it will be executed.  If not, the
		 * ActionEventData will increase noActionCount.  When an action is associated with this key, it
		 * will be executed once for each noActionCount until the action is complete.
		 * @param key The key of the notify we just received.
		 */
		internal function onNotify(key:String):void {
		}
		
		/**
		 * Starts listening for an event from a dispatcher.
		 * @param dispatcher The dispatcher to listen to.
		 * @param event The event to listen for.
		 * @param action The wait action that will be executed when the event occurs.  If this is null, the queue will
		 * start listening, and keeping a count of how many times the notify was received.
		 */
		internal function startListeningForEvent(dispatcher:EventDispatcher, event:String, action:Action = null):void {
			var data:ActionEventData = getActionEventData(dispatcher, event);
			if (action != null) {
				var i:int = 0;
				while (i < data.actionList.length) {
					var checkAction:Action = data.actionList[i];
					if (checkAction == null) {
						while (data.noActionCount > 0 && !action.hasCompleted) {
							--data.noActionCount;
							action.execute();
						}
						data.actionList[i] = action;
						return;
					}
					++i;
				}
			}
			data.actionList.push(action);
			// TODO: System.updater.updateOnEvent(event, dispatcher, this)
			dispatcher.removeEventListener(event,onUpdateEvent);
			dispatcher.addEventListener(event,onUpdateEvent);
		}
		
		/**
		 * Gets a current ActionEventData object for the target and type, or creates a new one if none exists.
		 * @param target EventDispatcher or IObservable to listen to.
		 * @param type event type or key to listen for.
		 * @return The ActionEventData for this event or notify.
		 */
		internal function getActionEventData(target:Object, type:String):ActionEventData {
			if (_waitDataList == null) {
				_waitDataList = new Vector.<ActionEventData>();
			}
			var i:int = 0;
			while (i < _waitDataList.length) {
				var data:ActionEventData = _waitDataList[i];
				if (data.target == target && data.type == type) {
					return data;
				}
				++i;
			}
			data = new ActionEventData();
			data.target = target;
			data.type = type;
			_waitDataList.push(data);
			return data;
		}
	} // class ActionQueue
} // package