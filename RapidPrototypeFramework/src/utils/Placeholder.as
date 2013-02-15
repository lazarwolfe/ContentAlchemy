package utils
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/****
	 * THIS CLASS SHOULD NOT EXIST. IT IS SOLELY BEING USED FOR TEMPORARY UTILITY FUNCTIONS THAT DO THINGS
	 * LIKE GENERATE PROGRAMMER ART.
	 */
	public class Placeholder
	{
		
		/**
		 * Get Button Sprite
		 * */
		public static function getButton(width:uint, height:uint, text:String="", callback:Function=null):SimpleButton
		{
			var color:uint = 0x000000;
			color += Math.floor(Math.random()*0x000088)*0x000001;
			color += Math.floor(Math.random()*0x000088)*0x000100;
			color += Math.floor(Math.random()*0x000088)*0x010000;
			color += 0x222222;
			
			return getColoredButton(width,height,text,color,callback);
		}
		
		/**
		 * Get Button Sprite
		 * */
		public static function getColoredButton(width:uint, height:uint, text:String="", color:uint=0x000000, callback:Function=null):SimpleButton
		{
			var up:Sprite = getButtonSprite(width,height,color,text);
			var over:Sprite = getButtonSprite(width+5,height,color+0x111111,text);
			var down:Sprite = getButtonSprite(width,height,color-0x111111,text);
			var button:SimpleButton = new SimpleButton(up,over,down,down);
			if(callback!=null){
				button.addEventListener(MouseEvent.CLICK,callback);
			}
			
			return button;
		}
		
		/**
		 * Get Button Sprite
		 * */
		public static function getColoredTab(width:uint, height:uint, text:String="", color:uint=0x000000, callback:Function=null):SimpleButton
		{
			var up:Sprite = getButtonSprite(width,height,color,text);
			var over:Sprite = getButtonSprite(width,height+10,color,text);
			over.y-=10;
			var down:Sprite = getButtonSprite(width,height,color,text);
			var button:SimpleButton = new SimpleButton(up,over,down,down);
			if(callback!=null){
				button.addEventListener(MouseEvent.CLICK,callback);
			}
			
			return button;
		}
		
		/**
		 * Get Button Sprite
		 * */
		public static function getButtonSprite(width:uint, height:uint, color:uint, text:String="", alpha:Number=1 ):Sprite 
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color,alpha);
			//sprite.graphics.lineStyle(1,0xFFFFFF,0.5);
			sprite.graphics.drawRoundRectComplex(0, 0, width, height, 0, 10, 0, 0);
			sprite.graphics.endFill();
			
			if (text != "") {
				var textField:TextField = getLabel(text,width,height);
				textField.name = "text";
				textField.selectable = false;
				textField.x = 6;
				textField.y = 4;
				
				sprite.addChild(textField);
			}
			
			return sprite;
		}
		
		/**
		 * Get a Label
		 * */
		public static function getLabel(label:String="", width:int=100, height:int=20, color:uint=0xFFFFFF, size:int=12 ):TextField
		{
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.width = width;
			textField.height = height;
			textField.textColor = color;
			textField.wordWrap = true;
			
			textField.defaultTextFormat = new TextFormat('Courier',size);
			textField.text = label;
			
			return textField;
		}
		
		/**
		 * Get an input textfield
		 * */
		public static function getInput(label:String="", width:int=100, height:int=20, color:uint=0x000000, bgColor:uint=0xFFFFFF, size:int=15 ):TextField
		{
			var input:TextField = getLabel(label,width,height,color,size);
			input.type = 'input';
			input.width = width;
			input.selectable = true;
			input.background = true;
			input.backgroundColor = bgColor;
			input.border = true;
			
			return input;
		}
		
		/**
		 * Returns Arrow
		 * */
		public static function getArrow(width:Number=20,height:Number=20,rotation:Number=0):Sprite
		{
			var sprite:Sprite;
			sprite = new Sprite();
			sprite.graphics.lineStyle(1,0xFFFFFF);
			sprite.graphics.beginFill(0x000000);
			
			width*=0.5;
			sprite.graphics.moveTo(-width,0);
			sprite.graphics.lineTo(-width,-height);
			sprite.graphics.lineTo(0,-height-width);
			sprite.graphics.lineTo(width,-height);
			sprite.graphics.lineTo(width,0);
			sprite.graphics.lineTo(-width,0);
			
			sprite.graphics.endFill();
			sprite.rotation = rotation;
			
			return sprite;
		}
		
		/**
		 * Returns Arrow
		 * */
		public static function getArrowButton(width:Number=20,height:Number=20,rotation:Number=0, callback:Function=null):SimpleButton
		{
			var sprite:Sprite = getArrow(width,height,rotation);
			var button:SimpleButton = new SimpleButton(sprite,sprite,sprite,sprite);
			if(callback!=null){
				button.addEventListener(MouseEvent.CLICK,callback);
			}
			return button;
		}
		
		/**
		 * Returns a Placeholder Sprite.
		 * It's a rectangle with an X through it.
		 * Like Slendy
		 * */
		public static function getSprite(x:Number=0,y:Number=0,width:Number=50,height:Number=50):Sprite
		{
			var sprite:Sprite;
			sprite = new Sprite();
			
			// Rectangle
			sprite.graphics.beginFill(0xCCCCCC,0.8);
			sprite.graphics.lineStyle(2,0x555555);
			sprite.graphics.drawRoundRect(x,y,width,height,20,20);
			sprite.graphics.endFill();
			
			// X
			sprite.graphics.moveTo(x,y);
			sprite.graphics.lineTo(x+width,y+height);
			sprite.graphics.moveTo(x+width,y);
			sprite.graphics.lineTo(x,y+height);
			
			return sprite;
		}
		
		/**
		 * Returns a Placeholder colored rectangle Sprite
		 * */
		public static function getRectangle(x:Number=0,y:Number=0,width:Number=50,height:Number=50,color:int=-1):Sprite
		{
			var sprite:Sprite;
			sprite = new Sprite();
			
			if( color<0 ){
				color = Math.random()*0xFFFFFF;
			}
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(x,y,width,height);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
		/**
		 * Returns Lorem Ipsum
		 * */
		public static function getLoremIpsum():String {
			return 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
		}
		
		/**
		 * Returns a Placeholder colored Circle Sprite
		 * */
		public static function getCircle(x:Number=0,y:Number=0,radius:Number=25,color:int=-1):Sprite
		{
			return getEllipse(x-radius,y-radius,radius*2,radius*2,color);
		}
		
		/**
		 * Returns a Placeholder colored Ellipse Sprite
		 * */
		public static function getEllipse(x:Number=0,y:Number=0,width:Number=50,height:Number=50,color:int=-1):Sprite
		{
			var sprite:Sprite;
			sprite = new Sprite();
			
			if( color<0 ){
				color = Math.random()*0xFFFFFF;
			}
			sprite.graphics.beginFill(color);
			sprite.graphics.drawEllipse(x,y,width,height);
			sprite.graphics.endFill();
			
			return sprite;
		}
	}
}