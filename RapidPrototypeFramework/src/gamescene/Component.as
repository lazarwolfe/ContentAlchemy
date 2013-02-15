package gamescene
{	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	
	public class Component {
		//The game object that aggregates this component
		protected var _owner:GameObject;
		public function get owner():GameObject {
			return _owner;
		}

		//Is this component active?
		private var _enabled:Boolean = true;
		public function get enabled():Boolean {
			return _enabled;
		}
		
		//Is this component initialized yet?
		private var _initialized:Boolean = false;
		public function get initialized():Boolean {
			return _initialized;
		}
		
		//The name of the class this object is an instance of
		private var _type:String;
		
		/**
		 * Constructor
		 * */
		public function Component() {}
		
		/**
		 * The Component destructor.
		 **/
		internal function destroy():void {
			this._enabled = false;
			this._owner = null;
			this._initialized = false;
			this._type = "";
		}
		
		//# PUBLIC
		
		/**
		 * Enables this component
		 * */
		public function enable():void {
			if(_enabled == false) {
				_enabled = true;
				if(_owner.enabled) {
					onEnable();
				}
			}
		}
		
		/**
		 * Disables this component
		 * */
		public function disable():void {
			if(_enabled == true) {
				_enabled = false;
				if(_owner.enabled) {
					onDisable();
				}
			}
		}
		
		/**
		 * Gets the name of the class this component is an instance of.
		 * */
		public function get typeName():String {
			if(_type != null) {
				return _type;
			}
				
			var fullClassName:String = getQualifiedClassName(this);
			var index:int = fullClassName.lastIndexOf("::") + 2;
			var className:String;
			if(index == -1) {
				className =  fullClassName;
			}
			else {
				className =  fullClassName.slice(index);
			}
			
			_type = className;
			return className;
		}
		
		/**
		 * Makes sure that another component exists in the game object that owns this component.
		 * Should be called onStart.
		 * */
		public function requiresComponent(type:String):void {
			var component:Component = _owner.getComponent(type);
			if(component == null) {
				//Core.logs.error("Required component not found in game object. " + type, this);
				throw new Error("Required component not found in game object. " + type);
			}
		}
		
		/**
		 * Makes sure that another component exists in the game object that owns this component.
		 * Should be called onStart.
		 * */
		public function requiresComponentField(field:Object):void {
			var component:Component = field as Component;
			if(component == null) {
				//Core.logs.error("Required component not found in game object. " + field.toString(), this);
				//throw new Error("Required component not found in game object. " + field.toString());
			}
		}
		
		/**
		 * Registers this component as a listener for a particular type of event
		 * */
		public function registerEvent(type:String):void {
			owner.registerEventForComponent(type, this);
		}
		
		//# CALLBACKS TO BE OVERRIDEN BY CONCRETE OBJECTIVES
		
		/**
		 * Called when this component is added to a game object. You should threat this as the constructor of the component.
		 * */
		public function onStart():void {}
		
		/**
		 * Called when this component is removed from a game object. You should threat this as the destructor of the component.
		 * */
		public function onDestroy():void { }
		
		/**
		 * Called when this component is enabled after being disabled.
		 * */
		public function onEnable():void {}
		
		/**
		 * Called when this component is disabled.
		 * */
		public function onDisable():void {}
		
		/**
		 * Called for every MouseEvent on that happens over the Renderable component's MovieClip that we are registered to.
		 * */
		public function onMouseEvent(event:MouseEvent):void {}
		
		/**
		 * Called for every KeyboardEvent that we are registered to.
		 * */
		public function onKeyboardEvent(event:KeyboardEvent):void {}
		
		/**
		 * Called every frame, if we are registered for it.
		 * */
		public function onEnterFrame(event:Event):void {}
		
		/**
		 * Called when collison events happen, if we are registered for them.
		 * */
		public function onCollision(other:PhysicsComponent):void {}
		
		/**
		 * Called when another component broadcasts a message using the GameObject broadcast() function or the GameScene's broadcast() function.
		 * */
		public function onBroadcast(event:Event):void {}
		
		//# PRIVATE 
		
		/**
		 * This is automatically called by the GameObject when this component is added to it.
		 * */
		internal function initialize(owner:GameObject):void {
			//Core.logs.assert(_owner == null, "Trying to assign a new owner to a component. Components cannot be reassigned.", this);
			_owner = owner;
			_initialized = true;
			onStart();
		}
	}
}