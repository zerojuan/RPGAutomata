package controllers
{	
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.ui.PBLabel;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import rpg.Conversation;
	import rpg.Dialog;

	public class TalkController extends TickedComponent
	{
		public var displayObjectProperty:PropertyReference;
		public var arrowPositionProperty:PropertyReference;
		public var actorIndexReference:PropertyReference;
		public var talkAlpha:Number = 0;
		public var arrowAlpha:Number = 0;
		
		public var talkSound:String;		
		
		private var _textOnScreen:String;
		private var _count:int = 0;
		private var _currentDialog:Dialog;
		
		private static const HIDDEN:int = 0;
		private static const SCROLLING:int = 1;
		private static const DONE_SCROLLING:int = 2;		
		
		private var state:int = HIDDEN;
		
		public function get player():String{
			return _playerName;
		}
		
		public function set player(val:String):void{
			_playerName = val;						
		}
		
		private function onStartedTalking(evt:TalkEvent):void{
			Logger.info(this, "onStartedTalking", "Started a conversation");
			_currentConversation = evt.conversation;
			_currentDialog = _currentConversation.next();
			owner.setProperty(actorIndexReference, _currentDialog.actorId);
			_count = 0;		
			state = SCROLLING;
			talkAlpha = 1;
			arrowAlpha = 0;
		}
		
		private function onNextTalk(evt:TalkEvent):void{
			Logger.info(this, "onNextTalk", "Next Dialog!");
			if(state == SCROLLING){
				_textOnScreen = _currentDialog.text;
				_count = _currentDialog.text.length+1;
			}else if(state == DONE_SCROLLING){
				_currentDialog = _currentConversation.next();
				_count = 0;
				state = SCROLLING;
				if(_currentDialog == null){
					_player.eventDispatcher.dispatchEvent(new TalkEvent(TalkEvent.END_TALK));					
					state = HIDDEN;
					_currentConversation.reset();
					talkAlpha = 0;
					arrowAlpha = 0;
				}else{
					owner.setProperty(actorIndexReference, _currentDialog.actorId);
				}
			}
		}
		
		override public function onTick(tickRate:Number):void{			
			if(state == SCROLLING){				
				_textOnScreen = _currentDialog.text.substring(0,_count);
				_count+=1;
				//PBE.log(this, _textOnScreen);
				_textField.caption = _textOnScreen;
				_textField.refresh();
				updateSound(tickRate);
				arrowAlpha = 0;
				if(_count > _currentDialog.text.length){
					state = DONE_SCROLLING;
				}
			}else if(state == DONE_SCROLLING){
				arrowAlpha = 1;
				_arrowPosition.y+=1;
				_arrowDownCount++;
				if(_arrowDownCount > _maxArrowDown){
					_arrowDownCount = 0;
					_arrowPosition.y = _arrowInitPosition.y;
				}
				owner.setProperty(arrowPositionProperty, _arrowPosition);
			}
		}
		
		private function updateSound(tickRate:Number):void{
			_timeSinceLastSound += tickRate;
			if(_timeSinceLastSound > .05){
				PBE.soundManager.play(talkSound);
				_timeSinceLastSound = 0;
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();
			
			if(_playerName){
				_player = PBE.lookup(player) as IEntity;
				_player.eventDispatcher.addEventListener(TalkEvent.START_TALK, onStartedTalking);
				_player.eventDispatcher.addEventListener(TalkEvent.NEXT_TALK, onNextTalk);
			}
			
			_textField = new PBLabel();
			_textField.width = 480;
			_textField.x = 120;
			_textField.y = 15;
			_textField.fontSize = 18;
			var displayObject:Sprite = owner.getProperty(displayObjectProperty) as Sprite;
			displayObject.addChild(_textField);
			
			_arrowInitPosition = owner.getProperty(arrowPositionProperty);
			_arrowPosition = _arrowInitPosition.clone();
			
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
		private var _arrowPosition:Point;
		private var _maxArrowDown:int = 5;
		private var _arrowDownCount:int = 0;
		private var _arrowInitPosition:Point;
		
		private var _currentConversation:Conversation;
		private var _playerName:String;
		private var _player:IEntity;
		private var _textField:PBLabel;
		
		private var _timeSinceLastSound:Number = 0;
	}
}