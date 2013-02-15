package utils {
	/**
	 * Utility class for Path related operations
	 * */
	public class PathUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Constructs an uint representing the color based on the values provided.
		 * The values must be uint between 0 and 255.
		 * */
		public static function getCompletePath(basePath:String, path:String):String {
			//Decide if we should use the basePath or not. 
			//We consider the path to be absolute if it starts with http or a slash, or the secont chatacter is : as in C: or D:
			if(path.substr(0,1) != "." && path.substr(0, 4) == "http" || path.substr(0,1) == "/" || path.substr(0,1) == "\\" || path.substr(1,1) == ":") {
				return path;
			}
			else {
				return basePath + path;
			}
		}
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package