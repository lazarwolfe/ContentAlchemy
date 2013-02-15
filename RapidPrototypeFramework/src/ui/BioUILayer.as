package ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class BioUILayer extends BioContainer
	{
		public function BioUILayer(stage:DisplayObjectContainer)
		{
			art = new Sprite();
			stage.addChild(art);
		}
	}
}