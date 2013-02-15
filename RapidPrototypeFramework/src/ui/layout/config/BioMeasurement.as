package ui.layout.config
{
	/**
	 * A measurement WITH UNITS.
	 * 
	 * UNIT_PIXEL: pixels, obviously.
	 * UNIT_PERCENT: e.g. If you want a child to be 50% of a parent's width.
	 * UNIT_AUTO: value doesn't matter, automatically calculate.
	 * */
	public class BioMeasurement
	{
		// ##### CONSTANTS
		public static const AUTO:int = 0;
		public static const UNIT_PIXEL:int = 1;
		public static const UNIT_RATIO:int = 2;
		
		// ##### PROPERTIES
		public var value:Number;
		public var unitType:int;
		public function getValue():Number {
			return this.value;
		}
		public function setValue(newValue:Number):void {
			this.value = newValue;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function BioMeasurement(unitType:int=AUTO,value:Number=0)
		{
			set(unitType,value);
		}
		
		// ##### PUBLIC
		/**
		 * Set value & unit
		 * @param value 
		 * @param unitType 
		 */		
		public function set(unitType:int=AUTO,value:Number=0):void
		{
			this.unitType = unitType;
			this.value = value;
		}
		public function initWithString(blueprint:String):void
		{
			blueprint = blueprint.toLowerCase();
			
			// AUTO
			if( blueprint == 'auto' ){
				this.set(AUTO,0);
				return;
			}
			
			// RATIO
			if( blueprint.indexOf("%") > 0 ){
				this.set( UNIT_RATIO, parseFloat(blueprint)/100 );
				return;
			}
			
			// PIXEL: px or nothing
			this.set( UNIT_PIXEL, parseFloat(blueprint) );
			return;
		}
		
	}
}