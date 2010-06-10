package components 
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.PBUtil;
	/**
	 * ...
	 * @author Julius
	 */
	public class StatComponent extends EntityComponent
	{		
		public var maxStamina:Number;
		public var maxHappiness:Number;
		
		private var _stamina:Number;
		private var _happiness:Number;
		
		override protected function onAdd():void {
			_stamina = 0;
			_happiness = maxHappiness;
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		public function set stamina(val:Number):void {			
			_stamina = PBUtil.clamp(val, 0, maxStamina);					
		}
		
		public function get stamina():Number {
			return _stamina;
		}
		
		public function set happiness(val:Number):void {
			_happiness = PBUtil.clamp(val, 0, maxHappiness);
		}
		
		public function get happiness():Number {
			return _happiness;
		}
		
	}

}