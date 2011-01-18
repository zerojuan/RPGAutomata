package core.rpg
{
	import flash.geom.Point;

	public class TalkingPoint
	{
		public var gridPosition:Point;
		public var talkId:String;
		public var preRequisites:Array = new Array();
		
		public function TalkingPoint(){
		}			
	}
}