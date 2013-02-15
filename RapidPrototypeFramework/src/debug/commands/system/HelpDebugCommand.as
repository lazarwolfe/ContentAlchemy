package debug.commands.system
{
	import debug.logger.IGameConsole;

	public class HelpDebugCommand implements IDebugCommand
	{
		public function getName():String {
			return "help";
		}
		
		public function getCategory():String {
			return "Console";
		}
		
		public function getHelp():String {
			return "Provides help to the user. If no arguments are passed, it will print a list of all the debug commands currently in the system. If the name of a command is passed as argument, it will print information on that command.";
		}
		
		public function execute(args:Array, console:IGameConsole):void {
			if(args.length == 0) {
				logCommandList(console);
			}
			else {
				logHelpOnCommand(args[0], console);
			}
		}
		
		/**
		 * Logs a list of all the currently available commands.
		 * */
		private function logCommandList(console:IGameConsole):void {	
			//See if we have an actual DebugCommandManager instead of a mocked version
			var manager:DebugCommandManager = Core.debugCommands as DebugCommandManager;
			if(manager == null) {
				return;
			}
			
			var commandList:Vector.<IDebugCommand> = manager.getCommandList();
			console.write("List of commands available on the console:");
			for(var i:int = 0; i < commandList.length; i++) {
				
				if(i == 0 || commandList[i].getCategory() !=commandList[i - 1].getCategory()) {
					console.write("\n" + commandList[i].getCategory() + ":");
				}
				
				console.write(" - " + commandList[i].getName().toLowerCase());
			}
		}
		
		/**
		 * Logs the help string for a command.
		 * */
		private function logHelpOnCommand(name:String, console:IGameConsole):void {
			//See if we have an actual DebugCommandManager instead of a mocked version
			var manager:DebugCommandManager = DebugCommandManager(Core.debugCommands);
			if(manager == null) {
				return;
			}
			
			var command:IDebugCommand = manager.getCommand(name);
			if(command != null) {
				console.write(command.getName() + ": " +  command.getHelp());
			}
			else {
				console.write("Debug Command not recognized: " + name + ". Type 'help' without arguments to get a list of commands and 'help commandName' to get information on a particular command.");
			}
		}
	}
}