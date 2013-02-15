package gamescene 
{
	
	import expose.Expose;
	import expose.component.ui.BreakComponent;
	import expose.component.ui.ButtonComponent;
	import expose.screen.page.ExposePage;
	import expose.utils.GameExposer;
	import expose.utils.PageFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import gamescene.GameObject;
	import gamescene.standardcomponents.RootGameObject;

	public class GameScene {
		//# PRIVATE
		
		//The MovieClip that will contain of the visuals of this scene.
		private var _clip:Sprite;
		
		public function get clip():Sprite {
			return _clip;
		}
		
		public function set clip(value:Sprite):void {
			if (_clip != null) {
				_clip.stage.removeEventListener(Event.ENTER_FRAME, onEvent, false);
				_clip.stage.removeEventListener(KeyboardEvent.KEY_UP, onEvent, false);
				_clip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEvent, false);
			}
			
			for (var i:uint = 0; i < _clip.numChildren; i++) {
				value.addChild(_clip.getChildAt(0));
			}
			
			_clip = value;
			
			if (_clip != null) {
				_clip.stage.addEventListener(Event.ENTER_FRAME, onEvent, false, 0, true);
				_clip.stage.addEventListener(KeyboardEvent.KEY_UP, onEvent, false, 0, true);
				_clip.stage.addEventListener(KeyboardEvent.KEY_DOWN, onEvent, false, 0, true);
			}
		}
		
		//The root game object for the scene
		private var _root:GameObject;
		
		public function get root():GameObject {
			return _root;
		}

		//Is this scene paused?
		private var _paused:Boolean;
		
		public function get paused():Boolean {
			return _paused;
		}
		
		//The collection of game objects in the scene
		//Keys are game object ids (strings). Values are game objects
		private var _gameObjects:Dictionary = new Dictionary(false);
		
		//A keyed representation of physics components for game objects in the scene.
		//Keys are categories (strings). Values are Vectors of PhysicsComponents with that key.
		private var _physicsComponents:Dictionary = new Dictionary(true);
		//A keyed list of keys, for which collision categories should check against which other collision categories.
		//Keys are categories (strings). Values are Vectors of categories.
		private var _collisionCategories:Dictionary = new Dictionary(true);
		
		//Another representation of game objects in the scene.
		//Keys are tags (strings). Values are Vectors of GameObjects with that tag.
		//A game object may be in more than one tag collection
		private var _tags:Dictionary = new Dictionary(true);
		
		//An eve increasing number that is used to name game objects (their ids) and guarantee they are unique
		private var _anonymousGameObjectCount:int = 0;
		
		//Is this the first update on the scene?
		private var _firstUpdate:Boolean = true;
		
		public var name:String = "CHANGE_THIS";
		
		/**
		 * Constructor
		 * */
		public function GameScene() {
			_clip = new Sprite();
			
			//Core.logs.assert(clip.stage != null, "Trying to create a GameScene object with a MovieClip that is not yed added to display tree. Make sure clip is added to the stage before constructing this.", this);
			
			//Initialize root
			_root = new RootGameObject(clip);
			addGameObject(_root);
			
			//Initialize UI
			initUI();
		}
		
		/**
		 * The GameScene destructor.
		 **/
		public function destroy():void {
			var gameObject:GameObject; 
			for each(gameObject in _gameObjects) {
				//This check is necessary because deleted gameObjects remain as null entries on the Dictionary
				if(gameObject != null) {
					removeGameObject(gameObject); 
				}
			}
			
			//remove event listeners
			pause();
			
			this._clip = null;
			this._firstUpdate = false;
			this._gameObjects = null;
			this._paused = true;
			this._tags = null;
			
			destroyUI();
			
			//This is a good moment to trigger the garbage collector.
			//GC.gc();
		}
		
		/**
		 * Creates all the UI elements for this scene.
		 */
		public function initUI():void {
			
		}
		
		/**
		 * Adds all UI elements to the UI layer.
		 */
		public function showUI():void {
			
		}
		
		/**
		 * Removes all UI elements from the UI layer.
		 */
		public function hideUI():void {
			
		}
		
		/**
		 * Destroys all UI elements.
		 */
		public function destroyUI():void {
			
		}
		
		//# PUBLIC
		/**
		 * Returns the game object with the specified id, null if no object with that id exists in the scene
		 * */
		public function getGameObjectById(id:String):GameObject {
			return _gameObjects[id];
		}
		
		/**
		 * Returns a list of all the game objects in the scene that have a particular tag.
		 * */
		public function getGameObjectsWithTag(tag:String):Vector.<GameObject> {
			var collection:Vector.<GameObject> = _tags[tag];
			if(collection == null) {
				return new Vector.<GameObject>();
			}
			else {
				return collection.concat();	//Concat here is important to clone the vector, otherwise the list returned would be a live list (and read only)
			}
				
		}
		
		//# PAUSE/UNPAUSE
		
		/**
		 * Pauses the scene: Stops all messages and event handlers.
		 * */
		public function pause():void {
			_paused = true;
			if (Core.stageRoot != null) {
				Core.stageRoot.removeEventListener(Event.ENTER_FRAME, onEvent, false);
				Core.stageRoot.removeEventListener(KeyboardEvent.KEY_UP, onEvent, false);
				Core.stageRoot.removeEventListener(KeyboardEvent.KEY_DOWN, onEvent, false);
			}
		}
		
		/**
		 * Unpauses the scene and re-enable all the messages and event handlers.
		 * */
		public function unpause():void {
			_paused = false;
			if (Core.stageRoot != null) {
				Core.stageRoot.addEventListener(Event.ENTER_FRAME, onEvent, false, 0, true);
				Core.stageRoot.addEventListener(KeyboardEvent.KEY_UP, onEvent, false, 0, true);
				Core.stageRoot.addEventListener(KeyboardEvent.KEY_DOWN, onEvent, false, 0, true);
			}
			initExpose();
		}
		
		/**
		 * Initializes the Expose Page for a GameScene
		 * */
		public function initExpose():void
		{
			var gamePage:ExposePage = new ExposePage()
				.add( ButtonComponent.getCaller('Edit Global Data',GameExposer.showGameDataPage) )
				.add( ButtonComponent.getCaller('Select Game Component',selectGameComponent) )
				.add( new BreakComponent(false) );
			PageFactory.getPageFromObject(this,gamePage);
			Expose.show(gamePage);
		}
		protected function selectGameComponent():void {
			Expose.showCoordSelector( GameExposer.showClickedGameObject );
		}
		
		//# TAG MANAGEMENT
		
		/**
		 * Adds a tag to a game object
		 * */
		public function addTagToGameObject(gameObject:GameObject, tag:String):void {
			var index:int;
			var collection:Vector.<GameObject>;
			
			//Core.logs.assert(_gameObjects[gameObject.id] != null, "Trying to add a tag to a game object that is not currently in the scene", this);
			
			if(gameObject.tags == null) {
				gameObject.setTags([]);
			}
			
			index = gameObject.tags.indexOf(tag);
			if(index == -1) {
				collection = _tags[tag];
				if(collection == null) {
					collection = _tags[tag] = new Vector.<GameObject>();
				}
				collection[collection.length] = gameObject;
				
				gameObject.setTags(gameObject.tags.concat(tag));
			}
		}
		
		/**
		 * Removes a tag from a game object
		 * */
		public function removeTagFromGameObject(gameObject:GameObject, tag:String):void {
			var index:int;
			var collection:Vector.<GameObject>;
			
			//This function will filter the tags array so that it excludes the tag we are removing
			var filterTags:Function = function(e:String):Boolean {
				return e == tag ? false : true;
			}
			
			//Core.logs.assert(_gameObjects[gameObject.id] != null, "Trying to remove a tag from a game object that is not currently in the scene", this);
			
			index = gameObject.tags.indexOf(tag);
			if(index == -1) {
				return;
			}
			
			collection = _tags[tag];
			if(collection == null) {
				return;
			}
			
			index = collection.indexOf(gameObject);
			if(index != -1) {
				collection.splice(index, 1);
				gameObject.setTags(gameObject.tags.filter(filterTags));
			}
		}
		
		//#BROADCASTING
		
		/**
		 * Sends an event to all of the game objects in the scene
		 * */
		public function broadcast(event:BroadcastedEvent):void {
			var gameObject:GameObject;
			for each (gameObject in _gameObjects) {
				//This if is necessary because removed elements are null entries in the Dictionary
				if(gameObject != null) {
					gameObject.broadcast(event);
				}
			}
		}
		
		/**
		 * Sends an event to all of the game objects in the scene that have a particular tag
		 * */
		public function broadcastToTag(tag:String, event:BroadcastedEvent):void {
			var gameObject:GameObject;
			var collection:Vector.<GameObject> = getGameObjectsWithTag(tag);
			var i:int;
			for(i = 0 ; i < collection.length ; i++) {
				collection[i].broadcast(event);
			}
		}
		
		//# PRIVATE
		
		/**
		 * Returns the next available id for anonymous game objects in this scene
		 * */
		private function getNextUniqueGameObjectId():String {
			_anonymousGameObjectCount++;
			return "anonymous_game_object_" + _anonymousGameObjectCount;
		}
		
		/**
		 * Calls onEvent on every GameObject
		 * This is automatically called by the Scene and event handlers.
		 * */	
		private function onEvent(event:Event):void {
			//Paused? Ignore the event.
			if(_paused == true) {
				return;
			}
			
			var gameObject:GameObject;
			for each (gameObject in _gameObjects) {
				//This if is necessary because removed elements are null entries in the Dictionary,
				//...also, skip disabled game objects
				if(gameObject != null && gameObject.enabled == true) {	
					//If this is the first update (ENTER_FRAME) after thescene was created, initialize the game objects
					//begore dispatching any events to them.
					if(_firstUpdate) {
						gameObject.initializeComponents();
					}
					
					gameObject.onEvent(event);
				}
			}
			
			updatePhysics();
			
			_firstUpdate = false;
		}
		
		private function updatePhysics():void {
			var e:int;
			var r:int;
			var checkerCategory:String;
			var checkers:Vector.<PhysicsComponent>;
			var checkeeCategory:String;
			var checkees:Vector.<PhysicsComponent>;
			var categories:Vector.<String>;
			var physicsComponent:PhysicsComponent;
			for (checkerCategory in _collisionCategories) {
				categories = _collisionCategories[checkerCategory];
				if (categories != null) {
					checkers = _physicsComponents[checkerCategory];
					if (checkers != null) {
						for (e=0; e<categories.length; e++) {
							checkeeCategory = categories[e];
							checkees = _physicsComponents[checkeeCategory];
							if (checkees != null) {
								for (r=0; r<checkers.length; r++) {
									physicsComponent = checkers[r];
									physicsComponent.checkCollisionWith(checkees);
								}
							}
						}
					}
				}
			}
		}
		
		public function addCollisionCheckPreference(checkerCategory:String, checkeeCategory:String):void {
			var categories:Vector.<String>;
			categories = _collisionCategories[checkeeCategory];
			if (categories != null) {
				if (categories.indexOf(checkerCategory) != -1) {
					// We are already checking this interation.  Ignore it.
					Core.logs.warning(checkeeCategory+" is already checking collision with "+checkerCategory, this);
					return;
				}
			}
			categories = _collisionCategories[checkerCategory];
			if (categories == null) {
				categories = new Vector.<String>();
			}
			categories[categories.length] = checkeeCategory;
		}
		
		//# INTERNAL
		
		/**
		 * Adds a game object to the scene.
		 * @param gameObject The game object to be added
		 * @param tags An optional array of strings with the tags for this game object
		 * */
		internal function addGameObject(gameObject:GameObject, tags:Array = null):void {
			var i:uint = 0;
			var tag:String;
			
			//If the id of the gameObject is null, assign a new unique one
			if(gameObject.id == null) {
				gameObject.setId(getNextUniqueGameObjectId());
			}
			
			//Core.logs.assert(_gameObjects[gameObject.id] == null, "Duplicate game object id. Make sure that the id of each game object is unique", this);
			
			gameObject.initialize(this);
			
			//Fast lookup by id
			_gameObjects[gameObject.id] = gameObject;
			
			if(tags == null) {
				tags = [];
			}
			
			//Fast lookup by tag
			for(i = 0 ; i < tags.length ; i++) {
				tag = tags[i];
				if(tag != null) {
					addTagToGameObject(gameObject, tag);
				}
			}
			
			//Catch physics components already added
			if (gameObject.physics != null) {
				addPhysicsComponent(gameObject.physics);
			}
		}
		
		/**
		 * Adds a physics component to the scene.
		 * @param physicsComponent The physics component to be added.
		 */
		internal function addPhysicsComponent(physicsComponent:PhysicsComponent):void {
			var category:Vector.<PhysicsComponent> = _physicsComponents[physicsComponent.category];
			if (category == null) {
				category = new Vector.<PhysicsComponent>();
				_physicsComponents[physicsComponent.category] = category;
			}
			if (category.indexOf(physicsComponent) == -1) {
				category[category.length] = physicsComponent;
			}
		}
		
		/**
		 * Adds a game object to the scene.
		 * @param gameObject The game object to be added
		 * @param tags An optional array of strings with the tags for this game object
		 * */
		internal function removeGameObject(gameObject:GameObject):void {
			var i:uint = 0;
			var tag:String;
			var collection:Vector.<GameObject>;
			var index:int;
			
			if(_gameObjects[gameObject.id] != null) {
				_gameObjects[gameObject.id] = null;
				
				//Remove it from the tag collections
				for(i = 0 ; i < gameObject.tags.length ; i++) {
					tag = gameObject.tags[i];
					if(tag != null) {
						collection = _tags[tag];
						if(collection != null) {
							index = collection.indexOf(gameObject);
							collection.splice(index, 1);
						}
					}
				}
				
				//Remove it's physics component
				if (gameObject.physics != null) {
					removePhysicsComponent(gameObject.physics);
				}
			
				//Notify its components that they are gone.
				gameObject.destroy();
			}
		}
		
		/**
		 * Removes a physics component from the scene.
		 * @param physicsComponent The physics component to be removed.
		 */
		internal function removePhysicsComponent(physicsComponent:PhysicsComponent):void {
			var category:Vector.<PhysicsComponent> = _physicsComponents[physicsComponent.category];
			if (category == null) {
				return;
			}
			var i:int = category.indexOf(physicsComponent);
			if (i != -1) {
				category.splice(i,1);
			}
		}
	}
}