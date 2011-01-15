package components.mouse
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;

	public class MouseController extends EntityComponent implements IMouseControllable
	{
		override protected function onAdd():void{
			
		}
		
		public function onClick():void{
			Logger.info(this, "onClick", "Clicked Me! " + owner.name);
		}
		
		public function onOver():void{
			
		}
		
		public function onOut():void{
			
		}
	}
}