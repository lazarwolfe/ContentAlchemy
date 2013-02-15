package ui.layout.config
{
	import ui.BioCell;

	public class BioPositionConfig
	{
		// ##### PRIVATE / PROTECTED / INTERNAL
		private var _top:BioMeasurement;
		private var _left:BioMeasurement;
		private var _right:BioMeasurement;
		private var _bottom:BioMeasurement;
		
		// ##### PUBLIC: To be calculated & modifed by Formatter
		public var x:Number;
		public var y:Number;
		
		// ##### PROPERTIES
		public function get top():BioMeasurement {
			return _top;
		}
		public function get left():BioMeasurement {
			return _left;
		}
		public function get right():BioMeasurement {
			return _right;
		}
		public function get bottom():BioMeasurement {
			return _bottom;
		}
		
		// ##### CONSTRUCTOR
		/**
		 * The Constructor
		 */
		public function BioPositionConfig()
		{
			_top = new BioMeasurement();
			_left = new BioMeasurement();
			_right = new BioMeasurement();
			_bottom = new BioMeasurement();
		}
		
		// ##### PUBLIC
		public function initWithObject(blueprint:Object):void
		{
			if(blueprint.top!=null) _top.initWithString(blueprint.top);
			if(blueprint.left!=null) _left.initWithString(blueprint.left);
			if(blueprint.right!=null){ _right.initWithString(blueprint.right); _left.set(); }
			if(blueprint.bottom!=null){ _bottom.initWithString(blueprint.bottom); _top.set(); }
		}
		public function fixToLeft(target:BioCell):void {
			_right.unitType = BioMeasurement.AUTO;
			_left.unitType = BioMeasurement.UNIT_PIXEL;
			_left.value = (target.parent.format.dimension.innerWidth-target.format.dimension.outerWidth) - _right.value;
		}
		public function fixToRight(target:BioCell):void {
			_left.unitType = BioMeasurement.AUTO;
			_right.unitType = BioMeasurement.UNIT_PIXEL;
			_right.value = (target.parent.format.dimension.innerWidth-target.format.dimension.outerWidth) - _left.value;
		}
		public function fixToTop(target:BioCell):void {
			_bottom.unitType = BioMeasurement.AUTO;
			_top.unitType = BioMeasurement.UNIT_PIXEL;
			_top.value = (target.parent.format.dimension.innerHeight-target.format.dimension.outerHeight) - _bottom.value;
		}
		public function fixToBottom(target:BioCell):void {
			_top.unitType = BioMeasurement.AUTO;
			_bottom.unitType = BioMeasurement.UNIT_PIXEL;
			_bottom.value = (target.parent.format.dimension.innerHeight-target.format.dimension.outerHeight) - _top.value;
		}
		
	}
}