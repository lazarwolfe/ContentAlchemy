package debug {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * A lightweight UI for tracking client performance.
	 * 
	 * @author SDedlmayr
	 **/
	public class DebugPerformanceUI extends Sprite {
		private var _fpsText:TextField;
		private var _memoryText:TextField;
		
		private var _timer:Timer;
		private var _fps:int = 0;
		
		/**
		 * The DebugPerformanceUI constructor.
		 **/
		public function DebugPerformanceUI() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		} //DebugPerformanceUI
		
		/**
		 * Destroys this instance.
		 **/		
		public function destroy():void {
			var length:uint = this.numChildren;
			
			for (var i:uint = 0; i < length; i++) {
				this.removeChildAt(0);
			}
			
			this._fpsText = null;
			this._memoryText = null;
			
		} //destroy
		
		/**
		 * Initializes this instance.
		 **/		
		public function initialize():void {
			this._fpsText = new TextField();
			this._memoryText = new TextField();
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		} //initialize
		
		/**
		 * Draws the presentation.
		 **/		
		public function draw():void 
		{
			var readoutSprite:Sprite = new Sprite();
			
			readoutSprite.graphics.beginFill(0x000000, 0.9);
			readoutSprite.graphics.drawRect(0, 0, 55, 40);
			readoutSprite.graphics.endFill();
			
			addChild(readoutSprite);
			
			this._fpsText.defaultTextFormat = new TextFormat('Arial', 12, 0xFFFF00);
			this._fpsText.width = 45;
			this._fpsText.height = 15;
			this._fpsText.x = 5;
			
			addChild(this._fpsText);
			
			this._memoryText.defaultTextFormat = new TextFormat('Arial', 12, 0x00FF00);
			this._memoryText.width = 45;
			this._memoryText.height = 15;
			this._memoryText.x = 5;
			this._memoryText.y = this._fpsText.y + 10;
			
			addChild(this._memoryText);
			
		} //draw
	
		/**
		 * Handles the ADDED_TO_STAGE event.
		 **/	
		private final function addedToStageHandler(event:Event):void {
			initialize();
			draw();
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false);
		} //addedToStageHandler
		
		/**
		 * Handles the ENTER_FRAME event.
		 **/	
		private final function enterFrameHandler(event:Event):void {
			_fps++;
		}
		
		/**
		 * Handles the Timer event.
		 **/	
		private final function onTimer(event:Event):void {
			_fpsText.text = _fps + " FPS";
			_memoryText.text = uint(System.totalMemory * 0.000000954) + " MB";
			_fps = 0;
		}
	} 
}