package expose.screen
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import utils.SpriteManager;

	public class ExposeScreen extends SpriteManager
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		protected var _stage:Stage;
		protected var _active:Boolean;
		
		// ##### PROPERTIES
		public function get active():Boolean {
			return _active;
		}
		public function set active(value:Boolean):void {
			_active = value;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function ExposeScreen(exposeSprite:Sprite,stage:Stage)
		{
			super();
			_stage = stage;
			_active = false;
			exposeSprite.addChild(_sprite);
		}
		
		// ##### PUBLIC
		public function resize(width:Number,height:Number):void
		{
			// TO BE IMPLEMENTED
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
	}
}