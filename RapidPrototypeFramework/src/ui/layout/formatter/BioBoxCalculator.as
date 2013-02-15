package ui.layout.formatter
{
	import ui.BioCell;
	import ui.layout.config.BioBox;
	import ui.layout.config.BioCellFormat;
	import ui.layout.config.BioMeasurement;

	public class BioBoxCalculator implements IBioBoxCalculator
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		// ##### PROPERTIES
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		
		// ##### PUBLIC
		/**
		 * @param cell
		 * @return The bounds of the content with margin
		 */		
		public function getExternalBox(cell:BioCell):BioBox
		{
			
		}
		
		/**
		 * @param cell
		 * @return The bounds of the content
		 */		
		public function getInternalBox(cell:BioCell):BioBox
		{
			var result:BioBox = new BioBox();
			var cellFormat:BioCellFormat = cell.format;
			
			// PARENT
			var parentCellBox:BioBox = getInternalBox(cell.parent);
			
			// WIDTH
			switch( cellFormat.width.unitType ){
				case BioMeasurement.UNIT_PIXEL:
					result.width = cellFormat.width.value;
					break;
				case BioMeasurement.UNIT_RATIO:
					result.width = cellFormat.width.value * parentCellBox.width;
					break;
			}
		}
		
		// ##### OVERRIDE / IMPLEMENTED
		// ##### PRIVATE / PROTECTED / INTERNAL
	}
}