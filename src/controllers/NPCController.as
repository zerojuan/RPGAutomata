package controllers
{
	import com.pblabs.components.stateMachine.TransitionEvent;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;

	public class NPCController extends TickedComponent{
				
		public var positionProperty:PropertyReference;				
		
		public function get animation():String{
			return _animation;
		}
		
		public function set animation(str:String):void{
			_animation = str;
		}
		
		private function onStateTransition(evt:TransitionEvent):void{
			
		}
		
		override public function onTick(tickRate:Number):void{
			
		}
		
		override protected function onAdd():void{
			super.onAdd();	
			
			owner.eventDispatcher.addEventListener(TransitionEvent.TRANSITION, onStateTransition);
		}
		
		override protected function onRemove():void{
			super.onRemove();
			
			owner.eventDispatcher.removeEventListener(TransitionEvent.Transition, onStateTransition);
		}
		
		private var _animation:String;
		
	}
}