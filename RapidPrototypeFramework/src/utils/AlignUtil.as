package utils {
	import flash.display.DisplayObject;

	/**
	 * Utility class for aligning display objects in respect to each other.
	 * @author CSteiner
	 */
	public class AlignUtil {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Changes the x of the child so it is centered with respect to the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 */
		public static function centerWithinX(target:DisplayObject, child:DisplayObject, offsetX:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = (target.width - child.width)/2 + offsetX;
		} // function centerWithinX
		
		/**
		 * Changes the y of the child so it is centered with respect to the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function centerWithinY(target:DisplayObject, child:DisplayObject, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.y = (target.height - child.height)/2 + offsetY;
		} // function centerWithinY
		
		/**
		 * Changes the x and y of the child so it is centered with respect to the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function centerWithin(target:DisplayObject, child:DisplayObject, offsetX:Number = 0, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = (target.width - child.width)/2 + offsetX;
			child.y = (target.height - child.height)/2 + offsetY;
		} // function centerWithinY
		
		/**
		 * Changes the x of the child so it's left edge is against the left edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 */
		public static function alignToLeft(target:DisplayObject, child:DisplayObject, offsetX:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = target.x + offsetX;
		} // function alignToLeft
		
		/**
		 * Changes the x of the child so it's right edge is against the right edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 */
		public static function alignToRight(target:DisplayObject, child:DisplayObject, offsetX:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = target.x + target.width - child.width + offsetX;
		} // function alignToRight
		
		/**
		 * Changes the y of the child so it's top edge is against the top edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function alignToTop(target:DisplayObject, child:DisplayObject, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.y = target.y + offsetY;
		} // function alignToTop
		
		/**
		 * Changes the y of the child so it's bottom edge is against the bottom edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function alignToBottom(target:DisplayObject, child:DisplayObject, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.y = target.y + target.height - child.height + offsetY;
		} // function alignToBottom
		
		/**
		 * Changes the x of the child so it's right edge is against the left edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 */
		public static function alignLeftOf(target:DisplayObject, child:DisplayObject, offsetX:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = target.x - child.width + offsetX;
		} // function alignLeftOf
		
		/**
		 * Changes the x of the child so it's left edge is against the right edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetX Optional offset to apply after aligning.
		 */
		public static function alignRightOf(target:DisplayObject, child:DisplayObject, offsetX:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.x = target.x + target.width + offsetX;
		} // function alignRightOf
		
		/**
		 * Changes the y of the child so it's bottom edge is against the top edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function alignAbove(target:DisplayObject, child:DisplayObject, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.y = target.y - child.height + offsetY;
		} // function alignAbove
		
		/**
		 * Changes the y of the child so it's top edge is against the bottom edge of the target.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param child DisplayObject to move.
		 * @param offsetY Optional offset to apply after aligning.
		 */
		public static function alignBelow(target:DisplayObject, child:DisplayObject, offsetY:Number = 0):void {
			if (target == null || child == null) {
				return;
			}
			child.y = target.y + target.height + offsetY;
		} // function alignBelow
		
		/**
		 * Changes the x of each child so it's left edge is against the right edge of the target or previous child.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to add after the target and between each child.
		 * @param offsetX Optional offset to apply once to all children.
		 */
		public static function stackRightOf(target:DisplayObject, children:Array, spacer:Number = 0, offsetX:Number = 0):void {
			if (target == null) {
				return;
			}
			stackRight(target.x + target.width + offsetX + spacer, children, spacer);
		} // function stackRightOf
		
		/**
		 * Changes the x of each child so it's left edge is against the starting point or the right edge of the previous child.
		 * @param targetX X position to treat as the left edge of the stack.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to add after the target and between each child.
		 */
		public static function stackRight(targetX:Number, children:Array, spacer:Number = 0):void {
			var child:DisplayObject;
			var i:int;
			for (i=0; i<children.length; ++i) {
				child = children[i];
				child.x = targetX;
				targetX += child.width + spacer;
			}
		} // function stackRight
		
		/**
		 * Changes the x of each child so it's right edge is against the left edge of the target or previous child.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to subtract after the target and between each child.
		 * @param offsetX Optional offset to apply once to all children.
		 */
		public static function stackLeftOf(target:DisplayObject, children:Array, spacer:Number = 0, offsetX:Number = 0):void {
			if (target == null) {
				return;
			}
			stackLeft(target.x + offsetX - spacer, children, spacer);
		} // function stackLeftOf
		
		/**
		 * Changes the x of each child so it's right edge is against the starting point or the left edge of the previous child.
		 * @param targetX X position to treat as the right edge of the stack.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to subtract after the target and between each child.
		 */
		public static function stackLeft(targetX:Number, children:Array, spacer:Number = 0):void {
			var child:DisplayObject;
			var i:int;
			for (i=0; i<children.length; ++i) {
				child = children[i];
				targetX -= child.width;
				child.x = targetX;
				targetX -= spacer;
			}
		} // function stackLeft
		
		/**
		 * Changes the y of each child so it's top edge is against the bottom edge of the target or previous child.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to add after the target and between each child.
		 * @param offsetY Optional offset to apply once to all children.
		 */
		public static function stackBelow(target:DisplayObject, children:Array, spacer:Number = 0, offsetY:Number = 0):void {
			if (target == null) {
				return;
			}
			stackDownward(target.y + target.height + offsetY + spacer, children, spacer);
		} // function stackBelow
		
		/**
		 * Changes the y of each child so it's top edge is against the starting point or the bottom edge of the previous child.
		 * @param targetY Y position to treat as the top edge of the stack.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to add after the target and between each child.
		 */
		public static function stackDownward(targetY:Number, children:Array, spacer:Number = 0):void {
			var child:DisplayObject;
			var i:int;
			for (i=0; i<children.length; ++i) {
				child = children[i];
				child.y = targetY;
				targetY += child.height + spacer;
			}
		} // function stackDownward
		
		/**
		 * Changes the y of each child so it's bottom edge is against the top edge of the target or previous child.
		 * @param target DisplayObject that defines the area to be aligned to.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to subtract after the target and between each child.
		 * @param offsetY Optional offset to apply once to all children.
		 */
		public static function stackAbove(target:DisplayObject, children:Array, spacer:Number = 0, offsetY:Number = 0):void {
			if (target == null) {
				return;
			}
			stackUpward(target.y + offsetY - spacer, children, spacer);
		} // function stackAbove
		
		/**
		 * Changes the y of each child so it's bottom edge is against the starting point or the top edge of the previous child.
		 * @param targetY Y position to treat as the bottom edge of the stack.
		 * @param children Array of DisplayObjects to move.
		 * @param spacer Optional offset to subtract after the target and between each child.
		 */
		public static function stackUpward(targetY:Number, children:Array, spacer:Number = 0):void {
			var child:DisplayObject;
			var i:int;
			for (i=0; i<children.length; ++i) {
				child = children[i];
				targetY -= child.height;
				child.y = targetY;
				targetY -= spacer;
			}
		} // function stackUpward
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package