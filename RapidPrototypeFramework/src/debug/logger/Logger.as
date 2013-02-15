//@MEC-SPECIFIC: Contains references to LoggerCategories.
package debug.logger {
	
	import flash.display.Sprite;

	/**
	 * A global debug logger class.
	 */
	public class Logger implements ILogger {
		//# STATIC CONST
		//The max number of log entries on the queue
		public static const MAX_NUMBER_OF_LOG_ENTRIES:uint = 500;
		
		public static const DEFAULT_CATEGORY_NAME:String = "GENERAL";
		
		// severity constants
		public static const SEVERITY_ERROR:uint = 0;
		public static const SEVERITY_WARNING:uint = 1;
		public static const SEVERITY_LOG:uint = 2;
		public static const SEVERITY_DEBUG:uint = 3;
		
		
		//# PRIVATE/PROTECTED/INTERNAL
		//The list of viewers for the logger
		private var _viewers:Vector.<ILoggerViewer> = new Vector.<ILoggerViewer>();
		
		//The list of entries that have been logged
		//First element is the oldest one, last element is the newest one
		private var _logEntries:Vector.<LogEntry> = new Vector.<LogEntry>();
		
		//A list of log entries that have been logged but not yet updated in the viewers
		private var _newLogEntries:Vector.<LogEntry> = new Vector.<LogEntry>();
		
		
		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Constructor.
		 **/		
		public function Logger() {
		} // constructor
		
		/**
		 * Initializes this object.
		 * 
		 * @param root The root Sprite where the console will be attached
		 */
		public function init(root:Sprite):void {
			var tempObject:Object;
			var traceLoggerViewer:TraceLoggerViewer;
			var gameConsole:GameConsole;
			
			traceLoggerViewer = new TraceLoggerViewer();
			traceLoggerViewer.init();
			addViewer(traceLoggerViewer);

			gameConsole = new GameConsole(root);
			gameConsole.init();
			addViewer(gameConsole);
			
		} // function init
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_newLogEntries = null;
			_logEntries = null;
			_viewers = null;
		} // function destroy
		
		
		//# INTERFACE BEGIN ILogger
		/**
		 * Creates a log entry with the error severity level if the condition is false
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		public function assert(condition:Boolean, errorMessage:String, where:Object, category:String = null):void {
			if(condition == false) {
				error("ASSERT FAILED: " + errorMessage, where, category);
			}
		} // function assert
		
		/**
		 * Creates a log entry with the error severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		public function error(message:String, where:Object, category:String = null, error:Error = null):void {
			var stackTrace:String;
			
			writeLog(message, where, category, SEVERITY_ERROR);
			
			//Get the current stacktrace. If we have an error object, use it.
			if (error != null) {
				stackTrace = error.getStackTrace();
				if (stackTrace != null) {
					writeLog(stackTrace, where, "STACK TRACE:", SEVERITY_ERROR);
				}
			}
			
			updateViewers();
		} // function error
		
		/**
		 * Creates a log entry with the warning severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		public function warning(message:String, where:Object, category:String = null):void {
			writeLog(message, where, category, SEVERITY_WARNING);
			updateViewers();
		} // function warning
		
		/**
		 * Creates a log entry with the log (normal) severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		public function log(message:String, where:Object, category:String = null):void {
			writeLog(message, where, category, SEVERITY_LOG);
			updateViewers();
		} // function log
		
		/**
		 * Creates a log entry with the debug severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		public function debug(message:String, where:Object, category:String = null ):void {
			writeLog(message, where, category, SEVERITY_DEBUG);
			updateViewers();
		} // function debug
		
		/**
		 * Returns the game console entity if it exists, null otherwise.
		 * The game console is a viewer previously registered
		 */
		public function getConsole():IGameConsole {
			for(var i:uint = 0 ; i < _viewers.length ; i++) {
				var console:IGameConsole = _viewers[i] as IGameConsole;
				if(console != null) {
					return console;
				}
			}
			return null;
		} // function getConsole
		
		/**
		 * Adds a viewer to the logging system; it will get notified every time some logs something.
		 * 
		 * @param viewer 	The viewer to add to the list.
		 */		
		public function addViewer(viewer:ILoggerViewer):void {
			_viewers.push(viewer);
		} // function addViewer
		
		/**
		 * Removes a viewer from the list of active logger viewers.
		 * 
		 * @param viewer 	The viewer to add to the list.
		 */
		public function removeViewer(viewer:ILoggerViewer):void {
			var i:int = _viewers.indexOf(viewer);
			
			if (i != -1) {
				_viewers.splice(i, 1);
			}
		} // function removeViewer
		
		/**
		 * Removes a viewer from the list of active logger viewers.
		 * 
		 * @return	A string representation of a stack trace.
		 */
		public function getCurrentStackTrace():String {
			var error:Error = new Error();
			var stackTrace:String = error.getStackTrace();
			var index : int = 0;
			
			if (stackTrace) {
				//Delete the first 3 lines 
				index = stackTrace.indexOf("\n");
				index = stackTrace.indexOf("\n", index+1);
				index = stackTrace.indexOf("\n", index+1);
				
				if (index != -1) {
					stackTrace = stackTrace.slice(index);
				}
				
				return stackTrace;
			}
			else {
				return "No stack trace information available. Use a debug version of the flash player in order to get it."
			}
		} // function getCurrentStackTrace
		
		/**
		 * Will return a list containing all the log entries in this logger that pass the filter's criteria. The list returned will be a shallow copy.
		 * 
		 * @param 	filter 	A LogFilter object to filter the entries. If null is provided all the entries will be returned.
		 * @return	A collection of LogEntry objects.
		 */
		public function getLogEntries(filter:LogFilter = null):Vector.<LogEntry> {
			var newList:Vector.<LogEntry> = new Vector.<LogEntry>();
			var i:uint;
			
			if(filter == null) {
				newList = _logEntries.concat();	//Shallow copy
			}
			else {
				for(i = 0 ; i < _logEntries.length ; i++) {
					if(filter.isLogEntryValid(_logEntries[i])) {	//Only copy the entries that pass the filter
						newList[newList.length] = _logEntries[i];
					}
				}
			}
			return newList;
		} // function getLogEntries
		//# INTERFACE END ILogger
		
		
		//# PRIVATE/PROTECTED/INTERNAL
		/**
		 * Creates a log entry but does NOT update the registered viewers.
		 * 
		 * @param message	The message to write to the log.
		 * @param where		The object context of the log message.
		 * @param category	The logger category.
		 * @param severity 	The severity of the log message.
		 * 
		 * @private
		 */		
		private function writeLog(message:String, where:Object, category:String, severity:uint):void {
			var entry:LogEntry;
			
			//Keep the max number of entries
			if (_logEntries.length > 0 && _logEntries.length + _newLogEntries.length > MAX_NUMBER_OF_LOG_ENTRIES) {
				entry = _logEntries.shift();
			}
			else {
				entry = new LogEntry();
			}

			entry.message = message;
			entry.className = where == null ? "" : where.toString();
			entry.category = category != null ? category : DEFAULT_CATEGORY_NAME;
			entry.severity = severity;
			_newLogEntries.push(entry);
		} // function writeLog
		
		/**
		 * Updates all viewers observing this Logger instance.
		 * 
		 * @private
		 */
		private function updateViewers():void {
			var i:uint = 0;
			var j:uint = 0;
			var filter:LogFilter;
			
			//Notify viewers.
			for (i = 0 ; i< _viewers.length ; i++) {	
				for (j = 0 ; j < _newLogEntries.length ; j++) {
					filter = _viewers[i].getFilter();
					//Apply the viewer's filter
					if(filter.isLogEntryValid(_newLogEntries[j])) {
						_viewers[i].update(_newLogEntries[j]);
					}
				}
			}
			
			//Put all the new log entries into the main list and then clean the new list.
			for (i = 0 ; i< _newLogEntries.length ; i++) {
				_logEntries[_logEntries.length] = _newLogEntries.splice(i, 1)[0];
			}
		} // function updateViewers
		
	} // class Logger
} // package