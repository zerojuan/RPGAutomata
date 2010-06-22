package controllers 
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.components.stateMachine.TransitionEvent;
	import flash.events.Event;
	
	import com.pblabs.engine.PBE;
	import components.StatComponent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Julius
	 */
	public class GuyController extends TickedComponent
	{
		public var velocityProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var animPauseProperty:PropertyReference;				
		
		public var currentStateProperty:PropertyReference;
		
		public var stats:StatComponent;			
		
		private var _animation:String;	
		
		private var _path:Array;
		
		private var _dest:Point;
		
		public function get animation():String {
			return _animation;
		}
		
		public function set animation(str:String):void {
			_animation = str;
		}
		
		override protected function onAdd():void {
			super.onAdd();		
			
			_dest = new Point();
			
			owner.eventDispatcher.addEventListener(TransitionEvent.TRANSITION, onStateTransition);
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		private function onStateTransition(evt:TransitionEvent):void {
			PBE.log(this, "State Transition: " + evt.newStateName);
			var newState:String = evt.newStateName;
			if (newState == "walk") {
				PBE.log(this, "WALKED");
				PBE.log(this, "Animation: " + animation);
				owner.eventDispatcher.dispatchEvent(new Event("GuyChangeAnimation"));
			}
			
		}
		
		override public function onTick(tickRate:Number):void {
			var velocity:Point = owner.getProperty(velocityProperty);
			var currentState:String = owner.getProperty(currentStateProperty);			
			
			if (currentState == "steady") {
				stats.happiness -= 10 * tickRate;
				stats.stamina += 10 * tickRate;
				//this is where our guy decides where to go and he'll keep doing that till he gets bored
				
				//for now just go random
				computeDestination();
				velocity.x = 0;
				velocity.y = 0;
				owner.setProperty(animPauseProperty, true);
			}
			
			if (currentState == "walk") {
				stats.happiness += 10 * tickRate;
				stats.stamina -= 10 * tickRate;
				velocity.y = _dest.y;				
				velocity.x = _dest.x;
				owner.setProperty(animPauseProperty, false);				
			}
			
			
			owner.setProperty(velocityProperty,velocity);
		}
		
		private function computeDestination():void {
			_dest.x = Math.random() * 50 - 25;
			_dest.y = Math.random() * 50 - 25;
			if (_dest.x > _dest.y) { //greater horizontal force
				if (_dest.x > 0)
					_animation = "right";
				else	
					_animation = "left";
			}else {
				if (_dest.y > 0) {
					_animation = "front";
				}else {
					_animation = "back";
				}
			}
			
		}
		
	}

}