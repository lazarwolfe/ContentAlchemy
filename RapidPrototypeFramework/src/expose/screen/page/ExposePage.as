package expose.screen.page
{
	import expose.component.ExposeComponent;
	import expose.component.proxy.Proxy;
	import expose.component.ui.BreakComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import utils.SpriteManager;

	public class ExposePage extends SpriteManager
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _components:Vector.<ExposeComponent>;
		private var _proxies:Vector.<Proxy>;
		private var _nextPosition:Point;
		private var _bounds:Rectangle;
		
		// ##### STATIC
		private static const PADDING_X:int = 10;
		private static const PADDING_Y:int = 10;
		private static const MARGIN_X:int = 20;
		private static const MARGIN_Y:int = 20;
		private static const MAX_HEIGHT:int = 400;
		
		// ##### PROPERTIES
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function ExposePage()
		{
			super();
			_components = new Vector.<ExposeComponent>();
			_proxies = new Vector.<Proxy>();
			_nextPosition = new Point();
		}
		
		// ##### PUBLIC
		public function add(comp:ExposeComponent):ExposePage
		{
			_components.push(comp);
			if( comp is Proxy ){
				_proxies.push(comp);
			}
			return this;
		}
		public function resize(width:Number,height:Number):void
		{
			var i:int;
			var comp:ExposeComponent;
			var greatestWidth:Number = 0;
			var greatestRowHeight:Number = 0;
			var yOffset:Number = 0;
			
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(2,0xFFFFFF);
			_nextPosition.x = _nextPosition.y = 0;
			
			for( i=0; i<_components.length; i++ )
			{
				comp = _components[i];
				
				// BREAK
				if( comp is BreakComponent ){
					if( BreakComponent(comp).breakColumn ){
						_nextPosition.x += greatestWidth + PADDING_X;
						_nextPosition.y = 0;
					}else{
						_nextPosition.x = 0;
						_nextPosition.y = 0;
						yOffset += greatestRowHeight + PADDING_Y;
						greatestRowHeight = 0;
						_sprite.graphics.moveTo( MARGIN_X, MARGIN_Y+yOffset );
						_sprite.graphics.lineTo( width-MARGIN_X, MARGIN_Y+yOffset );
						yOffset += PADDING_Y;
					}
					continue;
				}
				
				// Loop
				if( _nextPosition.y+comp.sprite.height > MAX_HEIGHT ){
					_nextPosition.x += greatestWidth + PADDING_X;
					_nextPosition.y = 0;
				}
				if( _nextPosition.x+200/*comp.sprite.width*/ > width-MARGIN_X*2 ){
					_nextPosition.x = 0;
					_nextPosition.y = 0;
					yOffset += greatestRowHeight + PADDING_Y*2;
					greatestRowHeight = 0;
				}
				
				// Place component
				_sprite.addChild(comp.sprite);
				comp.sprite.x = _nextPosition.x + MARGIN_X;
				comp.sprite.y = _nextPosition.y + MARGIN_Y + yOffset;
				
				// Greatest Width & Height
				if( greatestWidth < 200/*comp.sprite.width*/ ){
					greatestWidth = 200/*comp.sprite.width*/;
				}
				if( greatestRowHeight < _nextPosition.y+comp.sprite.height ){
					greatestRowHeight = _nextPosition.y+comp.sprite.height;
				}
				
				// Fluidly position next component
				//if( comp is Proxy ){
					_nextPosition.y += comp.sprite.height + PADDING_Y;
				/*}else{
					_nextPosition.x += comp.sprite.width + PADDING_X;
				}*/
			}
		}
		public function setBounds(bounds:Rectangle):void
		{
			_bounds = bounds;
			_nextPosition = bounds.topLeft;
		}
		public function updateUI():void
		{
			var proxy:Proxy;
			for each( proxy in _proxies ){
				proxy.updateUI();
			}
		}
		public function updateVar():void
		{
			var proxy:Proxy;
			for each( proxy in _proxies ){
				proxy.updateVar();
			}
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
		
	}
}