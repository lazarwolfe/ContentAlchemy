package utils
{
	public class VarProxy
	{
		// ##### PROPERTIES
		public function get value():*{ return getter(); }
		public function set value(val:*):void{ setter(val); }
		public var getter:Function;
		public var setter:Function;
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function VarProxy(getter:Function,setter:Function)
		{
			this.getter = getter;
			this.setter = setter;
		}
	}
}