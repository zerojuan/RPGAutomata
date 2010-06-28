package components
{
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;

	public class RPGSpatialComponent extends SimpleSpatialComponent
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		public function set gridPosition(val:Point):void{
			_gridPosition = val;		
		}
		
		public function get gridPosition():Point{
			return _gridPosition;
		}
		
		override public  function onTick(tickRate:Number):void{
			super.onTick(tickRate);
			
			_gridPosition.x = int(position.x / tileWidth);
			_gridPosition.y = int(position.y / tileHeight);
		}
		
		override protected function onAdd():void{
			super.onAdd();
			if(_gridPosition){
				position = new Point(_gridPosition.x * tileWidth, _gridPosition.y * tileHeight);				
			}else{
				gridPosition = new Point(32,64);
			}
		}
		
		private var _gridPosition:Point;
	}
}