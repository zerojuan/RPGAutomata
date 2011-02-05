package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.ui.PBLabel;
	
	import core.components.events.RPGActionEvent;
	import core.components.events.TalkEvent;
	import core.components.keyboard.BasicInputController;
	import core.rpg.Conversation;
	import core.rpg.Dialog;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class TalkDisplayController extends BasicInputController
	{
		public var displayObjectProperty:PropertyReference;
		public var actorIndexReference:PropertyReference;
		public var arrowPositionProperty:PropertyReference;		
		
		public var talkSound:String;
		
		public var dialogManager:DialogManager;
		
		public var arrowAlpha:int = 0;
		public var talkAlpha:int = 0;
		
		private static const HIDDEN:int = 0;
		private static const SCROLLING:int = 1;
		private static const DONE_SCROLLING:int = 2;
		
		private var state:int = HIDDEN;				
		
		private function onStartedTalking(evt:TalkEvent):void{
			Logger.info(this, "onStartedTalking", "Started a conversation at " + evt.conversation.charId);
			_currentConversation = evt.conversation;
			_currentDialog = dialogManager.dialogLibrary[_currentConversation.getDialogId()];
			_count = 0;
			state = SCROLLING;
			talkAlpha = 1;
		}
		
		private function nextTalk():void{
			PBE.log(this, "Next talk");
			var nextId:String = _currentDialog.exitA.id;
			if(_currentDialog.isMultipleChoice){
				
				if(_currentChoice == 0){
					nextId = _currentDialog.exitA.id;
				}else{
					nextId = _currentDialog.exitB.id;
				}
			}
			_currentDialog = dialogManager.dialogLibrary[nextId];
			_count = 0;
			_textOnScreen = "";
			_choiceA.visible = false;
			_choiceB.visible = false;
			state = SCROLLING;
		}
		
		private function endTalk():void{
			PBE.log(this, "Dispatch event to the world, that yes, we are done here people");
			arrowAlpha = 0;
			talkAlpha = 0;
			state = HIDDEN;
			owner.eventDispatcher.dispatchEvent(new RPGActionEvent(RPGActionEvent.END_ACTION, null, _currentDialog.exit));
		}
		
		override public function onTick(tickRate:Number):void{
			if(_displayObject==null){
				_displayObject = owner.getProperty(displayObjectProperty) as Sprite;
				if(_displayObject){
					_displayObject.addChild(_textField);
					_displayObject.addChild(_choiceA);
					_displayObject.addChild(_choiceB);
				}
			}
			
			if(state == SCROLLING){
				_textOnScreen = _currentDialog.text.substring(0,_count);
				_count+=1;
				//PBE.log(this, _textOnScreen);
				_textField.caption = _textOnScreen;
				_textField.refresh();
				//updateSound(tickRate);
				arrowAlpha = 0;
				if(_count > _currentDialog.text.length){
					state = DONE_SCROLLING;
				}
			}else if(state == DONE_SCROLLING){
				_textOnScreen = _currentDialog.text;
				_textField.caption = _textOnScreen;
				_textField.refresh();
				arrowAlpha = 1;
				_arrowPosition.y+=1;
				_arrowDownCount++;
				if(_arrowDownCount > _maxArrowDown){
					_arrowDownCount = 0;
					_arrowPosition.y = _arrowInitPosition.y;
				}
				owner.setProperty(arrowPositionProperty, _arrowPosition);
				if(_currentDialog.isMultipleChoice){
					_choiceA.visible = true;
					_choiceB.visible = true;
					if(_currentChoice == 0){
						_choiceA.caption = ">>" + _currentDialog.exitA.text.toString();
						_choiceB.caption = _currentDialog.exitB.text.toString();
					}else{
						_choiceA.caption = _currentDialog.exitA.text.toString();
						_choiceB.caption = ">>" + _currentDialog.exitB.text.toString();
					}
					
					_choiceA.refresh();
					_choiceB.refresh();
				}
			}
		}
		
		override protected function OnTalk(value:Number):void{
			if(_currentConversation){
				if(value == 0){
					if(state == SCROLLING){
						state = DONE_SCROLLING;
					}else{
						if(_currentDialog.exit && _currentDialog.exit != ""){
							endTalk();
						}else{
							nextTalk();
						}
					}
					
				}
			}
		}
		
		override protected function OnUp(value:Number):void{
			if(_currentDialog && _currentDialog.isMultipleChoice){
				if(value == 0){
					_currentChoice = 0;
					
					PBE.log(this, "Current choice: " + _currentChoice);
				}
			}
		}
		
		override protected function OnDown(value:Number):void{
			if(_currentDialog && _currentDialog.isMultipleChoice){
				if(value == 0){
					_currentChoice = 1;					
					PBE.log(this, "Current choice: " + _currentChoice);
				}
			}
		}
		
		override protected function onAdd():void{
			super.onAdd();
					
			_textField = new PBLabel();
			_textField.fontColor = 0x000000;
			_choiceA = new PBLabel();
			_choiceB = new PBLabel();
			_choiceA.fontColor = 0x000000;
			_choiceB.fontColor = 0x000000;
			_choiceA.visible = false;
			_choiceB.visible = false;
			_choiceA.caption = "Choice A";
			_choiceB.caption = "Choice B";
			_choiceA.refresh();
			_choiceB.refresh();
			
			_choiceA.x = 50;
			_choiceA.y = 60;
			_choiceA.width = 400;
			_choiceB.x = 50;
			_choiceB.y = 90;
			_choiceB.width = 400;
		
			if(actorIndexReference){
				_textField.width = 480;
				_textField.x = 120;
				_textField.y = 15;
				_textField.fontSize = 18;
			}else{
				_textField.width = 500;
				_textField.x = 20;
				_textField.y = 15;
				_textField.fontSize = 23;
			}
			//var displayObject:Sprite = owner.getProperty(displayObjectProperty) as Sprite;
			//displayObject.addChild(_textField);
			
			_arrowInitPosition = owner.getProperty(arrowPositionProperty);
			_arrowPosition = _arrowInitPosition.clone();
			
			owner.eventDispatcher.addEventListener(TalkEvent.START_TALK, onStartedTalking);
			//owner.eventDispatcher.addEventListener(TalkEvent.NEXT_TALK, onNextTalk);
			
		}
		
		override protected function onRemove():void{
			super.onRemove();
		}
		
		private var _displayObject:Sprite;
		
		private var _arrowPosition:Point;
		private var _maxArrowDown:int = 5;
		private var _arrowDownCount:int = 0;
		private var _arrowInitPosition:Point;
		
		private var _currentConversation:Conversation;
		private var _textOnScreen:String;
		private var _count:int = 0;
		private var _currentDialog:Dialog;
		private var _textField:PBLabel;
		private var _choiceA:PBLabel;
		private var _choiceB:PBLabel;
		private var _choiceAText:String;
		private var _choiceBText:String;
		
		private var _currentChoice:int = 0;
		
	}
}