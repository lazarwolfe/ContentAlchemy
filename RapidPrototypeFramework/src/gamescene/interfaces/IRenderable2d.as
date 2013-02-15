package gamescene.interfaces
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 * Components that provide rendering functionality must implement this interface
	 * */
	public interface IRenderable2d extends IRenderable {
		/**
		 * The x coordinate of the visual
		 * */
		function get x():Number;
		function set x(value:Number):void;
		
		/**
		 * The y coordinate of the visual
		 * */
		function get y():Number;
		function set y(value:Number):void;
		
		/**
		 * The absolute (x,y) coordinates of the visual
		 * */
		function get absolutePosition():Point;
		function set absolutePosition(value:Point):void;
		
		/**
		 * The width of the visual
		 * */
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * The height of the visual
		 * */
		function get height():Number;
		function set height(value:Number):void;
		
		/**
		 * The x scale of the visual
		 * */
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		/**
		 * The y scale of the visual
		 * */
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		/**
		 * The rotation angle of the visual
		 * */
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		/**
		 * The alpha value of the visual [0, 1]
		 * */
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		/**
		 * The object handling event dispatching for this instance. 
		 **/		
		function get eventDispatcher():IEventDispatcher;
		
		/**
		 * The stage property of the visual
		 * */
		function get stage():Stage;
		
		/**
		 * Internal property used by the system.
		 * Provides access to functions that deal with registering mouse events in the game object.
		 * */
		function get internalMouseEventDispatcher():IMouseEventDispatcherComponent;
		
		/**
		 * Internal property used by the system
		 * Provides access to functions that deal with aggregating game objects in the render graph
		 * */
		function get internalGameObjectContainer():IGameObjectContainer;

	}
}