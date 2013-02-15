package utils {
	/**
	 * Stores browser information.
	 **/
	public class BrowserInfo {
		public static const FIREFOX:String = "Firefox";
		public static const MSIE:String = "Explorer";
		public static const CHROME:String = "Chrome";
		public static const OPERA:String = "Opera";
		public static const OTHER:String = "Other";
		
		private var _version:Number = 0;
		
		/**
		 * The browser version.
		 * 
		 * @return The browser version.
		 **/		
		public function get version() : Number {
			return this._version;
		}
		
		public function set version(value:Number) : void {
			this._version = value;
		}
		
		private var _userAgent:String = "";
		
		/**
		 * The user agent.
		 * 
		 * @return The user agent. 
		 **/		
		public function get userAgent() : String {
			return this._userAgent;
		}
		
		public function set userAgent(value:String) : void {
			this._userAgent = value;
		}
		
		/**
		 * The BrowserInfo constructor.
		 **/
		public function BrowserInfo(version:Number=0, userAgent:String="") {
			if ( version != this._version ) { this._version = version; }
			if ( userAgent != this._userAgent ) { this._userAgent = userAgent; }
		} // function BrowserInfo
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class BrowserInfo
} // package utils