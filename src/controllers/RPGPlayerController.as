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
		public var gridPositionProperty:PropertyReference;
		public var conversationsLibProperty:PropertyReference;
		public var mapReference:RPGSpatialManagerComponent;
		
		public var isTalking:Boolean = false;
		
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
			_speed = _origSpeed = val;			
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
				_inputMap.mapActionToHandler("TalkPressed", _OnTalk);
				_inputMap.mapActionToHandler("Dash", _OnDash);
            }
        }
		
		public override function onTick(tickRate:Number):void {
			var position:Point = owner.getProperty(positionProperty);			
			checkInput();
			
			if(state == MOVING){
				_xSpeed = tileWidth * _speed;
				_ySpeed = tileHeight * _speed;
				var map:Array = mapReference.collisionMap;				
				_prevX = _xGrid;
				_prevY = _yGrid;
				_xGrid = Math.ceil(position.x/tileWidth);
				_yGrid = Math.ceil(position.y/tileHeight);
				if(map[_yGrid][_xGrid] != 0){
					_xGrid = _prevX;
					_yGrid = _prevY;
				}
				switch(direction){					
					case UP: 
						if(map[_yGrid - 1][_xGrid] == 0)
							position.y = position.y - _ySpeed;													
						if(position.y % tileHeight == 0)
							state = IDLE;
							 break;
					case RIGHT:
						_xGrid = Math.floor(position.x/tileWidth); //to adjust to rounding errors
						if(map[ _yGrid][_xGrid + 1] == 0)
							position.x = position.x + _xSpeed;												
						if(position.x % tileWidth == 0)
							state = IDLE;
							 break;
					case DOWN: 
						_yGrid = Math.floor(position.y/tileHeight); //to adjust to rounding errors
						if(map[ _yGrid + 1][_xGrid] == 0)
							position.y = position.y + _ySpeed;													
						if(position.y % tileHeight == 0 )
							state = IDLE;
							 break;
					case LEFT: 
						if(map[ _yGrid][_xGrid - 1] == 0)
							position.x = position.x - _xSpeed;																				
						if(position.x % tileWidth == 0)
							state = IDLE;
							 break;
				}
				owner.setProperty(gridPositionProperty, new Point(_xGrid, _yGrid));
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
					if(direction == UP)
						state = MOVING;											
					direction = UP;
					playAnimation("back");
				}else if(_left == 1){
					if(direction == LEFT)
						state = MOVING;
					direction = LEFT;
					state = MOVING;
					playAnimation("left");	
				}else if(_down == 1){
					if(direction == DOWN)
						state = MOVING;
					direction = DOWN;					
					playAnimation("front");
				}else if(_right == 1){
					if(direction == RIGHT)
						state = MOVING;
					direction = RIGHT;					
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
		
		private function _OnTalk(value:Number):void{
			if(value == 0){
				if(!isTalking){ //if not currently talking start a talking event
					isTalking = true;
					var conv:Array = owner.getProperty(conversationsLibProperty);				
					owner.eventDispatcher.dispatchEvent(new TalkEvent(TalkEvent.START_TALK, conv["test"]));
				}else{ //if i'm already talking fire a nextTalk event
					owner.eventDispatcher.dispatchEvent(new TalkEvent(TalkEvent.NEXT_TALK));
				}			
			}
		}
		
		private function _OnDash(value:Number):void{
			if(value == 1){
				_speed = _origSpeed * 2;
			}else{
				_speed = _origSpeed;
			}
		}
		
		private function onEndedTalking(evt:TalkEvent):void{
			PBE.log(this, "Ended talking");
			isTalking = false;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			owner.eventDispatcher.addEventListener(TalkEvent.END_TALK, onEndedTalking);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			
			owner.eventDispatcher.removeEventListener(TalkEvent.END_TALK, onEndedTalking);
		}
		
		private var _animation:String;
		
		private var _inputMap:InputMap;
		
		private var _left:Number = 0;
		private var _right:Number = 0;
		private var _up:Number = 0;
		private var _down:Number = 0;
		private var _dash:Number = 0;
		private var _talking:Number = 0;
		
		private var _origSpeed:Number;
		
		private var _ySpeed:int;
		private var _xSpeed:int;	
		private var _xGrid:int;
		private var _yGrid:int;
		private var _prevX:int;
		private var _prevY:int;
		
	}

}