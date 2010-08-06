package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.screens.BaseScreen;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class GameScreen extends BaseScreen
	{
		[Embed(source="../lib/images/gradient_edges.png")]
		private var edges:Class;
		
		private var mainView:SceneView = new SceneView();
		private var uiView:SceneView = new SceneView();

		private var curtain:Sprite = new Sprite();
		
		
		
		private var vignette:Bitmap;
		
		public function GameScreen(){
			mainView.name = "MainView";
			mainView.width = 640;
			mainView.height = 480;			
			//mainView.alpha = 0;
			addChild(mainView);
			
			vignette = new edges();
			addChild(vignette);
			
			uiView.name = "UIView";
			uiView.width = 640;
			uiView.height = 480;
			addChild(uiView);
			
			
			
			curtain.graphics.beginFill(0xffffff);
			curtain.graphics.drawRect(0,0,640, 480);
			curtain.graphics.endFill();
			
			addChild(curtain);
			
			PBE.mainStage.addEventListener(TilesetEvent.LOADED, onTilesetLoaded);
						
			//PBE.mainStage.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, onTilesetLoaded);
		}
		
		override public function onShow():void{
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, onLevelLoaded);
			PBE.mainStage.addEventListener("GameOver", onGameOver);
			mainView.y = 0;
			curtain.alpha = 1;

			LevelManager.instance.loadLevel(1);
		}
		
		private function onLevelLoaded(evt:LevelEvent):void{
			PBE.log(this, "Level has been loaded");
			LevelManager.instance.removeEventListener(LevelEvent.LEVEL_LOADED_EVENT, onLevelLoaded);					
		}
		
		private function onTilesetLoaded(evt:Event):void{
			//wait till the tiles are loaded before showing the level
			//TODO: Create a more appropriate transition
			PBE.log(this, "Loaded tilesets");
			TweenLite.to(curtain, 5, {alpha:0, ease:Bounce.easeOut});
		}
		
		private function onGameOver(evt:Event):void{
			//TweenLite.to(mainView, 1, {alpha:0, onComplete:gameOver});
			PBE.mainStage.removeEventListener("GameOver", onGameOver);			
			TweenLite.to(mainView, 4, {y:150, onComplete:gameOver});			
			TweenLite.to(curtain, 4, {alpha:1});
		}
		
		private function gameOver():void{
			LevelManager.instance.unloadCurrentLevel();
			Main.gotoGameOverScreen();
		}
	}
}