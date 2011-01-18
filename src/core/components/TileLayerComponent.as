package core.components 
{
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.BitmapRenderer;
	
	import flash.events.Event;

	/**
	 * ...
	 * @author Julius
	 */
	public class TileLayerComponent extends BitmapRenderer
	{
		public function get source():String {
			return _source;
		}
		
		public function set source(str:String):void {
			_source = str;
		}
						
		override protected function onAdd():void {			
			owner.eventDispatcher.addEventListener("TilesetLoadingComplete", onTilesetsLoaded);
			super.onAdd();
		}				
		
		override protected function onRemove():void {
			
		}
		
		private function onTilesetsLoaded(evt:Event):void {
			
		}
		
		private var _source:String;
		
	}

}