package controllers 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.components.stateMachine.TransitionEvent;
	import com.pblabs.engine.PBE;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Julius
	 */
	public class GuyController extends TickedComponent
	{
		public var velocityProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		
		public var currentStateProperty:PropertyReference;
		
		
		public var boredom:Number;
		public var stamina:Number;
		
		private var _animation:String;							
		
		public function get animation():String {
			return _animation;
		}
		
		public function set animation(str:String):void {
			_animation = str;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			boredom = 0;
			stamina = 100;
			
			owner.eventDispatcher.addEventListener(TransitionEvent.TRANSITION, onStateTransition);
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		private function onStateTransition(evt:TransitionEvent):void {
			PBE.log(this, "State Transition: " + evt.newStateName);
			var newState:String = evt.newStateName;
			
		}
		
		override public function onTick(tickRate:Number):void {
			var velocity:Point = owner.getProperty(velocityProperty);
			var currentState:String = owner.getProperty(currentStateProperty);
			
			if (currentState == "steady") {
				stamina++;
				boredom++;
				velocity.x = 0;
				velocity.y = 0;
			}
			
			if (currentState == "walk") {
				velocity.y = 20;
				stamina--;
				boredom--;
			}
			
			
			owner.setProperty(velocityProperty,velocity);
		}
		
	}

}