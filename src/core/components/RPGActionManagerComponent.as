package core.components
{
	import com.pblabs.engine.entity.EntityComponent;
	
	import core.GameDatabase;
	import core.components.events.RPGActionEvent;
	import core.components.events.TalkEvent;
	import core.data.rpg.Conversation;
	
	import flash.geom.Point;
	import core.components.input.RPGInputController;

	public class RPGActionManagerComponent extends EntityComponent
	{		
		
		protected var _currentConversation:Conversation;
		
		protected var _inputSource:RPGInputController;
		/**
		 * Reference to the world, so we can try to guess what the player is trying to do
		 */
		public var mapReference:RPGSpatialManagerComponent;
		
		public var conversationManager:ConversationManager;
		
		public var talkDisplayController:TalkDisplayController;
		
		public var locationDialogManager:InMapConversationManager;
		
		public var gameDatabase:GameDatabase;
		
		private function onAction(evt:RPGActionEvent):void{
			var frontCoord:Point = evt.frontCoordinates;
			var rpgObject:RPGSpatialComponent = mapReference.getObjectInGrid(frontCoord);
			
			if(rpgObject){ //if talking to an object
				startConversationOnID(rpgObject.owner.name);
			}else{ 
				//if talking to a non character object
				if(locationDialogManager){
					var locationID:String = locationDialogManager.getActionInGrid(frontCoord);				
					if(locationID){
						startConversationOnID(locationID);					
					}else{
						//do nothing
					}
					//removeEventListeners();
				}				
			}
		}
		
		protected function startConversationOnID(id:String):void{			
			//disable me for now
			_inputSource.disabledAction = true;
			_inputSource.isLocked = true;
			removeEventListeners();					
		}
		/**
		 * Reference to where we need to listen to ACTION_EVENTS
		 */
		public function set inputSource(input:RPGInputController):void{
			if(_inputSource){
				removeEventListeners();
			}
			_inputSource = input;
			addEventListeners();
		}
		
		/**
		 * Subclass this in your games to handle what happens to events
		 */
		protected function onEndAction(evt:RPGActionEvent):void{
			talkDisplayController.owner.eventDispatcher.removeEventListener(RPGActionEvent.END_ACTION, onEndAction);
			//
			gameDatabase.gameFlags[evt.actionResult] = true;
			//_currentConversation.states[evt.actionResult].condition = false;
			_currentConversation.defaultStateDone();
			_inputSource.disabledAction = false;
			_inputSource.isLocked = false;
			addEventListeners();									
		}
		
		private function addEventListeners():void{
			if(_inputSource){
				_inputSource.owner.eventDispatcher.addEventListener(RPGActionEvent.ACTION, onAction);
			}
		}
		
		private function removeEventListeners():void{
			if(_inputSource){
				_inputSource.owner.eventDispatcher.removeEventListener(RPGActionEvent.ACTION, onAction);
			}
		}
		
		override protected function onAdd():void{
			addEventListeners();
			owner.eventDispatcher.addEventListener(RPGActionEvent.END_ACTION, onEndAction);
		}
		
		override protected function onRemove():void{
			
		}
	}
}