package components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import rpg.Conversation;
	import rpg.Dialog;

	public class ConversationManager extends EntityComponent{
		
		public var conversationLibrary:Array;
		
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
		
		protected function onXMLLoaded(resource:XMLResource):void{
			_conversations = resource;
			var i:int;
			var xml:XML = _conversations.XMLData;
			
			conversationLibrary = new Array();
			
			//Populate conversationLibrary with conversation objects
			for(i = 0; i < xml.conversation.length(); i++){
				
				var conv:Conversation = new Conversation();
				conv.locked = xml.conversation[i].@locked;
				//Populate conversation objects with dialogs
				for(var x:int = 0; x < xml.conversation[i].talk.length(); x++){
					conv.push(new Dialog(xml.conversation[i].talk[x].@actor, xml.conversation[i].talk[x].@actorId, xml.conversation[i].talk[x])); 
				}
				conversationLibrary[xml.conversation[i].@id] = conv;				
			}
						
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", " Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _conversations:XMLResource;
	}
}