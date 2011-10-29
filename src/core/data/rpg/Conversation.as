package core.data.rpg
{
	import com.pblabs.engine.PBE;
	
	import flash.geom.Point;

	public class Conversation
	{
		/**
		 * The name of the character bearing this conversation tree
		 */
		public var charId:String;
		/**
		 * The coordinate where this dialog will be triggered, both the charId and the coordinate cannot be set at the same time
		 */
		public var coordinate:Point;
		/**
		 * Keep an array of states, so a character can have different things to say
		 * <p>{condition: these values should be true for the dialog to be selected, dialogRootId: reference to the dialog}</p>
		 */
		public var states:Array = [];
		
		public var defaultId:String;
		
		public function getDialogId():String{
			for each(var state:Object in states){
				if(state.condition){
					PBE.log(this, "Current Dialog is " + state.dialogRootId); 
					return state.dialogRootId;
				}
			}
			PBE.log(this, "Unable to find the right dialog");
			return "";
		}
		
		public function defaultStateDone():void{
			for each(var state:Object in states){
				if(state != states[defaultId]){
					state.condition = true;
				}				
			}
		}
	}
}