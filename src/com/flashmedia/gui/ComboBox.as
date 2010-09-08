package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/*
		TODO сделать чтобы можно было добавлять любой объект. Сейчас только текст.
		TODO цвет фона дроп листа
		TODO произвольный тип данных в ComboBox
	*/
	public class ComboBox extends GameObject
	{
		private var _dropList: GridBox;
		private var _dropIcon: Bitmap;
		private var _savedZOrder: int;
		private var _textFormat: TextFormat;
		private var _horizontalAlign: int;
		private var _embed:Boolean = false;
		private var _antiAliasType:String = AntiAliasType.NORMAL;
		private var _bitmapCommon: Bitmap;
		private var _bitmapDropped: Bitmap;
		
		public function ComboBox(value:GameScene)
		{
			super(value);
			width = 100;
			height = 20;
			setSelect(true);
			setFocus(true, false);
			_bitmapCommon = null;
			_bitmapDropped = null;
//			canHover = true;
			//fillBackground(0xfafaff, 1.0);
			_horizontalAlign = View.ALIGN_HOR_LEFT;
			_dropList = new GridBox(value, 1);
			//_dropList.fillBackground(0xffffff, 1.0);
			_dropList.visible = false;
			_dropList.x = 0;
			_dropList.y = height;
			_dropList.widthPolicy = GridBox.WIDTH_POLICY_STRETCH_BY_WIDTH;
			_dropList.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
			_dropList.width = width;
			_dropList.setPaddings(0, 0, 10, 0);
			_dropList.indentBetweenCols = 0;
			_dropList.indentBetweenRows = 0;
			_dropList.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_dropList.verticalItemsAlign = View.ALIGN_VER_CENTER;
			_dropList.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, onItemClickListener);
			addChild(_dropList);
			updateComboBox();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			if (_dropList) {
				_dropList.width = width;
			}
		}
		
		public override function set height(value: Number): void {
			super.height = value;
			if (_dropList) {
				_dropList.y = height;
			}
		}
		
		public function setDropListHoverColor(fillColor: int, fillAlpha: Number, borderColor: int, borderAlpha: Number): void {
			_dropList.setItemsHoverColor(fillColor, fillAlpha, borderColor, borderAlpha);
		}
		
		public function clear():void {
			_dropList.removeAllItems();
		}
		
		public function addItem(value: String): void {
			_dropList.addItem(value);
			updateComboBox();
		}
		
		public function setTextFormat(value: TextFormat, embed:Boolean = false, antiAliasType:String = AntiAliasType.NORMAL): void {
			_embed = embed;
			_antiAliasType = antiAliasType;
				
			if (value) {
				_textFormat = value;
				
				if (_textField) {
					_textField.setTextFormat(_textFormat);
					_textField.embedFonts = _embed;
					_textField.antiAliasType = _antiAliasType;
				}
				_dropList.setTextFormat(_textFormat, _embed, _antiAliasType);
			}
		}
		
		/**
		 * Установить горизонтальное выравнивание.
		 * Выравнены будут объекты в главном окне и списке
		 */
		public function set horizontalAlign(value: int): void {
			_horizontalAlign = value;
			updateComboBox();
		}
		
		public override function set bitmap(value: Bitmap): void {
			clearBackground();
			super.bitmap = value;
			_bitmapCommon = value;
		}
		
		public function set bitmapDropped(value: Bitmap): void {
			_bitmapDropped = value;
		}
	
		public function get selectedIndex(): uint {
			return _dropList.selectedRowIndex;
		}
		
		public function set selectedItem(value: String): void {
			_dropList.selectedItem = value;
			updateComboBox();
		}
		
		public function get selectedItem(): * {
			return _dropList.selectedItem;
		}
		
		public override function set focus(value: Boolean): void {
			super.focus = value;
			if (!value) {
				_dropList.visible = false;
				updateBitmap();
				if (zOrder == GameObject.MAX_Z_ORDER) {
					zOrder = _savedZOrder;
				}
			}
		}
		
		public function set dropIcon(value: Bitmap): void {
			_dropIcon = value;
			var bd: BitmapData = null;
			var b: Bitmap = null;
			if (_bitmap) {
				bd = _bitmap.bitmapData;
				b = _bitmap;
			}
			else {
				bd = new BitmapData(width, height, true, undefined);
				b = new Bitmap(bd);
			}
			var m: Matrix = new Matrix(1, 0, 0, 1, width - value.width, 0);
			bd.draw(value, m);
			bitmap = b;
			
			var bdD: BitmapData = null;
			var bD: Bitmap = null;
			if (_bitmapDropped) {
				bdD = _bitmapDropped.bitmapData;
				bD = _bitmapDropped;
				bdD.draw(value, m);
				bitmapDropped = bD;
			}
			updateComboBox();
		}
		
		private function updateComboBox(): void {
			//пока только текст
			//TODO объект из _dropList копируется (клонируется) в область ComboBox, не заботясь о типе
			if (_dropList.selectedItem) {
				var tf: TextField = new TextField();
				tf.text = _dropList.selectedItem as String;
				if (_textFormat) {
					tf.setTextFormat(_textFormat);
					tf.embedFonts = _embed;
					tf.antiAliasType = _antiAliasType;
				}
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.width = width;
				tf.height = height;
				switch (_horizontalAlign) {
					case View.ALIGN_HOR_LEFT:
						tf.x = 0;
					break;
					case View.ALIGN_HOR_CENTER:
						tf.x = (width - tf.width - ((_dropIcon) ? _dropIcon.width: 0)) / 2;
					break;
					case View.ALIGN_HOR_RIGHT:
						tf.x = (width - tf.width - ((_dropIcon) ? _dropIcon.width: 0));
					break;
				}
				setTextField(tf, View.ALIGN_HOR_NONE | View.ALIGN_VER_CENTER);
			}
			_dropList.horizontalItemsAlign = _horizontalAlign;
			
			var mask: Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawRoundRect(0, -12, _dropList.width, _dropList.height + 12, 12);
			mask.graphics.endFill();
			var bd: BitmapData = new BitmapData(_dropList.width, _dropList.height, false, 0xffffff);
			var b: Bitmap = new Bitmap(bd);
			_dropList.bitmap = b;
			_dropList.bitmapMask = mask;
		}
		
		private function updateBitmap(): void {
			if (_bitmapDropped) {
				if (_dropList.visible) {
					super.bitmap = _bitmapDropped;
				}
				else {
					super.bitmap = _bitmapCommon;
				}
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_dropList.visible = !_dropList.visible;
			updateBitmap();
			if (_dropList.visible) {
				_savedZOrder = zOrder;
				zOrder = GameObject.MAX_Z_ORDER;
			}
			else {
				zOrder = _savedZOrder;
			}
		}
		
		private function onItemClickListener(event: GridBoxEvent): void {
			_dropList.visible = false;
			updateBitmap();
			zOrder = _savedZOrder;
			updateComboBox();
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.ITEM_SELECT));
		}
		
//		private function onDropIconClickListener(event: GameObjectEvent): void {
//			focus = true;
//			_dropList.visible = !_dropList.visible;
//		}
//		
//		private function onDropIconMouseHoverListener(event: GameObjectEvent): void {
//			hover = true;
//		}
//		
//		private function onDropIconMouseLostListener(event: GameObjectEvent): void {
//			hover = false;
//		}
	}
}