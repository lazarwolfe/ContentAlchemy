package debug.logger {
	
	import flash.display.Sprite;

	public interface ILogger {
		/**
		 * Initializes this object.
		 * @param root The root Sprite where the console will be attached
		 */
		function init(root:Sprite):void;
		
		/**
		 * Creates a log entry with the error severity level if the condition is false
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		function assert(condition:Boolean, errorMessage:String, where:Object, category:String = null):void;
		
		/**
		 * Creates a log entry with the error severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 * @param error An optional error object that will be used to provide stack trace information, if provided.
		 */
		function error(message:String, where:Object, category:String = null, error:Error = null):void;
		
		/**
		 * Creates a log entry with the warning severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		function warning(message:String, where:Object, category:String = null):void;
		
		/**
		 * Creates a log entry with the log (normal) severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		function log(message:String, where:Object, category:String = null):void;
		
		/**
		 * Creates a log entry with the debug severity level.
		 * 
		 * @param message The message to be displayed
		 * @param where Always pass "this". Will be used to get class information
		 * @param category An optional category constant. Use the LoggerCatergories enum class.
		 */
		function debug(message:String, where:Object, category:String = null ):void;
		
		/**
		 * Returns the game console entity if it exists, null otherwise.
		 * The game console is a viewer previously registered
		 */
		function getConsole():IGameConsole;
		
		/**
		 * Adds a viewer to the logging system; it will get notified every time some logs something.
		 * 
		 * @param viewer 	The viewer to add to the list.
		 */		
		function addViewer(viewer:ILoggerViewer):void;
		
		/**
		 * Removes a viewer from the list of active logger viewers.
		 * 
		 * @param viewer 	The viewer to add to the list.
		 */
		function removeViewer(viewer:ILoggerViewer):void;
		
		/**
		 * Removes a viewer from the list of active logger viewers.
		 * 
		 * @return	A string representation of a stack trace.
		 */
		function getCurrentStackTrace():String;
		
		/**
		 * Will return a list containing all the log entries in this logger that pass the filter's criteria. The list returned will be a shallow copy.
		 * 
		 * @param 	filter 	A LogFilter object to filter the entries. If null is provided all the entries will be returned.
		 * @return	A collection of LogEntry objects.
		 */
		function getLogEntries(filter:LogFilter = null):Vector.<LogEntry>;
		
	} // interface ILogger
} // package