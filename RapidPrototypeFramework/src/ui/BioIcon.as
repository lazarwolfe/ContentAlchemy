package ui
{
	import flash.display.DisplayObject;
	
	public class BioIcon extends BioCell
	{
		public function BioIcon(art:DisplayObject=null)
		{
			super(art);
		}
		
		override public function resize(width:Number, height:Number):void
		{
			_art.width = width;
			_art.height = height;
		}
	}
}