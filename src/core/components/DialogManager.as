package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import core.rpg.Dialog;

	public class DialogManager extends EntityComponent
	{
		public var dialogLibrary:Array;
		
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
			
			for(i = 0; i < xml.dialog.length(); i++){
				var dialog:Dialog = new Dialog();
				dialog.text = xml.dialog[i].text;
				dialog.actor = xml.dialog[i].actor;
				dialog.exit = xml.dialog[i].exit;
				if(dialog.exit == ""){
					dialog.exitA = new Object();
					dialog.exitB = new Object();
					dialog.exitA.id = xml.dialog[i].exitA.@id;
					dialog.exitB.text = xml.dialog[i].exitB;
					if(dialog.exitB.text != ""){
						dialog.exitA.text = xml.dialog[i].exitA;
						dialog.exitB.text = xml.dialog[i].exitB;
						dialog.exitB.id = xml.dialog[i].exitB.@id;						
					}else{
						dialog.exitB = null;
					}
					dialog.exit = null;
				}
				trace(PBE.log(this, dialog.toString()));
			}
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", "Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _dialogs:XMLResource;
	}
}