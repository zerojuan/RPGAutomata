package components
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	import rpg.Conversation;
	import rpg.TalkingPoint;

	public class TalkManager extends EntityComponent{
		
		[TypeHint(type="rpg.TalkingPoint")]
		public var talkingPoints:Array = new Array();
		
		public var gameStateDB:RPGGameState;
		
		public var conversationLibrary:PropertyReference;
		
		public function getTalk(objectCoord:Point):Conversation{
			var convLib:Array = owner.getProperty(conversationLibrary);
			
			var talkPoint:String = getTalkPoint(objectCoord);
			//based on the returned talkpoints, evaluate which is most best
			if(talkPoint){
				if(talkPoint == "laptop"){
					if(!gameStateDB.gameStates["laptop"]){
						gameStateDB.activeState = "laptop";
						return convLib["laptop"];
					}else{
						return convLib["laptopDone"];
					}
				}
			}else{ //talk to self
				if(!gameStateDB.gameStates["talkedToSelf"]){
					gameStateDB.activeState = "talkedToSelf";
					return convLib["talkToSelf"];
				}else{
					return convLib["talkToSelfDone"];
				}
			}
			
			return null;
		}
		
		private function getTalkPoint(objectCoord:Point):String{
			var retArr:Array = new Array();
			var talkPoint:TalkingPoint;
			
			for each(talkPoint in talkingPoints){
				if(talkPoint.gridPosition.equals(objectCoord))
					return talkPoint.talkId;
			}
						
			return null;
		}
		
		override protected function onAdd():void{
			super.onAdd();
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
	}
}