package  {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import gamescene.GameObject;
	import gamescene.GameScene;
	import gamescene.prefabs.explosions.ExplosionPrefab;
	import gamescene.prefabs.lasers.LaserPrefab;
	import gamescene.prefabs.text.FloatingTextPrefab;
	
	public class HelloGameScene extends GameScene {
		
		private var _cubes:Vector.<GameObject> = new Vector.<GameObject>();
		
		private var s1:String = "Power the horse!";
		private var s2:String = "FULL FORCE!";
		
		private var _timer:Timer;
		
		public function HelloGameScene() {
			super();
			name = "Main Game";
//			for (var i:int = 0 ; i < 1000; i ++) {
//				var e:Enemy = new Enemy();
//				_cubes.push(e);
//				root.addChild(e);
//				//root.addChild(new LaserPrefab(new Point(Math.random() * 600, Math.random() * 400), new Point(Math.random() * 600, Math.random() * 400)));
//				//root.addChild(new FloatingTextPrefab(new Point(Math.random() * 600, Math.random() * 400),"Test"));
//			} 
			
			this.clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
		}
		
		public function onEnterFrame(e:Event):void {
			_timer = new Timer(1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, onFirstTimer);
			_timer.start();
		}
		
		public function onFirstTimer(e:TimerEvent):void {
			var k:int = Math.random() * 3;
			for(var i:int = 0 ; i < k; i++) {
				root.addChild(new ExplosionPrefab(new Point(Math.random() * 600, Math.random() * 400), 0x770022 + Math.random(), Math.random() *200 + 50));
			}
			
			k = Math.random() * 3;
			for(i = 0 ; i < k; i++) {
				root.addChild(new LaserPrefab(new Point(Math.random() * 600, Math.random() * 400), new Point(Math.random() * 600, Math.random() * 400)));
			}
			
			k = Math.random() * 3;
			for(i = 0 ; i < k; i++) {
				root.addChild(new FloatingTextPrefab(new Point(Math.random() * 600, Math.random() * 400), Math.random() > 0.5 ? s1 : s2, 0xFFFFFF, 40 ));
			}
		}
	}
}