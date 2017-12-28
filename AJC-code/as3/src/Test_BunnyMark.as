package
{
	import bunnyMark.BackGround;
	import bunnyMark.BunnyTileTest;
	import flash.display.Sprite;
	import flash.events.Event;
	

	/**
	 * ...
	 * @author Jason Huang
	 */
	public class Test_BunnyMark extends Sprite
	{
		/**
		* @usage this is used for configing emsc module.
		*
		* <inject_html>
		* <script type="text/javascript">
		* 		ajcGlobal.emscModuleFileName = "AjcRuntimeWeb";
		*		ajcGlobal.emscOutputModuleName = "flash";
		*		ajcGlobal.emscSrcEmscModuleName = "AjcRuntimeWeb";
		*		ajcGlobal.emscModuleConfig = {};
		* 		ajcGlobal.emscModuleAdditionalMainArgs = "";
		*
		*      ajcGlobal.stageInitWidth = 1280;
		* 		ajcGlobal.stageInitHeight = 700;
		* 		ajcGlobal.stageAutoSize = true;
		* 	    ajcGlobal.useStageMinSize = true;
		*
		* </script>
		* </inject_html>
		*/
		public function Test_BunnyMark()
		{
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, false);
		}

		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init, false);
			
			addChild(new BackGround());
			addChild(new BunnyTileTest(5000));
		}
	}

}