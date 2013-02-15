package ui.layout.formatter
{
	import ui.BioCell;
	import ui.BioContainer;
	import ui.layout.config.BioDimensionConfig;
	import ui.layout.config.BioMeasurement;
	import ui.layout.config.BioPositionConfig;

	public class BioPositionFormatter implements IBioFormatter
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
			var positionFormat:BioPositionConfig;
			var dimensionFormat:BioDimensionConfig;
			for each( child in container.children )
			{
				positionFormat = child.format.position;
				dimensionFormat = child.format.dimension;
				
				var child_x:Number;
				var child_y:Number;
				
				// X: Left overrides Right
				if( positionFormat.left.unitType != BioMeasurement.AUTO ){
					switch(positionFormat.left.unitType){
						case BioMeasurement.UNIT_PIXEL:
							child_x = positionFormat.left.value;
							break;
						case BioMeasurement.UNIT_RATIO:
							child_x = positionFormat.left.value * (container.format.dimension.innerWidth-dimensionFormat.outerWidth);
							break;
					}
				}else{
					switch(positionFormat.right.unitType){
						case BioMeasurement.UNIT_PIXEL:
							child_x = container.format.dimension.innerWidth - positionFormat.right.value;
							child_x -= dimensionFormat.outerWidth;
							break;
						case BioMeasurement.UNIT_RATIO:
							child_x = (1-positionFormat.right.value) * (container.format.dimension.innerWidth-dimensionFormat.outerWidth);
							child_x -= dimensionFormat.outerWidth;
							break;
					}
				}
				
				// Y: Top overrides bottom
				if( positionFormat.top.unitType != BioMeasurement.AUTO ){
					switch(positionFormat.top.unitType){
						case BioMeasurement.UNIT_PIXEL:
							child_y = positionFormat.top.value;
							break;
						case BioMeasurement.UNIT_RATIO:
							child_y = positionFormat.top.value * (container.format.dimension.innerHeight-dimensionFormat.outerHeight);
							break;
					}
				}else{
					switch(positionFormat.bottom.unitType){
						case BioMeasurement.UNIT_PIXEL:
							child_y =  container.format.dimension.innerHeight - positionFormat.bottom.value;
							child_y -= dimensionFormat.outerHeight;
							break;
						case BioMeasurement.UNIT_RATIO:
							child_y = (1-positionFormat.bottom.value) * (container.format.dimension.innerHeight-dimensionFormat.outerHeight);
							child_y -= dimensionFormat.outerHeight;
							break;
					}
				}
				
				// Re-position
				child.format.position.x = child_x;
				child.format.position.y = child_y;
				child.reposition(child_x,child_y);
			}
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
	}
}