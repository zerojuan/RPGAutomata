package controllers
{
	import com.pblabs.components.stateMachine.TransitionEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import components.RPGSpatialManagerComponent;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class NPCController extends TickedComponent{
				
		public var positionProperty:PropertyReference;		
		public var gridPositionProperty:PropertyReference;
				
		public var mapReference:RPGSpatialManagerComponent;
		
		public static const IDLE:int = 0;
		public static const MOVING:int = 1;
		public static const PAUSED:int = 2;
		
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		public static const LEFT:int = 4;
		
		public var state:int = IDLE;
		public var direction:int = UP;
		
		public function get speed():Number{
			return _speed;
		}
		
		public function set speed(val:Number):void{
			_speed = val;			
		}
		
		public function get animation():String{
			return _animation;
		}
		
		public function set animation(str:String):void{
			_animation = str;
		}
		
		private function playAnimation(str:String):void {
			if (str != _animation) {
				_animation = str;
				owner.eventDispatcher.dispatchEvent(new Event("GuyChangeAnimation"));
			}		
		}
		
		private function onStateTransition(evt:TransitionEvent):void{
			PBE.log(this, "State transition: " + evt.newStateName); 
			_currentState = evt.newStateName;
			if(_currentState == "steady"){
				var gridPosition:Point = owner.getProperty(gridPositionProperty) as Point;
				owner.setProperty(gridPositionProperty, gridPosition);				
			}else if(_currentState == "walk"){
				
			}
		}
		
		override public function onTick(tickRate:Number):void{
			if(_currentState == "steady"){				
				var gridPosition:Point = owner.getProperty(gridPositionProperty) as Point;
				owner.setProperty(gridPositionProperty, gridPosition);
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();							
			
			owner.eventDispatcher.addEventListener(TransitionEvent.TRANSITION, onStateTransition);
		}
		
		override protected function onRemove():void{
			super.onRemove();
			
			owner.eventDispatcher.removeEventListener(TransitionEvent.TRANSITION, onStateTransition);
		}
		
		private var _currentState:String = "steady";
		private var _animation:String = "up";
		private var _speed:Number;
		
	}
}