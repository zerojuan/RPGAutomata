package core.components.input.mouse
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.DisplayObjectScene;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MouseDragComponent extends TickedComponent
	{
		public var scene:DisplayObjectScene;
		
		private var startPosition:Point = new Point(0,0);
		
		private var isMouseDown:Boolean = false;
		
		protected override function onAdd():void{
			super.onAdd();
			
			scene.sceneView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(evt:MouseEvent):void{
			isMouseDown = true;
			
			startPosition.x = PBE.mainStage.mouseX;
			startPosition.y = PBE.mainStage.mouseY;
			
			scene.trackObject = null;
		}
		
		private function onMouseUp(evt:MouseEvent):void{
			isMouseDown = false;
			
			var endPosition:Point = new Point();
			
			endPosition.x = PBE.mainStage.mouseX;
			endPosition.y = PBE.mainStage.mouseY;
		
			//Logger.print(this, "Start position: " + startPosition + " End Position: " + endPosition);
		}
		
		override public function onTick(deltaTime:Number):void{
			if(isMouseDown){
				var endPosition:Point = new Point();
				
				endPosition.x = PBE.mainStage.mouseX;
				endPosition.y = PBE.mainStage.mouseY;
				
				var delta:Point = startPosition.subtract(endPosition);
				scene.screenPan(delta.x,delta.y);
				
				//startPosition = endPosition;
			}
		}
	}
}