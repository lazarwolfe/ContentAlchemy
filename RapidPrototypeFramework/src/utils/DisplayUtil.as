package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class DisplayUtil
	{
		
		public static function fromParentToTarget(parent:DisplayObjectContainer,target:DisplayObject):Vector.<DisplayObject>
		{
			var list:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			// Loop through parents.
			list.unshift(target);
			while( target!=parent ){
				target = target.parent;
				list.unshift(target);
				if( target==null ){
					return null;
				}
			}
			return list;
		}
		
		public static function targetIsChild(target:DisplayObject,parent:DisplayObjectContainer):Boolean
		{
			// Loop through parents.
			while( target!=parent ){
				target = target.parent;
				if( target==null ){
					return false;
				}
			}
			return true;
		}
		
		public static function targetIsParent(target:DisplayObjectContainer,child:DisplayObject):Boolean
		{
			return targetIsChild(child,target);
		}
		
		public static function clear(spr:Sprite):void{
			spr.graphics.clear();
			while(spr.numChildren>0){
				spr.removeChildAt(0);
			}
		}
		
		public static function focusOn(container:Sprite,focus:Sprite):void
		{
			var i:int;
			var child:DisplayObject;
			for( i=0; i<container.numChildren; i++ ){
				child = container.getChildAt(i);
				child.visible = false;
			}
			focus.visible = true;
		}
		
	}
}