package gamescene.prefabs.lasers
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gamescene.Component;
	import gamescene.standardcomponents.MovieClipComponent;
	
	public class LaserComponent extends Component {		
		
		public static var TOTAL_FRAMES:int = 15;
		public static var FRAMES_TO_HIT_TARGET:int = 5;
		
		private var _color:int;
		private var _power:Number = 6;
		private var _frame:int = 0;
		private var _start:Point;
		private var _end:Point;
		
		public function LaserComponent(start:Point, end:Point, color:int, power:int) {
			_power = power;
			_color = color;
			_start = start;
			_end = end;
			_frame = 0;
		}
		
		public override function onStart():void{
			registerEvent(Event.ENTER_FRAME);
		}
		
		public override function onEnterFrame(event:Event):void {
			if(_frame >= TOTAL_FRAMES){
				owner.destroy();
				return;
			}
			
			var color:uint = _color;
			
			var clip:MovieClip = (owner.render2d as MovieClipComponent).clip;
			
			clip.graphics.clear();
			clip.graphics.lineStyle( _power * (TOTAL_FRAMES - _frame) / TOTAL_FRAMES, color, (TOTAL_FRAMES - _frame) / TOTAL_FRAMES );
			clip.graphics.moveTo(_start.x,_start.y);
			if(_frame < FRAMES_TO_HIT_TARGET){
				clip.graphics.lineTo( _start.x + ( (_frame + 1) / FRAMES_TO_HIT_TARGET ) * (_end.x -_start.x), _start.y + ((_frame + 1) / FRAMES_TO_HIT_TARGET) * (_end.y - _start.y) );
			}else{
				clip.graphics.lineTo(_end.x, _end.y);
			}
			_frame++;
		}
	}
}