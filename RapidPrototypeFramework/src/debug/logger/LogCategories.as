//@MEC-SPECIFIC
package debug.logger {
	/**
	 * An enumeration of all the logger categories for MEC.
	 **/
	public class LogCategories {
		public static const GENERAL:String = "GENERAL";
		public static const DEBUG:String = "DEBUG";
		public static const ANIMATION:String = "ANIMATION";
		public static const RESOURCES:String = "RESOURCES";
		public static const LOADING:String = "LOADING";
		public static const UI:String = "UI";
		public static const COMBAT:String = "COMBAT";
		public static const SHIP:String = "SHIP";
		public static const SOUND:String = "SOUND";
		public static const SERIALIZATION:String = "SERIALIZATION";
		
		//We use this thing to be able to list all the possible categories.
		public static const categories:Array = [GENERAL, DEBUG, ANIMATION, RESOURCES, LOADING, UI, COMBAT, SHIP, SOUND, SERIALIZATION];
	} //LoggerCategories
} //bwsf.mec.debug.logger