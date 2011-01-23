package core.components
{
	import com.pblabs.engine.entity.EntityComponent;
	
	import core.components.events.RPGActionEvent;
	
	import flash.geom.Point;

	public class RPGActionManagerComponent extends EntityComponent
	{
		/**
		 * Reference to where we need to listen to ACTION_EVENTS
		 */
		public var inputSource:RPGInputController;
		/**
		 * Reference to the world, so we can try to guess what ther player is trying to do
		 */
		public var mapReference:RPGSpatialManagerComponent;
		
		private function onAction(evt:RPGActionEvent):void{
			var frontCoord:Point = evt.frontCoordinates;
			var rpgObject:RPGSpatialComponent = mapReference.getObjectInGrid(frontCoord);
			if(rpgObject){
				
			}else{
				
			}
		}
		
		
		protected function onEndAction(evt:RPGActionEvent):void{
			
		}
		
		override protected function onAdd():void{
			if(inputSource){
				inputSource.owner.eventDispatcher.addEventListener(RPGActionEvent.ACTION, onAction);
			}
			owner.eventDispatcher.addEventListener(RPGActionEvent.END_ACTION, onEndAction);
		}
		
		override protected function onRemove():void{
			
		}
	}
}