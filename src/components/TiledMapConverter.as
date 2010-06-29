package components 
{
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.mxml.ResourceBinding;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.rendering2D.BitmapRenderer;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.spritesheet.FixedSizeDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Julius
	 */
	public class TiledMapConverter extends EntityComponent{
		
		public var playerZIndex:int;
		public var collisionLayer:Array;
		
		public function get scene():DisplayObjectScene {
			return _scene;
		}
		
		public function set scene(value:DisplayObjectScene):void {
			_scene = value;
		}
		
		/**
         * The filename of the TMX file
         */
        public function get tmxFilename():String{
            return _tmxMap == null ? null : _tmxMap.filename;
        }
        
        /**
         * 
         */
        public function set tmxFilename(value:String):void
        {
            if (_tmxMap)
            {
                PBE.resourceManager.unload(_tmxMap.filename, XMLResource);
                tmxMap = null;
            }
            
            PBE.resourceManager.load(value, XMLResource, onXMLLoaded, onXMLFailed);
        }
		
		/**
         * The image resource to use for this sprite sheet.
         */
        public function get tmxMap():XMLResource
        {
            return _tmxMap;
        }
        
        /**
         * @private
         */
        public function set tmxMap(value:XMLResource):void{
            _tmxMap = value;            
        }
		
		
		protected function onXMLLoaded(resource:XMLResource):void {
			_tmxMap = resource;
			var i:int;
			var xml:XML = _tmxMap.XMLData;
			
			//tileLength = xml.layer.data.tile.length();
			spriteWidth = xml.attribute("width");
			spriteHeight = xml.attribute("height");
			tileWidth = xml.attribute("tilewidth");
			tileHeight = xml.attribute("tileheight");
			//spriteSource = xml.tileset.image.attribute("source");					
			
			for (i = 0; i < xml.layer.length(); i++ ) {
				var bitmapRenderer:TileLayerComponent = new TileLayerComponent();
				bitmapRenderer.scene = scene;
				bitmapRenderer.owner = this.owner;
				if (i >= playerZIndex) {
					bitmapRenderer.zIndex = i + 1;
				}else {
					bitmapRenderer.zIndex = i;
				}
				
				bitmapRenderer.bitmapData = new BitmapData(spriteWidth * tileWidth, spriteHeight * tileHeight, true, 0x00ffffff);
				
				mapLayers[i] = bitmapRenderer;
								
				var tileData:XMLList = xml.layer[i].data;
				var tiles:Array = new Array();
				var tileCoordinates:Array = new Array();
				
				if (xml.layer[i].properties.property && xml.layer[i].properties.property.attribute("name") == "collision") {					
					collisionLayer = parseCSV(tileData);					
				}else {
					layers[i] = parseCSV(tileData);
				}										
			}
												
			tilesetLength = xml.tileset.length();
			for (i = 0; i < tilesetLength; i++ ) {
				
				var ts:Tileset = new Tileset();
				ts.tileHeight = xml.tileset[i].attribute("tileheight");
				ts.tileWidth = xml.tileset[i].attribute("tilewidth");
				ts.firstGID = xml.tileset[i].attribute("firstgid");
				ts.name = xml.tileset[i].attribute("name");
				ts.imageSource = xml.tileset[i].image.attribute("source");
				
				tileset[i] = ts;
				PBE.resourceManager.load(ts.imageSource, ImageResource, onImageLoaded, onImageFailed);								
			}															
		}
		
		private function parseCSV(data:String):Array {
			var result:Array = new Array();
			result = data.split('\n');
			for (var i:int = 0; i < result.length; i++) {
				result[i] = result[i].split(",");
			}			
			return result;
		}
			
		private function onTilesetsLoaded():void {
			//actually start the drawing implementation
			Logger.info(this, "onTilesetsLoaded", "Finished loading tilesets");
			for (var i:uint = 0; i < layers.length; i++) {
				
				for (var spriteForX:Number = 0; spriteForX < spriteWidth; spriteForX++) {
					for (var spriteForY:Number = 0; spriteForY < spriteHeight; spriteForY++) {
						
						var tileNum:int=int(layers[i][spriteForY][spriteForX]);
						var destY:int=spriteForY*tileWidth;
						var destX:int = spriteForX * tileWidth;
						
						var tiles:Tileset = locateTileset(tileNum);
						if (tiles) {													
							var actualNum:int = tileNum - (tiles.firstGID - 1);
						
							var sourceY:int = Math.ceil(actualNum / (tiles.maxX)) - 1;						
							var sourceX:int = actualNum % (tiles.maxX) - 1;											
							mapLayers[i].bitmapData.copyPixels(tiles.image, new Rectangle(sourceX * tileWidth, sourceY * tileHeight, tileWidth, tileHeight), new Point(destX, destY));
						}
					}
				}
			}
		}
		
		private function locateTileset(tilenum:int):Tileset{
			var tiles:Tileset = new Tileset();
			for each(tiles in tileset) {
				if (tiles.isHere(tilenum)) {					
					return tiles;
				}
			}
			return null;
		}
		
		
		private function onImageLoaded(img:ImageResource):void {			
			//attribute loaded tileset to our tileset list
			var ts:Tileset;
			for each (ts in tileset) {
				if (ts.imageSource == img.filename) {
					ts.image = img.bitmapData;
					Logger.info(this, "onImageLoaded", "Loaded " + img.filename);
				}
			}
			
			tilesetsLoaded++;		
			if (tilesetsLoaded == tilesetLength) {								
				onTilesetsLoaded();
			}
		}
		
		private function onImageFailed(img:ImageResource):void {
			Logger.error(this, "onImageFailed", "Failed to load image: " + img.filename);
		}
		
		override protected function onAdd():void {
			super.onAdd();
			mapLayers = new Array();
			tileset = new Array();
			layers = new Array();
			if (!_scene) {
				Logger.error(this, "onAdd", "Unable to find a scene");
			}
		}
		
		override protected function onRemove():void {
			super.onRemove();
		}
		
		protected function onXMLFailed(resource:XMLResource):void {
			Logger.error(this, "onXMLFailed", "Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		private var tileLength:uint;
		private var tileHeight:uint;
		private var tileWidth:uint;
		private var spriteWidth:uint;
		private var spriteHeight:uint;
		private var layers:Array;
		private var tileset:Array;
		private var mapLayers:Array;
		private var tilesetLength:uint; //how many tilesets do we have?
		private var tilesetsLoaded:uint = 0;
		private var _tmxMap:XMLResource;
		private var _scene:DisplayObjectScene;
	}

}