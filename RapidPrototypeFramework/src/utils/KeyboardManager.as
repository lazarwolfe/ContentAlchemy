package utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * Represents the state of the keyboard.
	 */
	public class KeyboardManager
	{
		
		private var _initialized:Boolean = false;  // Marks whether or not the class has been initialized
		private var _keysDown:Object = new Object();  // Stores key codes of all keys pressed
		private var _stage:Stage;
		
		/**
		 * Constructor
		 */
		function KeyboardManager(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			_stage.addEventListener(Event.DEACTIVATE, onFocusLost);
		}
		
		/**
		 * Returns true or false if the key represented by the
		 * keyCode passed is being pressed
		 * @param keyCode The Keycode corresponding to the key that should be tested.
		 * @return A Boolean determining if the specified key is down.
		 */
		public function isKeyDown(keyCode:uint):Boolean
		{
			return Boolean(keyCode in _keysDown);
		}
		
		/**
		 * Event handler for capturing keys being pressed.
		 */
		private function onKeyPressed(event:KeyboardEvent):void
		{
			// create a property in keysDown with the name of the keyCode
			_keysDown[event.keyCode] = true;
		}
		
		/**
		 * Event handler for capturing keys being released.
		 */
		private function onKeyReleased(event:KeyboardEvent):void
		{
			if (event.keyCode in _keysDown)
			{
				//Delete the property in keysDown if it exists
				delete _keysDown[event.keyCode];
			}
		}
		
		/**
		 * Event handler for Flash Player deactivation.
		 */
		private function onFocusLost(event:Event):void
		{
			//Clear all keys in keysDown since the player cannot detect keys being pressed or released when not focused
			_keysDown = new Object();
		}
	}
}