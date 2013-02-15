package ui.layout.config
{
	import ui.BioCell;

	public class BioCellFormat
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _position:BioPositionConfig;
		private var _dimension:BioDimensionConfig;
		
		// ##### PROPERTIES
		public function get position():BioPositionConfig {
			return _position;
		}
		public function get dimension():BioDimensionConfig {
			return _dimension;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function BioCellFormat()
		{
			_position = new BioPositionConfig();
			_dimension = new BioDimensionConfig();
		}
		
		// ##### PUBLIC
		public function initWithObject(blueprint:Object):void
		{
			_position.initWithObject(blueprint);
			_dimension.initWithObject(blueprint);
		}
		
		
	}
}