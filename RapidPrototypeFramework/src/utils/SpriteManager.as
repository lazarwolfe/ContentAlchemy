package utils
{
	import flash.display.Sprite;

	public class SpriteManager
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		protected var _sprite:Sprite;
		
		// ##### PROPERTIES
		public function get sprite():Sprite {
			return _sprite;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function SpriteManager()
		{
			_sprite = new Sprite();
		}
	}
}