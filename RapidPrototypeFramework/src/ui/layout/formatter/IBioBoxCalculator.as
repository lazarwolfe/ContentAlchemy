package ui.layout.formatter
{
	import ui.layout.config.BioBox;
	import ui.BioCell;

	public interface IBioBoxCalculator
	{
		/**
		 * @param cell
		 * @return The bounds of the content with margin
		 */		
		function getExternalBox(cell:BioCell):BioBox;
		
		/**
		 * @param cell
		 * @return The bounds of the content
		 */		
		function getInternalBox(cell:BioCell):BioBox;
	}
}