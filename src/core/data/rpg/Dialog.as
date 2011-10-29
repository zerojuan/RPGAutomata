package core.data.rpg
{
	public class Dialog{
		/**
		* The name of the actor
		*/
		public var actor:String;
		/**
		 * The text that appears
		 */
		public var text:String;
		/**
		 * {id: Reference to the next dialog, text:the text that will show on the selection screen}
		 */
		public var exitA:Object;
		/**
		 * {id: Reference to the next dialog, text:the text that will show on the selection screen}
		 */
		public var exitB:Object;
		/**
		 * Reference to the gameState that will be changed after this dialog is through
		 */
		public var exit:String;
		
		public function get isMultipleChoice():Boolean{
			return exitA && exitB;
		}
		
		public function toString():String{
			return actor + ": " + text + "\n Exit A: " + (exitA!=null?exitA.id:"") + "."+ (exitA!=null?exitA.text:"") + "\n Exit B: " + (exitB!=null ? exitB.id:"") + "." + (exitB!=null ? exitB.text:"") + " End: " + (exit!=null?exit:"");
		}
	}
}