package components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.events.Event;

	public class SimpleHoverController extends TickedComponent
	{
		public var onOverEvent:PropertyReference;
		
		public var tilemapReference:TiledMapConverter;
		
		override protected function onAdd():void{
			super.onAdd();
			
			if(onOverEvent){
				owner.eventDispatcher.addEventListener(owner.getProperty(onOverEvent), onOver);
			}
		}
		
		private function onOver(evt:Event):void{
			PBE.log(this, "Hovering!");
			tilemapReference.tmxFilename = "../lib/office_map.tmx";
		}
	}
}