package bunnyMark
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * @author Joshua Granick
	 * @author Philippe Elsass
	 */
	public class BunnyTileTest extends Sprite
	{
		private var m_maxX:int;
		private var m_maxY:int;
		private var m_minX:int;
		private var m_minY:int;
		private var m_gravity:Number;
		private var m_numBunnies:int;
		private var m_numBunniesIncrease:int;
		
		private var m_bunnies_vector:Vector.<Bunny>;
		private var m_bunnyBitmapData:BitmapData;
		

		public function BunnyTileTest(numBunnies:uint)
		{
			m_numBunniesIncrease = numBunnies;
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			m_gravity = 0.5;
			m_minX = m_minY = m_numBunnies= 0;

			m_bunnyBitmapData = new BitmapData(26, 37,true, 0xff000000);
			m_bunnies_vector = new Vector.<Bunny>();

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.load(new URLRequest("./assets/skin.png"));

			stageResizeHandler(null);
			stageClickHandler(null);

			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);

		}

		private function loaderCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			
			var bitmap:Bitmap = loaderInfo.content as Bitmap;

			m_bunnyBitmapData = bitmap.bitmapData;
			
			for (var i:int = 0; i < m_numBunnies; i++ )
			{
				var bunny:Bunny = m_bunnies_vector[i];
				if (bunny)
					bunny.bitmapData = m_bunnyBitmapData;
			}
		}

		private function enterFrameHandler(e:Event) :void
		{
			for (var i:int = 0; i < m_numBunnies; i++ )
			{
				var bunny:Bunny = m_bunnies_vector[i];
				bunny.x += bunny.speedX;
				bunny.y += bunny.speedY;
				bunny.speedY += m_gravity;

				if (bunny.x > m_maxX)
				{
					bunny.speedX *= -1.0;
					bunny.x = m_maxX;
				}
				else if (bunny.x < m_minX)
				{
					bunny.speedX *= -1.0;
					bunny.x = m_minX;
				}
				if (bunny.y > m_maxY)
				{
					bunny.speedY *= -0.8;
					bunny.y = m_maxY;
					
					if (Math.random() > 0.5) bunny.speedY -= 3 + Math.random() * 4;
				}
				else if (bunny.y < m_minY)
				{
					bunny.speedY = 0;
					bunny.y = m_minY;
				}
			}
		}

		private function stageResizeHandler(e:Event) :void
		{
			m_maxX = stage.stageWidth;
			m_maxY = stage.stageHeight;
		}

		public function stageClickHandler(e:Event):void
		{
			m_numBunnies += m_numBunniesIncrease;
			
			for (var i :int = 0;  i < m_numBunniesIncrease; i++ )
			{
				var bunny:Bunny = new Bunny(m_bunnyBitmapData);

				bunny.speedX = Math.random() * 5.0;
				bunny.speedY = Math.random() * 5.0 - 2.5;

				var scaleRand:Number = 0.3 + Math.random();
				bunny.scaleX = scaleRand;
				bunny.scaleY = scaleRand;

				bunny.rotation = 120.0 * (15.0 - Math.random() * 30.0);
				
				addChild(bunny);
				m_bunnies_vector.push(bunny);
			}

		}
	}
}