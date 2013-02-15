//@SHARED CANDIDATE
package debug.logger {

	/**
	 * Standard interface for the viewer classes of the system Logger
	 **/
	public interface ILoggerViewer {
		/**
		 * To be called by the logger when there is new information to be presented.
		 * 
		 * @param logEntries	A list of log entries to be formatted for printing.
		 **/		
		function update(entry:LogEntry):void;
		
		/**
		 * Gets an object with the current filtering options.
		 * */
		function getFilter():LogFilter;
		
		/**
		 * Sets the current filter. The logger will only log messages if they match the filter's configuration.
		 * */
		function setFilter(filter:LogFilter):void;
		
	} //ILoggerViewer
} //bwsf.mec.debug.logger