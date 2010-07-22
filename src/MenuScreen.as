package
{
	import com.greensock.TweenLite;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.screens.BaseScreen;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;

	public class MenuScreen extends BaseScreen
	{
		[Embed(source="../lib/ui/menu.swf")]
		private var menuSwf:Class;
		
		private var menuMC:MovieClip;
		
		public function MenuScreen(){
			
			menuMC = new menuSwf();
			addChild(menuMC);				
		}
		
		override public function onShow():void{
			PBE.mainStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		override public function onHide():void{
			PBE.mainStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}				
		
		private function onKeyUp(evt:KeyboardEvent):void{
			PBE.log(this, "On Key up:" + evt.keyCode);
			if(evt.keyCode == 90 || evt.keyCode == 88){						
				TweenLite.to(this, .5, {alpha:0, onComplete:gotoNextScreen});
								
			}
			
		}
		
		private function gotoNextScreen():void{
			Main.gotoGameScreen();	
		}
	}
}