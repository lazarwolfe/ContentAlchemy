package gamescene {
	import expose.component.ui.BreakComponent;
	
	import gamescene.interfaces.IRenderable2d;
	
	public class PhysicsComponent extends Component {
		public var category:String;
		public var radius:Number;
		public var rSquared:Number;
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;

		public function PhysicsComponent(category:String, radius:Number) {
			this.category = category;
			this.radius = radius;
			super();
		}
		
		public function onUpdate(dt:Number):void {
			x += vx*dt;
			y += vy*dt;
		}
		
		public function checkCollisionWith(group:Vector.<PhysicsComponent>):void {
			var other:PhysicsComponent;
			var i:int;
			for (i=0; i<group.length; i++) {
				other = group[i];
				var dx:Number = other.x - x;
				var dy:Number = other.y - y;
				if ((dx*dx)+(dy*dy) <= (rSquared+other.rSquared)) {
					if (other != this) {
						_owner.onEvent(null, GameObject.COLLISION_EVENT, other);
					}
				}
			}
		}
	}
}