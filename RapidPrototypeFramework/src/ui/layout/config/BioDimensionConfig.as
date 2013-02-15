package ui.layout.config
{
	public class BioDimensionConfig
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _margin:BioMeasurement;
		private var _width:BioMeasurement;
		private var _height:BioMeasurement;
		
		// ##### PUBLIC: To be calculated & modifed by Formatter
		public var innerWidth:Number;
		public var innerHeight:Number;
		public var outerWidth:Number;
		public var outerHeight:Number;
		
		// ##### PROPERTIES
		public function get margin():BioMeasurement {
			return _margin;
		}
		public function get width():BioMeasurement {
			return _width;
		}
		public function get height():BioMeasurement {
			return _height;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function BioDimensionConfig()
		{
			_margin = new BioMeasurement( BioMeasurement.UNIT_PIXEL );
			_width = new BioMeasurement( BioMeasurement.UNIT_PIXEL );
			_height = new BioMeasurement( BioMeasurement.UNIT_PIXEL );
		}
		
		// ##### PUBLIC
		public function initWithObject(blueprint:Object):void
		{
			if(blueprint.margin!=null) _margin.initWithString(blueprint.margin);
			if(blueprint.width!=null) _width.initWithString(blueprint.width);
			if(blueprint.height!=null) _height.initWithString(blueprint.height);
		}
	}
}