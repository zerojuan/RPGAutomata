package components
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
		public function updateCollisionMap(_prevPosition:Point, _currPosition:Point):void{
			var collisionMap:Array = owner.getProperty(levelCollisionMapProperty);
			if(!collisionMap){
				Logger.warn(this, "updateCollisionMap", "CollisionMap not yet ready. Unable to update collision map.");				
				//return;
			}
			if(_prevPosition){
				collisionMap[_prevPosition.y][_prevPosition.x] = 0;
			}
			if(_currPosition){
				collisionMap[_currPosition.y][_currPosition.x] = 1;
			}
		}
		
		public function get objectArray():Array{
			return _objectList;
		}

	}
}