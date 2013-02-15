package gamescene.prefabs.lasers
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import gamescene.GameObject;
	import gamescene.standardcomponents.MovieClipComponent;
	
	public class LaserPrefab extends GameObject
	{
		public function LaserPrefab(start:Point, end:Point, color:int = 0x770022, power:int = 3)
		{
			addComponent(new MovieClipComponent(new MovieClip()));
			addComponent(new LaserComponent(start, end, color, power));
		}
	}
}