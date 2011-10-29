package core.components.input.mouse
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MouseEnabler extends EntityComponent
	{
		public var displayObjectProperty:PropertyReference;
		
		public const MOUSE_OVER:String = "OnMouseOver";
		public const MOUSE_OUT:String = "OnMouseOut";
		public const MOUSE_DOWN:String = "OnMouseDown";
		public const MOUSE_UP:String = "OnMouseUp";
		
		private var _addedListeners:Boolean = false;
		
		private function onMouseOver(evt:MouseEvent):void{
			PBE.log(this, "Mouse Over");
			owner.eventDispatcher.dispatchEvent(new Event(MOUSE_OVER));
		}
		
		private function onMouseOut(evt:MouseEvent):void{
			owner.eventDispatcher.dispatchEvent(new Event(MOUSE_OUT));
		}
		
		private function onMouseUp(evt:MouseEvent):void{
			owner.eventDispatcher.dispatchEvent(new Event(MOUSE_UP));
		}
		
		private function onMouseDown(evt:MouseEvent):void{
			owner.eventDispatcher.dispatchEvent(new Event(MOUSE_DOWN));
		}
		
		private function onMouseMove(evt:MouseEvent):void{
			PBE.log(this, "MouseMoved");
		}
		
		private function addEventListeners():void{
			var displayObject:DisplayObject = owner.getProperty(displayObjectProperty) as DisplayObject;
			if(displayObject){
				displayObject.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				displayObject.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				displayObject.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_addedListeners = true;
			}else{
				PBE.callLater(addEventListeners);
			}
		}
		
		override protected function onAdd():void{
			addEventListeners();
		}
		
		override protected function onRemove():void{
			if(_addedListeners){
				var displayObject:DisplayObject = owner.getProperty(displayObjectProperty) as DisplayObject;
				if(displayObject){
					displayObject.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					displayObject.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					displayObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}
	}
}