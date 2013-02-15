package debug.logger
{
	
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import utils.DisplayObjectUtils;

	/**
	 * Game console singleton class.
	 * */
	//@SHARED CANDIDATE
	internal class GameConsole implements ILoggerViewer, IGameConsole
	{	
		//#CONSTANTS
		private static const OPEN_CONSOLE_KEY_CODE:uint = 192; //~ (tilde) character
		private static const MAX_CONSOLE_HISTORY_COMMANDS:uint = 20;
		
		//Color constants
		private static const COLOR_ERROR:uint = 0xFF7F00;
		private static const COLOR_WARNING:uint = 0xFFA500;
		private static const COLOR_LOG:uint = 0xC6E2FF;
		private static const COLOR_DEBUG:uint = 0x9ACD32;
		
		//# PRIVATE VARS
			
		//The logger uses this to filter log entries
		private var _filter:LogFilter;
		
		//The sprite that holds every other gui element of the console
		private var _holder:Sprite;
		
		//The input textfield for entering commands
		private var _inputTextField:TextField;
		
		//The textfield for the console output
		private var _consoleTextField:TextField;
		
		//The textfield with the log entries
		private var _logTextField:TextField;
		
		//The background
		private var _background:Sprite;
		
		//The list of categories on the right
		private var _categoriesBackground:Sprite;
		
		//Collection of textfields for the categories
		private var _categoryTextfields:Vector.<TextField> = new Vector.<TextField>();
		
		//Clickable textfield to lock the scrolling of the console
		private var _lockScrollTextField:TextField;
		
		//The parent Sprite of the holder object
		private var _parent:Sprite;
		
		//The "memory" of the console. Entered commands are added here and you can quickly go back to them uing the arrow keys.
		private var _enteredCommands:Vector.<String> = new Vector.<String>();
		
		//The "memory" of the console. Entered commands are added here and you can quickly go back to them uing the arrow keys.
		private var _enteredCommandsMemoryIndex:uint = 0;
		
		//Set to true if the debug commands are disabled. Thsi value is automatically set by the configuration.
		private var _debugCommandsDisabled:Boolean = false;
		
		//Is the scrolling feature locked?
		private var _scrollLocked:Boolean = false;
		
		//The current category selected.
		private var _currentlySelectedCategorytextfield:TextField = null;
		
		//If set to true, all of the logs will also be printed to the console textfield
		private var _printLogsToConsole:Boolean = false;
		
		/**
		 * Constructor
		 * */
		public function GameConsole(parent:Sprite) {
			_parent = parent;
		}
		
		/**
		 * Configuration for the singleton.
		 * */
		public function init():void {
			var width:Number = 935;
			var height:Number = 350;
			
			var inputHeight:Number = 25;
			var categoryWidth:Number = 100;
			
			var i:uint = 0;
			var categoryTextfield:TextField;
			
			//Filter
			_filter = new LogFilter;
			
			 _holder = new Sprite();
			 _holder.visible = false;
			 
			 //Background
			 _background = new Sprite();
			 _background.graphics.beginFill(0x545454);
			 _background.graphics.drawRect(0,0, width - categoryWidth, height - inputHeight); 
			 _background.graphics.endFill();
			 _background.graphics.lineStyle(3, 0x708090, 1);  
			 _background.graphics.drawRect(0,0, width, height);
			 
			 _background.graphics.moveTo(0, height - inputHeight);
			 _background.graphics.lineTo(width, height - inputHeight);
			 
			 _background.alpha = 0.9;
			 _holder.addChild(_background);
			 
			 //Categories
			 _categoriesBackground = new Sprite();
			 _categoriesBackground.graphics.beginFill(0x646455);
			 _categoriesBackground.graphics.drawRect(width - categoryWidth,0, width - categoryWidth, height - inputHeight); 
			 _categoriesBackground.graphics.endFill();
			 _categoriesBackground.graphics.lineStyle(3, 0x708090, 1);  
			 
			 _categoriesBackground.graphics.moveTo(width - categoryWidth, 0);
			 _categoriesBackground.graphics.lineTo(width - categoryWidth, height - inputHeight);
			 
			 _categoriesBackground.alpha = 0.9;
			 _holder.addChild(_categoriesBackground);
			 
			var categories:Array = ["CONSOLE", "ALL"].concat(LogCategories.categories);
			 for(i = 0 ; i < LogCategories.categories.length ; i++) {
				 categoryTextfield = new TextField();
				 categoryTextfield.htmlText = "<b><font color='#C6E2FF'>" + categories[i] + "</font></b>";
				 categoryTextfield.addEventListener(MouseEvent.CLICK, onCategoryItemClick,false, 0, true);
				 categoryTextfield.x = width - categoryWidth + 10;
				 categoryTextfield.width = categoryWidth;
				 categoryTextfield.y = 15 + i * 20;
				 categoryTextfield.selectable = false;
				 _holder.addChild(categoryTextfield);
				 _categoryTextfields[_categoryTextfields.length] = categoryTextfield;
			 }
			 
			 //Our initial selection should be ALL, which is located at index 1
			 _currentlySelectedCategorytextfield = _categoryTextfields[1];
			 _currentlySelectedCategorytextfield .textColor = COLOR_WARNING;

			//Initialize the textfield for console output
			_consoleTextField = new TextField();
			_consoleTextField.multiline = true;
			_consoleTextField.x = 0;
			_consoleTextField.y = 0;
			_consoleTextField.width = width - categoryWidth;
			_consoleTextField.height = height - inputHeight;
			_consoleTextField.autoSize = TextFieldAutoSize.NONE;
			_consoleTextField.antiAliasType = AntiAliasType.ADVANCED;
			_consoleTextField.selectable = true;
			_consoleTextField.mouseEnabled = true;
			var consoleTextFormat:TextFormat = new TextFormat();
			consoleTextFormat.bold = true;
			consoleTextFormat.size = 14;
			_consoleTextField.defaultTextFormat = consoleTextFormat;
			_consoleTextField.wordWrap = true;
			_holder.addChild(_consoleTextField);
			_consoleTextField.visible = false;	//Initially hidden
			
			//Initialize the textfield for logs
			_logTextField = new TextField();
			_logTextField.multiline = true;
			_logTextField.x = 0;
			_logTextField.y = 0;
			_logTextField.width = width - categoryWidth;
			_logTextField.height = height - inputHeight;
			_logTextField.autoSize = TextFieldAutoSize.NONE;
			_logTextField.antiAliasType = AntiAliasType.ADVANCED;
			_logTextField.selectable = true;
			_logTextField.mouseEnabled = true;
			var logTextFormat:TextFormat = new TextFormat();
			logTextFormat.bold = true;
			logTextFormat.size = 14;
			_logTextField.defaultTextFormat = logTextFormat;
			_logTextField.wordWrap = true;
			_holder.addChild(_logTextField);
			
			//Input background
			_background.graphics.beginFill(0x5454AA);
			_background.graphics.drawRect(0,height - inputHeight, width - categoryWidth, inputHeight); 
			_background.graphics.endFill();
			
			//Scroll lock background
			_background.graphics.lineStyle(3, 0x708090, 1);  
			_background.graphics.beginFill(0x54AA54);
			_background.graphics.drawRect(width - categoryWidth, height - inputHeight, categoryWidth, inputHeight);
			_background.graphics.endFill();
			
			//Scroll lock
			_lockScrollTextField = new TextField();
			_lockScrollTextField.htmlText = "<b><font color='#C6E2FF'>Lock scrolling</font></b>";
			_lockScrollTextField.addEventListener(MouseEvent.CLICK, onLockScrollClick, false, 0, true);
			_lockScrollTextField.x = width - categoryWidth + 5;
			_lockScrollTextField.width = categoryWidth;
			_lockScrollTextField.y = height - inputHeight + 5;
			_lockScrollTextField.selectable = false;
			var lockScrollTextFormat:TextFormat = new TextFormat();
			lockScrollTextFormat.bold = true;
			lockScrollTextFormat.size = 18;
			_lockScrollTextField.defaultTextFormat = lockScrollTextFormat;
			_holder.addChild(_lockScrollTextField);
			
			//Initialize the input textfield
			_inputTextField = new TextField();
			_inputTextField.multiline = false;
			_inputTextField.x = 0;
			_inputTextField.y = height - inputHeight;
			_inputTextField.width = width - categoryWidth;
			_inputTextField.height = inputHeight;
			_inputTextField.autoSize = TextFieldAutoSize.NONE;
			_inputTextField.antiAliasType = AntiAliasType.ADVANCED;
			_inputTextField.selectable = true;
			_inputTextField.mouseEnabled = true;
			_inputTextField.type = TextFieldType.INPUT;
			_inputTextField.textColor = COLOR_DEBUG;
			var inputTextFormat:TextFormat = new TextFormat();
			inputTextFormat.bold = true;
			inputTextFormat.size = 18;
			_inputTextField.defaultTextFormat = inputTextFormat;
			_inputTextField.restrict = "^`";	//Regex for "allow everything except `"
			_holder.addChild(_inputTextField);
			
			//If the configuration says we shouldn't allow debug commands, disable them
			/*if(Core.config.configObject["logger"]["enableConsoleCommands"] == "false") {
				_inputTextField.text = "[Debug Commands Disabled]";
				_inputTextField.type = TextFieldType.DYNAMIC;
				_debugCommandsDisabled = true;
			}*/
			
			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 1000, true);
			_parent.stage.addChild(_holder);
		}
		
		/**
		 * Destructor
		 * */
		public function destroy():void {
			_filter = null;
			var i:int = 0;
			for(i = 0 ; i < _categoryTextfields.length ; i++) {
				_categoryTextfields[i].removeEventListener(MouseEvent.CLICK, onCategoryItemClick, false);
			}
			_categoryTextfields = null;
			_enteredCommands = null;
			_parent.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
			
			DisplayObjectUtils.safeRemoveFromParent(_holder);
		}
		
		//# ILoggerViewer INTERFACE
		
		/**
		 * To be called by the logger when there is new information to be presented
		 * */
		public function update(entry:LogEntry):void {
			var font:String;
			var newText:String;
	
			switch (entry.severity) {
				case Logger.SEVERITY_DEBUG:
					font = "<font color='#9ACD32'>";
					break;
				case Logger.SEVERITY_LOG:
					font = "<font color='#C6E2FF'>";
					break;
				case Logger.SEVERITY_WARNING:
					font = "<font color='#FFA500'>";
					break;
				case Logger.SEVERITY_ERROR:
					font = "<font color='#FF7F00'>";
					break;
				default:
					font = "<font color='#C6E2FF'>";
					break;
			}
			newText =  "<b>" + font + entry.category + ": " + entry.message + "</font>" + " <font color='#C6E2FF'>     " + entry.className + "</font></b><BR />";
			
			_logTextField.htmlText = _logTextField.htmlText + newText;
			
			//If this field is true, it means that a command is in the process of being executed and this actions
			if(_printLogsToConsole == true) {
				_consoleTextField.htmlText = _consoleTextField + newText;
				_consoleTextField.scrollV = _consoleTextField.maxScrollV;
				
			}
			
			//Scroll to the bottom!
			if(_scrollLocked == false ) {
				_logTextField.scrollV = _logTextField.maxScrollV;
			}
			
			//If this is an error, display the console right away
			if(entry.severity == Logger.SEVERITY_ERROR) {
				_holder.visible = true;
			}
		}
		
		/**
		 * Gets an object with the current filtering options.
		 * */
		public function getFilter():LogFilter {
			return _filter;
		}
		
		/**
		 * Sets the current filter. The logger will only log messages if they match the filter's configuration.
		 * */
		public function setFilter(filter:LogFilter):void {
			_filter = filter;
		}
		
		//# End ILoggerViewer
		
		//# IGameConsole
		
		/**
		 * Writes a line of text to the console
		 * */
		public function write(text:String):void{
			_consoleTextField.htmlText = _consoleTextField.htmlText +  "<b><font color='#C6E2FF'>" + text + "</font></b><BR />";
			
			//Scroll to the bottom!
			if(_scrollLocked == false ) {
				_logTextField.scrollV = _logTextField.maxScrollV;
			}
		}
		
		//# End IGameConsole
		
		//# PRIVATE
		
		/**
		 * Event handler for the key up event
		 * */
		private function onKeyUp(event:KeyboardEvent):void {
			
			//Open/close the console
			if (event.keyCode == OPEN_CONSOLE_KEY_CODE) {
				_holder.visible = !_holder.visible; 
				if(_holder.visible && _debugCommandsDisabled == false) {
					_holder.stage.focus = _inputTextField;
					_inputTextField.text = "";
					_enteredCommandsMemoryIndex = _enteredCommands.length;
				}
				event.stopImmediatePropagation();
				event.preventDefault();
			}
			
			//Debug commands disabled, nothing else to do
			if(_debugCommandsDisabled == true) {
				return;
			}
			
			//Enter commands in it
			if(event.keyCode == Keyboard.ENTER) {
				if(_holder.visible) {
					if(_holder.stage.focus == _inputTextField) {
						event.stopImmediatePropagation();
						event.preventDefault();
						
						_consoleTextField.htmlText = _consoleTextField.htmlText + "<b><font color='#9acd32'>    " + _inputTextField.text + "</font></b><BR />";
						
						//Set print logs to console so that all logs that trigger as the result of this command are seen in the console view
						_printLogsToConsole = true;
						Core.debugCommands.executeCommandString(_inputTextField.text);
						_printLogsToConsole = false;
						
						_consoleTextField.scrollV = _consoleTextField.maxScrollV;
						
						//Don't go the console view if the scroll is locked
						if(_scrollLocked == false) {
							setSelectedCategory("CONSOLE");
						}
						
						//Save it in memory
						while(_enteredCommands.length > MAX_CONSOLE_HISTORY_COMMANDS) {
							_enteredCommands.shift();
						}
						_enteredCommands.push(_inputTextField.text);
						_enteredCommandsMemoryIndex = _enteredCommands.length;
						
						//Save it to a shared object
						var so:SharedObject = SharedObject.getLocal("mec-console");
						so.data.lastCommand= _inputTextField.text;
						so.flush(); // writes changes to disk
						
						_inputTextField.text = "";
					}
				}
			}
			
			//Select the previous command
			if(event.keyCode == Keyboard.UP) {
				if(_holder.visible) {
					if(_holder.stage.focus == _inputTextField) {
						event.stopImmediatePropagation();
						event.preventDefault();
						
						if(_enteredCommandsMemoryIndex > 0 && _enteredCommands.length > 0) {
							_enteredCommandsMemoryIndex--;
							_inputTextField.text = _enteredCommands[_enteredCommandsMemoryIndex];
							_inputTextField.setSelection(_inputTextField.text.length, _inputTextField.text.length);
						}
					}
				}
			}
			
			//Select the next command
			if(event.keyCode == Keyboard.DOWN) {
				if(_holder.visible) {
					if(_holder.stage.focus == _inputTextField) {
						event.stopImmediatePropagation();
						event.preventDefault();
						
						if(_enteredCommandsMemoryIndex < _enteredCommands.length - 1 && _enteredCommands.length > 1) {
							_enteredCommandsMemoryIndex++;
							_inputTextField.text = _enteredCommands[_enteredCommandsMemoryIndex];
							_inputTextField.setSelection(_inputTextField.text.length, _inputTextField.text.length);
						}
					}
				}
			}
		}
		
		/**
		 * Event handler for when categories are changed
		 * */
		private function onCategoryItemClick(event:MouseEvent):void {
			var textfield:TextField = event.target as TextField;
			if(textfield != null){
				setSelectedCategory(textfield.text);
			}
		}
		
		/**
		 * Event handler for when the lock scroll button is pressed
		 * */
		private function onLockScrollClick(event:MouseEvent):void {
			_scrollLocked = !_scrollLocked;
			
			if(_scrollLocked) {
				_lockScrollTextField.textColor = COLOR_WARNING;
			}
			else {
				_lockScrollTextField.textColor = COLOR_LOG;
			}
		}
		
		/**
		 * Event handler for when categories are changed
		 * */
		private function reset(logEntries:Vector.<LogEntry>):void {
			var i:uint = 0;
			_logTextField.text = "";
			for(i = 0 ; i < logEntries.length; i++) {
				update(logEntries[i]);
			}
		}
		
		/**
		 * Event handler for when categories are changed
		 * */
		private function setSelectedCategory(category:String):void {
			
			//Find the textfield
			var textfield:TextField;
			var i:uint;
			for(i = 0 ; i < _categoryTextfields.length ; i++) {
				if(_categoryTextfields[i].text == category) {
					textfield = _categoryTextfields[i];
				}
			}
			
			if(textfield == null) {
				Core.logs.warning("Inavalid log category " + category, this, LogCategories.DEBUG);
				return;
			}
			
			_currentlySelectedCategorytextfield.textColor = COLOR_LOG;
			textfield.textColor = COLOR_WARNING;
			_currentlySelectedCategorytextfield = textfield;
			
			if(textfield.text == "CONSOLE") {
				_consoleTextField.visible = true;
				_logTextField.visible = false;
			}
			else {
				_consoleTextField.visible = false;
				_logTextField.visible = true;
			}
			
			if(textfield.text == "ALL") {
				_filter.categories = null;
			}
			else {
				_filter.categories = [textfield.text];
			}
			
			//Reset the textfield with the log entries
			reset(Core.logs.getLogEntries(_filter));
		}
	}
}