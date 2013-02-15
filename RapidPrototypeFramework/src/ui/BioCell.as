package ui  {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import ui.layout.config.BioCellFormat;
	
	public class BioCell implements IEventDispatcher {
		
		public function get name():String { return _art.name; }
		public function set name(value:String):void { _art.name = value; }
		
		/**
		 * The display object this cell manages.
		 */
		public function get art():DisplayObject {
			return _art;
		}
		public function set art(target:DisplayObject):void {
			if (_art != null) {
				_art.removeEventListener(Event.ADDED_TO_STAGE, startListening);
				_art.removeEventListener(Event.REMOVED_FROM_STAGE, stopListening);
			}
			if (isAddedToStage) {
				stopListening();
				_art = target;
				startListening();
			}
			else {
				_art = target;
			}
			if (_art != null) {
				_art.addEventListener(Event.ADDED_TO_STAGE, startListening);
				_art.addEventListener(Event.REMOVED_FROM_STAGE, stopListening);
			}
		}
		protected var _art:DisplayObject;
		
		public function get x():Number {
			return _art.x;
		}
		
		public function set x(value:Number):void {
			_art.x = value;
		}
		
		public function get y():Number  {
			return _art.y;
		}
		
		public function set y(value:Number):void {
			_art.y = value;
		}
		
		/**
		 * The cell's Format Config
		 * */
		public var format:BioCellFormat = new BioCellFormat();

		/**
		 * If the art is currently added to the stage.
		 */
		public function get isAddedToStage():Boolean {	return (art != null && art.stage != null);	}
		
		/**
		 * To keep track of event listeners.
		 */
		private var listenerEvents:Vector.<String> = new Vector.<String>();
		private var listenerCallbacks:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * The BioContainer that contains this BioCell.
		 */
		public function get parent():BioContainer { return _parent; }
		public function setParent(value:BioContainer):void { _parent = value; }
		protected var _parent:BioContainer;
		
		public function BioCell(art:DisplayObject = null) {
			this.art = art;
			calculateDefaultFormat();
		}
		
		/**
		 * Destroy function.  Frees up all connections.  Does not disassociate display objects.
		 */
		public function destroy():void {
			stopListening(null);
			while (listenerEvents.length != 0) {
				listenerEvents.pop();
				listenerCallbacks.pop();
			}
			_art = null;
			_parent = null;
		}
		
		public function setName(newName:String):BioCell {
			_art.name = newName;
			return this;
		}
		
		/**
		 * Adds all event listeners in the listener vectors.
		 */
		protected function startListening(event:Event=null):void {
			if (_art == null) {
				return;
			}
			var i:int;
			for (i=0; i<listenerEvents.length; i++) {
				_art.addEventListener(listenerEvents[i], listenerCallbacks[i]);
			}
		}
		
		/**
		 * Removes all event listeners in the listener vectors.
		 */
		protected function stopListening(event:Event=null):void {
			if (_art == null) {
				return;
			}
			var i:int;
			for (i=0; i<listenerEvents.length; i++) {
				_art.removeEventListener(listenerEvents[i], listenerCallbacks[i]);
			}
		}
		
		/**
		 * Associates an event listener with the art.  When the art is added to the stage, or if the art is already added to the stage,
		 * the listener will be added to the art.  When the art is removed from stage, the listener will be removed from the art.
		 * @note This does not check for duplicate listeners.
		 * @param type Event to listen to.
		 * @param listener Callback to call when the event is triggered.
		 * @param useCapture Not used.  Default is used instead.
		 * @param priority Not used.  Default is used instead.
		 * @param useWeakReference Not used.  Default is used instead.
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (isAddedToStage) {
				_art.addEventListener(type,listener);
			}
			listenerEvents[listenerEvents.length] = type;
			listenerCallbacks[listenerCallbacks.length] = listener;
		}
		
		/**
		 * Disassociates an event listener with the art.  If the art is added to stage, the event listener is removed from the art.
		 * @note This does not check for duplicate listeners.  Only the first will be removed.
		 * @param type Event to listen to.
		 * @param listener Callback to call when the event is triggered.
		 * @param useCapture Not used.  Default is used instead.
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if (isAddedToStage) {
				_art.removeEventListener(type,listener);
			}
			var i:int;
			for (i=0; i<listenerEvents.length; i++) {
				if (listenerEvents[i] == type && listenerCallbacks[i] == listener) {
					listenerEvents.splice(i,1);
					listenerCallbacks.splice(i,1);
					return;
				}
			}
		}
		
		public function dispatchEvent(event:Event):Boolean {
			if (_art != null) {
				_art.dispatchEvent(event);
			}
			return false;
		}
		
		public function hasEventListener(type:String):Boolean {
			return (listenerEvents.indexOf(type) != -1);
		}
		
		public function willTrigger(type:String):Boolean {
			return false;
		}
		
		/**
		 * Re-position and re-size the art.
		 * By default, make the art's position the given x & y coordinates,
		 * and do nothing with the width & height
		 * */
		public function reposition(x:Number,y:Number):void {
			_art.x = x;
			_art.y = y;
		}
		public function resize(width:Number,height:Number):void {
			// TO BE IMPLEMENTED
		}
		
		/**
		 * This passes the blueprint to its Format.
		 * In BioContainer, check Selectors to apply formats to children.
		 * */
		public function initFormatWithObject(blueprint:Object):BioCell {
			this.format.initWithObject(blueprint);
			return this;
		}
		
		/**
		 * Get default format from MovieClip
		 * */
		public function calculateDefaultFormat():void {
			// Default Format
			if (art!=null) {
				var artBounds:Rectangle = art.getBounds(art);
				initFormatWithObject({
					left: art.x,
					top: art.y,
					width: artBounds.right*art.scaleX,
					height: artBounds.bottom*art.scaleY
				});
			}
		}
			
	}
}