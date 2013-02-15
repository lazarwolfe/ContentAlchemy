package debug.commands.system {

	public interface IDebugCommandManager {
		/**
		 * Executes a command with the name name with args as arguments to it
		 * */
		function executeCommand(name:String, args:Array):void;
		
		/**
		 * Executes a command in the form of a string.
		 * Takes a string and tokenizes it. The first token is the name of the command to be executed, the rest are its arguments.
		 * */
		function executeCommandString(string:String):void;
		
		/**
		 * Adds a command to an internal structure so that it can be executed later
		 * */
		function registerCommand(command:IDebugCommand):void;
		
		/**
		 * Removes a command from an internal structure.
		 * */
		function unregisterCommand(command:IDebugCommand):void;
		
	} // interface IDebugCommandManager
} // package