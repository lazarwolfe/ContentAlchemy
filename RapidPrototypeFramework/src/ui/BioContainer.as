package ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import ui.layout.formatter.IBioFormatter;
	
	public class BioContainer extends BioCell {
		protected var _children:Vector.<BioCell> = new Vector.<BioCell>();
		public function get children():Vector.<BioCell> {
			return _children;
		}
		
		// This stores the children bio BioCell name for rapid lookup.
		protected var _childrenHash:Dictionary = new Dictionary(true);

		/**
		 * Ctor
		 * @param clip The art for the container
		 * @param findNamedChildren Set to true to recursively transverse the children of the clip to find elements with proper names and
		 * 			create BioCells for them
		 * **/
		public function BioContainer(clip:DisplayObjectContainer=null, findNamedChildren:Boolean = true) {
			super(clip);
			if (findNamedChildren == true) {
				//Can't start with clip because it's the root, so we have to special case it's children here.
				//After this point the search is recursive.
				for (var i:int = 0 ; i < clip.numChildren; i++) {
					findNamedChildrenRecursive(clip.getChildAt(i));
				}
			}
		}
		
		public function addChildCell(child:BioCell):void {
			if (child == null) {
				return;
			}
			child.setParent(this);
			_children[children.length] = child;
			_childrenHash[child.name] = child;
			
			// Adding child to art
			if (!DisplayObjectContainer(art).contains(child.art)){
				DisplayObjectContainer(art).addChild(child.art);
			}
		}
		
		public function removeChildCell(child:BioCell):void {
			if (child == null) {
				return;
			}
			var idx:int = _children.indexOf(child);
			if (idx != -1) {
				_children.splice(idx,1);
				_childrenHash[child.art.name] = null;
				child.setParent(null);
			}
			
			// Removing child from art
			DisplayObjectContainer(art).removeChild( child.art );
		}
		
		/**
		 * Recursively searches the BioCells that are children of this BioContainer for a cell with the given name.
		 * **/
		public function findChildByName(name:String):BioCell {
			var cell:BioCell = _childrenHash[name];
			if (cell != null)
				return cell;
			
			for (var i:int ; i < _children.length ; i++) {
				//Only search recursively on BioContainers
				var child:BioContainer = _children[i] as BioContainer;
				if (child != null) {
					cell = child.findChildByName(name);
					if (cell != null)
						return cell;
				}
			}
			return null;
		}
		
		/**
		 * Shortcut for findChildByName( "container" ).findChildByName( "subcontainer" ).findChildByName( "target" )
		 * is findChildByHierarchy( "container subcontainer target" );
		 * **/
		public function findChildByHierarchy(hierarchy:String):BioCell {
			var names:Vector.<String> = Vector.<String>( hierarchy.split(' ') );
			if ( names.length==0 ) {
				return null;
			}
			var cell:BioCell = this;
			var i:int;
			for ( i=0; i<names.length; i++ ) {
				if ( cell is BioContainer ) {
					cell = BioContainer(cell).findChildByName(names[i]);
				} else {
					return null;
				}
			}
			return cell;
		}
		
		/**
		 * Recursively searches the BioCells that are children of this BioContainer for a cell with the given ART
		 * **/
		public function findChildByArt(art:DisplayObject):BioCell {
			var cell:BioCell;
			for (var i:int ; i < _children.length ; i++) {
				//Only search recursively on BioContainers
				var child:BioCell = _children[i];
				if ( child.art == art ) {
					return child;
				}
				if ( child is BioContainer ) {
					cell = BioContainer(child).findChildByArt(art);
					if (cell != null) {
						return cell;
					}
				}
			}
			return null;
		}
		
		/**
		 * The cell's Formatter.
		 * On ADD TO STAGE, format it????
		 * 
		 * Must reformat on: ADD_TO_STAGE, RESIZE, and FULLSCREEN
		 * */
		public function reformat(formatter:IBioFormatter):void {
			formatter.format(this);
			var child:BioCell;
			for each ( child in _children ) {
				if ( child is BioContainer ) {
					BioContainer(child).reformat(formatter);
				}
			}
			// THIS PROPAGATES ONLY ONE FORMATTER DOWN.
			// If have own special formatter, that overrides the parent's?
		}
		
		/**
		 * Recursively searches the children of the given clip trying to find
		 * elements that follow the naming convention and creation BioCells for them.
		 * **/
		private function findNamedChildrenRecursive(clip:DisplayObject) :void {
			var i:int;
			var cell:BioCell;
			var sub:String = clip.name.match(/[a-z]*/g)[0];
			switch (sub) {
				case 'txt':
					cell = new BioTextField(null,TextField(clip));
					break;
				case "prog":
					cell = new BioProgressBar(MovieClip(clip));
					break;
				case "img":
					cell = new BioIcon(clip);
					break;
				case "btn":
					cell = new BioButton( DisplayObjectContainer(clip) );
					break;
				case "con":
					cell = new BioContainer( DisplayObjectContainer(clip), true);
					break;
				case "panel":
					cell = new BioSlidingPanel( DisplayObjectContainer(clip) );
					break;
				case "scroll":
					cell = new BioScrollPanel( DisplayObjectContainer(clip) );
					break;
				case "guide":
					clip.visible = false;
					break;
			}
			
			// If this is a named cell, add it
			if (cell != null) {
				addChildCell(cell);
			} else {
				//We have an unnamed DisplayObject. Check if it has children.
				var cont:DisplayObjectContainer = clip as DisplayObjectContainer;
				if (cont != null) {
					for (i = 0 ; i < cont.numChildren; i++) {
						var child:DisplayObject = cont.getChildAt(i);
						findNamedChildrenRecursive(child);
					}
				}
				
				//Dumb check for textfields that are not named properly. We don't want them!
				if (clip is TextField) {
					trace("ERROR: Textfield found with hardcoded text in the art inside: " + art.name + "  TextField name: " + clip.name);
				}
			}
		}
		
		/**
		 * This passes the blueprint to its Format.
		 * In BioContainer, check Selectors to apply formats to children.
		 * */
		override public function initFormatWithObject(blueprint:Object):BioCell {
			super.initFormatWithObject(blueprint);
			
			// Children
			var selector:String;
			var child:BioCell;
			for ( selector in blueprint ) {
				// ALL the Children
				if ( selector=='_' ) {
					for each ( child in _children ) {
						child.initFormatWithObject( blueprint[selector] );
					}
					continue;
				}
				
				// _childName
				if ( selector.charAt(0) == '_' ) {
					child = findChildByName(selector.slice(1));
					if ( child!=null ) {
						child.initFormatWithObject( blueprint[selector] );
					}
					continue;
				}
			}
			return this;
		}
		
		/************************************************************************************
		 *************************************************************************************
		 * HELPER METHODS WHEN YOU CREATE SOMETHING FROM A MOVIECLIP
		 *************************************************************************************
		 *************************************************************************************
		 * */
		
		/**
		 * Set Text
		 * */
		public function setText(hierarchy:String,text:String):BioContainer {
			var target:BioTextField = BioTextField( findChildByHierarchy(hierarchy) );
			if ( target!=null )
				target.setText(text);
			return this;
		}
		
		public function initButton(hierarchy:String,callback:Function):BioContainer {
			var target:BioButton = BioButton( findChildByHierarchy(hierarchy) );
			if ( target!=null )
				target.callback = callback;
			return this;
		}
		
		public function initProgress(hierarchy:String,current:Number,max:Number):BioContainer {
			var target:BioProgressBar = BioProgressBar( findChildByHierarchy(hierarchy) );
			if ( target!=null )
				target.init(current,max);
			return this;
		}
		
		public function initSliding(hierarchy:String,offsetX:Number=NaN,offsetY:Number=NaN):BioContainer {
			var target:BioSlidingPanel = BioSlidingPanel( findChildByHierarchy(hierarchy) );
			if ( target!=null )
				target.initHidePosition(offsetX,offsetY);
			return this;
		}
		
	}
}