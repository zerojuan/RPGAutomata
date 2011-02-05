package core
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;

	/**
	 * An array of game flags
	 */
	public class GameDatabase extends EntityComponent
	{
		public var gameFlags:Array = [];
		
		override protected function onAdd():void{
			super.onAdd();
			PBE.log(this, "Added game database");
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
	}
}