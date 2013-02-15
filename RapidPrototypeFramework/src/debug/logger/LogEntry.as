//@SHARED CANDIDATE
package debug.logger {
	/**
	 * Represents a single log entry in the logger.
	 **/
	public class LogEntry {
		public var className:String;
		public var message:String;
		public var category:String;
		public var severity:uint;
		
		/**
		 * The LogEntry constructor.
		 **/		
		public function LogEntry() {}
	} //LogEntry
} //bwsf.mec.debug.logger