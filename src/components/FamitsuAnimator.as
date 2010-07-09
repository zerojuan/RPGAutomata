package components
{	
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.events.Event;

	public class FamitsuAnimator extends AnimatedComponent
	{
		public var spriteIndexReference:PropertyReference;
		
		public var currentAnimationReference:PropertyReference;
		
		public var frameInterval:Number;
		
		public var changeAnimationEvent:String;
		
		private var _up:Array = [9,10,11];
		private var _down:Array = [0,1,2];
		private var _left:Array = [3,4,5];
		private var _right:Array = [6,7,8];
		
		private var _currArray:Array;
		private var _currIndex:int;
		
		private var _elapsedTime:Number = 0;
		
		override public function onFrame(elapsed:Number):void
		{
			
			if(!_currentAnimation){
				_currentAnimation = owner.getProperty(currentAnimationReference);
				setupAnimations();
			}
			
			if(_currArray){
				owner.setProperty(spriteIndexReference, _currArray[_currIndex]);
				_elapsedTime += elapsed;	
				if(_elapsedTime >= frameInterval){
					_currIndex++;
					PBE.log(this, "Next Frame: " + _currIndex + " Elapsed: " + _elapsedTime);
					if(_currIndex > 2){
						_currIndex = 0;
					}
					_elapsedTime = 0;
				}
			}else{
				owner.setProperty(spriteIndexReference, _currIndex);
			}						
		}
		
		private function setupAnimations():void{
			if(_currentAnimation == "up"){
				_currArray = _up;
				_currIndex = 0;
			}else if(_currentAnimation == "left"){
				_currArray = _left;
				_currIndex = 0;
			}else if(_currentAnimation == "right"){
				_currArray = _right;
				_currIndex = 0;
			}else if(_currentAnimation == "down"){
				_currArray = _down;
				_currIndex = 0;
			}else{
				_currArray = null;
				if(_currentAnimation == "upIdle"){
					_currIndex = 10;
				}else if(_currentAnimation == "downIdle"){
					_currIndex = 1;
				}else if(_currentAnimation == "rightIdle"){
					_currIndex = 7;
				}else if(_currentAnimation == "leftIdle"){
					_currIndex = 4;
				}
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();
			
			if (owner.eventDispatcher && changeAnimationEvent)
				owner.eventDispatcher.addEventListener(changeAnimationEvent, animationChangedHandler);
		}
		
		override protected function onRemove():void{
			super.onRemove();
			
			if (owner.eventDispatcher && changeAnimationEvent)
				owner.eventDispatcher.removeEventListener(changeAnimationEvent, animationChangedHandler);
		}
		
		private function animationChangedHandler(event:Event):void
		{			
			// This is all we need to do for the onFrame method to pick up that the 
			// animation is missing and load the current one based on the property references.
			_currentAnimation = null;
		}
		
		private var _currentAnimation:String;
	}
}