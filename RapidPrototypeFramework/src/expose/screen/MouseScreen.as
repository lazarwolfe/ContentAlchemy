package expose.screen
{
	import expose.Expose;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class MouseScreen extends ExposeScreen
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _reticle:Sprite;
		private var _callback:Function;
		private var _afterClick:Function;
		
		// ##### PROPERTIES
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function MouseScreen(exposeSprite:Sprite,stage:Stage)
		{
			super(exposeSprite,stage);
			_stage.addEventListener(MouseEvent.CLICK,onClick);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			init();
		}
		public function init():void
		{
			// Sprite Structure
			_reticle = new Sprite();
			_sprite.addChild(_reticle);
			
			// Draw
			drawReticle();
		}
		
		// ##### PUBLIC
		public function setCallback(callback:Function):void {
			_callback = callback;
		}
		public function setAfterClick(afterClick:Function):void {
			_afterClick = afterClick;
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		override public function resize(width:Number,height:Number):void
		{
			drawReticle();
		}
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		private function onClick(event:MouseEvent):void
		{
			updatePosition(event);
			if(!_active) return;
			
			_callback(event);
			if(_afterClick==null){
				Expose.showMain();
			}else{
				_afterClick();
			}
		}
		private function onMouseMove(event:MouseEvent):void
		{
			if(!_active) return;
			updatePosition(event);
		}
		private function updatePosition(event:MouseEvent):void
		{
			_reticle.x = event.stageX;
			_reticle.y = event.stageY;
		}
		private function drawReticle():void
		{
			_reticle.graphics.lineStyle(4,0x000000);
			drawReticleGraphics();
			_reticle.graphics.lineStyle(2,0xFFFFFF);
			drawReticleGraphics();
		}
		private function drawReticleGraphics():void
		{
			_reticle.graphics.drawCircle(0,0,10);
			_reticle.graphics.moveTo(10,0);
			_reticle.graphics.lineTo(_stage.stageWidth,0);
			_reticle.graphics.moveTo(-10,0);
			_reticle.graphics.lineTo(-_stage.stageWidth,0);
			_reticle.graphics.moveTo(0,10);
			_reticle.graphics.lineTo(0,_stage.stageHeight);
			_reticle.graphics.moveTo(0,-10);
			_reticle.graphics.lineTo(0,-_stage.stageHeight);
		}
		
	}
}