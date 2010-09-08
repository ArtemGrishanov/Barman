package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends GameObject
	{
		public static const ICON_TEXT_DX: int = 5;
		
		private var _icon: Bitmap;
		private var _tf: TextField;
		private var _text: String;
		private var _textFormat: TextFormat;
		private var _embed:Boolean = false;
		private var _antiAliasType:String = AntiAliasType.NORMAL;
		
		public function Label(value: GameScene, text: String = '')
		{
			super(value);
//			debug = true;
			this.text = text;
		}
		
		public function set icon(value: Bitmap): void {
			if (!value && _icon) {
				_view.removeDisplayObject('icon');
			}
			_icon = value;
			update();
		}
		
		public function set text(value: String): void {
			if (!value && _tf) {
				_view.removeDisplayObject('text');
			}
			_text = value;
			update();
		}
		
		public function get text(): String {
			return _text;
		}
		
		public function setTextFormat(value: TextFormat, embed:Boolean = false, antiAliasType:String = AntiAliasType.NORMAL): void {
			_embed = embed;
			_antiAliasType = antiAliasType;
			
			if (value) {
				_textFormat = value;
				update();
			}
		}
		
		private function update(): void {
			//var xx: uint = 0;
			var w: uint = 0;
			var h: uint = 0;
			if (_icon) {
				if (!_view.contains('icon')) {
					_view.addDisplayObject(_icon, 'icon', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_CENTER | View.ALIGN_HOR_LEFT);
				}
				//xx += _icon.width;
				w += _icon.width + ICON_TEXT_DX;
				h = _icon.height;
			}
			if (_text) {
				if (!_tf) {
					_tf = new TextField();
					_tf.selectable = false;
					_tf.autoSize = TextFieldAutoSize.LEFT;
				}
				_tf.text = _text;
				if (_textFormat) {
					_tf.setTextFormat(_textFormat);
					_tf.embedFonts = _embed;
					_tf.antiAliasType = _antiAliasType;
				}
				if (!_view.contains('text')) {
					_view.addDisplayObject(_tf, 'text', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_CENTER | View.ALIGN_HOR_RIGHT);
				}
				//_tf.x = xx;
				if (h < _tf.height) {
					h = _tf.height;
				}
				//_tf.y = (h - _tf.textHeight) / 2;
				w += _tf.width;
			}
			width = w;
			height = h;
		}
	}
}