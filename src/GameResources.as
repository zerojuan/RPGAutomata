package  
{
	import com.pblabs.engine.resource.ResourceBundle;
	/**
	 * ...
	 * @author Julius
	 */
	public class GameResources extends ResourceBundle {		
		[Embed(source = '../lib/levels/level1.pbelevel', mimeType = 'application/octet-stream')]
		public var level1:Class;
		[Embed(source = '../lib/levels/spritesheets.pbelevel', mimeType = 'application/octet-stream')]
		public var spritesheets:Class;
		[Embed(source = "../lib/office_map.xml", mimeType = "application/octet-stream")]
		public var officeMap:Class;
		
		[Embed(source = '../lib/images/male/male_01.png')]
		public var maleUp:Class;
		[Embed(source = '../lib/images/male/male_02.png')]
		public var maleLeft:Class;
		[Embed(source = '../lib/images/male/male_04.png')]
		public var maleRight:Class;
		[Embed(source = '../lib/images/male/male_03.png')]
		public var maleDown:Class;
		
		[Embed(source = "../lib/images/free_tileset.png")]
		public var tileset1:Class;
		[Embed(source = "../lib/images/free_tileset_version_8.png")]
		public var tileset2:Class;
		[Embed(source = "../lib/images/office-tileset.png")]
		public var tileset3:Class;
		
		[Embed(source="../lib/images/textbox.png")]
		public var textBox:Class;
		[Embed(source="../lib/images/arrow.png")]
		public var arrow:Class;
		
		[Embed(source="../lib/images/actor-image.png")]
		public var actorImage:Class;
		
		[Embed(source = "../lib/conversations/conversations.xml", mimeType="application/octet-stream")]
		public var conversations:Class;
		
		[Embed(source="../lib/manaspc.ttf", embedAsCFF="false", fontName="manaspace")]
		public var manaSpaceFont:Class;
	}

}