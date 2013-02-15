package ui.layout.formatter
{
	import ui.BioContainer;

	public class BioFormatter implements IBioFormatter
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		protected var _position:BioPositionFormatter;
		protected var _dimension:BioDimensionFormatter;
		
		// ##### PROPERTIES
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function BioFormatter():void
		{
			_position = new BioPositionFormatter();
			_dimension = new BioDimensionFormatter();
		}
		
		// ##### PUBLIC
		/**
		 * Format a given container.
		 * e.g. Arranging its children, resizing it to fit children, etc...
		 * 
		 * @param container The Container to format
		 */
		public function format(container:BioContainer):void
		{
			_dimension.format(container);
			_position.format(container);
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
	}
}