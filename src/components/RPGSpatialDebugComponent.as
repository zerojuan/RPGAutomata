package components
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class RPGSpatialDebugComponent extends DisplayObjectRenderer{
		
		public function set spatialManager(manager:RPGSpatialManagerComponent):void{
			_manager = manager;
			
		}
		
		public function get spatialManager():RPGSpatialManagerComponent{
			return _manager;
		}
		
		override public function get layerIndex():int
		{
			// Always draw last.
			if(scene && scene.layerCount)
				return scene.layerCount - 1;
			else
				return 0;
		}
		
		override public function onFrame(elapsed:Number):void{
			if(!_manager){
				return;
			}
			
			var objList:Array = _manager.objectArray;
			
			_sprite.graphics.clear();
			for(var i:int = 0; i < objList.length; i++){
				var rpgElement:RPGSpatialComponent = objList[i] as RPGSpatialComponent;
				drawSquare(rpgElement.gridPosition);
				
				if(_manager.collisionMap){
					if(_manager.collisionMap[rpgElement.gridPosition.y][rpgElement.gridPosition.x] != 0){
						drawSquare(rpgElement.gridPosition, 0xFF0000, rpgElement.gridWidth, rpgElement.gridHeight);
					}
				}
			}
			/*
			if(_manager.collisionMap)
				for(var row:int = 0; row < _manager.collisionMap.length; row++){
					for(var col:int = 0; col < _manager.collisionMap[row].length; col++){
						if(_manager.collisionMap[row][col] > 0){
							drawSquare(new Point(col,row));
						}
					}
				}
			*/
			super.onFrame(elapsed);
		}
		
		private function drawSquare(p:Point, color:uint = 0x00FF00, width:Number = 1, height:Number = 1):void{
			_sprite.graphics.beginFill(color, .5);
			_sprite.graphics.drawRect(p.x * 32, p.y * 32, 32*width, 32*height);
			_sprite.graphics.endFill();
		}
		
		override protected function onAdd():void{
			super.onAdd();
			displayObject = new Sprite();
			_zIndex = 30000;
			_sprite = displayObject as Sprite;
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
		private var _manager:RPGSpatialManagerComponent;
		private var _sprite:Sprite;
	}
}