package components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;

	public class RPGGameState extends EntityComponent{
		//TODO: You can use this for the Save functionality
		public var gameStates:Array = new Array(); 		
		
		public var playerName:String;
		
		public var activeState:String; //The gameState that may or may not change
		
		public var talkNum:int = 0;
		
		override protected function onAdd():void{
			super.onAdd();
			
			if(playerName){
				_player = PBE.lookup(playerName) as IEntity;
				_player.eventDispatcher.addEventListener(TalkEvent.END_TALK, onTalkDone);
			}
		}
		
		private function onTalkDone(evt:TalkEvent):void{
			if(activeState){
				gameStates[activeState] = true;
			}			
			activeState = null;
		}
		
		override protected function onRemove():void{
			super.onRemove();
			
			if(_player){
				_player.eventDispatcher.removeEventListener(TalkEvent.END_TALK, onTalkDone);
			}
		}
		
		private var _player:IEntity;
	}
}