package controllers 
{
	
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.entity.PropertyReference;
	
	import components.RPGSpatialManagerComponent;
	
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Controller for our RPG character
	 * @author Julius
	 */
	public class RPGPlayerController extends TickedComponent{
		
		public var velocityProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var mapReference:RPGSpatialManagerComponent;
		public var tileWidth:int;
		public var tileHeight:int;
				
		public static const IDLE:int = 0;
		public static const MOVING:int = 1;
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		public static const LEFT:int = 4;	
				
		public var state:int = IDLE;
		public var direction:int = UP;
		
		private var _speed:Number; // a fraction of the tileWidth or tileHeight from 0-1
		
		public function get speed():Number{
			return _speed;
		}
		
		public function set speed(val:Number):void{
			_speed = val;			
		}
		
		public function get input():InputMap
        {
            return _inputMap;
        }
        
        public function set input(value:InputMap):void
        {
            _inputMap = value;
            
            if (_inputMap != null)
            {
                _inputMap.mapActionToHandler("GoLeft", _OnLeft);
                _inputMap.mapActionToHandler("GoRight", _OnRight);
                _inputMap.mapActionToHandler("GoUp", _OnUp);
				_inputMap.mapActionToHandler("GoDown", _OnDown);
            }
        }
		
		public override function onTick(tickRate:Number):void {
			var position:Point = owner.getProperty(positionProperty);
			
			checkInput();
			
			if(state == MOVING){
				_xSpeed = tileWidth * _speed;
				_ySpeed = tileHeight * _speed;
				var map:Array = mapReference.collisionMap;
				var xGrid:int = Math.ceil(position.x/tileWidth);
				var yGrid:int = Math.ceil(position.y/tileHeight);				
				switch(direction){					
					case UP: 
						if(map[yGrid - 1][xGrid] == 0)
							position.y = position.y - _ySpeed;													
						if(position.y % tileHeight == 0)
							state = IDLE;
							 break;
					case RIGHT:
						xGrid = Math.floor(position.x/tileWidth); //to adjust to rounding errors
						if(map[ yGrid][xGrid + 1] == 0)
							position.x = position.x + _xSpeed;												
						if(position.x % tileWidth == 0)
							state = IDLE;
							 break;
					case DOWN: 
						yGrid = Math.floor(position.y/tileHeight); //to adjust to rounding errors
						if(map[ yGrid + 1][xGrid] == 0)
							position.y = position.y + _ySpeed;													
						if(position.y % tileHeight == 0 )
							state = IDLE;
							 break;
					case LEFT: 
						if(map[ yGrid][xGrid - 1] == 0)
							position.x = position.x - _xSpeed;																				
						if(position.x % tileWidth == 0)
							state = IDLE;
							 break;
				}
			}
					
			owner.setProperty(positionProperty, position);
		}
				
		public function get animation():String {
			return _animation;
		}
		
		public function set animation(str:String):void {
			_animation = str;
		}
		
		private function checkInput():void{
			if(state == IDLE){
				if(_up == 1){
					direction = UP;
					state = MOVING;
					playAnimation("back");
				}else if(_left == 1){
					direction = LEFT;
					state = MOVING;
					playAnimation("left");	
				}else if(_down == 1){
					direction = DOWN;
					state = MOVING;
					playAnimation("front");
				}else if(_right == 1){
					direction = RIGHT;
					state = MOVING;
					playAnimation("right");
				}
			}
		}
		
		private function playAnimation(str:String):void {
			if (str != _animation) {
				_animation = str;
				owner.eventDispatcher.dispatchEvent(new Event("GuyChangeAnimation"));
			}
		}
		
		private function _OnLeft(value:Number):void {
			_left = value;
		}
		
		private function _OnRight(value:Number):void {
			_right = value;			
		}
		
		private function _OnUp(value:Number):void {
			_up = value;			
		}
		
		private function _OnDown(value:Number):void {
			_down = value;			
		}
		
		override protected function onAdd():void {
			super.onAdd();
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		private var _animation:String;
		
		private var _inputMap:InputMap;
		
		private var _left:Number = 0;
		private var _right:Number = 0;
		private var _up:Number = 0;
		private var _down:Number = 0;
		
		private var _ySpeed:int;
		private var _xSpeed:int;
		
	}

}