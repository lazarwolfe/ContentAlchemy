package data.cache
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;

	public class CacheManager
	{
		static private var instance:CacheManager;
		static public function getInstance():CacheManager
		{
			if(!instance)
			{
				instance = new CacheManager();
			}
			
			return instance;
		}
		
		private var sharedObject:SharedObject;
		public static const minDiskSpace:int = 20000000;
		
		public function CacheManager()
		{
			sharedObject = SharedObject.getLocal("fileCache");
			sharedObject.addEventListener(NetStatusEvent.NET_STATUS, errorHandler);
		}
		
		protected function errorHandler(event:NetStatusEvent):void
		{
			//
			Core.logs.error(event.info.toString(), this);
		}
		
		public function save(name:String, data:Object):Boolean
		{
			//
			try
			{
				sharedObject.setProperty(name, data);
				sharedObject.flush(minDiskSpace);
			}
			catch(e:Error)
			{
				//
				Core.logs.error(e.message, this);
			}
			
			return true;
		}
		
		public function load(name:String):Object
		{
			try
			{
				var o:Object = sharedObject.data[name];
			}
			catch(e:Error)
			{
				//
				Core.logs.error(e.message, this);
			}
			
			return o ? o.data : null;
		}
		
		public function clear():void
		{
			sharedObject.clear();
		}
	}
}