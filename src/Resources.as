package  
{
	import com.pblabs.engine.resource.ResourceBundle;
	/**
	 * ...
	 * @author Julius
	 */
	public class Resources extends ResourceBundle {
		[Embed(source = '../lib/levels/level1.pbelevel', mimeType = 'application/octet-stream')]
		private var level1:Class;
		[Embed(source = '../lib/levels/spritesheets.pbelevel', mimeType = 'application/octet-stream')]
		private var spritesheets:Class;
		
		[Embed(source = '../lib/images/male/male_01.png')]
		private var maleUp:Class;
		[Embed(source = '../lib/images/male/male_02.png')]
		private var maleLeft:Class;
		[Embed(source = '../lib/images/male/male_04.png')]
		private var maleRight:Class;
		[Embed(source = '../lib/images/male/male_03.png')]
		private var maleDown:Class;
		
	}

}