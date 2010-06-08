package controllers 
{
	import com.pblabs.engine.components.TickedComponent;
	/**
	 * ...
	 * @author Julius
	 */
	public class GuyController extends TickedComponent
	{
		
		private var _animation:String;
		
		public function get animation():String {
			return _animation;
		}
		
		public function set animation(str:String):void {
			_animation = str;
		}
		
		override protected function onAdd():void {
			super.onAdd();
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		override public function onTick(tickRate:Number):void {
			
		}
		
	}

}