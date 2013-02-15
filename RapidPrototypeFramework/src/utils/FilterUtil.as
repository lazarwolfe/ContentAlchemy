package utils {
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**
	 * Common filters used throughout the game.  The first time the filter is accessed, it is created.  Subsequent calls return the same filter.
	 * @author csteiner
	 */
	public class FilterUtil {
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		private static var _glowBlack:GlowFilter;
		private static var _glowWhite:GlowFilter;
		private static var _greyscale:ColorMatrixFilter;
		private static var _lightGreyscale:ColorMatrixFilter;
		private static var _darkGreyscale:ColorMatrixFilter;
		private static var _swapRedBlue:ColorMatrixFilter;
		private static var _tintGreen:ColorMatrixFilter;
		private static var _tintRed:ColorMatrixFilter;

		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		/**
		 * Returns a black GlowFilter.
		 */
		public static function getBlackGlow():GlowFilter {
			if (_glowBlack == null) {
				_glowBlack = new GlowFilter(0x0, 1, 3, 3, 8);
			}
			return _glowBlack;
		} // function getBlackGlow

		/**
		 * Returns a white GlowFilter.
		 */
		public static function getWhiteGlow():GlowFilter {
			if (_glowWhite == null) {
				_glowWhite = new GlowFilter(0xFFFFFF, 1, 3, 3, 8);
			}
			return _glowWhite;
		} // function getBlackGlow
		
		/**
		 * Returns a greyscale ColorMatrixFilter
		 */
		public static function getGreyscale():ColorMatrixFilter {
			if (_greyscale == null) {
				_greyscale = new ColorMatrixFilter([0.35,	0.35,	0.35,	0,		0,		// Red
													0.35,	0.35,	0.35,	0,		0,		// Green
													0.35,	0.35,	0.35,	0,		0,		// Blue
													0,		0,		0,		1,		0]);	// Alpha
			}
			return _greyscale;
		} // function getGretscale
		
		/**
		 * Returns a darkened greyscale ColorMatrixFilter
		 */
		public static function getDarkGreyDisable():ColorMatrixFilter {
			if (_darkGreyscale == null) {
				_darkGreyscale = new ColorMatrixFilter([0.25,	0.20,	0.20,	0,		0,		// Red
													0.20,	0.25,	0.20,	0,		0,		// Green
													0.20,	0.20,	0.25,	0,		0,		// Blue
													0,		0,		0,		1,		0]);	// Alpha
			}
			return _darkGreyscale;
		} // function getDarkGreyDisable
		
		/**
		 * Returns a lightened greyscale ColorMatrixFilter
		 */
		public static function getLightenedGreyscale():ColorMatrixFilter {
			if (_lightGreyscale == null) {
				_lightGreyscale = new ColorMatrixFilter([0.65,	0.65,	0.65,	0,		0,		// Red
													0.65,	0.65,	0.65,	0,		0,		// Green
													0.65,	0.65,	0.65,	0,		0,		// Blue
													0,		0,		0,		1,		0]);	// Alpha
			}
			return _lightGreyscale;
		} // function getLightenedGreyscale
		
		/**
		 * Returns a ColorMatrixFilter to enhance green
		 */
		public static function getTintGreen():ColorMatrixFilter {
			if (_tintGreen == null) {
				_tintGreen = new ColorMatrixFilter([0.5,	0,		0,		0,		0,		// Red
													0,		2,		0,		0,		0,		// Green
													0,		0,		0.5,	0,		0,		// Blue
													0,		0,		0,		1,		0]);	// Alpha
			}
			return _tintGreen;
		} // function getLightenedGreyscale
		
		/**
		 * Returns a ColorMatrixFilter to enhance red
		 */
		public static function getTintRed():ColorMatrixFilter {
			if (_tintRed == null) {
				_tintRed = new ColorMatrixFilter([2,		0,		0,		0,		0,		// Red
												  0,		0.5,	0,		0,		0,		// Green
												  0,		0,		0.5,	0,		0,		// Blue
												  0,		0,		0,		1,		0]);	// Alpha
			}
			return _tintRed;
		} // function getLightenedGreyscale
		
		/**
		 * Returns a ColorMatrixFilter to swap red and blue
		 */
		public static function getSwapRedBlue():ColorMatrixFilter {
			if (_swapRedBlue == null) {
				_swapRedBlue = new ColorMatrixFilter([0,	0,		1,		0,		0,		// Red
													0,		1,		0,		0,		0,		// Green
													1,		0,		0,		0,		0,		// Blue
													0,		0,		0,		1,		0]);	// Alpha
			}
			return _swapRedBlue;
		} // function getLightenedGreyscale
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package