package core.components 
{
	import com.pblabs.rendering2D.BitmapRenderer;
	
	import flash.events.Event;

	/**
	 * <p> Does nothing different from BitmapRenderer </p>
	 * 
	 * <p> I don't know why I'm still using this. </p> 
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
			//owner.eventDispatcher.addEventListener("TilesetLoadingComplete", onTilesetsLoaded);
			super.onAdd();
		}				
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		private function onTilesetsLoaded(evt:Event):void {
			
		}
		
		private var _source:String;
		
	}

}