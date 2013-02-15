package utils {
	import com.netease.protobuf.UInt64;
	
	/**
	 * NumberUtils
	 * 
	 * Functions for conversions, random numbers, and other number-related
	 * things that do not clearly belong somewhere else.
	 * 
	 * All functions are static.
	 */
	public class NumberUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Do not construct. All functions are static.
		 */
		public function NumberUtils() {
		} // constructor

		/**
		 * Converts a UInt64.to a Number.
		 */
		public static function uint64ToNumber(i:UInt64):Number {
			var n:Number;
			
			n = Number(i.high);
			n *= 0xFFFFFFFF;
			n += Number(i.low);

			return n;
		} // function UInt64ToNumber

		/**
		 * Converts a Number to a UInt64.
		 */
		public static function numberToUInt64(n:Number):UInt64{
			var i:UInt64;
			
			i = new UInt64();
			i.high = uint(n / 0xFFFFFFFF);
			i.low = n-(i.high * 0xFFFFFFFF); // uint(n) does not work.
			
			return i;
		} // function NumberToUInt64
		//# PRIVATE/PROTECTED/INTERNAL
	} // class NumberUtils
} // package
