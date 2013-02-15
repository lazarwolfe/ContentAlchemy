package gamescene {
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import gamescene.interfaces.IRenderable2d;
	import gamescene.interfaces.ITimelineAnimation;
	import gamescene.standardcomponents.FakeRenderable2d;
	import gamescene.standardcomponents.MovieClipComponent;
	
	/**
	 * Represents a game object (entity) in the game world
	 * */
	public class GameObject {
		public static const COLLISION_EVENT:String = "CollisionEvent";
		
		//The string id of this obejct. Must be unique in the scene
		private var _id:String;
		public function get id():String {
			return _id;
		}
		
		//Is this game object active?
		private var _enabled:Boolean = true;
		public function get enabled():Boolean {
			return _enabled;
		}	
		
		//The scene where this game object lives
		private var _scene:GameScene;
		public function get scene():GameScene {
			return _scene;
		}
		
		//The collection of components this game obejct aggregates
		protected var _components:Vector.<Component> = new Vector.<Component>();
		public function get components():Vector.<Component> {
			return _components;
		}
		
		//The tags this game object has on the scene. An array of strings.
		private var _tags:Array = [];
		public function get tags():Array {
			return _tags;
		}
		
		//Keeps track of all the events different components are registered for
		private var _eventInformation:Dictionary = new Dictionary(true);
		
		//The parent of this game object
		private var _parent:GameObject = null;
		
		//The children of this game object
		private var _children:Vector.<GameObject> = null;
		
		//#UTILITY
		
		//Utility and fast reference to components
		private var _render2d:IRenderable2d = new FakeRenderable2d();
		public function get render2d():IRenderable2d {
			return _render2d;
		}
		
		//Utility and fast reference to components
		private var _animation:ITimelineAnimation = null;
		public function get animation():ITimelineAnimation {
			return _animation;
		}
		
		//Utility and fast reference to components
		private var _physics:PhysicsComponent = null;
		public function get physics():PhysicsComponent {
			return _physics;
		}
		
		//# CONSTRUCTION
		
		/**
		 * Constructor
		 * */
		public function GameObject(id:String = null) {
			this._id = id;
		}
		
		//# PUBLIC
		
		/**
		 * Enables this component
		 * */
		public function enable():void {
			var i:uint = 0;
			var component:Component;
			if(_enabled == false) {
				_enabled = true;
				
				//Notify all enabled components that they are enabled again.
				//The disabled ones will still be disabled so we shouldn't notify them.
				for(i = 0 ; i < _components.length ; i++) {
					component = _components[i];
					if(component.enabled == true) {
						component.onEnable();
					}
				}
			}
		}
		
		/**
		 * Disables this component
		 * */
		public function disable():void {
			var i:uint = 0;
			var component:Component;
			if(_enabled == true) {
				_enabled = false;
				
				//Notify all enabled components that they are disabled again.
				//The disabled ones were already in the new state so no need for notification.
				for(i = 0 ; i < _components.length ; i++) {
					component = _components[i];
					if(component.enabled == true) {
						component.onDisable();
					}
				}
			}
		}
		
		/**
		 * Destroys this game object and removes it from the scene
		 * */
		public function destroyGameObject():void {
			if(parent != null) {
				parent.removeChild(this);
			}
			
			//The scene is responsible for calling the internal method destroy() on this object
			_scene.removeGameObject(this);
		}
		
		/**
		 * Returns the first component of the specified type that this game object has, null otherwise
		 * */
		public function getComponent(type:String):Component {
			var i:int = 0;
			var component:Component;
			for(i = 0 ; i < _components.length ; i++) {
				component = _components[i];
				if(component.typeName == type) {
					return component;
				}
			}
			return null;
		}
		
		/**
		 * Returns a list with all the components of the specified type that this game object has
		 * */
		public function getComponents(type:String):Vector.<Component> {
			var i:int = 0;
			var list:Vector.<Component> = new Vector.<Component>();
			var component:Component;
			for(i = 0 ; i < _components.length ; i++) {
				component = _components[i];
				if(component.typeName == type) {
					list[list.length] = component;
				}
			}
			return list;
		}
		
		/**
		 * Adds a component to this game object.
		 * This should be called to add components at runtime.
		 * If the component is not initialized
		 * */
		public function addComponent(component:Component, initialize:Boolean = true):void {
			var i:int;
			var savedChildren:Vector.<GameObject>;
			var parentIndex:int;
			
			_components[_components.length] = component;
			
			//If we are adding a renderable component, remove our children and them again under the new renderable to update the render graph
			if(component is IRenderable2d) {
				//Remove from parent
				if(parent != null) {
					parentIndex = parent.getChildIndex(this);
					parent.render2d.internalGameObjectContainer.removeChild(this);
				}
				
				//Remove all children
				if(_children != null) {
					savedChildren =_children.concat();
					for(i= 0; i < _children.length ; i++) {
						_render2d.internalGameObjectContainer.removeChild(_children[i]);
					}
				}
				
				//Set the new component
				_render2d = component as IRenderable2d;
				
				//Add parent again
				if(parent != null) {
					parent.render2d.internalGameObjectContainer.addChildAt(this, parentIndex);
				}
				
				//Add children again
				if(_children != null) {
					for(i= 0; i < savedChildren.length ; i++) {
						_render2d.internalGameObjectContainer.addChild(savedChildren[i]);
					}
				}
			}
			
			if (component is PhysicsComponent) {
				_physics = component as PhysicsComponent;
				if (_scene != null) {
					_scene.addPhysicsComponent(_physics);
				}
			}
			
			//If we are adding a renderable component, remove our children and them again under the new renderable to update the render graph
			if(component is ITimelineAnimation) {
				//Set the new component
				_animation = component as ITimelineAnimation;
			}
			
			if(initialize == true) {
				component.initialize(this);
			}
		}
		
		/**
		 * Removes the specified component
		 * */
		public function removeComponent(component:Component):void {
			var i:int;
			var index:int = _components.indexOf(component);
			if(index != -1) {
				
				//If this is renderable, reamove our children from the render graph
				if(component is IRenderable2d) {
					var c:IRenderable2d = component as IRenderable2d;
					if(_children != null) {
						for(i= 0; i < _children.length ; i++) {
							c.internalGameObjectContainer.removeChild(_children[i]);
						}
					}
					_render2d = new FakeRenderable2d();
				}
				
				_components.splice(index, 1);
				component.onDestroy();
			}
				
		}
		
		/**
		 * Removes the first component of the specified type
		 * */
		public function removeComponentOfType(type:String):void {
			var i:int = 0;
			for (i = 0 ; i < _components.length ; i++) {
				if (_components[i].typeName == type) {
					removeComponent(_components[i]);
					return;
				}
			}
		} 
		
		/**
		 * Removes all components of the specified type
		 * */
		public function removeComponentsOfType(type:String):void {
			var i:int = 0;
			for (i = 0 ; i < _components.length ; i++) {
				if (_components[i].typeName == type) {
					removeComponent(_components[i]);
				}
			}
		} 
		
		//# OBJECT COMPOSITING
		
		/**
		 * The parent of this Game Object
		 * */
		public function get parent():GameObject {
			return _parent;
		}
		public function set parent(value:GameObject):void {
			_parent = value;
		}
		
		/**
		 *	The number of children this GameObject has
		 * */ 
		public function get numChildren():uint {
			if(_children != null) {
				return _children.length;
			}
			return 0;
		}
		
		/**
		 * Returns true if the specified object is a child of this one
		 * */
		public function contains(child:GameObject):Boolean {
			if(_children == null) {
				return false;
			}
			else {
				return _children.indexOf(child) != -1;
			}
		}
		
		/**
		 * Returns the child at the specified index
		 * */
		public function getChildAt(index:int):GameObject {
			if(_children == null || _children.length <= index) {
				return null;
			}
			else {
				return _children[index];
			}
		}
		
		/**
		 * Gets the index of the specified child
		 * */
		public function getChildIndex(child:GameObject):int {
			var i:int = 0;
			if(_children == null) {
				return -1;
			}
			for(i= 0; i < _children.length ; i++) {
				if(_children[i] == child) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * Adds a child to this game object
		 * */
		public function addChild(child:GameObject, tags:Array = null):GameObject {
			return addChildAt(child, numChildren, tags);
		}
		
		/**
		 * Adds a child at the specified index
		 * */
		public function addChildAt(child:GameObject, index:int, tags:Array = null):GameObject {
			//Scene management
			if (_scene != null) {
				if(child.scene == null) {
					_scene.addGameObject(child, tags);
				}
				else if(child.scene != scene) {
					//Core.logs.error("Trying to add a game object that belongs to another scene!", this);
				}
			}
			
			//Safe remove the old parent and set the new one
			if(child.parent != null) {
				child.parent.removeChild(child);
			}
			child.parent = this;
			
			if(_children == null) {
				_children = new Vector.<GameObject>();
			}
			
			//Add it in the specified index or at the end of the array
			if(_children.length <= index) {
				_children[_children.length] = child;
			}
			else {
				_children.splice(index, 0, child);	//Add it at the index
			}
			
			//Notify the render graph
			if(render2d != null) {
				render2d.internalGameObjectContainer.addChildAt(child, index);
			}
			
			return child;
		}
		
		/**
		 * Removes the specified child
		 * */
		public function removeChild(child:GameObject):GameObject {
			var index:int;
			if(_children == null) {
				return null;
			}
			index = _children.indexOf(child);
			if(index != -1) {
				_children.splice(index, 1);
				child.parent = null;
				
				//Notify the render graph
				if(render2d != null) {
					render2d.internalGameObjectContainer.removeChild(child);
				}
				
				return child;
			}
			else {
				return null;
			}
		}
		
		/**
		 * Swaps 2 childen indices
		 * */
		public function swapChildren(child1:GameObject, child2:GameObject):void {
			var index1:int;
			var index2:int;
			if(_children == null) {
				return;
			}
			index1 = _children.indexOf(child1);
			index2 = _children.indexOf(child2);
			
			if(index1 == -1 || index2 == -1 ) {
				return;
			}
			
			_children[index1] = child2;
			_children[index2] = child1;
			
			//Notify the render graph
			if(render2d != null) {
				render2d.internalGameObjectContainer.swapChildren(child1, child2);
			}
		}
		
		//# EVENT REGISTERING/UNREGISTERING
		
		/**
		 * Sends an event to all of the components in this game object
		 * */
		public function broadcast(event:BroadcastedEvent):void {
			onEvent(event);
		}
		
		/**
		 * Registers an event for a component
		 * */
		internal function registerEventForComponent(type:String, component:Component):void {
			var components:Vector.<Component> = _eventInformation[type];
			
			//If it didin't exist already, create a collection for this event type
			if(components == null) {
				components = _eventInformation[type] = new Vector.<Component>();
			}
			
			//Is this a mouse event?
			//We need to manually add an event listener for the Renderable component
			switch(type) {
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.ROLL_OVER:
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_WHEEL:
					//Core.logs.assert(this.render2d != null, "Assigning a mouse event to a game object (" + _id + ") without a Renderable component.", this);
					if(render2d != null) {
						render2d.internalMouseEventDispatcher.registerMouseEvent(type, onEvent);						
					}
					break;
			}
			
			
			if(components.indexOf(component) == -1) {
				components[components.length] = component;
			}
		}
		
		/**
		 * Unregisters an event for a component
		 * */
		internal function unregisterEventForComponent(type:String, component:Component):void {
			var components:Vector.<Component> = _eventInformation[type];
			var index:int;
			
			if(components == null) {
				return;
			}
			
			//Remove it
			index = components.indexOf(component);
			if(index != -1) {
				components.splice(index, 1);
			}
			
			//Remove mouse event listeners
			if(components.length == 0) {
				//Is this a mouse event?
				//We need to manually remove the event listener for the Renderable component if we were the last component using it
				switch(type) {
					case MouseEvent.CLICK:
					case MouseEvent.DOUBLE_CLICK:
					case MouseEvent.MOUSE_DOWN:
					case MouseEvent.MOUSE_UP:
					case MouseEvent.ROLL_OVER:
					case MouseEvent.ROLL_OUT:
					case MouseEvent.MOUSE_WHEEL:
						if(render2d != null) {
							render2d.internalMouseEventDispatcher.unregisterMouseEvent(type, onEvent);
						}
						break;
				}
			}
		}
		
		//# PRIVATE
		
		/**
		 * DO NOT CALL THIS FUNCTION. 
		 * This is automatically called by the Scene when this game object is added to it.
		 * */
		internal function setId(id:String):void {
			_id = id;
			
			//Ugly hack in case we have a movie clip
			var mcc:MovieClipComponent = render2d as MovieClipComponent;
			if(mcc) {
				mcc.clip.name = id;
			}
		}
		
		/**
		 * This is automatically called by the Scene when this game object is added to it.
		 * */
		internal function initialize(scene:GameScene):void {
			//Core.logs.assert(_scene == null, "Trying to assign a new scene to a game object. Game Objects cannot be moved to a new scene.", this);
			_scene = scene;
			initializeComponents();
		}
		
		/**
		 * This is automatically called by the Scene.
		 * */
		internal function setTags(tags:Array):void {
			_tags = tags;
		}
		
		/**
		 * This is automatically called by the Scene and event handlers.
		 * */	
		internal function onEvent(event:Event=null, type:String=null, data:Object=null):void {
			var i:int = 0;
			var toUpdate:Vector.<Component>;
			
			//Scene paused? Do nothing!
			if(_scene != null && _scene.paused == true) {
				return;
			}
			
			//Get the list of components that need to be notfied of this event.
			toUpdate = _eventInformation[event.type];
			if(toUpdate == null) {
				return;
			}
			
			if (type == null && event != null) {
				type = event.type;
			}
			
			for(i = 0 ; i < toUpdate.length ; i++){
				
				//Skip disabled components
				if(toUpdate[i].enabled == false) {
					continue;
				}
				
				switch(type) {
					//Enter Frame
					case Event.ENTER_FRAME:
						toUpdate[i].onEnterFrame(event);
						break;
					
					//Mouse events
					case MouseEvent.CLICK:
					case MouseEvent.DOUBLE_CLICK:
					case MouseEvent.MOUSE_DOWN:
					case MouseEvent.MOUSE_UP:
					case MouseEvent.ROLL_OVER:
					case MouseEvent.ROLL_OUT:
					case MouseEvent.MOUSE_WHEEL:
						toUpdate[i].onMouseEvent(MouseEvent(event));
						break;
					
					case COLLISION_EVENT:
						toUpdate[i].onCollision(data as PhysicsComponent);
						break;
					
					//Keyboard events
					case KeyboardEvent.KEY_DOWN:
					case KeyboardEvent.KEY_UP:
						toUpdate[i].onKeyboardEvent(KeyboardEvent(event));
						break;
					
					//Any other case is a broadcasted event
					default:
						//Core.logs.assert(event is BroadcastedEvent, "Can't find event type for event!", this);
						toUpdate[i].onBroadcast(BroadcastedEvent(event));
						break;
				}	
			}
		}
		
		/**
		 * This is automatically called by the Scene.
		 * */
		internal function initializeComponents():void {			
			//Call onStart on them
			var i:int = 0;
			for(i = 0 ; i < _components.length ; i++) {
				if(_components[i].initialized == false) {
					_components[i].initialize(this);
				}
			}
		}
		
		/**
		 * This is automatically called by the Scene.
		 * */
		public function destroy():void {
			var currentComponents:Vector.<Component> = new Vector.<Component>();
			var type:String
			var i:int = 0;
			
			//Remove all event listeners
			for (type in this._eventInformation) {
				currentComponents = this._eventInformation[type];
				if(currentComponents != null) {
					for (i = 0; i < currentComponents.length; i++) {
						unregisterEventForComponent(type, currentComponents[i]);
					}
				}

				this._eventInformation[type] = null;
			}
			
			//Notify each component of its destruction
			for(i = 0 ; i < _components.length ; i++) {
				_components[i].onDestroy();
				_components[i].destroy();
				_components[i] = null;
			}
			
			_components = null;
			_enabled = false;
			_eventInformation = null;
			_id = "";
			_render2d = null;
			_scene = null;
			_tags = null;
			_children = null;
		}
	}
}