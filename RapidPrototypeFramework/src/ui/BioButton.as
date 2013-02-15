package ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.skin.BaseButtonSkin;
	
	public class BioButton extends BioContainer {
		public var callback:Function;
		
		public function BioButton(clip:DisplayObjectContainer=null, findNamedChildren:Boolean = true) {
			if (clip == null) {
				clip = new BaseButtonSkin();
			}
			
			super(clip,findNamedChildren);
			
			if ( clip is Sprite ) {
				Sprite(clip).buttonMode = true;
				Sprite(clip).useHandCursor = true;
				Sprite(clip).mouseChildren = false;
			}
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function setCallback(callback:Function):BioButton {
			this.callback = callback;
			return this;
		}
		
		protected function onClick(event:MouseEvent):void {
			if ( callback!=null ) {
				callback(event);
			}
		}
	}
}