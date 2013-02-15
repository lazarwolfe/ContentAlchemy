package expose.component.proxy
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import utils.Placeholder;
	
	public class CheckboxProxy extends Proxy
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _checkbox:Sprite;
		private var _checkbox_MARK:Sprite;
		private var _checkbox_BACKGROUND:Sprite;
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function CheckboxProxy(getter:Function,setter:Function)
		{
			super(getter,setter);
			
			// Button
			_sprite.buttonMode = true;
			_sprite.useHandCursor = true;
			_sprite.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		// ##### FACTORY METHODS
		public static function getNormal(label:String,getter:Function,setter:Function):CheckboxProxy
		{
			var checkbox:CheckboxProxy = new CheckboxProxy(getter,setter);
			checkbox.initUI(label);
			return checkbox;
		}
		
		// ##### PUBLIC
		
		// ##### OVERRIDE / IMPLEMENTED
		override public function updateVar():void
		{
			updateUI();
		}
		override public function updateUI():void
		{
			_checkbox_MARK.visible = _proxy.value;
		}
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		internal function initUI(label:String):void
		{
			// Create Label
			var labelField:TextField = Placeholder.getLabel(label,90);
			var newFormat:TextFormat = new TextFormat();
			newFormat.align = TextFormatAlign.RIGHT;
			labelField.setTextFormat( newFormat );
			_sprite.addChild(labelField);
			
			// Create Checkbox
			_checkbox = new Sprite();
			_checkbox_MARK = Placeholder.getRectangle(0,0,20,20,0xFF0000);
			_checkbox_MARK.graphics.lineStyle(2,0xFFFFFF);
			_checkbox_MARK.graphics.moveTo(0,0);
			_checkbox_MARK.graphics.lineTo(20,20);
			_checkbox_MARK.graphics.moveTo(20,0);
			_checkbox_MARK.graphics.lineTo(0,20);
			_checkbox_BACKGROUND = Placeholder.getRectangle(0,0,20,20,0xFFFFFF);
			_checkbox.addChild(_checkbox_BACKGROUND);
			_checkbox.addChild(_checkbox_MARK);
			_checkbox.x = 100;
			_sprite.addChild(_checkbox);
		}
		protected function onClick(event:MouseEvent):void
		{
			_proxy.value = !_proxy.value;
			updateVar();
		}
		
	}
}