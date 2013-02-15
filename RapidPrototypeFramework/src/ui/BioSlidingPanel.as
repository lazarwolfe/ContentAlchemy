package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ui.layout.config.BioMeasurement;
	
	public class BioSlidingPanel extends BioContainer
	{
		private var _toggleButton:BioButton;
		private var _active:Boolean;
		
		private var _offsetCoords:Point;
		
		public function BioSlidingPanel(clip:DisplayObjectContainer=null)
		{
			super(clip, true);
			
			// When Toggle Button is clicked
			_active = true;
			_toggleButton = BioButton(this.findChildByName('btnToggle'));
			_toggleButton.callback = onToggle;
			
			// Guides & Offset
			_offsetCoords = new Point();
			var guideShow:DisplayObject = clip.getChildByName('guideShow');
			var guideHide:DisplayObject = clip.getChildByName('guideHide');
			if( guideShow!=null && guideHide!=null ){
				initHidePosition( guideHide.x-guideShow.x, guideHide.y-guideShow.y );
			}
		}
		public function initHidePosition( offsetX:Number=NaN, offsetY:Number=NaN ):void
		{
			if( !isNaN(offsetX) )
				_offsetCoords.x = offsetX;
			if( !isNaN(offsetY) )
				_offsetCoords.y = offsetY;
		}
		private function onToggle(event:Event):void
		{
			_active = !_active;
			
			// Fake the formatting for now
			var newPositionConfig:Object;
			var slideConfig:Object = {};
			if(_active){
				newPositionConfig =  { x:art.x-_offsetCoords.x, y:art.y-_offsetCoords.y };
			}else{
				newPositionConfig = { x:art.x+_offsetCoords.x, y:art.y+_offsetCoords.y };
			}
			TweenLite.to( art, 0.5, newPositionConfig );
			
			// SLIDE X
			slideConfig = { left:newPositionConfig.x };
			if(this.format.position.left.unitType==BioMeasurement.AUTO){
				this.initFormatWithObject(slideConfig);
				this.format.position.fixToRight(this);
			}else{
				this.initFormatWithObject(slideConfig);
			}
			
			// SLIDE Y
			slideConfig = { top:newPositionConfig.y };
			if(this.format.position.top.unitType==BioMeasurement.AUTO){
				this.initFormatWithObject(slideConfig);
				this.format.position.fixToBottom(this);
			}else{
				this.initFormatWithObject(slideConfig);
			}
			
			TweenLite.to( _toggleButton.art, 0.5, {rotation:_toggleButton.art.rotation+180} );
		}
	}
}