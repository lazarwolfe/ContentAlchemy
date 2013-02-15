package data
{
	import expose.Expose;
	import expose.utils.GameExposer;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import utils.JsonAutoSerializerUtils;

	public class GameDataManager
	{
		private static var instance:GameDataManager;
		
		private var file:FileReference;
		
		public function GameDataManager()
		{
		}
		
		public static function getInstance():GameDataManager
		{
			if( instance == null )
			{
				instance = new GameDataManager();
			}
			
			return instance;
		}
		
		public function loadGameData():void
		{
			//
			file = new FileReference();
			file.addEventListener(Event.SELECT, loadFileSelectHandler);
			
			var fileFilter:FileFilter = new FileFilter("JSON:", "*.json");
			file.browse([fileFilter]);
		}
		
		protected function loadFileSelectHandler(event:Event):void
		{
			//
			file.removeEventListener(Event.SELECT, loadFileSelectHandler);
			
			file.addEventListener(Event.COMPLETE, loadCompleteHandler);
			file.load();
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			//
			file.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			Core.data = JsonAutoSerializerUtils.fromJsonString(file.data.toString(), GameData) as GameData;
			GameExposer.showGameDataPage();
		}
		
		public function saveGameData():void
		{
			var gameDataStr:String = JsonAutoSerializerUtils.toJsonString(Core.data);
			file = new FileReference();
			file.addEventListener(Event.COMPLETE, saveCompleteHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			file.save(gameDataStr, "GameData.json");
		}
		
		protected function saveIOErrorHandler(event:IOErrorEvent):void
		{
			file.removeEventListener(Event.COMPLETE, saveCompleteHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			
			Core.logs.error("Error while saving the file", this);
		}
		
		protected function saveCompleteHandler(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE, saveCompleteHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
			
			Core.logs.debug("Save complete", this);
		}
		
	}
}


















