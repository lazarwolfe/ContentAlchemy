package expose.utils
{
	public class ReflectionProxy
	{
		// ##### PROPERTIES
		public var object:Object;
		public var propertyName:String;
		public var access:String;
		
		// ##### CONSTANTS
		public static const ACCESS_RW:String = "readwrite"; //private static?
		public static const ACCESS_R:String = "readonly";
		public static const ACCESS_W:String = "writeonly";
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function ReflectionProxy( object:Object, propertyName:String, access:String=ACCESS_RW )
		{
			this.object = object;
			this.propertyName = propertyName;
			this.access = access;
		}
		
		public function getter():*
		{
			if( !(access==ACCESS_RW||access==ACCESS_R) ) return;
			return object[propertyName];
		}
		
		public function setter(val:*):void
		{
			if( !(access==ACCESS_RW||access==ACCESS_W) ) return;
			object[propertyName] = val;
		}
		
	}
}