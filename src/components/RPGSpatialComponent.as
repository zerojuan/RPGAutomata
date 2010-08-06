package components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;

	public class RPGSpatialComponent extends SimpleSpatialComponent
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		public var gridWidth:Number = 1;
		public var gridHeight:Number = 1;
		
		public function set gridPosition(val:Point):void{
			try{
				if(_prevPosition){ //if there is a previous position already
					if(!_gridPosition.equals(val) || _isRegisteredToGrid == false){					
						_prevPosition = _gridPosition.clone();
						_gridPosition = val;
						//PBE.log(this, "Changed Position: " + _prevPosition + " " + _gridPosition);
						(spatialManager as RPGSpatialManagerComponent).updateCollisionMap(_prevPosition, _gridPosition, gridWidth, gridHeight);
					}				
				}else{					
					_gridPosition = val;
					_prevPosition = _gridPosition.clone();
					(spatialManager as RPGSpatialManagerComponent).updateCollisionMap(null, _gridPosition, gridWidth, gridHeight);
				}	
				_isRegisteredToGrid = true;
			}catch(e:Error){				
				_isRegisteredToGrid = false;
			}			
		}
		
		public function disableFromGrid(val:Boolean):void{
			_disabled = true;
			if(val){			
				(spatialManager as RPGSpatialManagerComponent).updateCollisionMap(_gridPosition, null, gridWidth, gridHeight);
			}else{
				(spatialManager as RPGSpatialManagerComponent).updateCollisionMap(null, _gridPosition, gridWidth, gridHeight);
			}
		}
		
		/**
		 * Check another object overlaps in my position
		 */
		public function gridOverlapped():Boolean{
			if(_disabled){
				for(var i:int = 0; i < gridWidth; i++){
					for(var c:int = 0; c < gridHeight; c++){
						var p:Point = new Point(gridPosition.x + i, gridPosition.y + c);
						if((spatialManager as RPGSpatialManagerComponent).getGridValue(p) > 0){
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function get gridPosition():Point{
			return _gridPosition;
		}
		
		public function get prevGridPosition():Point{
			return _prevPosition;
		}
		
		public function get currentGridPosition():Point{
			return new Point(_gridPosition.x * tileWidth, _gridPosition.y * tileHeight);
		}				
		
		override public function onTick(tickRate:Number):void{			
			if(!_isRegisteredToGrid){ //keep trying to register				
				gridPosition = _gridPosition;
			}			
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
		private var _prevPosition:Point;
		
		private var _disabled:Boolean;
		
		private var _isRegisteredToGrid:Boolean = false;
	}
}