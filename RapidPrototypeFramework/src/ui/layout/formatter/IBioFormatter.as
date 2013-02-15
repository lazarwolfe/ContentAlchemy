package ui.layout.formatter
{
	import ui.BioContainer;

	public interface IBioFormatter
	{
		/**
		 * Format a given container.
		 * e.g. Arranging its children, resizing it to fit children, etc...
		 * 
		 * @param container The Container to format
		 */		
		function format(container:BioContainer):void;
	}
}