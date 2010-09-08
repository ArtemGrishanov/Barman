package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Button extends GameObject
	{
		private static const HORIZONTAL_INDENT:uint = 10;
		private static const VERTICAL_INDENT:uint = 5;
		
		public var paginationIndex:int;
		
		protected var _state:uint = CONTROL_STATE_NORMAL;
		
		protected var _normalStateBackgroundColor:uint;
		protected var _highlightedStateBackgroundColor:uint;
		protected var _useHighlightedStateBackgroundColor:Boolean = false;
		
		protected var _normalStateTitle:String = "";
		protected var _highlightedStateTitle:String;
		protected var _useHighlightedStateTitle:Boolean = false;
		
		protected var _normalStateTextFormat:TextFormat;
		protected var _highlightedStateTextFormat:TextFormat;
		
		protected var _normalStateBackgroundImage:Bitmap;
		protected var _highlightedStateBackgroundImage:Bitmap;
		
		public function Button(value:GameScene, x:uint=0, y:uint=0, width:uint=50, height:uint=20)
		{
			super(value);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			setTextField(new TextField());
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			
			setTextFormatForState(new TextFormat("Times New Roman", 12), CONTROL_STATE_NORMAL);
			setBackgroundColorForState(0xa0a0ff, CONTROL_STATE_NORMAL);
			
			setSelect(true);
			
			useHandCursor = true;
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		public function setTextPosition(x:int, y:int):void {
			setTextField(_textField, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE);
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.x = x;
			_textField.y = y;
			
			update();
		}
		
		public function setBackgroundImageForState(image:Bitmap, state:uint):void {
			if (image) {
				autoSize = true;
				clearBackground();
				
				switch (state) {
					case CONTROL_STATE_NORMAL:
						_normalStateBackgroundImage = image;
					break;
					case CONTROL_STATE_HIGHLIGHTED:
						_highlightedStateBackgroundImage = image;
					break;
				}
				update();
			}
		}
		
		public function backgroundImageForState(state:uint):Bitmap {
			switch (state) {
				case CONTROL_STATE_HIGHLIGHTED:
					return _highlightedStateBackgroundImage;
				case CONTROL_STATE_NORMAL:
				default:
					return _normalStateBackgroundImage;
			}
		}
		
		public function setBackgroundColorForState(color:uint, state:uint):void {
			switch (state) {
				case CONTROL_STATE_NORMAL:
					_normalStateBackgroundColor = color;
				break;
				case CONTROL_STATE_HIGHLIGHTED:
					_useHighlightedStateBackgroundColor = true;
					_highlightedStateBackgroundColor = color;
				break;
			}
			update();
		}
		
		public function backgroundColorForState(state:uint):uint {
			switch (state) {
				case CONTROL_STATE_HIGHLIGHTED:
					return _highlightedStateBackgroundColor;
				case CONTROL_STATE_NORMAL:
				default:
					return _normalStateBackgroundColor;
			}
		}
		
		public function setTitleForState(title:String, state:uint):void {
			if (title) {
				var field:TextField = new TextField();
				field.autoSize = TextFieldAutoSize.LEFT;
				var textWidth:uint;
				var textHeight:uint;
						
				switch (state) {
					case CONTROL_STATE_NORMAL:
						_normalStateTitle = title;
						field.text = _normalStateTitle;
						field.setTextFormat(_normalStateTextFormat);
					break;
					case CONTROL_STATE_HIGHLIGHTED:
						_useHighlightedStateTitle = true;
						_highlightedStateTitle = title;
						field.text = _highlightedStateTitle;
						field.setTextFormat(_highlightedStateTextFormat);
					break;
				}
				
				textWidth = field.width + HORIZONTAL_INDENT*2;
				textHeight = field.height + VERTICAL_INDENT*2;
				
				if (width < textWidth) width = textWidth;
				if (height < textHeight) height = textHeight;
				field = null;
				
				update();
			}
		}
		
		public function titleForState(state:uint):String {
			switch (state) {
				case CONTROL_STATE_HIGHLIGHTED:
					return _highlightedStateTitle;
				case CONTROL_STATE_NORMAL:
				default:
					return _normalStateTitle;
			}
		}
		
		public function setTextFormatForState(format:TextFormat, state:uint):void {
			switch (state) {
				case CONTROL_STATE_NORMAL:
					_normalStateTextFormat = format;
				break;
				case CONTROL_STATE_HIGHLIGHTED:
					_highlightedStateTextFormat = format;
				break;
			}
			update();
		}
		
		public function textFormatForState(state:uint):TextFormat {
			switch (state) {
				case CONTROL_STATE_HIGHLIGHTED:
					return _highlightedStateTextFormat;
				case CONTROL_STATE_NORMAL:
				default:
					return _normalStateTextFormat;
			}
		}
		
		public function update():void {
			switch (_state) {
				case CONTROL_STATE_NORMAL:
					if (_normalStateBackgroundImage) {
						bitmap = _normalStateBackgroundImage;
					}
					else {
						fillBackground(_normalStateBackgroundColor, 1.0);
					}
					
					textField.text = _normalStateTitle;
					textField.setTextFormat(_normalStateTextFormat);
				break;
				case CONTROL_STATE_HIGHLIGHTED:
					if (_highlightedStateBackgroundImage || _normalStateBackgroundImage) {
						bitmap = (_highlightedStateBackgroundImage) ? _highlightedStateBackgroundImage : _normalStateBackgroundImage;
					}
					else {
						if (_useHighlightedStateBackgroundColor) {
							fillBackground(_highlightedStateBackgroundColor, 1.0);
						}
						else {
							fillBackground(_normalStateBackgroundColor, 1.0);
						}
					}
					textField.text = (_highlightedStateTitle) ? _highlightedStateTitle : _normalStateTitle;
					textField.setTextFormat((_highlightedStateTitle) ? _highlightedStateTextFormat : _normalStateTextFormat);
				break;
			}
		}
		
		protected function mouseDownListener(event: MouseEvent): void {
			_state = CONTROL_STATE_HIGHLIGHTED;
			update();
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			_state = CONTROL_STATE_NORMAL;
			update();
		}
		
		protected function mouseUpListener(event: MouseEvent): void {
			_state = CONTROL_STATE_NORMAL;
			update();
		}

		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_state = CONTROL_STATE_NORMAL;
			update();
		}
	}
}