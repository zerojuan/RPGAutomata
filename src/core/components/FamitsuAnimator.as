package core.components
{	
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.events.Event;
	
	/**
	 * Animator for Famitsu (RPGMaker) style spritesheets
	 * 
	 * <p>Defines an up, down, left and right animation</p>
	 * 
	 * @author Julius
	 */
	public class FamitsuAnimator extends AnimatedComponent
	{
		/**
		 * Reference to the index of the spritesheet we are trying to animate
		 */
		public var spriteIndexReference:PropertyReference;
		/**
		 * Reference to the animation string that is currently playing
		 */
		public var currentAnimationReference:PropertyReference;
		/**
		 * Specify in milliseconds the time between frames
		 */
		public var frameInterval:Number;
		/**
		 * The event we should be listening to for animation changes
		 */
		public var changeAnimationEvent:String;
		
		override public function onFrame(elapsed:Number):void{
			if(!_currentAnimation){ 
				//If current animation is null, it means an animation change was triggered
				_currentAnimation = owner.getProperty(currentAnimationReference);
				//so let's setup the animations again
				setupAnimations();
			}
			
			if(_currArray){
				//If it's a multi frame animation (walking, running)
				owner.setProperty(spriteIndexReference, _currArray[_currIndex]);
				_elapsedTime += elapsed;	
				if(_elapsedTime >= frameInterval){
					_currIndex++;					
					if(_currIndex > 2){
						_currIndex = 0;
					}
					_elapsedTime = 0;
				}
			}else{
				//If it's a one frame animation (idle)
				owner.setProperty(spriteIndexReference, _currIndex);
			}						
		}
		/**
		 * Sets up the animation arrays that will be used for animation
		 * 
		 * <p>Checks the current animation reference. If it's a multiframe animation, an array is used. If not, an index.</p>
		 */
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
					_currIndex = 9;
				}else if(_currentAnimation == "downIdle"){
					_currIndex = 0;
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
		
		private var _up:Array = [9,10,11];
		private var _down:Array = [0,1,2];
		private var _left:Array = [3,4,5];
		private var _right:Array = [6,7,8];
		
		private var _currArray:Array;
		private var _currIndex:int;
		
		private var _elapsedTime:Number = 0;
		
		private var _currentAnimation:String;
	}
}