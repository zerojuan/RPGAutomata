package 
{
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.components.stateMachine.BasicState;
	import com.pblabs.components.stateMachine.FSMComponent;
	import com.pblabs.components.stateMachine.PropertyTransition;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.AnimationController;
	import com.pblabs.rendering2D.AnimationControllerInfo;
	import com.pblabs.rendering2D.BasicSpatialManager2D;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.screens.ScreenManager;
	
	import components.CollisionMap;
	import components.ConversationManager;
	import components.FamitsuAnimator;
	import components.RPGGameState;
	import components.RPGSpatialComponent;
	import components.RPGSpatialDebugComponent;
	import components.RPGSpatialManagerComponent;
	import components.StatComponent;
	import components.TalkManager;
	import components.TiledMapConverter;
	
	import controllers.GuyController;
	import controllers.NPCController;
	import controllers.RPGPlayerController;
	import controllers.TalkController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import rpg.TalkingPoint;
	
	/**
	 * Main class
	 * @author Julius
	 */
	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]
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
						
			PBE.registerType(com.pblabs.engine.entity.IEntity);
			PBE.registerType(AnimationController);
			PBE.registerType(AnimationControllerInfo);
			PBE.registerType(CellCountDivider);
			PBE.registerType(SpriteSheetComponent);
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.animation.Animator);
			PBE.registerType(com.pblabs.animation.AnimatorType);
			PBE.registerType(DisplayObjectScene);
			PBE.registerType(SimpleSpatialComponent);
			PBE.registerType(SpriteSheetRenderer);
			PBE.registerType(com.pblabs.rendering2D.SimpleShapeRenderer);
			PBE.registerType(SceneView);
			PBE.registerType(BasicSpatialManager2D);
			PBE.registerType(FSMComponent);
			PBE.registerType(PropertyTransition);
			PBE.registerType(BasicState);
			PBE.registerType(InputKey);

			PBE.registerType(StatComponent);
			PBE.registerType(GuyController);
			PBE.registerType(RPGPlayerController);
			PBE.registerType(TiledMapConverter);
			PBE.registerType(controllers.TalkController);
			PBE.registerType(components.CollisionMap);
			PBE.registerType(components.RPGSpatialComponent);
			PBE.registerType(components.RPGSpatialManagerComponent);
			PBE.registerType(components.ConversationManager);
			PBE.registerType(components.FamitsuAnimator);
			PBE.registerType(components.RPGGameState);
			PBE.registerType(components.TalkManager);
			PBE.registerType(components.RPGSpatialDebugComponent);
			PBE.registerType(controllers.NPCController);
			PBE.registerType(rpg.TalkingPoint);
			
			
			PBE.startup(this);
			PBE.addResources(new GameResources());
			
			PBE.levelManager.addFileReference(0, "../lib/levels/spritesheets.pbelevel");
			PBE.levelManager.addFileReference(0,"../lib/levels/templates.pbelevel");
			PBE.levelManager.addGroupReference(0, "SpriteSheets");
				
			PBE.levelManager.addFileReference(1, "../lib/levels/spritesheets.pbelevel");
			PBE.levelManager.addFileReference(1,"../lib/levels/templates.pbelevel");
			PBE.levelManager.addFileReference(1, "../lib/levels/level1.pbelevel");
			PBE.levelManager.addGroupReference(1, "SpriteSheets");
			PBE.levelManager.addGroupReference(1, "LevelOne");
						
									
			ScreenManager.instance.registerScreen("game", new GameScreen());			
			ScreenManager.instance.goto("game");
			
		}
		
	}
	
}