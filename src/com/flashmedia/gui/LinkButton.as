package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LinkButton extends GameObject
	{
		public var paginationIndex:int;
		
		protected var _normalStateTextFormat:TextFormat = new TextFormat();
		protected var _highlithedStateTextFormat:TextFormat;
		
		protected var _enabled:Boolean = true;
		protected var _state:uint = CONTROL_STATE_NORMAL;
				
		public function LinkButton(scene:GameScene, text:String=null, x:uint=0, y:uint=0, autoSize:String=TextFieldAutoSize.LEFT)
		{
			super(scene);
			
			setTextField(new TextField());
			textField.autoSize = autoSize;
			textField.selectable = false;
			textField.mouseEnabled = false;
			
			this.x = x;
			this.y = y;
			this.width = textField.width;
			this.height = textField.height;
			this.label = text;
			
			buttonMode = true;
			useHandCursor = true;
			setSelect(true);
		}
		
		private function update():void {
			switch (_state) {
				case CONTROL_STATE_NORMAL:
					textField.setTextFormat(_normalStateTextFormat);
				break;
				case CONTROL_STATE_HIGHLIGHTED:
					textField.setTextFormat(_highlithedStateTextFormat);
				break;
			}
			
			if (textField.autoSize == TextFieldAutoSize.LEFT) {
				width = textField.width;
				height = textField.height;
			}
		}
		
		public function set enabled(enable:Boolean):void {
			_enabled = enable;
			buttonMode = _enabled;
			useHandCursor = _enabled;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public override function set width(value: Number):void {
			super.width = value;
			if (textField && textField.wordWrap) update();
		}
		
		public function set wordWrap(wrap:Boolean): void {
			textField.wordWrap = wrap;
			update();
		}
		
		public function get label():String {
			return textField.text;
		}
		
		public function set label(text:String):void {
			var format:TextFormat = textField.getTextFormat();
			textField.text = text;
			textField.setTextFormat(format);
			update();
		}
		
		public function setTextFormatForState(format:TextFormat, state:uint):void {
			switch (state) {
				case CONTROL_STATE_NORMAL:
					_normalStateTextFormat = format;
				break;
				case CONTROL_STATE_HIGHLIGHTED:
					_highlithedStateTextFormat = format;
				break;
			}
			update();
		}
		
		public function getTextFormatForState(state:uint):TextFormat {
			switch (state) {
				case CONTROL_STATE_NORMAL:
					return _normalStateTextFormat;
				case CONTROL_STATE_HIGHLIGHTED:
					return _highlithedStateTextFormat;
			}
			return null;
		}
		
		protected override function mouseOverListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				if (_highlithedStateTextFormat) {
					_state = CONTROL_STATE_HIGHLIGHTED;
					update();
				}
			}
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			
			if (_enabled) {
				_state = CONTROL_STATE_NORMAL;
				update();
			}
		}
	}
}