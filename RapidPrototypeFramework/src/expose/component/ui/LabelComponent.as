package expose.component.ui
{
	import expose.component.ExposeComponent;
	
	import flash.text.TextField;
	import utils.Placeholder;
	
	public class LabelComponent extends ExposeComponent
	{
		public function LabelComponent(label:String)
		{
			super();
			initUI(label);
		}
		
		// ##### FACTORY METHODS
		public static function getLabel(label:String):LabelComponent
		{
			return new LabelComponent(label);
		}
		
		// ##### PUBLIC
		
		// ##### OVERRIDE / IMPLEMENTED
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		internal function initUI(label:String):void
		{
			var textField:TextField = Placeholder.getLabel(label,200);
			_sprite.addChild(textField);
		}
		
	}
}