package gamescene.interfaces {
	/**
	 * Interface for an object that represents a linear timelien animation.
	 * 
	 * @author SDedlmayr
	 **/	
	public interface ITimelineAnimation {
		/**
		 * Plays the timeline animation.
		 **/		
		function play():void;
		
		/**
		 * Stops the timelien animation.
		 **/		
		function stop():void;
		
		/**
		 * Moves the playhead of the timeline animation to the specified frame and stops it.
		 * 
		 * @param frame The frame to which to move the playhead.
		 **/		
		function gotoAndStop(frame:uint):void;
		
		/**
		 * Moves the playhead of the timeline animation to the specified frame and plays it.
		 * 
		 * @param frame The frame to which to move the playhead.
		 **/		
		function gotoAndPlay(frame:uint):void;
		
		/**
		 * Moves the playhead of the timeline animation to the next frame.
		 **/		
		function nextFrame():void;
		
		/**
		 * Moves the playhead of the timeline animation to the previous frame.
		 **/		
		function prevFrame():void;
	} // interface ITimelineAnimation
} // package scene.standardcomponents.interfaces