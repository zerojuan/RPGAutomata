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
		[Embed(source = '../lib/levels/templates.pbelevel', mimeType = 'application/octet-stream')]
		public var templates:Class;
		[Embed(source = "../lib/office_map.xml", mimeType = "application/octet-stream")]
		public var officeMap:Class;
		
		[Embed(source="../lib/images/female/girl.png")]
		public var girlImg:Class;
		
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
			
		
		[Embed(source="../lib/sounds/button_snd.mp3")]
		public var buttonSnd:Class;
		[Embed(source="../lib/sounds/step_snd.mp3")]
		public var stepSnd:Class;
		[Embed(source="../lib/sounds/talk_snd.mp3")]
		public var talkSnd:Class;
		
	}

}