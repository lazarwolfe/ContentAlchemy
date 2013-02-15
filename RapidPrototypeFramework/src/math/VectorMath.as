package math
{
	public class VectorMath
	{
		
		public static function getDistanceSquared(a:Pt, b:Pt):Number
		{
			return Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2) + Math.pow(a.y - b.y, 2);	
		}
		
		public static function getDistance(a:Pt, b:Pt):Number
		{
			return Math.sqrt(getDistanceSquared(a, b));
		}
	}
}