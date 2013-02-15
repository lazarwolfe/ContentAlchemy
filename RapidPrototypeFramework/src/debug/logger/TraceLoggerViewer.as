//@SHARED CANDIDATE
package debug.logger {

	/**
	 * A simple LoggerViewer that will trace() each logged message.
	 **/
	public class TraceLoggerViewer implements ILoggerViewer {
		
		//The logger uses this to filter log entries
		private var _filter:LogFilter;
		
		/**
		 * TraceLoggerViewer constructor.
		 **/
		public function TraceLoggerViewer() {} //TraceLoggerViewer
		
		/**
		 * Initializes the TraceLoggerViewer instance.
		 **/
		public function init():void {
			_filter = new LogFilter();
		} //init
		
		/**
		 * Destructor
		 * */
		public function destroy():void {
			_filter = null;
		}
		
		/**
		 * To be called by the logger when there is new information to be presented.
		 * 
		 * @param logEntries	A list of log entries to be formatted for printing.
		 **/		
		public function update(entry:LogEntry):void {
			var severityText:String = "";
			var space:String = "";
			var i:uint = 0;
	
			switch (entry.severity) {
				case Logger.SEVERITY_DEBUG:
					severityText = "DEBUG: ";
					break;
				case Logger.SEVERITY_LOG:
					severityText = "LOG: ";
					break;
				case Logger.SEVERITY_WARNING:
					severityText = "WARNING: *";
					break;
				case Logger.SEVERITY_ERROR:
					severityText = "ERROR: *****";
					break;
			}
			
			for(i = 0; i <= 15 - severityText.length ; i++) {
				space = space + " ";
			}
			
			trace(severityText + space + entry.category + ": " + entry.message + "     " + entry.className);
		}
		
		/**
		 * Gets an object with the current filtering options.
		 * */
		public function getFilter():LogFilter {
			return _filter;
		}
		
		/**
		 * Sets the current filter. The logger will only log messages if they match the filter's configuration.
		 * */
		public function setFilter(filter:LogFilter):void {
			_filter = filter;
		}
		
	} //TraceLoggerViewer
} //bwsf.mec.debug.logger