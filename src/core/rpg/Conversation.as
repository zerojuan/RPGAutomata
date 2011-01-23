package core.rpg
{
	import flash.geom.Point;

	public class Conversation
	{
		public var charId:String;
		
		public var coordinate:Point;
		/**
		 * Keep an array of states, so a character can have different things to say
		 */
		public var states:Array;
		
		public function getDialogId():String{
			for each(var state:Object in states){
				if(state.codition){
					return state.dialogRootId;
				}
			}
			
			
			return "";
		}
	}
}