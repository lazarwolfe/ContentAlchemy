package expose.screen.page
{
	
	import expose.screen.ExposeScreen;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import utils.DisplayUtil;

	public class PageScreen extends ExposeScreen
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _background:Sprite;
		private var _currPage:ExposePage;
		private var _currPageSprite:Sprite;
		
		// ##### PROPERTIES
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function PageScreen(exposeSprite:Sprite,stage:Stage)
		{
			super(exposeSprite,stage);
			_stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			init();
		}
		public function init():void
		{
			// Sprite Structure
			_background = new Sprite();
			_currPageSprite = new Sprite();
			_sprite.addChild(_background);
			_sprite.addChild(_currPageSprite);
		}
		
		// ##### PUBLIC
		public function show(page:ExposePage):void
		{
			// Clear
			DisplayUtil.clear(_currPageSprite);
			
			// Add page
			_currPage = page;
			_currPageSprite.addChild(page.sprite);
			
			// Resize
			resize(_stage.stageWidth,_stage.stageHeight);
		}
		public function updateUI():void
		{
			_currPage.updateUI();
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		override public function resize(width:Number,height:Number):void
		{
			_currPage.resize(width,height);
			_background.graphics.clear();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,width,height);
		}
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		private function onEnterFrame(event:Event):void
		{
			if(!_active) return;
			
			updateUI();
		}
	}
}