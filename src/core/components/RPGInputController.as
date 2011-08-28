package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.PropertyReference;
	
	import core.components.events.RPGActionEvent;
	import core.components.events.TalkEvent;
	import core.components.keyboard.BasicInputController;
	import core.rpg.Conversation;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class RPGInputController extends BasicInputController
	{
		public var velocityProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var prevGridPositionProperty:PropertyReference;
		public var gridPositionProperty:PropertyReference;
		
		public var mapReference:RPGSpatialManagerComponent;
		
		public var tileWidth:int;
		public var tileHeight:int;
		
		public var state:int = IDLE;
		public var direction:int = UP;
		/**
		 * Flag for when the player is currently talking
		 */
		public var isTalking:Boolean = false;
		/**
		 * Flag for when we don't want the character to be controlled (cutscenes)
		 */
		public var isLocked:Boolean = false;
		/**
		 * Flag for when we don't want to listen to any action event
		 */
		public var disabledAction:Boolean = false;
		
		public function get animation():String{
			return _animation;
		}				
		
		public function get speed():Number{
			return _speed;
		}
		
		public function set speed(val:Number):void{
			_speed = _origSpeed = val;
		}
				
		override public function onTick(tickRate:Number):void{
			var gridPosition:Point = owner.getProperty(gridPositionProperty);
			//if(gridPosition.equals(_exitPoint)){
				//TODO: If I reach an exit point, don't trigger a game over yet, rather trigger some change of level
			//	PBE.mainStage.dispatchEvent(new Event("GameOver"));
			//	state = IDLE;
			//}
			if(isLocked){
				state = IDLE;
				return;
			}
			checkInput();
			if(state == MOVING){
				updatePosition(tickRate);
			}			
		}
		
		override protected function OnTalk(value:Number):void{
			if(value == 0){
				if(!disabledAction){			
					var frontCoord:Point = getFrontCoord();
					owner.eventDispatcher.dispatchEvent(new RPGActionEvent(RPGActionEvent.ACTION, frontCoord));					
				}
			}
		}		
		
		override protected function OnDash(value:Number):void{
			if(value == 1){
				_speed = .5; //_origSpeed * 2;
			}else{
				_speed = _origSpeed;
			}
		}
		
		private function checkInput():void{
			if(state == IDLE){
				if(up == 1){										
					if(direction == UP)
						state = MOVING;											
					direction = UP;
					playAnimation("up");
				}else if(left == 1){
					if(direction == LEFT)
						state = MOVING;
					direction = LEFT;					
					playAnimation("left");	
				}else if(down == 1){
					if(direction == DOWN)
						state = MOVING;
					direction = DOWN;					
					playAnimation("down");
				}else if(right == 1){
					if(direction == RIGHT)
						state = MOVING;
					direction = RIGHT;					
					playAnimation("right");
				}
				if(state == MOVING){										
					_startPosition = (owner.getProperty(positionProperty) as Point).clone();
				}
			}	
		}
		
		private function updatePosition(tickRate:Number):void{
			var map:Array = mapReference.collisionMap;		
			var prevGridPosition:Point = owner.getProperty(prevGridPositionProperty);
			var gridPosition:Point = owner.getProperty(gridPositionProperty);
			
			_position = owner.getProperty(positionProperty);				
			
			//TODO: speed formula with tickrate needs to be tweaked
			_xSpeed = tileWidth * _speed + (tickRate);
			_ySpeed = tileHeight * _speed + (tickRate);
			
			_xGrid = gridPosition.x;
			_yGrid = gridPosition.y;
			
			switch(direction){					
				case UP: 
					//Collision Detection:
					if(map[_xGrid][_yGrid - 1] == 0){
						_position.y = _position.y - _ySpeed;
						_destPosition.y = (_yGrid-1) * 32;
					}						
					//Sometimes, position doesn't sync well especially when shifting from
					//dash to walk in mid tile. So it is also necessary to check if it 
					//exceeded the destination.
					if(_position.y <= _destPosition.y){
						if(_startPosition.y != _position.y)
							_yGrid -= 1;
						_position.y = _destPosition.y;
						setIdle();
					}						
					break;
				case RIGHT:						
					if(map[_xGrid + 1][ _yGrid] == 0){
						_position.x = _position.x + _xSpeed;
						_destPosition.x = (_xGrid + 1) * 32;
					}					
					if(_position.x >= _destPosition.x){
						if(_startPosition.x != _position.x)
							_xGrid += 1;
						_position.x = _destPosition.x;
						setIdle();
					}
					break;
				case DOWN: 						
					if(map[_xGrid][ _yGrid + 1] == 0){
						_position.y = _position.y + _ySpeed;
						_destPosition.y = (_yGrid+1) * 32;
					}
					if(_position.y >= _destPosition.y){
						if(_startPosition.y != _position.y)
							_yGrid += 1;
						_position.y = _destPosition.y;
						setIdle();
					}
					break;
				case LEFT: 						
					if(map[_xGrid - 1][ _yGrid] == 0){							
						_position.x = _position.x - _xSpeed;
						_destPosition.x = (_xGrid-1) * 32;
					}						
					if(_position.x <= _destPosition.x){
						if(_startPosition.x != _position.x)
							_xGrid -= 1;
						_position.x = _destPosition.x;
						setIdle();
					}
					break;
			}				
			owner.setProperty(gridPositionProperty, new Point(_xGrid, _yGrid));
			if(_position)		
				owner.setProperty(positionProperty, _position);
		}
		
		private function setIdle():void{			
			state = IDLE;			
			switch(direction){
				case UP: playAnimation("upIdle");
					break;
				case DOWN: playAnimation("downIdle");
					break;
				case LEFT: playAnimation("leftIdle");
					break;
				case RIGHT: playAnimation("rightIdle");
					break;
			}
		}
		
		private function playAnimation(str:String):void {
			if (str != _animation) {
				_animation = str;
				owner.eventDispatcher.dispatchEvent(new Event("CharChangeAnimation"));
			}		
		}
		
		private function getFrontCoord():Point{
			var gridCoord:Point = (owner.getProperty(gridPositionProperty) as Point).clone();
			
			switch(direction){
				case UP:  gridCoord.y-=1;
					break;
				case DOWN: gridCoord.y+=1;
					break;
				case LEFT: gridCoord.x-=1;
					break;
				case RIGHT: gridCoord.x+=1;
					break;
			}
			return gridCoord;
		}
		
		override protected function onAdd():void{
			super.onAdd();
			
			_position = owner.getProperty(positionProperty);
			_destPosition = _position.clone();
			_startPosition = _position.clone();
		}
		
		override protected function onRemove():void{
			super.onRemove();						
		}
		
		private var _speed:Number;
		private var _origSpeed:Number;
		
		private var _destPosition:Point;
		private var _startPosition:Point;
		private var _position:Point;
		
		private var _animation:String;
		
		private var _ySpeed:int;
		private var _xSpeed:int;	
		private var _xGrid:int;
		private var _yGrid:int;
		private var _prevX:int;
		private var _prevY:int;
	}
}