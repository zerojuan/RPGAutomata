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
		 * Reference to the world, so we can try to guess what the player is trying to do
		 */
		public var mapReference:RPGSpatialManagerComponent;
		
		private function onAction(evt:RPGActionEvent):void{
			var frontCoord:Point = evt.frontCoordinates;
			var rpgObject:RPGSpatialComponent = mapReference.getObjectInGrid(frontCoord);
			if(rpgObject){ //if talking to an object
				
			}else{ //if talking as a monologue
				removeEventListeners();
			}
		}
		
		
		protected function onEndAction(evt:RPGActionEvent):void{
			addEventListeners();
		}
		
		private function addEventListeners():void{
			if(inputSource){
				inputSource.owner.eventDispatcher.addEventListener(RPGActionEvent.ACTION, onAction);
			}
		}
		
		private function removeEventListeners():void{
			if(inputSource){
				inputSource.owner.eventDispatcher.removeEventListener(RPGActionEvent.ACTION, onAction);
			}
		}
		
		override protected function onAdd():void{
			addEventListeners();
			owner.eventDispatcher.addEventListener(RPGActionEvent.END_ACTION, onEndAction);
		}
		
		override protected function onRemove():void{
			
		}
	}
}