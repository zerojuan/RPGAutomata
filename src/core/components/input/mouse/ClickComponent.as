package core.components.input.mouse
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.ISpatialManager2D;
	import com.pblabs.rendering2D.ISpatialObject2D;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ClickComponent extends EntityComponent
	{
		//the scene manager we will get the entities from
		public var scene:DisplayObjectScene;
		
		public var spatialManager:ISpatialManager2D;
		
		protected override function onAdd():void{			
			PBE.mainStage.addEventListener(MouseEvent.CLICK, onClick);
		}				
		
		private function onClick(evt:MouseEvent):void{
			var results:Array = [];
			var point:Point = new Point(PBE.mainStage.mouseX, PBE.mainStage.mouseY);
			
			if(spatialManager){
				point = scene.transformScreenToWorld(point);
				var foundObjects:Boolean = spatialManager.getObjectsUnderPoint(point, results);
				
				for each(var spatialObj:SimpleSpatialComponent in results){
					var mouseComponent:IMouseControllable = spatialObj.owner.lookupComponentByType(IMouseControllable) as IMouseControllable;
					if(mouseComponent){
						mouseComponent.onClick();
					}
				}
				
			}else{
				var foundRenderers:Boolean = scene.getRenderersUnderPoint(point, results);
				
				for each(var obj:DisplayObjectRenderer in results){
					Logger.print(this, obj.name);
				}
			}
			
		}		
	}
}