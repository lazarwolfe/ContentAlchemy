package debug.commands.system
{
	import debug.logger.IGameConsole;

	public interface IDebugCommand
	{
		/**
		 * Returns the name of this command. This will be the command you type in the console.
		 * */
		function getName():String;
		
		/**
		 * Returns the category name for this command. This is used to group commands together when they are listed.
		 * */
		function getCategory():String;
		
		/**
		 * Returns a help string that must contain a description of the command and information about the arguments it expects.
		 * */
		function getHelp():String;
		
		/**
		 * Executes the command with the passed arguments.
		 * 
		 * @param 	args 	An array of string arguments for this command
		 * @param	console	An IGameConsole object user to write output to the console.
		 * */
		function execute(args:Array, console:IGameConsole):void;
	}
}