package core.components.keyboard
{
	import com.pblabs.engine.core.InputMap;

	public class RPGBaseController
	{
		
		public function get input():InputMap{
			return _inputMap;
		}
		
		public function set input(value:InputMap):void{
			_inputMap = value;
			
			if (_inputMap != null)
			{
				_inputMap.mapActionToHandler("GoLeft", OnLeft);
				_inputMap.mapActionToHandler("GoRight", OnRight);
				_inputMap.mapActionToHandler("GoUp", OnUp);
				_inputMap.mapActionToHandler("GoDown", OnDown);
				_inputMap.mapActionToHandler("TalkPressed", OnTalk);
				_inputMap.mapActionToHandler("Dash", OnDash);
			}
		}
		
		protected function OnLeft(value:Number):void{
			left = value;
		}
		
		protected function OnRight(value:Number):void{
			right = value;
		}
		
		protected function OnUp(value:Number):void{
			up = value;
		}
		
		protected function OnDown(value:Number):void{
			down = value;
		}
		
		protected function OnTalk(value:Number):void{
			
		}
		
		protected function OnDash(value:Number):void{
			
		}
		
		private var _inputMap:InputMap;
		
		protected var left:Number = 0;
		protected var right:Number = 0;
		protected var up:Number = 0;
		protected var down:Number = 0;
		protected var dash:Number = 0;
		protected var talking:Number = 0;
	}
}