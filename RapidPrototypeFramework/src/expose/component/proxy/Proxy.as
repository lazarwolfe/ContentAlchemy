package expose.component.proxy
{
	import flash.display.Sprite;
	import expose.component.ExposeComponent;
	import expose.utils.VarProxy;
	
	public class Proxy extends ExposeComponent
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		protected var _proxy:VarProxy;
		
		// ##### PROPERTIES
		public function get proxy():VarProxy {
			return _proxy;
		}
		public function set proxy(value:VarProxy):void {
			_proxy = value;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function Proxy(getter:Function,setter:Function)
		{
			super();
			_proxy = new VarProxy(getter,setter);
		}
		
		// ##### PUBLIC
		public function updateVar():void {
			// TO BE IMPLEMENTED
		}
		public function updateUI():void {
			// TO BE IMPLEMENTED
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		
		// ##### PRIVATE / PROTECTED / INTERNAL 
	}
}