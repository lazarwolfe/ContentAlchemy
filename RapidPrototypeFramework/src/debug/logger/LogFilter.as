package debug.logger
{
	/**
	 * Configuration for filtering log entries
	 * */
	public class LogFilter
	{
		public var severityThreshold:uint = 0;
		public var categories:Array = null;
		
		/**
		 * CTOR
		 */
		public function LogFilter(){
		}
		
		/**
		 * Returns false if this filter should filter out the specified log entry
		 * */
		public function isLogEntryValid(logEntry:LogEntry):Boolean {
			var i:uint;
			
			//Severity Threshold filtering:
			if(logEntry.severity < severityThreshold) {
				return false;
			}
			
			//Category filtering:
			
			//If no categories are specified, all entries are good
			if(categories == null || categories.length == 0) {
				return true;
			}
			
			for( i = 0 ; i < categories.length ; i++) {
				if(logEntry.category == categories[i]) {
					return true;
				}
			}
			
			return false;
		}
	}
}