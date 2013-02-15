package {
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.BioButton;
	import ui.BioContainer;
	
	import utils.sound.SoundManager;

	public class HelloHUD extends BioContainer {
		public var optionButtons:Vector.<BioButton> = new Vector.<BioButton>();
		public var optionsBtn:BioButton;
		public var pauseBtn:BioButton;
		
		private var _paused:Boolean = false;
		public function get paused():Boolean { return _paused; }
		private var _sound:Boolean = true;
		public function get soundOn():Boolean { return _sound; }
		private var _optionsOut:Boolean = false;

		private var spacer:Number = 5;
		private var btnScale:Number = 0.6;
		private var tweenDuration:Number = 0.1;

		public function HelloHUD() {
			super(new Sprite());
			name = "conHUD";

			var button:BioButton = addButton("Options",onOptionsClicked);
			addButton("Pause",onPauseClicked);
			addButton("Sound",onSoundClicked);
			setText("btnSound txtLabel","Sound On");
			
			initFormatWithObject({
				right: button.art.width,
				top: 0
			});
			//art.x = 735-button.art.width;
			
			Core.ui.layers.hud.addChildCell(this);
		}
		
		internal function addButton(label:String,callback:Function):BioButton {
			var button:BioButton = new BioButton();
			button.art.scaleX = button.art.scaleY = btnScale;
			button.setCallback(callback)
				.setText("txtLabel", label)
				.setName("btn"+label)
			optionButtons[optionButtons.length] = button;
			addChildCell(button);
			button.art.parent.addChildAt(button.art, 0);
			return button;
		}
		
		private function onOptionsClicked(event:MouseEvent):void {
			var art:DisplayObject;
			var i:int;
			var targetY:Number = 0;
			_optionsOut = !_optionsOut;
			for (i=0; i<optionButtons.length; i++) {
				art = optionButtons[i].art;
				TweenLite.killTweensOf(art);
				TweenLite.to(art, tweenDuration, {y:targetY});
				if (_optionsOut) {
					targetY += art.height + spacer;
				}
			}
		}
		
		private function onPauseClicked(event:MouseEvent):void {
			_paused = !_paused;
			if (_paused) {
				setText("btnPause txtLabel","Unpause");
				Core.scenes.getCurrScene().pause();
			} else {
				setText("btnPause txtLabel","Pause");
				Core.scenes.getCurrScene().unpause();
			}
		}
		
		private function onSoundClicked(event:MouseEvent):void {
			_sound = !_sound;
			if (_sound) {
				setText("btnSound txtLabel","Sound On");
				Core.sound.unmute();
			} else {
				setText("btnSound txtLabel","Sound Off");
				Core.sound.mute();
			}
		}
	}
}