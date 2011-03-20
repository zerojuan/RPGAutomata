package core.components 
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.AnimatedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.mxml.ResourceBinding;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.XMLResource;
	import com.pblabs.rendering2D.BitmapRenderer;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.spritesheet.FixedSizeDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	
	import core.components.events.TilesetEvent;
	import core.tilemap.Tileset;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Creates TileLayers based on a TMX file
	 * 
	 * @author Julius
	 */
	public class TiledMapConverter extends EntityComponent{
		/**
		 * The layer index reserved for the player
		 */
		public var playerZIndex:int;
		/**
		 * The layer reserved for collision detection
		 */
		public var collisionLayer:Array;
		/**
		 * Where the assets for the images are located
		 */
		public var assetDirectory:String;
		/**
		 * The tile layers
		 */
		private var tileLayers:Vector.<TileLayerComponent> = new Vector.<TileLayerComponent>;
		/**
		 * Where the layers are drawn
		 */
		public function get scene():DisplayObjectScene {
			return _scene;
		}
		/**
		 * Where the layers are drawn
		 */
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
         * The filename of the TMX file
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
         * The XML Resource containing the TileMap data
         */
        public function get tmxMap():XMLResource
        {
            return _tmxMap;
        }
        /**
         * Set the XML Resource containing the TileMap data
         */
        public function set tmxMap(value:XMLResource):void{
            _tmxMap = value;            
        }
		/**
		 * Look for a specific layer based on its name
		 */
		private function lookupLayerByName(layerName:String):TileLayerComponent{
			for each(var layer:TileLayerComponent in tileLayers){
				if(layer.name == layerName){
					return layer;
				}
			}
			return null;
		}
		/**
		 * Parse the TMX file.
		 * 
		 * This only initiates the loading of the graphic assets.
		 * The painting happens only when all the graphic assets are loaded.
		 */
		protected function onXMLLoaded(resource:XMLResource):void {
			_tmxMap = resource;
			
			var i:int;
			var xml:XML = _tmxMap.XMLData;
			
			tilesetsLoaded = 0;
			
			spriteWidth = xml.attribute("width");
			spriteHeight = xml.attribute("height");
			tileWidth = xml.attribute("tilewidth");
			tileHeight = xml.attribute("tileheight");
			
			for (i = 0; i < xml.layer.length(); i++ ) {
				var tileData:XMLList = xml.layer[i].data;
				var tiles:Array = new Array();
				var tileCoordinates:Array = new Array();
				
				var layerName:String = xml.layer[i].attribute("name");
				PBE.log(this, "Looking up component: " + layerName);
				//TODO: Make a public variable to control whether to overwrite a layer or not
				var bitmapRenderer:TileLayerComponent = lookupLayerByName(layerName);
				var registered:Boolean = false;
				if(bitmapRenderer){
					PBE.log(this, "Layer already exists, using that layer");
					registered = true;
				}else{
					PBE.log(this, "Registering new layer");
					bitmapRenderer = new TileLayerComponent();					
				}
				
				bitmapRenderer.bitmapData = new BitmapData(spriteWidth * tileWidth, spriteHeight * tileHeight, true, 0x00ffffff);
				bitmapRenderer.scene = scene;																
				//check where we want to put our player in
				if (i >= playerZIndex) {
					bitmapRenderer.zIndex = i + 1;
				}else {
					bitmapRenderer.zIndex = i;
				}
				
				mapLayers[i] = bitmapRenderer;
				if(!registered){
					bitmapRenderer.register(this.owner, layerName);
					tileLayers.push(bitmapRenderer);
				}
				
				
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
				ts.imageSource = assetDirectory + xml.tileset[i].image.attribute("source");
				
				tilesets[i] = ts;
				PBE.resourceManager.load(ts.imageSource, ImageResource, onImageLoaded, onImageFailed);								
			}															
		}
		/**
		 * Helper function for parsing CSVs into an array
		 */
		private function parseCSV(data:String):Array {
			var result:Array = new Array();
			result = data.split('\n');
			for (var i:int = 0; i < result.length; i++) {
				result[i] = result[i].split(",");
			}			
			return result;
		}
		/**
		 * This is where the actual drawing is done.
		 * 
		 * Must be called only when all tilesets have been loaded
		 */	
		private function onTilesetsLoaded():void {
			Logger.info(this, "onTilesetsLoaded", "Finished loading tilesets");
			for (var i:uint = 0; i < layers.length; i++) {
				
				for (var spriteForX:Number = 0; spriteForX < spriteWidth; spriteForX++) {
					for (var spriteForY:Number = 0; spriteForY < spriteHeight; spriteForY++) {
						
						var tileNum:int = int(layers[i][spriteForY][spriteForX]);
						var destY:int = spriteForY * tileHeight;
						var destX:int = spriteForX * tileWidth;
						
						var tiles:Tileset = locateTileset(tileNum);
						if (tiles) {													
							var actualNum:int = tileNum - (tiles.firstGID - 1);
						
							var sourceY:int = Math.ceil(actualNum / (tiles.cols)) - 1;						
							var sourceX:int = actualNum % (tiles.cols) - 1;											
							mapLayers[i].bitmapData.copyPixels(tiles.image, new Rectangle(sourceX * tileWidth, sourceY * tileHeight, tileWidth, tileHeight), new Point(destX, destY));
						}else{
							Logger.error(this, "onTilesetsLoaded", "Unable to locate tiles. GID must be out of range");
						}
					}
				}
			}			
			//Tell the stage that we're done loading
			PBE.mainStage.dispatchEvent(new TilesetEvent(TilesetEvent.LOADED));
		}
		/**
		 * Get the Tileset that includes the specified tile number
		 */
		private function locateTileset(tilenum:int):Tileset{
			var tiles:Tileset = new Tileset();
			for each(tiles in tilesets) {
				if (tiles.isHere(tilenum)) {					
					return tiles;
				}
			}
			return null;
		}
		/**
		 * Handler for image loading of the tileset images.
		 * 
		 * <p>Calls onTilesetsLoaded when all the tileset images have been loaded </p>
		 */
		private function onImageLoaded(img:ImageResource):void {			
			//Attribute loaded tileset to our tileset list
			var ts:Tileset;
			for each (ts in tilesets) {
				if (ts.imageSource == img.filename) {
					ts.image = img.bitmapData;
					Logger.debug(this, "onImageLoaded",  "Loaded " + img.filename);
				}
			}
			
			tilesetsLoaded++;		
			//if all tilesets are loaded
			if (tilesetsLoaded == tilesetLength) { 								
				onTilesetsLoaded();
			}
		}
		/**
		 * Fail handler for loading images
		 */
		private function onImageFailed(img:ImageResource):void {
			Logger.error(this, "onImageFailed", "Failed to load image: " + img.filename);
		}
		/**
		 * Fail handler for loading the XML file
		 */
		protected function onXMLFailed(resource:XMLResource):void {
			Logger.error(this, "onXMLFailed", "HOMG! Failed to load '" + (resource ? resource.filename : "(unknown)") + "'");
		}
		
		override protected function onAdd():void {
			super.onAdd();
			mapLayers = new Array();
			tilesets = new Array();
			layers = new Array();
			if (!_scene) {
				Logger.error(this, "onAdd", "Unable to find a scene");
			}
		}
		
		override protected function onRemove():void {
			mapLayers = null;
			tilesets = null;
			layers = null;

			super.onRemove();
		}
		
		
		
		private var tileLength:uint;
		private var tileHeight:uint;
		private var tileWidth:uint;
		private var spriteWidth:uint;
		private var spriteHeight:uint;
		private var layers:Array;
		private var tilesets:Array;
		private var mapLayers:Array;
		private var tilesetLength:uint; //how many tilesets do we have?
		private var tilesetsLoaded:uint = 0;
		private var _tmxMap:XMLResource;
		private var _scene:DisplayObjectScene;
	}

}