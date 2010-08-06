package
{	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import mx.core.ByteArrayAsset;

	public class CustomPreloader extends MovieClip
	{
		[Embed(source="../lib/ui/loading.swf", mimeType="application/octet-stream")]
		private var loadingSwf:Class;
		
		public var loader:Loader=new Loader;
		public var logo:ByteArrayAsset;
		private var loadingMC:MovieClip;
		
		public function CustomPreloader()
		{
			logo = new loadingSwf();
			
			loader.contentLoaderInfo.addEventListener(Event.INIT,loadCompleteListener,false,0,true);
			loader.loadBytes(logo);
						
			stop();			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function loadCompleteListener(e:Event):void{
			loadingMC = MovieClip(loader.content);
			addChild(loadingMC);
			loadingMC.stop();
		}
		
		public function onEnterFrame(event:Event):void
		{
			graphics.clear();
			if(framesLoaded == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if(loadingMC)
					loadingMC.gotoAndStop(2);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
			}
			else
			{
				var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				if(loadingMC){
					loadingMC.bar.scaleX = percent;					
				}
				/*
				graphics.beginFill(0);				
				graphics.drawRect(0, stage.stageHeight / 2 - 10, stage.stageWidth * percent, 20);				
				graphics.endFill()*/				
			}
		}
		
		private function onMouseUp(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			nextFrame();
			TweenLite.to(loadingMC, 1, {alpha: 0, onComplete: init});					
		}
		
		private function init():void
		{			
			var mainClass:Class = Class(getDefinitionByName("Main"));
			if(mainClass)
			{
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	}
}