package
{
	import flash.events.Event;

	public class TilesetEvent extends Event
	{
		public static const LOADED:String = "TILESET_LOADED";						
		
		public function TilesetEvent(type:String){
			super(type, true, false);			
		}
	}
}