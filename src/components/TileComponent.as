package components 
{
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Julius
	 */
	public class TileComponent extends SpriteSheetComponent
	{
		
		override public function getFrame(index:int,  direction:Number=0.0):BitmapData {
			super.buildFrames();
			
			return super.getFrame(index);
		}
	}

}