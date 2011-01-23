package core.components.events
{
	import flash.events.Event;
	import flash.geom.Point;

	public class RPGActionEvent extends Event
	{
		public static const ACTION:String = "RPG_ACTION";
		public static const END_ACTION:String = "RPG_END_ACTION";
		
		/**
		 * The coordinates in front of the character who made the action
		 */
		public var frontCoordinates:Point;
		/**
		 * The result of the action
		 */
		public var actionResult:int = 0;
		
		public function RPGActionEvent(type:String, frontCoord:Point = null, actionResult:int = -1)
		{
			super(type);
			frontCoordinates = frontCoord;
			this.actionResult = actionResult;
		}
	}
}