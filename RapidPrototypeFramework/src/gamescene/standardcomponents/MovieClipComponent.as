package gamescene.standardcomponents {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import gamescene.Component;
	import gamescene.GameObject;
	import gamescene.interfaces.IGameObjectContainer;
	import gamescene.interfaces.IMouseEventDispatcherComponent;
	import gamescene.interfaces.IRenderable2d;
	import gamescene.interfaces.ITimelineAnimation;

	public class MovieClipComponent extends Component implements IRenderable2d, IGameObjectContainer, IMouseEventDispatcherComponent, ITimelineAnimation {
		
		//The MovieClip 
		protected var _clip:MovieClip = null;
		
		/**
		 * Setter
		 * */
		public function get clip():MovieClip {
			return _clip;
		}
		
		/**
		 * Constructor
		 * */
		public function MovieClipComponent (clip:MovieClip) {
			setClip(clip);
		}
		
		/**
		 * Setter. Makes sure to remove the old clip from the display tree (if any)
		 * */
		private function setClip(clip:MovieClip):void {
			//Remove the old one from the display tree
			if(_clip != null) {
				if( _clip.parent != null) {
					_clip.parent.removeChild(_clip);
				}
			}
			
			//Add to the display tree if we are already activated
			if(owner!= null) {
				owner.scene.clip.addChild(_clip);
			}
			
			_clip = clip;
		}
		
		//# IRenderable2d
		
		/**
		 * The x coordinate of the visual
		 * */
		public function get x():Number {
			return _clip.x;
		}
		public function set x(value:Number):void {
			_clip.x = value;
		}
		
		/**
		 * The y coordinate of the visual
		 * */
		public function get y():Number {
			return _clip.y;
		}
		public function set y(value:Number):void {
			_clip.y = value;
		}
		
		/**
		 * The absolute (x,y) coordinates of the visual
		 * */
		public function get absolutePosition():Point {
			if(_clip.parent == null)
				return null;
			return _clip.parent.localToGlobal(new Point(_clip.x, _clip.y));
		}
		public function set absolutePosition(value:Point):void {
			if(_clip.parent == null)
				return;
			var p:Point = _clip.parent.globalToLocal(value);
			_clip.x = p.x;
			_clip.y = p.y
		}	
		
		/**
		 * The width of the visual
		 * */
		public function get width():Number {
			return this._clip.width;
		}
		
		public function set width(value:Number):void {
			this._clip.width = value;
		}
		
		/**
		 * The height of the visual
		 * */
		public function get height():Number {
			return this._clip.height;
		}
		
		public function set height(value:Number):void {
			this._clip.height = value;
		}
		
		/**
		 * The x scale of the visual
		 * */
		public function get scaleX():Number {
			return _clip.scaleX;
		}
		public function set scaleX(value:Number):void {
			_clip.scaleX = value;
		}
		
		/**
		 * The y scale of the visual
		 * */
		public function get scaleY():Number {
			return _clip.scaleY;
		}
		public function set scaleY(value:Number):void {
			_clip.scaleY = value;
		}
		
		/**
		 * The rotation angle of the visual
		 * */
		public function get rotation():Number {
			return _clip.rotation;
		}
		public function set rotation(value:Number):void {
			_clip.rotation = value;
		}
		
		/**
		 * The alpha value of the visual [0, 1]
		 * */
		public function get alpha():Number {
			return _clip.alpha;
		}
		public function set alpha(value:Number):void {
			_clip.alpha = value;
		}
		
		/**
		 * The object handling event dispatching for this instance. 
		 **/		
		public function get eventDispatcher():IEventDispatcher {
			return this._clip;
		}
		
		/**
		 * The stage property of the visual
		 * */
		public function get stage():Stage {
			return _clip.stage;
		}
		
		//# IMouseEventDispatcherComponent
		
		/**
		 * Registers the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		public function registerMouseEvent(type:String, callback:Function):void {
			_clip.addEventListener(type, callback);
		}
		
		/**
		 * Unregisters the callback as a listener for the specified MouseEvent
		 * @param type the MouseEvent type. e.g. mouseEvent.CLICK
		 * @param callback the listener function for that event. Should be GameObject.onEvent
		 * */
		public function unregisterMouseEvent(type:String, callback:Function):void {
			_clip.removeEventListener(type, callback);
		}
		
		//# IGameObjectContainer
		
		/**
		 * Adds a child to this game object
		 * */
		public function addChild(child:GameObject):void {
			clip.addChild(getClip(child));
		}
		
		/**
		 * Adds a child at the specified index
		 * */
		public function addChildAt(child:GameObject, index:int):void {
			clip.addChildAt(getClip(child), index);
		}
		
		/**
		 * Removes the specified child
		 * */
		public function removeChild(child:GameObject):void {
			clip.removeChild(getClip(child));
		}
		
		/**
		 * Removes the child at the specified index
		 * */
		public function removeChildAt(index:int):void {
			clip.removeChildAt(index);
		}
		
		/**
		 * Changes a child's index
		 * */
		public function setChildIndex(child:GameObject, index:int):void {
			clip.setChildIndex(getClip(child), index);
		}
		
		/**
		 * Swaps 2 childen indices
		 * */
		public function swapChildren(child1:GameObject, child2:GameObject):void {
			clip.swapChildren(getClip(child1), getClip(child2));
		}
		
		/**
		 * Swaps 2 childen indices
		 * */
		public function swapChildrenAt(index1:int, index2:int):void {
			clip.swapChildrenAt(index1, index2);
		}
		
		//# BEGIN ITimelineAnimation INTERFACE
		
		/**
		 * Plays the timeline animation.
		 **/		
		public function play():void {
			_clip.play();
		} 
		
		/**
		 * Stops the timelien animation.
		 **/		
		public function stop():void {
			_clip.stop();
		} 
		
		/**
		 * Moves the playhead of the timeline animation to the specified frame and stops it.
		 * 
		 * @param frame The frame to which to move the playhead.
		 **/		
		public function gotoAndStop(frame:uint):void {
			_clip.gotoAndStop(frame);
		} 
		
		/**
		 * Moves the playhead of the timeline animation to the specified frame and plays it.
		 * 
		 * @param frame The frame to which to move the playhead.
		 **/		
		public function gotoAndPlay(frame:uint):void {
			_clip.gotoAndPlay(frame);
		} 
		
		/**
		 * Moves the playhead of the timeline animation to the next frame.
		 **/		
		public function nextFrame():void {
			_clip.nextFrame();
		} 
		
		/**
		 * Moves the playhead of the timeline animation to the previous frame.
		 **/		
		public function prevFrame():void {
			_clip.prevFrame();
		} 
		
		//# END ITimelineAnimation INTERFACE
		
		
		//# Event handlers
		
		/**
		 * Startup
		 * */
		public override function onStart():void {
		}
		
		/**
		 * Destruction
		 * */
		public override function onDestroy():void {
			if(_clip != null) {
				if( _clip.parent != null) {
					_clip.parent.removeChild(_clip);
					_clip = null;
				}
			}
		}
		
		//# Private
		
		/**
		 * Extracts a MovieClip from a Game Object.
		 * Will throw an error if the Gameobject doesn't have a MovieClipComponent
		 * */
		private function getClip(object:GameObject):MovieClip {
			if(object.render2d == null) {
				//Core.logs.error("Trying to do a render operation on an object that doesn't have an IRenderable2d component", this);
				return null;
			}
			var mcRenderable:MovieClipComponent = object.render2d as MovieClipComponent;
			if(mcRenderable == null) {
				//Core.logs.error("Trying to do a render operation with a target object that doesn't have an MovieClipComponent component", this);
				return null;
			}
			return mcRenderable.clip;
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