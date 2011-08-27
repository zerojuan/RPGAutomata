package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import flash.geom.Point;

	public class LocationDialogManager extends EntityComponent{
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
		
		public function getActionInGrid(val:Point):String{
			for each(var action:LocationBasedAction in dialogLibrary){
				if(action.location.equals(val)){
					return action.id;
				}
			}
			return null;
		}
		
		protected function onXMLLoaded(resource:XMLResource):void{
			_dialogs = resource;
			var i:int;
			var xml:XML = _dialogs.XMLData;
			
			dialogLibrary = [];
			
			for(i = 0; i < xml.action.length(); i++){
				var locDialog:LocationBasedAction = new LocationBasedAction();
				locDialog.location = new Point();
				locDialog.location.x = xml.action[i].x;
				locDialog.location.y = xml.action[i].y;
				locDialog.id = xml.action[i].id;
				dialogLibrary[i] = locDialog;
			}
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", "Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _dialogs:XMLResource;
	}
}