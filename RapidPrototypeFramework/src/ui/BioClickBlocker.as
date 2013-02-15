package ui
{
	import flash.display.DisplayObject;
	import utils.Placeholder;
	
	public class BioClickBlocker extends BioIcon
	{
		public function BioClickBlocker()
		{
			super( Placeholder.getRectangle(0,0,100,100,0x000000) );
			_art.alpha = 0.5;
			this.initFormatWithObject({
				width: "100%",
				height: "100%"
			});
		}
	}
}