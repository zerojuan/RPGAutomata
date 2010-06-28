package components
{
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.BasicSpatialManager2D;

	public class RPGSpatialManagerComponent extends BasicSpatialManager2D{
		public var levelCollisionMapProperty:PropertyReference;
		
		public function get collisionMap():Array{
			var collisionMap:Array = owner.getProperty(levelCollisionMapProperty);
			return collisionMap;
		}
	}
}