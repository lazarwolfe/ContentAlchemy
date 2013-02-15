package gamescene.standardcomponents
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import gamescene.GameObject;
	import gamescene.interfaces.IGameObjectContainer;
	import gamescene.interfaces.IMouseEventDispatcherComponent;
	import gamescene.interfaces.IRenderable2d;
	
	/**
	 * Empty renderable. Does nothing. used as the default renderable2d object in Game Obejcts.
	 * */
	public class FakeRenderable2d implements IRenderable2d, IMouseEventDispatcherComponent, IGameObjectContainer {
		public function FakeRenderable2d() {}
		
		public function get x():Number {
			return 0;
		}
		
		public function set x(value:Number):void{
		}
		
		public function get y():Number {
			return 0;
		}
		
		public function set y(value:Number):void {
		}
		
		public function get absolutePosition():Point {
			return new Point();
		}
		
		public function set absolutePosition(value:Point):void {
		}
		
		public function get width():Number {
			return 0;
		}
		
		public function set width(value:Number):void {
		}
		
		public function get height():Number {
			return 0;
		}
		
		public function set height(value:Number):void {
		}
		
		public function get scaleX():Number {
			return 0;
		}
		
		public function set scaleX(value:Number):void {
		}
		
		public function get scaleY():Number {
			return 0;
		}
		
		public function set scaleY(value:Number):void {
		}
		
		public function get rotation():Number {
			return 0;
		}
		
		public function set rotation(value:Number):void {
		}
		
		public function get alpha():Number {
			return 0;
		}
		
		public function set alpha(value:Number):void {
		}
		
		/**
		 * The object handling event dispatching for this instance. 
		 **/		
		public function get eventDispatcher():IEventDispatcher {
			return null;
		}
		
		public function get stage():Stage {
			return null;
		}
		
		public function registerMouseEvent(type:String, callback:Function):void {
		}
		
		public function unregisterMouseEvent(type:String, callback:Function):void {
		}
		
		public function addChild(child:GameObject):void {
		}
		
		public function addChildAt(child:GameObject, index:int):void {
		}
		
		public function removeChild(child:GameObject):void {
		}
		
		public function removeChildAt(index:int):void {
		}
		
		public function setChildIndex(child:GameObject, index:int):void {
		}
		
		public function swapChildren(child1:GameObject, child2:GameObject):void {
		}
		
		public function swapChildrenAt(index1:int, index2:int):void {
		}
		
		//# PRIVATE
		//# Accessor to itnernal forms of the API
		
		/**
		 * Internal property used by the system.
		 * Provides access to functions that deal with registering mouse events in the game object.
		 * */
		public function get internalMouseEventDispatcher():IMouseEventDispatcherComponent {
			return this as IMouseEventDispatcherComponent;
		}
		
		/**
		 * Internal property used by the system
		 * Provides access to functions that deal with aggregating game objects in the render graph
		 * */
		public function get internalGameObjectContainer():IGameObjectContainer {
			return this as IGameObjectContainer;
		}
	}
}