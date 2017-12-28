package bunnyMark
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Jason Huang
	 */
	public class BackGround extends Sprite
	{
		private var m_tileWidth:int;
		private var m_tileHeight:int;
		private var m_bitmap:Bitmap;

		public function BackGround()
		{
			if (stage) 
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, false);
		}

		private function init(event:Event): void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init, false);
			
			
			m_tileWidth = 64;
			m_tileHeight = 64;

			var bitmapData:BitmapData = new BitmapData(m_tileWidth, m_tileHeight, false, 0xff000000);
			m_bitmap = new Bitmap(bitmapData);
			m_bitmap.scaleX = stage.stageWidth / m_tileWidth;
			m_bitmap.scaleY = stage.stageHeight / m_tileHeight;

			addChild(m_bitmap);

			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, false);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, false);

			addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, false);
		}
		private function removed(event:Event): void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed, false);

			removeChild(m_bitmap);

			stage.removeEventListener(Event.RESIZE, stageResizeHandler, false);
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
		}
		private function stageResizeHandler(event:Event): void
		{
			m_bitmap.scaleX = stage.stageWidth / m_tileWidth;
			m_bitmap.scaleY = stage.stageHeight / m_tileHeight;
		}
		private function enterFrameHandler(event:Event): void
		{
			var t:int = getTimer() / 400.0;

			var scale:Number = 4.0;
			var wave:Number = Math.PI * 6.0 / Number(m_tileHeight);

			for (var x:int = 0; x < m_tileWidth; x++)
			{
				for (var y:int = 0; y < m_tileHeight; y++)
				{
					var offsetY:Number = Math.sin(x * wave / 20.0 + t) * 30.0 + Math.sin(x * wave / 5.0 + t * 2) * 5.0;
					var offsetX:Number = (2.0 + Math.sin((y + offsetY) * wave + t) + Math.sin((y + offsetY) * wave * 0.7 + t * 2.4)) / 4.0;
					
					var bitmapData :BitmapData = m_bitmap.bitmapData;
					bitmapData.setPixel(x, y, uint(255 * offsetX));
					
					COMPILE::JS
					{
						bitmapData.emsc_delete();
					}
				}
			}
		}

	}
}