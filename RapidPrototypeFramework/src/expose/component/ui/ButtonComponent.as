package expose.component.ui
{
	import expose.Expose;
	import expose.screen.page.ExposePage;
	import expose.component.ExposeComponent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import utils.Placeholder;

	public class ButtonComponent extends ExposeComponent
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _callback:Function;
		
		// ##### PROPERTIES
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function ButtonComponent(label:String,callback:Function)
		{
			super();
			_callback = callback;
			initUI(label);
		}
		
		// ##### FACTORY METHODS
		public static function getCaller(label:String,callback:Function):ButtonComponent 
		{
			return new ButtonComponent(label,callback);
		}
		public static function getPageLink(label:String,page:ExposePage):ButtonComponent 
		{
			return new ButtonComponent(label,function():void{
				Expose.show(page,true);
			});
		}
		
		// ##### PUBLIC
		
		// ##### OVERRIDE / IMPLEMENTED
		
		// ##### PRIVATE / PROTECTED / INTERNAL
		internal function initUI(label:String):void
		{
			var button:DisplayObject = Placeholder.getButton(200,25,label,onClick);
			_sprite.addChild(button);
		}
		private function onClick(event:MouseEvent):void
		{
			event.stopPropagation();
			_callback();
		}
		
	}
}