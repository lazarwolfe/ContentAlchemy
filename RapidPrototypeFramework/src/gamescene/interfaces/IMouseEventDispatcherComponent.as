package gamescene.interfaces
{
	public interface IMouseEventDispatcherComponent {
		/**
		 * THIS FUNCTION SHOULD NOT BE CALLED BY OTHER COMPONENTS!
		 * Registers the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		function registerMouseEvent(type:String, callback:Function):void;
		
		/**
		 * THIS FUNCTION SHOULD NOT BE CALLED BY OTHER COMPONENTS!
		 * Unregisters the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		function unregisterMouseEvent(type:String, callback:Function):void;
	}
}