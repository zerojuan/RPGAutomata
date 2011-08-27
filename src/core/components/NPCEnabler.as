package core.components
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.BitmapDataScene;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	
	import flash.geom.Point;

	/**
	 * Component for enabling or disabling an NPC from the game
	 */
	public class NPCEnabler extends EntityComponent{		
		public var spatialReference:RPGSpatialComponent;
		public var rendererReference:SpriteSheetRenderer;
		
		public function enable(val:Boolean):void{
			var spatialManager:RPGSpatialManagerComponent = spatialReference.spatialManager as RPGSpatialManagerComponent;
			if(val){
				spatialReference.registerForTicks = true;				
				spatialManager.updateCollisionMap(spatialReference.gridPosition, spatialReference.gridPosition);				
				rendererReference.registerForUpdates = true;
				rendererReference.scene = _scene;
				rendererReference.alpha = 1;
			}else{
				spatialReference.registerForTicks = false;
				rendererReference.registerForUpdates = false;
				rendererReference.scene = null;
				spatialManager.updateCollisionMap(new Point(0,0), new Point(0,0));
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();
			
			_scene = rendererReference.scene as DisplayObjectScene;
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
		private var _scene:DisplayObjectScene;
	}
}