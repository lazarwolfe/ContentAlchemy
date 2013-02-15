package {
	import debug.DebugPerformanceUI;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	import ui.BioCell;
	
	[SWF(width='800',height='450',frameRate='30')]
	public class RapidPrototypeFramework extends Sprite {
		public static var instance:RapidPrototypeFramework;
		
		private var debugPerformanceCell:BioCell;
		
		private var hud:HelloHUD;
		
		public function RapidPrototypeFramework () {
			instance = this;
			
			initializeSystems();
			initializeScenes();
		}
		
		private function initializeSystems():void {
			Core.initialize(this);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			debugPerformanceCell = new BioCell(new DebugPerformanceUI());
			debugPerformanceCell.initFormatWithObject({
				left:0,
				top:0
			});
			Core.ui.layers.debug.addChildCell(debugPerformanceCell);
		}
		
		private function initializeScenes():void {
			hud = new HelloHUD();
			Core.logs.debug("Testing debug statement!", this);
			Core.scenes.storeScene(new HelloGameScene());
			Core.scenes.storeScene(new HelloBaseScene());
			Core.scenes.storeScene(new HelloSplashScreen());
			Core.scenes.pushScene("Main Game");
			Core.scenes.pushScene("Splash Screen");
			Core.ui.resizeToStage();
		}
	}
}