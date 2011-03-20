package core.tilemap 
{
	import com.pblabs.engine.debug.Logger;
	
	import flash.display.BitmapData;
	
	/**
	 * Model class for a Tileset in a TMXMap
	 * 
	 * @author Julius
	 */
	public class Tileset
	{
		/**
		 * The GID of the topleft tile
		 */
		public var firstGID:int = 0;
		/**
		 * The GID of the bottom right tile
		 */
		public var lastGID:int = 0;
		/**
		 * The name of this Tileset
		 */
		public var name:String;
		/**
		 * The width of one tile
		 */
		public var tileWidth:int;
		/**
		 * The height of one tile
		 */
		public var tileHeight:int;

		//public var spacing:int;
		//public var margin:int;
		/**
		 * The URL of the image
		 */
		public var imageSource:String;
		
		/**
		 * Number of columns this tileset has
		 */
		public var cols:int;
		/**
		 * Number of rows this tileset has
		 */
		public var rows:int;

		/**
		 * Returns true if the given tileNum is within this Tileset
		 */
		public function isHere(tileNum:int):Boolean {
			return (tileNum >= firstGID && tileNum <= lastGID);
		}
		/**
		 * Stores the bitmapData for this Tileset
		 */
		public function set image(val:BitmapData):void {
			_image = val;
			cols = _image.width / tileWidth;
			rows = _image.height / tileHeight;
			lastGID = firstGID + (cols * rows);
			Logger.debug(this, "set image -- " + name, "Tileset Image Dimension:[ "+ _image.width + ", " + tileWidth + "]");
			Logger.debug(this, "set image -- " + name, "FirstGID( "+firstGID+" ) + Row*Col(" + cols + "," + rows + ") = LastGID(" + lastGID+")");
		}
		/**
		 * Stores the bitmapData for this Tileset
		 */
		public function get image():BitmapData {
			return _image;
		}
		
		private var _image:BitmapData;
		
	}

}