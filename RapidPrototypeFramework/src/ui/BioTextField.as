package ui
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	public class BioTextField extends BioCell
	{
		private var _textField:TextField;
		
		public function BioTextField(text:String=null,textField:TextField=null)
		{
			// TextField
			if(textField==null){
				textField = new TextField();
			}
			_textField = textField;

			textField.selectable = false;
			textField.mouseEnabled = false;
			
			// Set Text
			if(text!=null){
				setText(text);
			}
			
			super(_textField);
		}
		
		public function getText():String {
			return _textField.text;
		}
		public function setText(text:String):void {
			_textField.text = text;
		}
	}
}