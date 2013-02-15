package ui {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import ui.layout.formatter.IBioFormatter;
	import ui.layout.formatter.BioFormatter;

	public class BioLayers {
		public var debug:BioContainer = new BioContainer(new Sprite());
		public var error:BioContainer = new BioContainer(new Sprite());
		public var tooltip:BioContainer = new BioContainer(new Sprite());
		public var fx:BioContainer = new BioContainer(new Sprite());
		public var dialog:BioContainer = new BioContainer(new Sprite());
		public var hud:BioContainer = new BioContainer(new Sprite());
		
		public var parent:BioContainer;
		private var stage:Stage;
		private var _formatter:IBioFormatter = new BioFormatter();
		
		/**
		 * Ctor
		 * */
		public function BioLayers(parent:BioContainer) {
			this.parent = parent;
			//Order is important
			parent.addChildCell(hud);
			parent.addChildCell(dialog);
			parent.addChildCell(fx);
			parent.addChildCell(tooltip);
			parent.addChildCell(error);
			parent.addChildCell(debug);
			
			parent.initFormatWithObject({
				_:{
					width:"100%",
					height:"100%"
				}
			});
			
			if (parent.art.stage == null) {
				parent.art.addEventListener(Event.ADDED_TO_STAGE, listenForResizeEvents);
			} else {
				listenForResizeEvents();
			}
		}
		
		private function listenForResizeEvents(event:Event = null):void {
			parent.art.removeEventListener(Event.ADDED_TO_STAGE, listenForResizeEvents);
			stage = parent.art.stage;
			stage.addEventListener(Event.RESIZE, resizeToStage);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, resizeToStage);
			resizeToStage();
		}
		
		public function resizeToStage(event:Event = null):void {
			parent.format.dimension.innerWidth = parent.format.dimension.outerWidth = stage.stageWidth;
			parent.format.dimension.innerHeight = parent.format.dimension.outerWidth = stage.stageHeight;
			parent.resize(stage.stageWidth, stage.stageHeight);
			parent.reformat(_formatter);
		}
	}
}