package core.rpg
{
	public class Dialog{
		public var actor:String;
		public var actorId:int;
		public var text:String;
	
		public function Dialog(actor:String, actorId:int, text:String):void{
			this.actor = actor;
			this.text = text;
			this.actorId = actorId;
		}
	}
}