package controllers
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import components.RPGSpatialComponent;
	
	import flash.geom.Point;

	public class GateController extends TickedComponent
	{
		public var upperGateFrame:PropertyReference;
		public var lowerGateFrame:PropertyReference;
						
		public var spatialReference:RPGSpatialComponent;
		
		public const CLOSED:int = 0;
		public const TRANSITION:int = 1;
		public const OPEN:int = 2;
		
		public function set state(val:int):void{
			_prevState = _state;
			_state = val;
		}
		
		public function get state():int{
			return _state;
		}
		
		override public function onTick(tickRate:Number):void{
			_elapsedTime += tickRate;
			if(_state == TRANSITION){
				if(_prevState == CLOSED){
					if(_elapsedTime > .08){
						_currFrame++;					
						_elapsedTime = 0;
					}
					if(_currFrame >= _endFrame){
						_elapsedTime = 0;
						spatialReference.disableFromGrid(true);
						_state = OPEN;
					}
				}else{
					if(_elapsedTime > .08){
						_currFrame--;					
						_elapsedTime = 0;
					}
					if(_currFrame <= 0){
						_elapsedTime = 0;
						_state = CLOSED;
					}
				}																			
				owner.setProperty(upperGateFrame, _currFrame);
				owner.setProperty(lowerGateFrame, _currFrame);
			}else if(_state == OPEN){				
				if(_elapsedTime > 2){
					spatialReference.disableFromGrid(false);
					_elapsedTime = 0;
					state = TRANSITION;					
				}
			}else if(_state == CLOSED){
				if(_elapsedTime > 2){
					_elapsedTime = 0;
					state = TRANSITION;
				}
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();						
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
		private var _state:int = TRANSITION;
		private var _prevState:int = CLOSED;
		
		
		private var _currFrame:int = 0;
		
		private var _endFrame:int = 3;
		
		private var _elapsedTime:Number = 0;
	}
}