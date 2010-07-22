package
{
	import com.pblabs.screens.BaseScreen;
	
	import flash.display.MovieClip;

	public class GameoverScreen extends BaseScreen
	{
		[Embed(source="../lib/ui/gameover.swf")]
		private var gameoverSwf:Class;
		
		private var gameoverMC:MovieClip;
		
		public function GameoverScreen(){
			gameoverMC = new gameoverSwf();
			addChild(gameoverMC);
		}
	}
}