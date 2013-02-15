package ui {
	import flash.display.DisplayObjectContainer;
	
	public class BioDialog extends BioContainer {
		private var _onClosedCallback:Function;

		public function BioDialog(art:DisplayObjectContainer=null) {
			super(art);
		}
		
		internal function playOpenAnimation():void {
		}
		
		internal function playCloseAnimation(onClosed:Function):void {
			_onClosedCallback = onClosed;
			onDoneClosing();
		}
		
		private function onDoneClosing():void {
			if (_onClosedCallback != null) {
				_onClosedCallback(this);
			}
		}
	}
}