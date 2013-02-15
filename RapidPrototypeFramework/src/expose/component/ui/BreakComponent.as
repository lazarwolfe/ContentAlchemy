package expose.component.ui
{
	import expose.component.ExposeComponent;
	
	public class BreakComponent extends ExposeComponent
	{
		public var breakColumn:Boolean;
		
		public function BreakComponent(breakColumn:Boolean=true)
		{
			super();
			this.breakColumn = breakColumn;
		}
	}
}