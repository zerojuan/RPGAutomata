package components
{
	import com.pblabs.engine.entity.EntityComponent;
	
	import flash.geom.Point;

	public class ConversationComponent extends EntityComponent
	{
		public var conversationManager:ConversationManager;
		
		public var currentNode:int = 0;
		
		public function get grid():Point{
			return _grid;
		}
		
		public function set grid(p:Point):void{
			_grid = p;
		}
		
		public function get dialog():Array{
			return _dialog;
		}
		
		public function set dialog(arr:Array):void{
			_dialog = arr;
		}
		
		public function get conditions():Array{
			return _conditions;
		}
		
		public function set conditions(arr:Array):void{
			_conditions = arr;
		}
		
		override protected function onAdd():void{
			if(conversationManager){
				if(grid){
					
				}
			}else{
				
			}
		}
		
		override protected function onRemove():void{
			
		}
		
		private var _grid:Point;
		private var _dialog:Array;
		private var _conditions:Array;
	}
}