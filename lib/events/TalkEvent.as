package
{
	import flash.events.Event;
	
	import rpg.Conversation;

	public class TalkEvent extends Event
	{
		public static const START_TALK:String = "StartTalk";
		public static const NEXT_TALK:String = "NextTalk";
		public static const END_TALK:String = "EndTalk";
		
		public var conversation:Conversation;
		
		public function TalkEvent(type:String, _conversation:Conversation = null){
			super(type, true, false);
			conversation = _conversation;
		}
	}
}