package gamescene {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	
	import utils.DisplayObjectUtils;
	
	/**
	 * A basic state machine engine
	 **/
	public class SceneManager {
		private var _rootObject:DisplayObjectContainer;
		private var _parentObject:DisplayObjectContainer;
		private var _sceneStack:Vector.<GameScene>;
		private var _nextStateID:int = 0;
		
		private var _storedScenes:Dictionary = new Dictionary(true);
		
		/**
		 * CTOR
		 * @param rootObject the layer that game objects should be put on.
		 **/
		public function SceneManager(rootObject:DisplayObjectContainer) {
			_rootObject = rootObject;
			_sceneStack = new Vector.<GameScene>();
		}
		
		public function storeScene(newScene:GameScene):void {
			if (newScene == null) {
				return;
			}
			_storedScenes[newScene.name] = newScene;
		}
		
		/**
		 * Puts this scene on the top of the stack.
		 * If it was in the stack already, it moves it up.
		 **/
		public function switchToScene(name:String):void {
			switchToNewScene(_storedScenes[name]);
		}
		
		/**
		 * Puts this scene on the top of the stack.
		 * If it was in the stack already, it moves it up.
		 * @Note: This does not store the scene by name.
		 **/
		public function switchToNewScene(newScene:GameScene):void {
			if (newScene == getCurrScene()) {
				return;
			}
			var i:int = _sceneStack.indexOf(newScene);
			if (i != -1) {
				_sceneStack.splice(i,1);
			}
			pushNewScene(newScene);
		}
		
		/**
		 * Pushes a scene on to the stack.  Any current scene is paused.
		 **/
		public function pushScene(name:String):void {
			pushNewScene(_storedScenes[name]);
		}
		
		/**
		 * Pushes a scene on to the stack.  Any current scene is paused.
		 * @Note: This does not store the scene by name.
		 **/
		public function pushNewScene(newScene:GameScene):void {
			if (newScene == null) {
				return;
			}
			var currScene:GameScene = getCurrScene();
			if (currScene != null) {
				currScene.hideUI();
				_rootObject.removeChild(currScene.clip);
				currScene.pause();
			}
			newScene.showUI();
			newScene.unpause();
			_sceneStack.push(newScene);
			_rootObject.addChild(newScene.clip);
		}
		
		/**
		 * pops a state off of the state machine
		 **/
		public function popScene():void {
			var lastScene:GameScene = _sceneStack.pop();
			if (lastScene != null) {
				lastScene.hideUI();
				_rootObject.removeChild(lastScene.clip);
				DisplayObjectUtils.safeRemoveFromParent(lastScene.clip);
				lastScene.destroy();
			}
			var newScene:GameScene = getCurrScene();
			if (newScene != null) {
				_rootObject.addChild(newScene.clip);
				newScene.unpause();
			}
		}
		
		/**
		 * @returns the current sscene
		 **/
		public function getCurrScene():GameScene {
			if (_sceneStack.length == 0)
				return null;
			else
				return _sceneStack[_sceneStack.length-1];
		}
	}
}