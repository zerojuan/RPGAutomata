package components 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Julius
	 */
	public class Tileset
	{
		private var _image:BitmapData;
		
		public var firstGID:int = 0;
		public var lastGID:int = 0;
		public var name:String;
		public var tileWidth:int;
		public var tileHeight:int;
		public var spacing:int;
		public var margin:int;
		public var imageSource:String;
		
		public var maxX:int;
		public var maxY:int;
		
		
		public function Tileset() 
		{
			
		}
		
		public function isHere(tileNum:int):Boolean {
			return (tileNum >= firstGID && tileNum <= lastGID);
		}
		
		public function set image(val:BitmapData):void {
			_image = val;
			maxX = _image.width / tileWidth;
			maxY = _image.height / tileHeight;
			lastGID = firstGID + (maxX * maxY);
			trace(_image.width + ", " + tileWidth);
			trace(maxX + "," + maxY + " = " + lastGID);
		}
		
		public function get image():BitmapData {
			return _image;
		}
		
	}

}