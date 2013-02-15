package utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * Collection of utility collection methods for  DisplayObjects, Sprites and MovieClips
	 * */
	public class DisplayObjectUtils {
		/**
		 * Calls target.parent.removeChild(target) if both target and target.parent are non null.
		 */
		public static function safeRemoveFromParent(target:DisplayObject):void {
			if (target == null || target.parent == null) {
				return;
			}
			target.parent.removeChild(target);
		}
		
		/**
		 * Removes all children from a Sprite
		 */
		public static function removeAllChildren(target:Sprite):void {
			if (target == null) {
				return;
			}
			while(target.numChildren > 0) {
				target.removeChildAt(0);
			}
		}
		
		/**
		 * Determines whether a DisplayObject possesses a DisplayObjectContainer in its heirarchy of ancestors.
		 * 
		 * @param target The target DisplayObject.
		 * @param parent The parent DisplayObjectContainer being evaluated.
		 * 
		 * @return Whether the DisplayObject possesses the DisplayObjectContainer being evaluated as an ancestor.
		 **/		
		public static function hasAncestor(target:DisplayObject, ancestor:DisplayObjectContainer):Boolean {
			if (target.parent != null) {
				if (target.parent == ancestor) {
					return true;
				} else {
					if (target.parent.parent != null) {
						return hasAncestor(target.parent, target.parent.parent);
					} else {
						return false;
					}
				}
			}
			
			return false;
		}
		
		//taken from the upstanding class known as dmf.as
		//Boo. -Steve
		
		/** Given root, adds display objects in root's tree (including root itself) to outputNodes list, adding 
		 * only those objects in tree with a manually defined instance name. */
		protected static var gatheredDispObjs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		static public function getNamedDisplayTreeObjects(root:DisplayObjectContainer, outputNodes:Vector.<DisplayObject>):void {
			gatherDisplayTreeObjects(root);
			
			//Iterate over list and filter
			for each (var dispObj:DisplayObject in gatheredDispObjs) {
				if (dispObj != null && dispObj.name != null && dispObj.name.indexOf("instance") != 0)
					outputNodes.push(dispObj);
			}
		}
		
		/** Given root, adds display objects in root's tree (including root itself) to outputNodes list, adding 
		 * only those objects in tree that are MovieClips. */
		static public function getDisplayTreeMovieClips(root:DisplayObjectContainer, outputNodes:Vector.<MovieClip>):void {
			gatherDisplayTreeObjects(root);
			
			//Iterate over list and filter
			for each (var dispObj:DisplayObject in gatheredDispObjs) {
				var mc:MovieClip = dispObj as MovieClip;
				if (mc)
					outputNodes.push(mc);
			}
		}
		
		/** Internal util function that places all display tree objects in root's tree into dispObjs. */
		private static var nodesToExplore:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		static private function gatherDisplayTreeObjects(root:DisplayObject):void {
			gatheredDispObjs.length = 0;
			nodesToExplore.length = 0;
			nodesToExplore.push(root);
			
			// Depth first search of tree
			var node:DisplayObject;
			var nodeContainer:DisplayObjectContainer;
			var child:DisplayObject;
			while (nodesToExplore.length > 0) {
				node = nodesToExplore.pop();
				
				//Add
				gatheredDispObjs.push(node);
				
				//Recurse
				nodeContainer = node as DisplayObjectContainer;
				if (nodeContainer) {
					var numChildNodes:int = nodeContainer.numChildren;
					for (var i:int = 0; i < numChildNodes; i++) {
						child = nodeContainer.getChildAt(i);
						nodesToExplore.push(child);
					}
				}
			}
		}
		
		///Source: http://livedocs.adobe.com/flash/9.0/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000149.html
		static public function printDisplayList(obj:DisplayObjectContainer, indentString:String = ""):void {
			if (obj == null) {
				trace("Display Container to trace is null");
				return;
			}
			var child:DisplayObject;
			for (var i:uint=0; i < obj.numChildren; i++) {
				child = obj.getChildAt(i);
				if (!child) continue;
				trace(indentString, child, child.name); 
				if (obj.getChildAt(i) is DisplayObjectContainer) {
					printDisplayList(DisplayObjectContainer(child), indentString + "    ")
				}
			}
		}
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package