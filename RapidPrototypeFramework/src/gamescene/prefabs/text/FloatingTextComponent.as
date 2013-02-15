package gamescene.prefabs.text
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gamescene.Component;
	import gamescene.standardcomponents.MovieClipComponent;
	
	import ui.BioTextField;
	import ui.layout.config.BioBox;
	
	public class FloatingTextComponent extends Component {	
		
		public static var TOTAL_FRAMES:int = 15;
		public static var FRAMES_START_FADING:int = 8;
		
		private var _color:int;
		private var _position:Point;
		private var _text:String
		private var _size:int;
		private var _moveUp:Boolean = true;
		
		private var _frame:int = 0;
		private var _textfield:TextField;
		
		public function FloatingTextComponent(position:Point, text:String, color:int, size:int, moveUp:Boolean) {
			_position = position;
			_text = text;
			_color = color;
			_size = size;
			_moveUp = moveUp;
		}
		
		public override function onStart():void{
			registerEvent(Event.ENTER_FRAME);
			
			_textfield = new TextField();
			_textfield.textColor = _color;
			_textfield.selectable = false;
			_textfield.mouseEnabled = false;
			_textfield.text = _text;
			
			var format:TextFormat = new TextFormat();
			format.color = _color;
			format.size = _size;
			format.bold = true;
			format.font = "Comic Sans MS";
			
			_textfield.defaultTextFormat = format;
			_textfield.x = _position.x
			_textfield.y = _position.y;
			
			var clip:MovieClip = (owner.render2d as MovieClipComponent).clip;
			clip.addChild(_textfield);
		}
		
		public override function onEnterFrame(event:Event):void {
			if(_frame >= TOTAL_FRAMES){
				owner.destroy();
				return;
			}
			
			if(_frame > FRAMES_START_FADING){
				
				var i:Number = (_frame - FRAMES_START_FADING) / (TOTAL_FRAMES - FRAMES_START_FADING);
				
				_textfield.alpha = 1 - i;
				
				if(_moveUp) {
					_textfield.y = _position.y - i * 10;
				}
			}
			
			_frame++;
		}
	}
}