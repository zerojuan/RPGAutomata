package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import core.rpg.Dialog;

	public class DialogManager extends EntityComponent
	{
		public var dialogLibrary:Array = [];
		
		public function get filename():String{
			return _dialogs == null ? null:_dialogs.filename;
		}
		
		public function set filename(value:String):void{
			if(_dialogs){
				PBE.resourceManager.unload(_dialogs.filename, XMLResource);
				_dialogs = null;
			}
			PBE.resourceManager.load(value, XMLResource, onXMLLoaded, onXMLFailed);
		}
		
		public function get dialogs():XMLResource{
			return _dialogs;
		}
		
		public function set dialogs(value:XMLResource):void{
			_dialogs = value;
		}
		
		protected function onXMLLoaded(resource:XMLResource):void{
			_dialogs = resource;
			var i:int;
			var xml:XML = _dialogs.XMLData;
			
			dialogLibrary = [];
			
			for(i = 0; i < xml.dialog.length(); i++){
				var dialog:Dialog = new Dialog();
				dialog.text = xml.dialog[i].text;
				dialog.actor = xml.dialog[i].actor;
				dialog.exit = xml.dialog[i].exit;
				if(dialog.exit == ""){
					dialog.exitA = new Object();
					dialog.exitB = new Object();
					dialog.exitA.id = xml.dialog[i].exitA.@id.toString();
					dialog.exitB.text = xml.dialog[i].exitB.@text;					
					if(dialog.exitB.text.toString() != ""){
						dialog.exitA.text = xml.dialog[i].exitA.@text.toString();
						dialog.exitB.text = xml.dialog[i].exitB.@text.toString();
						dialog.exitB.id = xml.dialog[i].exitB.@id.toString();						
					}else{
						dialog.exitB = null;
					}
					dialog.exit = null;
				}
				PBE.log(this, "Adding " + xml.dialog[i].@id + ".");
				dialogLibrary[xml.dialog[i].@id] = dialog;
			}
			//PBE.log(this, "Added " + dialogLibrary.length + " into the DialogLibrary");
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", "Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _dialogs:XMLResource;
	}
}