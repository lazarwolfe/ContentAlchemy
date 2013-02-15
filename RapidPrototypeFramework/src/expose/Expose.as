package expose
{
	import expose.screen.MouseScreen;
	import expose.screen.page.ExposePage;
	import expose.screen.page.PageScreen;
	import expose.utils.PageFactory;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import utils.DisplayUtil;

	public class Expose
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private static var _sprite:Sprite;
		private static var _mainScreen:PageScreen;
		private static var _mouseScreen:MouseScreen;
		private static var _stage:Stage;
		private static var _active:Boolean;
		
		// ##### PROPERTIES
		public static function get active():Boolean {
			return _active;
		}
		public static function set active(value:Boolean):void {
			_active = value;
			_sprite.visible = _active;
			if(!_active){
				showMain();
			}
			
			if(Core.scenes.getCurrScene()!=null){
				if (_active) {
					Core.scenes.getCurrScene().pause();
				}else{
					Core.scenes.getCurrScene().unpause();
				}
			}
		}
		public static function get sprite():Sprite {
			return _sprite;
		}
		
		// ##### INITIALIZER
		/**
		 * The Initializer
		 */
		public static function init(stage:Stage):void
		{
			_stage = stage;
			
			// Screen structure
			_sprite = new Sprite();
			_mainScreen = new PageScreen(_sprite,_stage);
			_mainScreen.show( new ExposePage() ); // Just BLANK.
			_mouseScreen = new MouseScreen(_sprite,_stage);
			
			// Default
			showMain();
			Expose.active = false;
			
			// Stage Events
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			_stage.addEventListener(Event.RESIZE,onResize);
		}
		
		// ##### PUBLIC
		public static function show(page:ExposePage,activate:Boolean=false):void
		{
			_mainScreen.show(page);
			showMain();
			
			// Activate
			if(activate){
				Expose.active = true;
			}
		}
		public static function showObject(obj:*,activate:Boolean=false):void
		{
			show( PageFactory.getPageFromObject(obj), activate );
		}
		public static function showObjectProperties(obj:*,...properties):void
		{
			show( PageFactory.getPageFromObject(obj,null,properties), true );
		}
		public static function showMain():void
		{
			// DRY.....
			DisplayUtil.focusOn(_sprite,_mainScreen.sprite);
			_mainScreen.active = true;
			_mouseScreen.active = false;
		}
		public static function showCoordSelector(callback:Function,afterClick:Function=null):void
		{
			DisplayUtil.focusOn(_sprite,_mouseScreen.sprite);
			_mainScreen.active = false;
			_mouseScreen.active = true;
			
			_mouseScreen.setCallback(callback);
			_mouseScreen.setAfterClick(afterClick);
		}
		public static function addScreenTo(spr:Sprite):void {
			spr.addChild(_sprite);
		}
		public static function activate():void {
			Expose.active = true;
		}
		public static function deactivate():void {
			Expose.active = false;
		}
		public static function onResize(event:Event):void {
			_mainScreen.resize(_stage.stageWidth,_stage.stageHeight);
			_mouseScreen.resize(_stage.stageWidth,_stage.stageHeight);
		}
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		private static function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 13: // ENTER: Remove focus (TEMPORARY?)
					if(_active){
						_stage.focus = null;
					}
					break;
				
				case 88: // X: Toggle active
					if (_stage.focus==null){
						Expose.active = !Expose.active;
					}
					break;
				
				// ESCAPE
			}
		}
		
	}
}