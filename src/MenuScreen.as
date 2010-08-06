package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.sound.SoundManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.core.ByteArrayAsset;

	public class MenuScreen extends BaseScreen
	{
		[Embed(source="../lib/ui/menu.swf", mimeType="application/octet-stream")]
		private var menuSwf:Class;
		
		private var loader:Loader = new Loader;
		private var bytes:ByteArrayAsset;
		private var menuMC:MovieClip;
		
		public function MenuScreen(){
			bytes = new menuSwf();
			
			loader.contentLoaderInfo.addEventListener(Event.INIT, loadComplete);
			loader.loadBytes(bytes);
								
		}
		
		private function loadComplete(evt:Event):void{
			menuMC = MovieClip(loader.content);
			addChild(menuMC);
			menuMC.stop();
			menuMC.alpha = 0;
			TweenLite.to(menuMC, 2, {alpha: 1});
		}
		
		override public function onShow():void{
			PBE.mainStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
			PBE.soundManager.play("../lib/sounds/musicbox.mp3", SoundManager.MUSIC_MIXER_CATEGORY, 0, int.MAX_VALUE);
			PBE.soundManager.volume = 0;
			if(menuMC){
				menuMC.alpha = 0;
				menuMC.gotoAndStop(1);
				TweenLite.to(menuMC, 2, {alpha: 1});
			}
			
			TweenLite.to(PBE.soundManager, 2, {volume: 1, ease:Cubic.easeIn});
		}
		
		override public function onHide():void{			
		}				
				
		
		private function onKeyUp(evt:KeyboardEvent):void{
			PBE.log(this, "On Key up:" + evt.keyCode);
			if(evt.keyCode == 90 || evt.keyCode == 88){
				menuMC.gotoAndStop(2);				
				TweenLite.to(menuMC, .5, {alpha:0, onComplete:gotoNextScreen});
				PBE.mainStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			
		}
		
		private function gotoNextScreen():void{
			Main.gotoGameScreen();	
		}
	}
}