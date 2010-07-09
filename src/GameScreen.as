package
{
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.screens.BaseScreen;

	public class GameScreen extends BaseScreen
	{
		private var mainView:SceneView = new SceneView();
		private var uiView:SceneView = new SceneView();
		
		public function GameScreen(){
			mainView.name = "MainView";
			mainView.width = 640;
			mainView.height = 480;			
			addChild(mainView);
			
			uiView.name = "UIView";
			uiView.width = 640;
			uiView.height = 480;
			addChild(uiView);
			
		}
		
		override public function onShow():void{
			LevelManager.instance.start(1);
		}
	}
}