package {
	
	import data.GameData;
	import data.GameDataManager;
	
	import flash.events.Event;
	
	import gamescene.GameScene;
	
	import ui.BioButton;
	import ui.BioDialog;
	
	public class HelloSplashScreen extends GameScene {
		private var _dialog:BioDialog;

		public function HelloSplashScreen() {
			super();
			name = "Splash Screen";
		}
		
		public override function initUI():void {
			_dialog = new BioDialog(new SimpleDialog());
			_dialog
				.setText("txtTit","HELLO PLAYER")
				.setText("txtMsg","shooby da boop ba beedee dop da")
				.initButton("btnOk",closeDialog);
			_dialog.initFormatWithObject({
				top: "50%",
				left: "50%"
			});
		}
		
		public override function showUI():void {
			Core.ui.displayDialog(_dialog);
		}
		
		public override function hideUI():void {
			Core.ui.closeDialog(_dialog);
		}
		
		public override function destroyUI():void {
			Core.ui.closeDialog(_dialog);
			_dialog = null;
		}
		
		public function closeDialog(event:Event = null):void {
			Core.scenes.popScene();
		}
	}
}