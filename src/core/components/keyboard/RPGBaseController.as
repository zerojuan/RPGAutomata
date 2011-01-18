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
				_inputMap.mapActionToHandler("GoLeft", _OnLeft);
				_inputMap.mapActionToHandler("GoRight", _OnRight);
				_inputMap.mapActionToHandler("GoUp", _OnUp);
				_inputMap.mapActionToHandler("GoDown", _OnDown);
				_inputMap.mapActionToHandler("TalkPressed", _OnTalk);
				_inputMap.mapActionToHandler("Dash", _OnDash);
			}
		}
		
		protected function _OnLeft(value:Number):void{
			_left = value;
		}
		
		protected function _OnRight(value:Number):void{
			_right = value;
		}
		
		protected function _OnUp(value:Number):void{
			_up = value;
		}
		
		protected function _OnDown(value:Number):void{
			_down = value;
		}
		
		protected function _OnTalk(value:Number):void{
			
		}
		
		protected function _OnDash(value:Number):void{
			
		}
		
		private var _inputMap:InputMap;
		
		private var _left:Number = 0;
		private var _right:Number = 0;
		private var _up:Number = 0;
		private var _down:Number = 0;
		private var _dash:Number = 0;
		private var _talking:Number = 0;
	}
}