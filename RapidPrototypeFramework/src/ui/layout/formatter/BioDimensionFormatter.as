package ui.layout.formatter
{
	import ui.BioCell;
	import ui.BioContainer;
	import ui.layout.config.BioDimensionConfig;
	import ui.layout.config.BioMeasurement;

	public class BioDimensionFormatter implements IBioFormatter
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		// ##### PROPERTIES
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		
		// ##### PUBLIC
		/**
		 * Format a given container.
		 * e.g. Arranging its children, resizing it to fit children, etc...
		 * 
		 * @param container The Container to format
		 */
		public function format(container:BioContainer):void
		{
			var child:BioCell;
			var dimensionFormat:BioDimensionConfig;
			for each( child in container.children )
			{
				dimensionFormat = child.format.dimension;
				
				var child_width:Number = 0;
				var child_height:Number = 0;
				var child_margin:Number = 0;
				
				// MARGIN
				switch(dimensionFormat.margin.unitType){
					case BioMeasurement.UNIT_PIXEL:
						child_margin = dimensionFormat.margin.value;
						break;
				}
				
				
				// WIDTH
				switch(dimensionFormat.width.unitType){
					case BioMeasurement.UNIT_PIXEL:
						child_width = dimensionFormat.width.value;
						break;
					case BioMeasurement.UNIT_RATIO:
						child_width = dimensionFormat.width.value * (container.format.dimension.innerWidth-child_margin*2);
						break;
				}
				
				// HEIGHT
				switch(dimensionFormat.height.unitType){
					case BioMeasurement.UNIT_PIXEL:
						child_height = dimensionFormat.height.value;
						break;
					case BioMeasurement.UNIT_RATIO:
						child_height = dimensionFormat.height.value * (container.format.dimension.innerHeight-child_margin*2);
						break;
				}
				
				// Re-position
				child.format.dimension.innerWidth = child_width;
				child.format.dimension.innerHeight = child_height;
				child.format.dimension.outerWidth = child_width + child_margin*2;
				child.format.dimension.outerHeight = child_height + child_margin*2;
				child.resize(child_width,child_height);
				
			}
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
	}
}