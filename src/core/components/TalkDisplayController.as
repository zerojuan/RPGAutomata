package core.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.ui.PBLabel;
	
	import core.components.events.RPGActionEvent;
	import core.components.events.TalkEvent;
	import core.components.keyboard.BasicInputController;
	import core.rpg.Conversation;
	import core.rpg.Dialog;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * Controller for the scrolling text display
	 * 
	 * @author Julius
	 */
	public class TalkDisplayController extends BasicInputController
	{
		public var displayObjectProperty:PropertyReference;
		public var actorIndexReference:PropertyReference;
		public var arrowPositionProperty:PropertyReference;		
		
		/**
		 * URL string of the sound that plays when talking
		 */
		public var talkSound:String;
		/**
		 * Reference to the DialogManager. Needed to access the dialogs using ids
		 */
		public var dialogManager:DialogManager;
		/**
		 * Controls the alpha visibility of the bottom arrow
		 */
		public var arrowAlpha:int = 0;
		/**
		 * Controls the alpha visibility of the panel background
		 */
		public var talkAlpha:int = 0;
		
		/**
		 * State constants
		 */
		private static const HIDDEN:int = 0;
		private static const SCROLLING:int = 1;
		private static const DONE_SCROLLING:int = 2;
	
		private var state:int = HIDDEN;				
		
		/**
		 * Event handler when someone triggered a started talking event
		 * Sets the current conversation tree then 
		 * gets the starting dialog of the tree.
		 * Automatically starts the scrolling phase.
		 */
		private function onStartedTalking(evt:TalkEvent):void{
			Logger.info(this, "onStartedTalking", "Started a conversation at " + evt.conversation.charId);
			_currentConversation = evt.conversation;
			_currentDialog = dialogManager.dialogLibrary[_currentConversation.getDialogId()];
			
			initDisplay();
		}
		/**
		 * Go to next dialog in the conversation tree
		 */
		private function nextTalk():void{
			//Pick next talk. Assume that the first choice is the default
			var nextId:String = _currentDialog.exitA.id;			
			if(_currentDialog.isMultipleChoice){				
				if(_currentChoice == 0){
					nextId = _currentDialog.exitA.id;
				}else{
					nextId = _currentDialog.exitB.id;
				}
			}
			Logger.info(this, "nextTalk", "Next talk: " + nextId);
			
			//Get the next dialog from the DialogManager
			_currentDialog = dialogManager.dialogLibrary[nextId];
			initDisplay();
		}
		/**
		 * Called when the conversation tree is over.
		 * Dispatches an RPGActionEvent.END_ACTION event
		 */
		private function endTalk():void{
			Logger.info(this, "endTalk", "Dialog ended at: " + _currentDialog.exit);
			arrowAlpha = 0;
			talkAlpha = 0;
			state = HIDDEN;
			owner.eventDispatcher.dispatchEvent(new RPGActionEvent(RPGActionEvent.END_ACTION, null, _currentDialog.exit));
		}
		/**
		 * Play the beeping talk sound
		 */
		private function updateSound(tickRate:Number):void{
			_timeSinceLastSound += tickRate;
			if(_timeSinceLastSound > .05){
				PBE.soundManager.play(talkSound);
				_timeSinceLastSound = 0;
			}
		}
		/**
		 * Reset the display. Setting it ready for scrolling
		 */
		private function initDisplay():void{
			_scrollCount = 0;
			_textOnScreen = "";
			_choiceA.visible = false;
			_choiceB.visible = false;
			state = SCROLLING;
			talkAlpha = 1;
		}
		/**
		 * Hackish way to add the textfields to the display list
		 * <p>Tries to check if there is a display object ready. If there is
		 * then add the textfields. If not, then try again next tick. </p>
		 */
		private function addToDisplayList():void{
			if(_displayObject==null){
				_displayObject = owner.getProperty(displayObjectProperty) as Sprite;
				if(_displayObject){
					_displayObject.addChild(_textField);
					_displayObject.addChild(_choiceA);
					_displayObject.addChild(_choiceB);
				}else{
					PBE.callLater(addToDisplayList);
				}
			}
		}
		
		override public function onTick(tickRate:Number):void{
			if(state == SCROLLING){
				_textOnScreen = _currentDialog.text.substring(0,_scrollCount);
				_scrollCount+=1;
				_textField.caption = _textOnScreen;
				_textField.refresh();
				if(talkSound){
					updateSound(tickRate);
				}
				arrowAlpha = 0;
				if(_scrollCount > _currentDialog.text.length){
					state = DONE_SCROLLING;
				}
			}else if(state == DONE_SCROLLING){
				_textOnScreen = _currentDialog.text;
				_textField.caption = _textOnScreen;
				_textField.refresh();
				arrowAlpha = 1;
				_arrowPosition.y+=1; //animate the arrow position, to bob up and down
				_arrowDownCount++;
				if(_arrowDownCount > _maxArrowDown){
					_arrowDownCount = 0;
					_arrowPosition.y = _arrowInitPosition.y;
				}
				owner.setProperty(arrowPositionProperty, _arrowPosition);
				if(_currentDialog.isMultipleChoice){ //if multiple choice, show choices
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
		/**
		 * Overriden from BasicInputController. Called whenever the talk button is pressed.
		 */
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
		/**
		 * Used for moving the choice cursor
		 */
		override protected function OnUp(value:Number):void{
			if(_currentDialog && _currentDialog.isMultipleChoice){
				if(value == 0){
					_currentChoice = 0;
				}
			}
		}
		/**
		 * Used for moving the choice cursor
		 */
		override protected function OnDown(value:Number):void{
			if(_currentDialog && _currentDialog.isMultipleChoice){
				if(value == 0){
					_currentChoice = 1;					
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
			
			addToDisplayList();
			//owner.eventDispatcher.addEventListener(TalkEvent.NEXT_TALK, onNextTalk);
			
		}
		
		override protected function onRemove():void{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(TalkEvent.START_TALK, onStartedTalking);
		}
		
		private var _displayObject:Sprite;
		
		/**
		 * Used for animating the arrow image
		 */
		private var _arrowPosition:Point;
		private var _maxArrowDown:int = 5;
		private var _arrowDownCount:int = 0;
		private var _arrowInitPosition:Point;
		
		private var _currentConversation:Conversation;
		private var _textOnScreen:String;
		private var _scrollCount:int = 0; 
		private var _currentDialog:Dialog;
		private var _textField:PBLabel;
		private var _choiceA:PBLabel;
		private var _choiceB:PBLabel;
		private var _choiceAText:String;
		private var _choiceBText:String;
		
		/**
		 * Used to space the sound beeps accordingly
		 */
		private var _timeSinceLastSound:Number = 0;
		/**
		 * The user's current choice
		 */
		private var _currentChoice:int = 0;
		
	}
}