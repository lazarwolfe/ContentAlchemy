package debug.logger
{
	/**
	 * This is passed to debug commands when there is no actual game console.
	 * */
	public class FakeGameConsole implements IGameConsole
	{
		/**
		 * Constructor
		 * */
		public function FakeGameConsole()
		{
		}
		
		/**
		 * Writes a line of text to the console
		 * */
		public function write(text:String):void{
			//Does nothing
		}
		
		/**
		 * Writes a line of text to the console, prints it in a red color so it is more visible.
		 * Should be used for errors, etc.
		 * */
		public function alert(text:String):void{
			//Does nothing
		}
	}
}