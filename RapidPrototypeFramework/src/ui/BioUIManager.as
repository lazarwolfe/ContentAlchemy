package ui {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class BioUIManager {
		private var _layers:BioLayers;
		public function get layers():BioLayers { return _layers; }
		
		//The list of active dialogs in the queue
		private var _activeDialogs:Vector.<BioDialog> = new Vector.<BioDialog>();
		
		//The currently displayed dialog
		private var _currentDialog:BioDialog = null;
		public function get currentDialog():BioDialog { return _currentDialog; }
		
		/**
		 * Ctor
		 * */
		public function BioUIManager(uiLayer:Sprite)
		{
			_layers = new BioLayers(new BioContainer(uiLayer));
		}
		
		public function resizeToStage():void {
			_layers.resizeToStage();
		}
		
		/**
		 * Displays a given dialog, when possible
		 * */
		public function displayDialog(dialog:BioDialog):void
		{
			_activeDialogs.splice(0,0, dialog);	//Add it at index 0
			displayNextDialog();
		}
		
		/**
		 * Closes a given dialog
		 * */
		public function closeDialog(dialog:BioDialog):void
		{
			if (_currentDialog == dialog) {
				closeCurrentDialog();
				return;
			}
			var i:int = _activeDialogs.indexOf(dialog);
			if (i != -1) {
				_activeDialogs.splice(i,1);
			}
		}
		
		/**
		 * Closes the current dialog, if any
		 * */
		public function closeCurrentDialog():void
		{
			if(_activeDialogs.length > 0)
			{
				var dialog:BioDialog = _activeDialogs.shift();	//Remove last element
				_currentDialog = null;
				dialog.playCloseAnimation(onDialogClosed);
				displayNextDialog();	
			}
		}
		
		internal function onDialogClosed(dialog:BioDialog):void {
			_layers.dialog.removeChildCell(dialog);
		}
		
		/**
		 * Displays the next dialog in the queue, if any
		 * */
		private function displayNextDialog():void
		{
			if(_activeDialogs.length > 0 && currentDialog == null)
			{
				var dialog:BioDialog = _activeDialogs[_activeDialogs.length - 1];
				_layers.dialog.addChildCell(dialog);
				dialog.playOpenAnimation();
				_currentDialog = dialog;
				
				_layers.resizeToStage();
			}
		}
	}
}