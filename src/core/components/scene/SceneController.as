package core.components.scene
{
	import com.greensock.TweenLite;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.DisplayObjectScene;
	
	import flash.events.Event;

	/**
	 * Used for controlling the displayObjectScene
	 * <p>For example</p>
	 * <p>tracking and untracking objects</p>
	 */
	public class SceneController extends EntityComponent
	{		
		
		public var sceneReference:DisplayObjectScene;
		
		public var _trackTarget:DisplayObjectRenderer;
		
		public function set trackTarget(displayObjectRenderer:DisplayObjectRenderer):void{
			if(_trackTarget){
				_trackTarget.owner.eventDispatcher.removeEventListener("PositionChange", onPositionChange);
			}			
			_trackTarget = displayObjectRenderer;
			if(_trackTarget){
				_trackTarget.owner.eventDispatcher.addEventListener("PositionChange", onPositionChange);
			}
		}
		
		private function onPositionChange(evt:Event):void{
			if(sceneReference.trackObject == null){
				PBE.log(this, "Back to tracking the object");
				sceneReference.trackObject = _trackTarget;
				//TweenLite.to(sceneReference.position, 1, {x:100, y:100});
			}
		}
		
		override protected function onAdd():void{
			if(_trackTarget){
				_trackTarget.owner.eventDispatcher.addEventListener("PositionChange", onPositionChange);
			}
		}
		
		override protected function onRemove():void{
			if(_trackTarget){
				_trackTarget.owner.eventDispatcher.removeEventListener("PositionChange", onPositionChange);
			}
		}
	}
}