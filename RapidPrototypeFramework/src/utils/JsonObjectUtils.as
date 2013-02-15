package utils {
	/**
	 * Utility class for simple dynamic object related operations.
	 * Function in this class only work with Json objects, which means that 
	 * objects with fields of complex data types (custom classes) wont work,
	 * however, objects that contain arrays, simple data types and other objects
	 * will work just fine.
	 * */
	public class JsonObjectUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Recursively copies one simple object to another. Values will be created
		 * if they do not exist and overwriten if they do.
		 * 
		 * @param dst Destination object; must not be null
		 * @param src Source object; must not be null, but may be empty
		 * 
		 * @private
		 */
		public static function copyObject(dst:Object, src:Object):void {
			var index:int;
			var key:*;
			var temp:*;
			var type:String;
			
			for (key in src) {
				temp = src[key];
				type = typeof temp;
				if (type != "object") {
					if (temp is String) {
						dst[key] = new String(temp);
					}
					else {
						dst[key] = temp; // primitive types only
					}
				}
				else {
					if (!dst[key]) {
						if (src[key] is Array) {
							dst[key] = new Array();
						}
						else {
							dst[key] = new Object();
						}
					}
					copyObject(dst[key], temp);
				}
			}
		} 
		
		/**
		 * Recursive function that generates a string describing all properties of an object
		 * */
		public static function getDescriptionString(object:Object, indentationLevel:uint = 0):String {
			var key:String;
			var text:String = "";
			var i:int;
			
			if(object == null) {
				for(i = 0 ; i < indentationLevel ; i++)
					text = text + "   ";
				return  text + "[null Object]";
			}
			
			for(key in object){
				for(i = 0 ; i < indentationLevel ; i++)
					text = text + "   ";
				
				text = text + key + ": ";
				
				if(typeof(object[key]) == "object") {
					text = text + "\n" +getDescriptionString(object[key], indentationLevel + 1);
				}
				else {
					text = text + object[key] + "\n";
				}	
			}
			return text;
		}
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package