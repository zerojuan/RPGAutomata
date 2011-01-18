package core.components
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.BasicSpatialManager2D;
	
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;

	public class RPGSpatialManagerComponent extends BasicSpatialManager2D{
		public var levelCollisionMapProperty:PropertyReference;
		
		public function get collisionMap():Array{
			var collisionMap:Array = owner.getProperty(levelCollisionMapProperty);
			return collisionMap;
		}
		
		//Update the collisionMap, called when a SpatialComponent has moved
		public function updateCollisionMap(_prevPosition:Point, _currPosition:Point, _width:Number = 1, _height:Number = 1):void{
			var collisionMap:Array = owner.getProperty(levelCollisionMapProperty);
			var i:int = 0;
			var c:int = 0;
			if(!collisionMap){
				//Logger.warn(this, "updateCollisionMap", "CollisionMap not yet ready. Unable to update collision map.");				
				//return;
			}
			if(_prevPosition){
				setGridValue(_prevPosition, _width, _height, 0);
			}
			if(_currPosition){
				setGridValue(_currPosition, _width, _height, 1);
			}
		}
		
		public function getObjectInGrid(coord:Point):RPGSpatialComponent{
			for(var i:int = 0; i < _objectList.length; i++){
				var rpgObject:RPGSpatialComponent = _objectList[i] as RPGSpatialComponent;
				if(rpgObject.gridPosition.equals(coord)){
					return rpgObject;
				}
			}
			return null;
		}
		
		private function setGridValue(origin:Point, width:Number, height:Number, value:Number):void{
			var i:int;
			for(i = 0; i < height; i++)
				collisionMap[origin.y+i][origin.x] = value;
			for(i = 0; i < width; i++)
				collisionMap[origin.y][origin.x+i] = value;
		}
		
		public function get objectArray():Array{
			return _objectList;
		}

	}
}