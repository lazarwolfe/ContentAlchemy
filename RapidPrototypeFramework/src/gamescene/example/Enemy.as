package gamescene.example
{
	import flash.display.MovieClip;
	
	import gamescene.GameObject;
	
	import gamescene.standardcomponents.MovieClipComponent;

	public class Enemy extends GameObject {
		
		public var foo:String = "Barred";
		
		public function Enemy() {
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0x539eea, 1);
			mc.graphics.lineStyle(3);
			mc.graphics.drawRect(0,0, Math.random() * 100 + 20, Math.random() * 100 + 20);
			mc.graphics.endFill();
			
			addComponent(new MovieClipComponent(mc));
			addComponent(new MoveInDirection());
			
			render2d.x = Math.random() *  600;
			render2d.y = Math.random() *  400;	
		}
	}
}