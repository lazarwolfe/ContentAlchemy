package utils {
	/**
	 * TrigUtils
	 * 
	 * Functions related to points, distances, angles, etc.
	 * 
	 * All functions are static.
	 */
	public class TrigUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Do not construct. All functions are static.
		 */
		public function TrigUtils() {
		} // constructor

		//# PUBLIC
		/**
		 * Gets the angle of the line connecting 2 points.
		 */
		public static function getAngleBetweenPoints(x1:Number, y1:Number, x2:Number, y2:Number):Number {			
			return Math.atan2( (y2-y1), (x2-x1) );
		} // function getAngleBetweenPoints
		
		/**
		 * Gets the distance squared between two points.
		 */
		public static function getDistanceSquared(x1:Number, y1:Number, x2:Number, y2:Number):Number {			
			return ((x1-x2)*(x1-x2)) + ((y1-y2)*(y1-y2));
		} // function getDistanceSquared
		
		/**
		 * Gets the distance between two points.
		 */
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {			
			return Math.sqrt(getDistanceSquared(x1,y1,x2,y2));
		} // function getDistance
		
		/**
		 * Converts from radians to euclidian geometry.
		 */
		public static function radianToEuclidian(angle:Number):Number {
			return (angle * 180.0)/Math.PI;
		} // function radianToEuclidian
		
		/**
		 * Converts from radians to euclidian geometry.
		 */
		public static function euclidianToRadian(angle:Number):Number {
			return (angle * Math.PI) / 180.0;
		} // function euclidianToRadian
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class TrigUtils
} // package
