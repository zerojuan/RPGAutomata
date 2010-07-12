package rpg
{
	public class Conversation
	{
		public var currIndex:int;
		
		public var locked:Boolean;
		
		public function Conversation(){
			_dialogArray = new Array();
			reset();
		}
		
		public function push(d:Dialog):void{
			_dialogArray.push(d);
		}
		
		public function reset():void{
			currIndex = 0;
		}
		
		public function current():Dialog{
			return _dialogArray[currIndex];
		}
		
		public function next():Dialog{
			if(currIndex > _dialogArray.length)
				return null;
			
			return _dialogArray[currIndex++];
		}
		
		private var _dialogArray:Array;
	}
}