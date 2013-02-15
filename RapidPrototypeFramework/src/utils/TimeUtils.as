package utils {
	public class TimeUtils {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		public static function getTimeString(time:int, showSeconds:Boolean = true):String {
			var seconds:int = time%60;
			time /= 60;
			var minutes:int = time%60;
			time /= 60;
			var hours:int = time%24;
			time /= 24;
			var days:int = time;
			var timeTxt:String;
			if (showSeconds) {
				timeTxt = minutes + ":" + ((seconds<10)?"0":"") + seconds;
			}
			else {
				timeTxt = "" + minutes;
			}
			// Check for 0 for minutes.
			if ((days > 0 || hours > 0) && minutes < 10) {
				timeTxt = "0" + timeTxt;
			}
			// Add hours
			if (days > 0 || hours > 0) {
				timeTxt = hours + ":" + timeTxt;
			}
			// Check for prefix for hours
			if (days > 0 && hours < 10) {
				timeTxt = "0" + timeTxt;
			}
			// Add Days
			if (days > 0) {
				timeTxt = days + ":" + timeTxt;
			}
			// Check for generic prefix
			switch (timeTxt.length) {
				case 0:
					timeTxt = "0:00";
					break;
				case 1:
					timeTxt = "0:0"+timeTxt;
					break;
				case 2:
					timeTxt = "0:"+timeTxt;
					break;
			}
			return timeTxt;
		} // function getTimeString
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package