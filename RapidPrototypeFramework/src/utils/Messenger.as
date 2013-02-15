package utils
{
	public class Messenger
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _callbacks:Vector.<Function>;
		
		// ##### PROPERTIES
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function Messenger()
		{
			_callbacks = new Vector.<Function>();
		}
		
		// ##### PUBLIC
		public function notify(data:*):void
		{
			var callback:Function;
			for each( callback in _callbacks ){
				callback(data);
			}
		}
		public function add(callback:Function):void
		{
			_callbacks.push(callback);
		}
		public function remove(callback:Function):void
		{
			var index:int = _callbacks.indexOf(callback);
			_callbacks.splice(index,1);
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		
	}
}