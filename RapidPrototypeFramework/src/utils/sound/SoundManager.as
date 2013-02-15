package utils.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class SoundManager extends EventDispatcher
	{
		public var soundPackageName:String = "";
		public var defaultVolume:Number = 1.0;
		private var activeSound:Dictionary;
		
		static private var instance:SoundManager;
		static public function getInstance():SoundManager
		{
			if(!instance)
			{
				instance = new SoundManager();
			}
			
			return instance;
		}
		
		public function SoundManager()
		{
			activeSound = new Dictionary();
		}
		
		/**
		 * Set the Global volume
		 **/
		public function setGlobalVolume(volume:Number):void
		{
			SoundMixer.soundTransform = new SoundTransform(volume);
		}
		
		/**
		 * Set volume for a single sound
		 **/
		public function setVolume(name:String, volume:Number):void
		{
			var sound:SoundChannel = getActiveSound(name);
			
			if(sound)
			{
				sound.soundTransform = new SoundTransform(volume);
			}
		}
		
		private function getActiveSound(name:String):SoundChannel
		{
			return activeSound[name];
		}
		
		public function play(name:String, loop:int = 1, volume:Number = 1.0):void
		{
			//
			try
			{
				var ref:Class = getDefinitionByName(name) as Class;
			}
			catch(e:Error)
			{
				Core.logs.error(e.message, this);
			}
			
			var sound:Sound;
			if(ref)
			{
				sound = (new ref()) as Sound;
			}
			else
			{
				sound = new Sound();
				sound.load(new URLRequest(name), new SoundLoaderContext(1000, true));
				sound.addEventListener(IOErrorEvent.IO_ERROR, soundCompleteHandler);
			}
			
			var channel:SoundChannel = sound.play(0, loop != -1 ? loop : int.MAX_VALUE);
			
			//play sound failed
			if(!channel)
			{
				return;
			}
			
			if(loop != 0 && loop != -1)
			{
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
			
			activeSound[name] = channel;
			
			channel.soundTransform = new SoundTransform((volume != -1) ? volume : defaultVolume);
			
			//
			function soundCompleteHandler(evt:Event):void
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundCompleteHandler);
				
				delete activeSound[name];
			}
		}
		
		public function stop(name:String):void
		{
			//
			var sound:SoundChannel = activeSound[name];
			delete activeSound[name];
			
			if(sound)
			{
				sound.stop();
			}
		}
		
		public function stopAll():void
		{
			//
			for(var name:String in activeSound)
			{
				stop(name);
			}
		}

		
		public function isPlaying(name:String):Boolean
		{
			return activeSound[name] != null;
		}
		
		
	}
}