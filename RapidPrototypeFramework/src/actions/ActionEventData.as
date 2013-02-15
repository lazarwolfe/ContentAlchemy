package actions {
	/**
	 * A structure to keep track of which actions anre responding to which messages.
	 * 
	 * @author CSteiner
	 */
	internal class ActionEventData {
		/** EventDispatcher or IObservable that will send the message */
		public var target:Object;
		/** String defining the type of message to listen for */
		public var type:String;
		/** Action that is waiting on the event or will be triggered by the event */
		public var actionList:Vector.<Action> = new Vector.<Action>();
		/** Number of times this message has been received without an action executed */
		public var noActionCount:int = 0;
		
		/**
		 * ActionEventData constructor.
		 **/		
		public function ActionEventData() {} //ActionEventData
	}
}