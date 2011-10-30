package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.resource.XMLResource;
	
	import flash.geom.Point;
	import core.data.rpg.InMapAction;

	/**
	 * Store conversations that are based on map locations
	 */
	public class InMapConversationManager extends EntityComponent{
		public var inMapActionLibrary:Array = [];
				
		public function get filename():String{
			return _inMapActions == null ? null:_inMapActions.filename;
		}
		
		public function set filename(value:String):void{
			if(_inMapActions){
				PBE.resourceManager.unload(_inMapActions.filename, XMLResource);
				_inMapActions = null;
			}
			PBE.resourceManager.load(value, XMLResource, onXMLLoaded, onXMLFailed);
		}
		
		public function getActionInGrid(val:Point):String{
			for each(var action:InMapAction in inMapActionLibrary){
				if(action.location.equals(val)){
					return action.id;
				}
			}
			return null;
		}
		
		protected function onXMLLoaded(resource:XMLResource):void{
			_inMapActions = resource;
			var i:int;
			var xml:XML = _inMapActions.XMLData;
			
			inMapActionLibrary = [];
			
			for(i = 0; i < xml.action.length(); i++){
				var inMapAction:InMapAction = new InMapAction();
				inMapAction.location = new Point();
				inMapAction.location.x = xml.action[i].x;
				inMapAction.location.y = xml.action[i].y;
				inMapAction.id = xml.action[i].id;
				inMapActionLibrary[i] = inMapAction;
			}
		}
		
		protected function onXMLFailed(resource:XMLResource):void{
			Logger.error(this, "onXMLFailed", "Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var _inMapActions:XMLResource;
	}
}