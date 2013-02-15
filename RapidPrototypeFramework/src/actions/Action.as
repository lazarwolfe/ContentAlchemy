package actions {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * This is an atomic piece of the Action system.  An Action can call a function, wait, or cancel
	 * another action.
	 * 
	 * Functions outside of bwsf.shared.actions should only keep a reference to an action to pass to
	 * functions on an ActionQueue.  There should be no public functions on an Action.
	 * 
	 * @author CSteiner
	 */
	public class Action {
		//# STATIC CONST
		
		//# PUBLIC
		/** True if the action has started executing. */
		public var hasStarted:Boolean;
		/** True if the action is complete and should be destroyed. */
		public var hasCompleted:Boolean;
		/** Function to call on execution */
		public var executeFunction:Function;
		/** Parameters to pass to the execute function. */
		public var executeParameters:Array;
		/** Number of times execution should happen.  If this number is negative, this action repeat endlessly. */
		public var executeCount:int;
		/** Time to wait between execution that is not event based */
		public var tickTime:Number;
		/** Reference to the queue this Action is in */
		public var queue:ActionQueue;
		/** True if this function executes immediately instead of on a timer or event */
		public var executeImmediately:Boolean;
		/** EventDispatcher to listen to when this action is started, if any */
		public var dispatcher:EventDispatcher;
		/** Array of strings to listen for */
		public var messageTypes:Array;
		/** True if this action is meant to block progress until it's conditions are met. */
		public var isWaitAction:Boolean;
		
		//# PRIVATE/PROTECTED/INTERNAL

		//# CONSTRUCTOR/INIT/DESTROY
		
		/**
		 * Creates an Action object.
		 */
		public function Action() {
			hasStarted = false;
			hasCompleted = false;
			executeCount = 1;
			tickTime = -1;
			executeImmediately = false;
		} // function Action
		
		/**
		 * Releases all memory.
		 * This removes the listener if there was one, and sets all values to 0 or no action.
		 */
		public function destroy():void {
			hasCompleted = true;
			executeFunction = null;
			executeParameters = null;
			queue = null;
			executeCount = 0;
			tickTime = -1;
		} // function destroy
		
		//# PUBLIC
		/**
		 * Sets the function to call on execution.
		 * @param func Function to call.
		 * @param params Parameters to pass to the function.
		 */
		public function setFunction(func:Function, params:Array):void {
			executeFunction = func;
			if (params == null) {
				// Always have a parameter list, even if it's empty.  That way we can add to it if necessary.
				params = [];
			}
			executeParameters = params;
		}

		/**
		 * Starts an action executing.
		 * If _tickTime is > 0, then this will set _nextTickTime counting down.
		 * If neither of these is the case, then this will call execute immediately and set _completed to true.
		 * @return True if successful.  False if the action was already started or completed.
		 */
		public function start():Boolean {
			if (hasStarted || hasCompleted) {
				return false;
			}
			hasStarted = true;
			return true;
		}
		
		/**
		 * Updates based on ammount of time passed.
		 * @param delta The time since the last update.
		 */
		public function onUpdateTick(delta:Number):void {
			if (queue == null || queue._paused) {
				return;
			}
			if (executeParameters != null) {
				executeParameters[0] = delta;
			}
			execute();
			if (hasCompleted) {
				queue.checkProgress();
			}
		}
		
		/**
		 * Updates every time the event is received.
		 * @param event The event that triggered this update, usually ENTER_FRAME.
		 */
		public function onUpdateEvent(event:Event):void {
			if (executeParameters != null) {
				executeParameters[0] = event;
			}
			execute();
		}
		
		/**
		 * Performs the basic execution of this action.
		 * If _executeFunction is specified, the function will be called.
		 * If _executeCount is not negative, it will count down one, and upon reaching 0 will set _completed to true.
		 */
		public function execute():void {
			if (!hasStarted || hasCompleted) {
				// Don't execute if we haven't started or have completed.
				return;
			}
			// Execute function if needed.
			if (executeFunction != null) {
				try {
					executeFunction.apply(this,executeParameters);
				} catch (e:Error) {
					if (queue != null) {
						queue.onError(e);
					}
				}
			}
			// Determine if we are complete.
			if (executeCount > 0) {
				--executeCount;
				if (executeCount == 0) {
					hasCompleted = true;
				}
			}
		}
		
		/**
		 * Sets this action as complete.
		 * This also removes the listener if there was one, and removes the reference to the execute function, parameters,
		 * dispatcher, event, etc.
		 * After this function is called, the only important feature about this action should be that complete = true.
		 */
		public function setComplete():void {
			hasCompleted = true;
			if (tickTime > 0) {
				queue.actionManager.stopUpdatingOnTick(tickTime,onUpdateTick);
			}
			// Now that we are complete, our queue may wish to update.
			queue.checkProgress();
		}
		
	} // class Action
} // package
