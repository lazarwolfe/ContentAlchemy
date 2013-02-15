package gamescene.example
{
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import gamescene.Component;

	public class MoveInDirection extends Component {		
		
		public var _x:int = 0;
		public var _y:int = 0;
		
		public function MoveInDirection(){
			_x = Math.random() > 0.5 ? 1 : -1;
			_y = Math.random() > 0.5 ? 1 : -1;
		}
		
		public override function onStart():void{
			registerEvent(Event.ENTER_FRAME);
		}
		
		public override function onEnterFrame(event:Event):void {
			
			if(Core.keyboard.isKeyDown(Keyboard.SPACE)) {
				_x = Math.random() > 0.5 ? 1 : -1;
				_y = Math.random() > 0.5 ? 1 : -1;
			}
			
			owner.render2d.x += _x;
			owner.render2d.y += _y;
		}
	}
}