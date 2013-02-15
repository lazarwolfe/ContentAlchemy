package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ui.layout.formatter.IBioFormatter;
	
	public class BioScrollPanel extends BioContainer
	{
		private var _firstButton:BioButton;
		private var _prevButton:BioButton;
		private var _nextButton:BioButton;
		private var _lastButton:BioButton;
		private var _gallery:BioContainer;
		
		public var spacer:Number = 10;
		private var _pageIndex:int = 0;
		private var _pageWidth:Number;
		private var _pageMax:int = 0;
		private var _cellsHigh:int;
		private var _cellsWide:int;
		
		public function get gallery():BioContainer{
			return _gallery;
		}
		
		public function BioScrollPanel(clip:DisplayObjectContainer=null)
		{
			super(clip, true);
			
			// Buttons
			_firstButton = BioButton(this.findChildByName('btnFirst'));
			_prevButton = BioButton(this.findChildByName('btnPrev'));
			_nextButton = BioButton(this.findChildByName('btnNext'));
			_lastButton = BioButton(this.findChildByName('btnLast'));
			
			// Callbacks
			_firstButton.callback = onFirst;
			_prevButton.callback = onPrev;
			_nextButton.callback = onNext;
			_lastButton.callback = onLast;
			
			// Gallery
			var guide:DisplayObject = clip.getChildByName('imgMask');
			_gallery = new BioContainer( new Sprite(), false );
			_gallery.art.x = guide.x;
			_gallery.art.y = guide.y;
			_gallery.art.mask = guide;
			_gallery.format.initWithObject({
				width: guide.width,
				height: guide.height
			});
			this.addChildCell(_gallery);
		}
		
		public function addGalleryCell(cell:BioCell):void {
			if (_gallery.children.length == 0) {
				_cellsWide = (_gallery.art.mask.width+spacer) / (cell.art.width+spacer);
				_cellsHigh = (_gallery.art.mask.height+spacer) / (cell.art.height+spacer);
				
				cell.art.x = _gallery.art.mask.x;
				cell.art.y = _gallery.art.mask.y;
				
				if (_cellsWide <= 1) {
					_cellsWide = 1;
					cell.art.x += (_gallery.art.mask.width - cell.art.width)/2;
				}
				if (_cellsHigh <= 1) {
					_cellsHigh = 1;
					cell.art.y += (_gallery.art.mask.height - cell.art.height)/2;
				}
				_pageWidth = _cellsWide * (cell.art.width+spacer);
			} else {
				var firstCell:BioCell = _gallery.children[0];
				var i:int = _gallery.children.length;
				var page:int = i / (_cellsWide*_cellsHigh);
				_pageMax = page;
				var pi:int = i - (page*_cellsWide*_cellsHigh);
				var px:int = (pi%_cellsWide) + page*_cellsWide;
				var py:int = pi/_cellsWide;
				cell.art.x = firstCell.art.x + px*(firstCell.art.width+spacer);
				cell.art.y = firstCell.art.y + py*(firstCell.art.height+spacer);
			}
			cell.initFormatWithObject({
				left: cell.art.x,
				top: cell.art.y,
				width: cell.art.width,
				height: cell.art.height
			});
			_gallery.addChildCell(cell);
		}
		
		private function onFirst(event:Event=null):void {
			goToPage(0);
		}
		
		private function onPrev(event:Event=null):void {
			goToPage(Math.max(0, _pageIndex-1));
		}
		
		private function onNext(event:Event=null):void {
			goToPage(Math.min(_pageMax, _pageIndex+1));
		}
		
		private function onLast(event:Event=null):void {
			goToPage(_pageMax);
		}
		
		public function goToPage(pageIndex:Number):void {
			_pageIndex = pageIndex;
			var newX:Number = -_pageIndex*_pageWidth;
			TweenLite.to( _gallery.art, 0.5, {x:newX} );
			_gallery.initFormatWithObject({
				left: newX
			});
		}
		
	}
}