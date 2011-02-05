package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import core.rpg.Conversation;
	
	/**
	 * Handles the conversion of the conversation.xml file.
	 * And creates a conversation library.
	 */
	public class ConversationManager extends EntityComponent{
		
		public var conversationLibrary:Array = [];
		
		public function get filename():String{
			return _conversations == null ? null: _conversations.filename;
		}
		
		public function set filename(value:String):void{
			if(_conversations){
				PBE.resourceManager.unload(_conversations.filename, XMLResource);
				_conversations = null;	
			}			
			PBE.resourceManager.load(value, XMLResource, onXMLLoaded, onXMLFailed);
		}
		
		public function get conversations():XMLResource{
			return _conversations;
		}
		
		public function set conversation(value:XMLResource):void{
			_conversations = value;
		}
		
		public function getConversationByCharacterId(id:String):Conversation{
			for each(var conv:Conversation in conversationLibrary){
				if(conv.charId == id){
					return conv;
				}
			}
			
			return null;
		}
		
		protected function onXMLLoaded(resource:XMLResource):void{
			_conversations = resource;
			var i:int;
			var xml:XML = _conversations.XMLData;
			
			conversationLibrary = new Array();
			
			//Populate conversationLibrary with conversation objects
			for(i = 0; i < xml.conversation.length(); i++){
				
				var conv:Conversation = new Conversation();
				conv.charId = xml.conversation[i].charId;
				conv.defaultId = xml.conversation[i].defaultState.@id;
				//Populate conversation objects with dialogs
				for(var x:int = 0; x < xml.conversation[i].state.length(); x++){
					var state:Object = new Object();
					state.condition = (xml.conversation[i].state[x].@id == conv.defaultId)
					state.dialogRootId = xml.conversation[i].state[x].@dialogRootId;
					//PBE.log(this, "Conversation text: " + xml.conversation[i].state[x].@dialogRootId);
					conv.states[xml.conversation[i].state[x].@id] = state;
				}
				conversationLibrary.push(conv);				
			}
			
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", " Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _conversations:XMLResource;
	}
}