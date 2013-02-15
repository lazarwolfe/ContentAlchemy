package gamescene.standardcomponents
{
	import gamescene.GameObject;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class RootGameObject extends GameObject {
		public function RootGameObject(sprite:Sprite) {
			super("__root__");
			var mc:MovieClip = new MovieClip();
			var movieClipComponent:MovieClipComponent = new MovieClipComponent(mc);
			
			sprite.addChild(mc);
			
			addComponent(movieClipComponent, false);
			addComponent(new RootRenderableComponent, false);
		}
	}
}