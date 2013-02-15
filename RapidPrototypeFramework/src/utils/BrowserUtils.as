package utils {
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BrowserUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Detects whether a browser is Firefox, MSIE or other, and the version number.
		 **/
		public static function detectBrowser() : BrowserInfo {
			var browserData:Object = ExternalInterface.call("function() {" + 
				"var BrowserDetect = {" + 
				"init: function () {" + 
				"this.browser = this.searchString(this.dataBrowser) || 'Other';" + 
				"this.version = this.searchVersion(navigator.userAgent)" + 
				"|| this.searchVersion(navigator.appVersion)" + 
				"|| 0;" + 
				"}," + 
				"searchString: function (data) {" + 
				"for ( var i = 0; i < data.length; i++ )	{" + 
				"var dataString = data[i].string;" + 
				"var dataProp = data[i].prop;" + 
				
				"this.versionSearchString = data[i].versionSearch || data[i].identity;" + 
				
				"if ( dataString ) {" + 
				"if ( dataString.indexOf(data[i].subString) != -1 ) { return data[i].identity; }" + 
				"} else if ( dataProp ) {" + 
				"return data[i].identity;" + 
				"}" + 
				"}" + 
				"}," + 
				"searchVersion: function (dataString) {" + 
				"var index = dataString.indexOf(this.versionSearchString);" + 
				
				"if ( index == -1 ) { return; }" + 
				
				"return parseFloat(dataString.substring(index+this.versionSearchString.length+1));" + 
				"}," + 
				"dataBrowser: [" + 
				"{" + 
				"string: navigator.userAgent," + 
				"subString: 'Chrome'," + 
				"identity: 'Chrome'" + 
				"}," + 
				"{ 	string: navigator.userAgent," + 
				"subString: 'OmniWeb'," + 
				"versionSearch: 'OmniWeb/'," + 
				"identity: 'OmniWeb'" + 
				"}," + 
				"{" + 
				"string: navigator.vendor," + 
				"subString: 'Apple'," + 
				"identity: 'Safari'," + 
				"versionSearch: 'Version'" + 
				"}," + 
				"{" + 
				"prop: window.opera," + 
				"identity: 'Opera'" + 
				"}," + 
				"{" + 
				"string: navigator.vendor," + 
				"subString: 'iCab'," + 
				"identity: 'iCab'" + 
				"}," + 
				"{" + 
				"string: navigator.vendor," + 
				"subString: 'KDE'," + 
				"identity: 'Konqueror'" + 
				"}," + 
				"{" + 
				"string: navigator.userAgent," + 
				"subString: 'Firefox'," + 
				"identity: 'Firefox'" + 
				"}," + 
				"{" + 
				"string: navigator.vendor," + 
				"subString: 'Camino'," + 
				"identity: 'Camino'" + 
				"}," + 
				"{" + //For newer Netscapes (6+).
				"string: navigator.userAgent," + 
				"subString: 'Netscape'," + 
				"identity: 'Netscape'" + 
				"}," + 
				"{" + 
				"string: navigator.userAgent," + 
				"subString: 'MSIE'," + 
				"identity: 'Explorer'," + 
				"versionSearch: 'MSIE'" + 
				"}," + 
				"{" + 
				"string: navigator.userAgent," + 
				"subString: 'Gecko'," + 
				"identity: 'Mozilla'," + 
				"versionSearch: 'rv'" + 
				"}," + 
				"{" + //For older Netscapes (4-).
				"string: navigator.userAgent," + 
				"subString: 'Mozilla'," + 
				"identity: 'Netscape'," + 
				"versionSearch: 'Mozilla'" + 
				"}" + 
				"]" + 
				"};" + 
				
				"BrowserDetect.init();" + //Code above this line based on the example at http://www.quirksmode.org/js/detect.html.
				
				"version = BrowserDetect.version;" + //Capture x.x portion and store as a number.
				"var userAgent = BrowserDetect.browser;" + 
				
				"return {version:version, userAgent:userAgent};" + 
				"}");
			
			return new BrowserInfo(browserData["version"], browserData["userAgent"]);
		}
		
		/**
		 * Refreshes the user's browser.
		 **/
		public static function refreshBrowser() : void {
			var url:String = ExternalInterface.call("function() { url = location.href; return url; }");
			
			navigateToURL(new URLRequest(url), "_self");
		}
		
		/**
		 * Lame constructor
		 * */
		public function BrowserUtils() {}
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package