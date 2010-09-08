package com.flashmedia.gui
{
	import com.flashmedia.basics.GameScene;
	
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class Memo extends Form
	{
		private var _textInput: TextField;
		
		public function Memo(value:GameScene, x:int, y:int, width:int, height:int)
		{
			super(value, x, y, width, height);
			fillBackground(0xffffff, 1.0);
			_textInput = new TextField();
			_textInput.autoSize = TextFieldAutoSize.LEFT;
			_textInput.selectable = true;
			_textInput.x = 0;
			_textInput.y = 0;
			_textInput.text = 'Input here';
			_textInput.width = width;
			_textInput.type = TextFieldType.INPUT;
			_textInput.multiline = true;
			_textInput.wordWrap = true;
			_textInput.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			addComponent(_textInput);
		}
		
		private function onTextInput(event: TextEvent): void {
			
		}
		
	}
}