package bunnyMark
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * ...
	 * @author Joshua Granick
	 */
	public class Bunny extends Bitmap
	{
		public var speedX:Number;
		public var speedY:Number;
		
		public function Bunny(bitmapData:BitmapData)
		{
			super(bitmapData);
			speedX = 0;
			speedY = 0;
		}
		
	}
}