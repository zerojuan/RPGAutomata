package controllers 
{
	
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.entity.PropertyReference;
	
	import components.RPGSpatialComponent;
	import components.RPGSpatialManagerComponent;
	import components.TalkManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import rpg.Conversation;
	import rpg.TalkingPoint;

	/**
	 * Controller for our RPG character
	 * @author Julius
	 */
	public class RPGPlayerController extends TickedComponent{
		
		public var velocityProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var prevGridPositionProperty:PropertyReference;
		public var gridPositionProperty:PropertyReference;
		
		public var mapReference:RPGSpatialManagerComponent;
		
		public var talkManager:TalkManager;
		
		//Sound References
		public var stepSound:String;	
		public var stepSound2:String;
		
		public var isTalking:Boolean = false;
		public var isLocked:Boolean = false;
		
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
			if(isLocked){
				state = IDLE;
				return;
			}
			
			checkInput();
			if(state == MOVING){
				updatePosition(tickRate);			
			}
			if(state == MOVING){ //the state may have changed during updatePosition
				updateSound(tickRate);
			}
			
		}
				
		private function updateSound(tickRate:Number):void{
			_timeSinceLastSound += tickRate;
			if(_timeSinceLastSound > .2){
				if(_stepAlt){
					PBE.soundManager.play(stepSound);
				}else{
					PBE.soundManager.play(stepSound2);
				}
				_stepAlt != _stepAlt;
				_timeSinceLastSound = 0;
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
					if(map[_yGrid - 1][_xGrid] == 0){
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
					if(map[ _yGrid][_xGrid + 1] == 0){
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
					if(map[ _yGrid + 1][_xGrid] == 0){
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
					if(map[ _yGrid][_xGrid - 1] == 0){							
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
					playAnimation("up");
				}else if(_left == 1){
					if(direction == LEFT)
						state = MOVING;
					direction = LEFT;					
					playAnimation("left");	
				}else if(_down == 1){
					if(direction == DOWN)
						state = MOVING;
					direction = DOWN;					
					playAnimation("down");
				}else if(_right == 1){
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
					var conversation:Conversation;
					var frontCoord:Point = getFrontCoord();
					var frontObject:RPGSpatialComponent = mapReference.getObjectInGrid(frontCoord);					
					if(frontObject){ //if talking to an object
						var npcController:NPCController = frontObject.owner.lookupComponentByName("Controller") as NPCController;
						if(npcController && npcController.talkId){
							conversation = talkManager.getTalkById(npcController.talkId);
							npcController.talkingTo(owner, owner.getProperty(gridPositionProperty) as Point); 
						}						
					}else{ //maybe i'm talking to a part of the scene
						conversation = talkManager.getTalkByCoord(frontCoord);						
					}
					
					if(conversation){
						isTalking = true;
						isLocked = conversation.locked;
						owner.eventDispatcher.dispatchEvent(
							new TalkEvent(TalkEvent.START_TALK, conversation));
					}else{
						isTalking = false;
					}										
				}else{ //if i'm already talking fire a nextTalk event
					owner.eventDispatcher.dispatchEvent(new TalkEvent(TalkEvent.NEXT_TALK));
				}			
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
		
		private function _OnDash(value:Number):void{
			if(value == 1){
				_speed = .5; //_origSpeed * 2;
			}else{
				_speed = _origSpeed;
			}
		}
		
		private function onEndedTalking(evt:TalkEvent):void{
			PBE.log(this, "Ended talking");
			isTalking = false;
			isLocked = false;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			_position = owner.getProperty(positionProperty);
			_destPosition = _position.clone();
			_startPosition = _position.clone();
			
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
		
		private var _idleMoment:int;
		private var _idleTolerance:int = 20;
		
		private var _destPosition:Point;
		private var _startPosition:Point;
		private var _position:Point;
		
		private var _timeSinceLastSound:Number = 0;
		private var _stepAlt:Boolean;
	}

}