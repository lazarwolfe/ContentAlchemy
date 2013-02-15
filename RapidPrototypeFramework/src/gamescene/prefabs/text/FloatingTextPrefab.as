package gamescene.prefabs.text
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import gamescene.GameObject;
	import gamescene.prefabs.text.FloatingTextComponent;
	import gamescene.standardcomponents.MovieClipComponent;
	
	public class FloatingTextPrefab extends GameObject
	{
		public function FloatingTextPrefab(position:Point, text:String, color:int = 0x770022, size:int = 16, moveUp:Boolean = true)
		{
			addComponent(new MovieClipComponent(new MovieClip()));
			addComponent(new FloatingTextComponent(position, text, color, size, moveUp));
		}
	}
}