package 
{
	import com.pblabs.components.stateMachine.BasicState;
	import com.pblabs.components.stateMachine.FSMComponent;
	import com.pblabs.components.stateMachine.PropertyTransition;
	import com.pblabs.rendering2D.AnimationController;
	import com.pblabs.rendering2D.AnimationControllerInfo;
	import com.pblabs.rendering2D.BasicSpatialManager2D;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.ui.SceneView;
	import components.StatComponent;
	import components.TiledMapConverter;
	import controllers.GuyController;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.pblabs.engine.PBE;
	
	/**
	 * ...
	 * @author Julius
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			PBE.registerType(BasicSpatialManager2D);
			PBE.registerType(AnimationController);
			PBE.registerType(AnimationControllerInfo);
			PBE.registerType(CellCountDivider);
			PBE.registerType(SpriteSheetComponent);
			PBE.registerType(DisplayObjectScene);
			PBE.registerType(SimpleSpatialComponent);
			PBE.registerType(SpriteSheetRenderer);
			PBE.registerType(SceneView);
			PBE.registerType(BasicSpatialManager2D);
			PBE.registerType(FSMComponent);
			PBE.registerType(PropertyTransition);
			PBE.registerType(BasicState);

			PBE.registerType(StatComponent);
			PBE.registerType(GuyController);
			PBE.registerType(TiledMapConverter);
			
			PBE.startup(this);
			PBE.addResources(new Resources());
			
			PBE.levelManager.addFileReference(1, "../lib/levels/spritesheets.pbelevel");
			PBE.levelManager.addFileReference(1, "../lib/levels/level1.pbelevel");
			PBE.levelManager.addGroupReference(1, "SpriteSheets");
			PBE.levelManager.addGroupReference(1, "LevelOne");
			
			PBE.levelManager.start(1);
			
		}
		
	}
	
}