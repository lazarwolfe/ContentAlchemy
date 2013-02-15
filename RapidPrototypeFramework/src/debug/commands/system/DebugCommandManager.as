package debug.commands.system {
	import debug.logger.FakeGameConsole;
	import debug.logger.IGameConsole;
	
	import flash.utils.Dictionary;

	/**
	 * This class holds a reference to the debog command instances and executes them
	 */
	public class DebugCommandManager implements IDebugCommandManager {
		//# PRIVATE/PROTECTED/INTERNAL
		private var _commandList:Dictionary = new Dictionary();
		private var _console:IGameConsole;

		
		//# CONSTRUCTOR/INIT/DESTROY
		/**
		 * Constructor
		 */
		public function DebugCommandManager(console:IGameConsole = null){
			//If we have an actual game console, use it, otherwise use an empty object that won't do anything
			if (console != null) {
				_console = console;
			}
			else {
				_console = new FakeGameConsole();
			}
			
			registerCommand(new HelpDebugCommand());
		} // constructor
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_commandList = null;
			_console = null;
		} // function destroy
		
		
		//# PUBLIC
		/**
		 * Returns the IDebugCommand object that was registered with the name specified. Returns null if the command is not recognized.  
		 */
		public function getCommand(name:String):IDebugCommand {
			return _commandList[name];
		} // function getCommand
		
		/**
		 * Gets a list of all the commands currently registered in the system
		 */
		public function getCommandList():Vector.<IDebugCommand> {
			var command:IDebugCommand;
			var list:Vector.<IDebugCommand> = new Vector.<IDebugCommand>();
			for each (command in _commandList) {
				list[list.length] = command;
			}
			
			list.sort(commandSort);
			return list;
		} // function getCommandList
		
		
		//# INTERFACE BEGIN IDebugCommandManager
		/**
		 * Executes a command with the name name with args as arguments to it
		 */
		public function executeCommand(name:String, args:Array):void {
			name = name.toLowerCase();
			var command:IDebugCommand = _commandList[name];
			if (command != null) {	
				command.execute(args, _console);
			}
			else {
				_console.write("Debug Command not recognized: " + name + ". Type 'help' without arguments to get a list of commands and 'help commandName' to get information on a particular command.");
			}
		} // function executeCommand
		
		/**
		 * Executes a command in the form of a string.
		 * Takes a string and tokenizes it. The first token is the name of the command to be executed, the rest are its arguments.
		 */
		public function executeCommandString(string:String):void {
			var tokens:Array = string.split(" ");
			var name:String = tokens.shift();
			executeCommand(name, tokens);
		} // function executeCommandString
		
		/**
		 * Adds a command to an internal structure so that it can be executed later
		 */
		public function registerCommand(command:IDebugCommand):void {
			_commandList[command.getName().toLowerCase()] = command;
		} // function registerCommand
		
		/**
		 * Removes a command from an internal structure.
		 */
		public function unregisterCommand(command:IDebugCommand):void {
			_commandList[command.getName().toLowerCase()] = null;
		} // unregisterCommand
		//# INTERFACE END IDebugCommandManager
		
		
		//# PRIVATE/PROTECTED/INTERNAL
		/**
		 * Small utility function used to sort the commands by category and then alphabetically
		 */
		private function commandSort(a:IDebugCommand, b:IDebugCommand):int {
			var k:Boolean;
			if (a.getCategory() == b.getCategory()) {
				k = a.getName().toLowerCase() > b.getName().toLowerCase();
				return  k ? 1 : -1;
			}
			
			k = a.getCategory() > b.getCategory();
			return  k ? 1 : -1;
		} // function commandSort
		
	} // class DebugCommandManager
} // package