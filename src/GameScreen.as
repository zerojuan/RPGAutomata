package
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.screens.BaseScreen;
	
	import flash.events.Event;

	public class GameScreen extends BaseScreen
	{
		private var mainView:SceneView = new SceneView();
		private var uiView:SceneView = new SceneView();
		
		public function GameScreen(){
			mainView.name = "MainView";
			mainView.width = 640;
			mainView.height = 480;			
			mainView.alpha = 0;
			addChild(mainView);
			
			uiView.name = "UIView";
			uiView.width = 640;
			uiView.height = 480;
			addChild(uiView);
			
			PBE.mainStage.addEventListener(TilesetEvent.LOADED, onTilesetLoaded);
		}
		
		override public function onShow():void{
			LevelManager.instance.start(1);
		}
		
		private function onTilesetLoaded(evt:Event):void{
			//wait till the tiles are loaded before showing the level
			//TODO: Create a more appropriate transition
			mainView.alpha = 1;
		}
	}
}