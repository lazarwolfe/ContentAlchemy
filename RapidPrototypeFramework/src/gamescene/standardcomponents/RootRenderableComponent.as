package gamescene.standardcomponents
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import gamescene.Component;
	import gamescene.GameObject;
	import gamescene.interfaces.IGameObjectContainer;
	import gamescene.interfaces.IMouseEventDispatcherComponent;
	import gamescene.interfaces.IRenderable2d;
	
	/**
	 * IRenderable component that should only be used by the Root object of the scene. 
	 * It supports multiple render graphs to ease development (you can add children that are using any rendering technique),
	 * but this causes some problems and some functionality cannot be implemented, like addChildAt, removeChildAt, etc.
	 * */
	public class RootRenderableComponent extends Component implements IRenderable2d, IGameObjectContainer, IMouseEventDispatcherComponent {
		//The other renderable components 
		private var _movieClipComponent:MovieClipComponent = null;
		
		public function RootRenderableComponent() {
		}
		
		//# IRenderable2d
		
		/**
		 * The x coordinate of the visual
		 * */
		public function get x():Number {
			return 0;
		}
		public function set x(value:Number):void {
		}
		
		/**
		 * The y coordinate of the visual
		 * */
		public function get y():Number {
			return 0;
		}
		public function set y(value:Number):void {
		}
		
		/**
		 * The absolute (x,y) coordinates of the visual
		 * */
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
		
		/**
		 * The x scale of the visual
		 * */
		public function get scaleX():Number {
			return 1;
		}
		public function set scaleX(value:Number):void {
		}
		
		/**
		 * The y scale of the visual
		 * */
		public function get scaleY():Number {
			return 1;
		}
		public function set scaleY(value:Number):void {
		}
		
		/**
		 * The rotation angle of the visual
		 * */
		public function get rotation():Number {
			return 0;
		}
		public function set rotation(value:Number):void {
		}
		
		/**
		 * The alpha value of the visual [0, 1]
		 * */
		public function get alpha():Number {
			return 1;
		}
		public function set alpha(value:Number):void {
		}
		
		/**
		 * The object handling event dispatching for this instance. 
		 **/		
		public function get eventDispatcher():IEventDispatcher {
			return Stage as Stage;
		}
		
		/**
		 * The stage property of the visual
		 * */
		public function get stage():Stage {
			return Stage as Stage;
		}
		
		//# IMouseEventDispatcherComponent
		
		/**
		 * Registers the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		public function registerMouseEvent(type:String, callback:Function):void {
		}
		
		/**
		 * Unregisters the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		public function unregisterMouseEvent(type:String, callback:Function):void {
		}
		
		//# IGameObjectContainer
		
		/**
		 * Adds a child to this game object
		 * */
		public function addChild(child:GameObject):void {
			if(child.render2d != null) {
				getRenderableType(child).internalGameObjectContainer.addChild(child);
			}
		}
		
		/**
		 * Adds a child at the specified index
		 * */
		public function addChildAt(child:GameObject, index:int):void {
			addChild(child);	//Sorry folks, no support for index here. The problem is that because this component has more than 1 render graph (it holds multiple renderable components),
								//the index passed here will not match the one in the render graph. e.g. If this root game obejct has 100 children, 50 using MuvieClips and 50 Blittable,
								//when you add a new one the index will be 101, which makes no sense to either graph (they are expecting 51). 
		}
		
		/**
		 * Removes the specified child
		 * */
		public function removeChild(child:GameObject):void {
			if(child.render2d != null) {
				getRenderableType(child).internalGameObjectContainer.removeChild(child);
			}
		}
		
		/**
		 * Removes the child at the specified index
		 * */
		public function removeChildAt(index:int):void {
			//In which component?
			//This cannot be implemented.
			//See the comment in addChildAt();
		}
		
		/**
		 * Changes a child's index
		 * */
		public function setChildIndex(child:GameObject, index:int):void {
			if(child.render2d != null) {
				getRenderableType(child).internalGameObjectContainer.setChildIndex(child, index);
			}
		}
		
		/**
		 * Swaps 2 childen indices
		 * */
		public function swapChildren(child1:GameObject, child2:GameObject):void {
			if(child1.render2d != null && child2.render2d != null) {
				getRenderableType(child1).internalGameObjectContainer.swapChildren(child1, child2);
			}
		}
		
		/**
		 * Swaps 2 childen indices
		 * */
		public function swapChildrenAt(index1:int, index2:int):void {
			//In which component?
			//This cannot be implemented.
			//See the comment in addChildAt();
		}
		
		//# Event handlers
		
		/**
		 * Startup
		 * */
		public override function onStart():void {
			requiresComponent("MovieClipComponent");
			_movieClipComponent = owner.getComponent("MovieClipComponent") as MovieClipComponent;
		}
		
		/**
		 * Destruction
		 * */
		public override function onDestroy():void {
			_movieClipComponent = null;
		}
		
		//# Private
		
		/**
		 * Determines the type of the renderable component for the given game object and
		 * returns the IRenderable that should perform the operation based on it.
		 * */
		public function getRenderableType(object:GameObject):IRenderable2d {
			if(object.render2d is MovieClipComponent) {
				return _movieClipComponent;
			}
			return null;
		}

		
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