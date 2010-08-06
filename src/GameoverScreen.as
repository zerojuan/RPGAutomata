package
{
	import com.greensock.TweenLite;
	import com.pblabs.engine.PBE;
	import com.pblabs.screens.BaseScreen;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class GameoverScreen extends BaseScreen
	{
		[Embed(source="../lib/ui/gameover.swf")]
		private var gameoverSwf:Class;
		
		private var gameoverMC:MovieClip;
		
		public function GameoverScreen(){
			gameoverMC = new gameoverSwf();
			addChild(gameoverMC);
		}
		
		override public function onShow():void{
			//y = 20;
			PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			alpha = 0;						
			TweenLite.to(this, 2, {alpha:1});
		}
		
		override public function onHide():void{
			PBE.mainStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
		}
		
		private function onMouseUp(evt:MouseEvent):void{
			PBE.soundManager.stopAll();
			Main.gotoMenuScreen();
		}
	}
}