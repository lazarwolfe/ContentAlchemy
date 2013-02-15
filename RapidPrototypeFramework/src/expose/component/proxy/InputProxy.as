package expose.component.proxy
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import utils.Placeholder;

	public class InputProxy extends Proxy
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		protected var _allowUpdateUI:Boolean;
		private var _parseToVar:Function;
		private var _parseToUI:Function;
		private var _input:TextField;
		
		// ##### PROPERTIES
		public function set parseToVar(value:Function):void {
			_parseToVar = value;
		}
		public function set parseToUI(value:Function):void {
			_parseToUI = value;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function InputProxy(getter:Function,setter:Function)
		{
			super(getter,setter);
			_allowUpdateUI = true;
			
			// Focus Events
			_sprite.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			_sprite.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		
		// ##### FACTORY METHODS
		public static function getHex(label:String,getter:Function,setter:Function):InputProxy // Put label in front 
		{
			var input:InputProxy = new InputProxy(getter,setter);
			input.initUI(label,'a-f0-9',8);
			input.parseToVar = function(str:String):uint {
				return parseInt('0x'+str);
			}
			input.parseToUI = function(hex:uint):String {
				return hex.toString(16);
			}
			return input;
		}
		public static function getNumber(label:String,getter:Function,setter:Function,signed:Boolean=true):InputProxy
		{
			var input:InputProxy = new InputProxy(getter,setter);
			var restrict:String; 
			if(signed) 
				restrict='-.0-9';
			else
				restrict='.0-9';
			input.initUI(label,restrict);
			input.parseToVar = function(str:String):Number {
				return parseFloat(str);
			}
			input.parseToUI = function(value:Number):String {
				return value.toPrecision(8);
			}
			return input;
		}
		public static function getInt(label:String,getter:Function,setter:Function,signed:Boolean=true):InputProxy
		{
			var input:InputProxy = new InputProxy(getter,setter);
			var restrict:String; 
			if(signed)
				restrict='-0-9';
			else
				restrict='0-9';
			input.initUI(label,restrict);
			input.parseToVar = function(str:String):int {
				return parseInt(str);
			}
			input.parseToUI = function(value:int):String {
				return value.toString();
			}
			return input;
		}
		public static function getString(label:String,getter:Function,setter:Function):InputProxy
		{
			var input:InputProxy = new InputProxy(getter,setter);
			var restrict:String; 
			input.initUI(label,restrict);
			input.parseToVar = function(str:String):String {
				return str;
			}
			input.parseToUI = function(value:String):String {
				return value;
			}
			return input;
		}
		
		// ##### PUBLIC
		
		// ##### OVERRIDE / IMPLEMENTED
		override public function updateVar():void
		{
			_proxy.value = _parseToVar(_input.text);
			updateUI();
		}
		override public function updateUI():void
		{
			if(!_allowUpdateUI) return;
			var newText:String = _parseToUI(_proxy.value);
			if(newText==null) newText='';
			_input.text = newText;
		}
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		internal function initUI(label:String,restrict:String,maxChars:int=0):void
		{
			// Create Label
			var labelField:TextField = Placeholder.getLabel(label,90);
			var newFormat:TextFormat = new TextFormat();
			newFormat.align = TextFormatAlign.RIGHT;
			labelField.setTextFormat( newFormat );
			_sprite.addChild(labelField);
			
			// Create Input
			_input = Placeholder.getInput();
			_input.x = 100;
			_input.maxChars = maxChars;
			_input.restrict = restrict;
			_sprite.addChild(_input);
		}
		private function onFocusOut(event:FocusEvent):void {
			updateVar();
			_allowUpdateUI = true;
		}
		private function onFocusIn(event:FocusEvent):void {
			_allowUpdateUI = false;
		}
		
	}
}