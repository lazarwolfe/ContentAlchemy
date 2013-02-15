package utils {
	/**
	 * Utility class for Color related operations
	 * */
	public class ColorUtils {
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
		public static function rgbToUint(red : uint, green : uint, blue : uint):uint {
			return rgbaToUint(255, red, green, blue);
		} // function rgbToUint
		
		/**
		 * Constructs an uint representing the color based on the values provided.
		 * The values must be uint between 0 and 255.
		 * */
		public static function rgbaToUint(alpha : uint, red : uint, green : uint, blue : uint):uint {
			var rgba:uint = 0;
			rgba += (alpha<<24);
			rgba += (red<<16);
			rgba += (green<<8);
			rgba += (blue);
			return rgba;
		} // function rgbaToUint
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package