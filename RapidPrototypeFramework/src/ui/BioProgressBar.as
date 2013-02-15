package ui
{
	import flash.display.MovieClip;
	
	public class BioProgressBar extends BioCell
	{
		public function BioProgressBar(art:MovieClip=null)
		{
			super(art);
			MovieClip(art).stop();
		}
		
		public function updateFrame():void
		{
			MovieClip(art).gotoAndStop( Math.ceil((current/max)*MovieClip(art).totalFrames) );
		}

		public function init(current:Number,max:Number):void {
			_current = current;
			_max = max;
			updateFrame();
		}
		
		protected var _current:Number;
		protected var _max:Number;
		
		public function get current():Number{
			return _current;
		}
		public function set current(value:Number):void{
			_current = value;
			updateFrame();
		}
		public function get max():Number{
			return _max;
		}
		public function set max(value:Number):void{
			_max = value;
		}
		
	}
}