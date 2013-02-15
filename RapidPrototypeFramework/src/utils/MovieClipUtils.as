package utils { //parts from the ever wonderful dmf.as
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/****************************
	 * Miscellaneous Functions
	 ***************************/
	public class MovieClipUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		
		//helper vars
		//used to gather lists of display objs
		protected static var gatheredDispObjs:Vector.<DisplayObject> = new Vector.<DisplayObject>();; 
		private static var nodesToExplore:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public function MovieClipUtils() {}
		
		
		
		/**
		 * Given a display object containers, stops all movie clips at current frame 
		 * that are within that display object's display hierarchy. 
		 */
		public static function stopFramesInHierarchy(dispObj:DisplayObject):void {
			var mc:MovieClip = dispObj as MovieClip;
			if (mc) 
				mc.stop();
			var dispObjCont:DisplayObjectContainer = dispObj as DisplayObjectContainer
			if (dispObjCont) {
				for (var i:int = 0; i < dispObjCont.numChildren; i++) {
					var childObj:DisplayObject = dispObjCont.getChildAt(i);
					stopFramesInHierarchy(childObj);
				}
			}
		}
		
		public static function removeDisplayObjectInHierarchy(dispObj:DisplayObject):void {
			if(dispObj == null || dispObj.parent == null) return;
			
			if(dispObj is DisplayObjectContainer) {
				var container:DisplayObjectContainer = dispObj as DisplayObjectContainer;
				for(var i:int = 0; i < container.numChildren; i++) {
					removeDisplayObjectInHierarchy(container.getChildAt(i));
				}
			}
			
			dispObj.parent.removeChild(dispObj);
		}

		
		
		
		static public function childToTop(d:DisplayObject):void {
			if ((d == null) || (d.parent == null)) return;
			
			var topPosition:int = d.parent.numChildren - 1;
   		 	d.parent.setChildIndex(d, topPosition);
		}

		
		
		static public function getGlobalX(d:DisplayObjectContainer):int {
			//var globalPoint:Point = d.localToGlobal(new Point(d.x, d.y));
			var globalPoint:Point = d.localToGlobal(new Point(0, 0));
			return globalPoint.x;
		}

		static public function getGlobalY(d:DisplayObjectContainer):int {
			//var globalPoint:Point = d.localToGlobal(new Point(d.x, d.y));
			var globalPoint:Point = d.localToGlobal(new Point(0, 0));
			return globalPoint.y;
		}		
	
		
		
		
		/**
		 * Rotates a matrix and returns the result. The unit parameter lets the user specify "degrees", 
		 * "gradients", or "radians". 
		 */
		public static function rotate(object:DisplayObject, angle:Number, unit:String = "degrees"):void {
			
			var tempMatrix:Matrix = object.transform.matrix;
			
			if (unit == "degrees") {
				angle = Math.PI * 2 * angle / 360;
			} else if (unit == "gradients") {
				angle = Math.PI * 2 * angle / 100;
			}
			
			tempMatrix.rotate(angle)
			
			object.transform.matrix = tempMatrix;
		}
		

		
		/**
		 * Returns unqualified class of object as string
		 * Source: http://mail.flashcodersny.org/pipermail/flashcodersny_flashcodersny.org/2007-December/005376.html
		 */
		public static function getClassString(obj:Object):String {
			var fullName:String = getQualifiedClassName(obj);
			var name:String = fullName.slice(fullName.lastIndexOf("::") + 2);
			return name;
		}			
		/**********************************************************************************
		 * translate a string to true or false.
		 * *******************************************************************************/
		public static function TrueOrFalseStr(str : String) : Boolean {
			if (str == null || str.length == 0)
				return false
			if(str.toUpperCase() == "FALSE")
				return false;
			return true;
		}
		
		/**********************************************************************************
		 * gets the value of an object, applying default if not defined
		 * *******************************************************************************/
		public static function getValueWithDefault(str : String, defaultVal : Object) : Object {
			if (str == null || str.length == 0) {
				return defaultVal;
			}
			return str;
		}
		

	}
	
}