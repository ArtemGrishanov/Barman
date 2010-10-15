package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	//TODO удаление компонентов с GridBox
	//TODO при установке итема более тонкая настройка его фокуса, выделения и т.д
	public class GridBox extends Form
	{
		/**
		 * Высота ряда вычисляется на основании элемента с наибольшей высотой.
		 * Высота различных рядов может быть разной.
		 */
		public static const ROW_HEIGHT_POLICY_BY_MAX_CELL: String = 'row_height_policy_by_max_size';
		/**
		 * Высота всех рядов одинакова. Элемент с наибольшей высотой в GridBox будет определять высоту всех рядов.
		 */
		public static const ROW_HEIGHT_POLICY_ALL_SAME: String = 'row_height_policy_all_same';
		/**
		 * Ширина столбца вычисляется на основании элемента с наибольшей шириной.
		 * Ширина различных столбцов может быть разной.
		 */
		public static const COLUMN_WIDTH_POLICY_BY_MAX_CELL: String = 'column_width_policy_by_max_size';
		/**
		 * Ширина всех столбцов одинакова. Элемент с наибольшей шириной в GridBox будет определять ширину всех столбцов.
		 */
		public static const COLUMN_WIDTH_POLICY_ALL_SAME: String = 'column_width_policy_all_same';
		/**
		 * Ширина имеет абсолютное значение, заданное пользователем. Не зависит от содержимого.
		 * Если содержимое выходит за пределы, то возможна прокрутка.
		 */
		public static const WIDTH_POLICY_ABSOLUTE: String = 'width_policy_absolute';
		/**
		 * Ширина выставляется автоматически на основе содержимого.
		 */
		public static const WIDTH_POLICY_AUTO_SIZE: String = 'width_policy_auto_size';
		/**
		 * Ширина имеет абсолютное значение. Ячейки "пытаются" растянуться так, чтобы заполнить заданную ширину.
		 * Или "сжаться" так, чтобы уместиться в заданную пользователем ширину.
		 */
		public static const WIDTH_POLICY_STRETCH_BY_WIDTH: String = 'width_policy_stretch_by_width';
		/**
		 * Высота имеет абсолютное значение, заданное пользователем. Не зависит от содержимого.
		 * Если содержимое выходит за пределы, то возможна прокрутка.
		 */
		public static const HEIGHT_POLICY_ABSOLUTE: String = 'height_policy_absolute';
		/**
		 * Высота выставляется автоматически на основе содержимого.
		 */
		public static const HEIGHT_POLICY_AUTO_SIZE: String = 'height_policy_auto_size';
		/**
		 * Высота имеет абсолютное значение. Ячейки "пытаются" растянуться так, чтобы заполнить заданную высоту.
		 * Или "сжаться" так, чтобы уместиться в заданную пользователем высоту.
		 */
		public static const HEIGHT_POLICY_STRETCH_BY_HEIGHT: String = 'height_policy_stretch_by_height';
		
		protected static const PADDING_ITEM: uint = 5;
		protected static const INDENT_BETWEEN_ITEMS: uint = 5;
		
		protected static const COLUMNS_DEF_COUNT: uint = 8;
		protected static const ROWS_DEF_COUNT: uint = undefined;
		
		protected var _maxColumnsCount: uint;
		protected var _maxRowsCount: uint;
		protected var _selectedItem: *;
		protected var _selectedColumnIndex: uint;
		protected var _selectedRowIndex: uint;
		
		protected var _maxItemWidth: uint;
		protected var _maxItemHeight: uint;
		/**
		 * padding - расстояние (отступ) от границы ячейки (выделения) до содержимого ячейки (GameObject)
		 */
		protected var _paddingItemLeft: uint;
		protected var _paddingItemTop: uint;
		protected var _paddingItemRight: uint;
		protected var _paddingItemBottom: uint;
		protected var _indentBetweenCols: uint;
		protected var _indentBetweenRows: uint;
		protected var _horizontalItemsAlign: int;
		protected var _verticalItemsAlign: int;
		protected var _rowHeightPolicy: String;
		protected var _columnWidthPolicy: String;
		protected var _widthPolicy: String;
		protected var _heightPolicy: String;
		
		protected var _items: Array;
		protected var _gameObjects: Array;
//		protected var _originGameObjectWidth: Array;
//		protected var _originGameObjectHeight: Array;
		protected var _columnsWidth: Array;
		protected var _rowsHeight: Array;
		protected var _textFormat: TextFormat;
		protected var _embed:Boolean = false;
		protected var _antiAliasType:String = AntiAliasType.NORMAL;
		
		protected var _focusItemsFillColor: int;
		protected var _focusItemsFillAlpha: Number;
		protected var _focusItemsBorderColor: int;
		protected var _focusItemsBorderAlpha: Number;
		protected var _hoverItemsFillColor: int;
		protected var _hoverItemsFillAlpha: Number;
		protected var _hoverItemsBorderColor: int;
		protected var _hoverItemsBorderAlpha: Number;
		
		public function GridBox(value:GameScene, maxColumnsCount: uint = COLUMNS_DEF_COUNT, maxRowsCount: uint = ROWS_DEF_COUNT)
		{
			super(value, 0, 0, 100, 100);
			_focusItemsFillColor = FOCUS_COLOR;
			_focusItemsFillAlpha = FOCUS_ALPHA;
			_focusItemsBorderColor = FOCUS_COLOR;
			_focusItemsBorderAlpha = 1;
			_hoverItemsFillColor = HOVER_COLOR;
			_hoverItemsFillAlpha = HOVER_ALPHA;
			_hoverItemsBorderColor = HOVER_COLOR;
			_hoverItemsBorderAlpha = 1;
			_paddingLeft = 0;
			_paddingTop = 0;
			_paddingBottom = 0;
			_paddingRight = 0
			_items = new Array();
			_gameObjects = new Array();
//			_originGameObjectWidth = new Array();
//			_originGameObjectHeight = new Array();
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			_selectedColumnIndex = undefined;
			_selectedRowIndex = undefined;
			_maxColumnsCount = maxColumnsCount;
			_maxRowsCount = maxRowsCount;
			_maxItemWidth = undefined;
			_maxItemHeight = undefined;
			_paddingItemLeft = PADDING_ITEM;
			_paddingItemTop = PADDING_ITEM;
			_paddingItemRight = PADDING_ITEM;
			_paddingItemBottom = PADDING_ITEM;
			_indentBetweenCols = INDENT_BETWEEN_ITEMS;
			_indentBetweenRows = INDENT_BETWEEN_ITEMS;
			_horizontalItemsAlign = View.ALIGN_HOR_CENTER;
			_verticalItemsAlign = View.ALIGN_VER_CENTER;
			_rowHeightPolicy = ROW_HEIGHT_POLICY_BY_MAX_CELL;
			_columnWidthPolicy = COLUMN_WIDTH_POLICY_BY_MAX_CELL;
			_widthPolicy = WIDTH_POLICY_AUTO_SIZE;
			_heightPolicy = HEIGHT_POLICY_AUTO_SIZE;
		}
		
		public function addItem(value: *, go: GameObject = null): void {
			_items.push(value);
			var g: GameObject = (go) ? go : createGameObject(value);
			g.setFocusColor(_focusItemsFillColor, _focusItemsFillAlpha, _focusItemsBorderColor, _focusItemsBorderAlpha);
			g.setHoverColor(_hoverItemsFillColor, _hoverItemsFillAlpha, _hoverItemsBorderColor, _hoverItemsBorderAlpha);
			g.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
			g.addEventListener(GameObjectEvent.TYPE_MOUSE_DOUBLECLICK, itemMouseDoubleClickListener);
			_gameObjects.push(g);
			updateLayout(true, true);
		}
		
		public function changeItem(oldItem: *, newItem: *, newGo: GameObject = null): void {
			for (var i: int = 0; i < _items.length; i++) {
				if (_items[i] == oldItem) {
					_items[i] = newItem;
					removeComponent(_gameObjects[i]);
					_gameObjects[i] = null;
					_gameObjects[i] = (newGo) ? newGo : createGameObject(newItem);
					(_gameObjects[i] as GameObject).setFocusColor(_focusItemsFillColor, _focusItemsFillAlpha, _focusItemsBorderColor, _focusItemsBorderAlpha);
					(_gameObjects[i] as GameObject).setHoverColor(_hoverItemsFillColor, _hoverItemsFillAlpha, _hoverItemsBorderColor, _hoverItemsBorderAlpha);
					_gameObjects[i].addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, itemMouseClickListener);
					_gameObjects[i].addEventListener(GameObjectEvent.TYPE_MOUSE_DOUBLECLICK, itemMouseDoubleClickListener);
				}
			}
			updateLayout(true, true);
		}
		
		public function setItemsHoverColor(fillColor: int, fillAlpha: Number, borderColor: int, borderAlpha: Number): void {
			_hoverItemsFillColor = fillColor;
			_hoverItemsFillAlpha = fillAlpha;
			_hoverItemsBorderColor = borderColor;
			_hoverItemsBorderAlpha = borderAlpha;
			for (var i: int = 0; i < _gameObjects.length; i++) {
				(_gameObjects[i] as GameObject).setHoverColor(fillColor, fillAlpha, borderColor, borderAlpha);
			}
		}
		
		public function setItemsFocusColor(fillColor: int, fillAlpha: Number, borderColor: int, borderAlpha: Number): void {
			_focusItemsFillColor = fillColor;
			_focusItemsFillAlpha = fillAlpha;
			_focusItemsBorderColor = borderColor;
			_focusItemsBorderAlpha = borderAlpha;
			for (var i: int = 0; i < _gameObjects.length; i++) {
				(_gameObjects[i] as GameObject).setFocusColor(fillColor, fillAlpha, borderColor, borderAlpha);
			}
		}
		
		public function removeAllItems(): void {
			_items = new Array();
			for each (var go: GameObject in _gameObjects) {
				removeComponent(go);
			}
			_gameObjects = new Array();
			updateLayout(true, true);
		}
		
		/**
		 * Список gameObjects - список визуальных объектов, содержимого GridBox 
		 */
		public function get gameObjects(): Array {
			return _gameObjects;
		}
		
		/**
		 * Выделенный объект GameObject.
		 */
		public function get selectedGameObject(): GameObject {
			var index: int = _items.indexOf(_selectedItem);
			if (index != -1) {
				return _gameObjects[index];
			}
			return null;
		}
		
		/**
		 * Список значений, установленных в GridBox.
		 * Не одно и тоже с gameObjects.
		 */
		public function get items(): Array {
			return _items;
		}
		
		/**
		 * Тукущее значение GridBox.
		 */
		public function get selectedItem(): * {
			return _selectedItem;
		}
		
		public function set selectedItem(value:*): void {
			var index: uint = _items.indexOf(value);
			if (index != -1) {
				selectItem(_gameObjects[index]);
			}
		}
		
//		public function setItemFocus(value: DisplayObject, layout: int = 0): void {
//			for each (var go: GameObject in _gameObjects) {
//				go.setFocus(true, true, value, layout);
//			}
//		}
		
		public function get selectedColumnIndex(): uint {
			return _selectedColumnIndex;
		}
		
		public function get selectedRowIndex(): uint {
			return _selectedRowIndex;
		}
		
		public function get columnsCount(): uint {
			if (!_columnsWidth) {
				return undefined;
			}
			return _columnsWidth.length;
		}
		
		public function get rowsCount(): uint {
			if (!_rowsHeight) {
				return undefined;
			}
			return _rowsHeight.length;
		}
		
		public function getColumnWidth(value: uint): uint {
			if (!_columnsWidth[value]) {
				return undefined;
			}
			return _columnsWidth[value];// + 2 * _paddingItem;
		}
		
		public function getRowHeight(value: uint): uint {
			if (!_rowsHeight[value]) {
				return undefined;
			}
			return _rowsHeight[value];// + 2 * _paddingItem;
		}
		
		public function setPaddings(left: uint, top: uint, right: uint, bottom: uint): void {
			_paddingItemLeft = left;
			_paddingItemTop = top;
			_paddingItemRight = right;
			_paddingItemBottom = bottom;
			updateLayout(true, true);
		}
		
		public function set indentBetweenCols(value: uint): void {
			_indentBetweenCols = value;
			updateLayout(true, true);
		}
		
		public function set indentBetweenRows(value: uint): void {
			_indentBetweenRows = value;
			updateLayout(true, true);
		}
		
		public function set horizontalItemsAlign(value: int): void {
			_horizontalItemsAlign = value;
			updateLayout(true, true);
		}
		
		public function set verticalItemsAlign(value: int): void {
			_verticalItemsAlign = value;
			updateLayout(true, true);
		}
		
		public function set columnWidthPolicy(value: String): void {
			_columnWidthPolicy = value;
			updateLayout(true, true);
		}
		
		public function set rowHeightPolicy(value: String): void {
			_rowHeightPolicy = value;
			updateLayout(true, true);
		}
		
		public function set widthPolicy(value: String): void {
			_widthPolicy = value;
			updateLayout(true, false);
		}
		
		public function set heightPolicy(value: String): void {
			_heightPolicy = value;
			updateLayout(false, true);
		}
		
//		public function set textFormat(value: TextFormat): void {
//			if (value) {
//				_textFormat = value;
//				if (_textField) {
//					_textField.setTextFormat(_textFormat);
//				}
//				for each (var go: GameObject in _gameObjects) {
//					if (go is Label) {
//						(go as Label).textFormat = _textFormat;
//					}
//				}
//				updateLayout(true, true);
//			}
//		}

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
				
				for each (var go: GameObject in _gameObjects) {
					var label:Label;
					
					if (go is Label) {
						label = (go as Label);
						label.setTextFormat(_textFormat, _embed, _antiAliasType);
					}
				}
				updateLayout(true, true);
			}
		}
		
		private function updateLayout(updWidthPolicy: Boolean = false, updHeightPolicy: Boolean = false): void {
			_columnsWidth = new Array();
			_rowsHeight = new Array();
			var curCol: uint = 0;
			var curRow: uint = 0;
			// рассчет размеров колонок и рядов
			for (var i: uint; i < _gameObjects.length; i++) {
				var goWidth: uint = (_gameObjects[i] as GameObject).width;
				var goHeight: uint = (_gameObjects[i] as GameObject).height;
				if (_maxColumnsCount && curCol >= _maxColumnsCount) {
					curCol = 0;
					curRow++;
				}
				if (_maxRowsCount && curRow >= _maxRowsCount) {
					break;
				}
				switch (_columnWidthPolicy) {
					case COLUMN_WIDTH_POLICY_ALL_SAME:
						if (!_columnsWidth[curCol]) {
							if (curCol == 0) {
								_columnsWidth[curCol] = 0;
							}
							else {
								_columnsWidth[curCol] = _columnsWidth[0];
							}
						}
						if ((goWidth + _paddingItemLeft + _paddingItemRight) > _columnsWidth[0]) {
							for (var c: uint = 0; c < columnsCount; c++) {
								_columnsWidth[c] = goWidth + _paddingItemLeft + _paddingItemRight;
							}
						}
					break;
					default:
					case COLUMN_WIDTH_POLICY_BY_MAX_CELL:
						if (!_columnsWidth[curCol]) {
							_columnsWidth[curCol] = 0;
						}
						if ((goWidth + _paddingItemLeft + _paddingItemRight) > _columnsWidth[curCol]) {
							_columnsWidth[curCol] = goWidth + _paddingItemLeft + _paddingItemRight;
						}
					break;
				}
				switch (_rowHeightPolicy) {
					case ROW_HEIGHT_POLICY_ALL_SAME:
						if (!_rowsHeight[curRow]) {
							if (curRow == 0) {
								_rowsHeight[curRow] = 0;
							}
							else {
								_rowsHeight[curRow] = _rowsHeight[0];
							}
						}
						if ((goHeight + _paddingItemTop + _paddingItemBottom) > _rowsHeight[0]) {
							for (var r: uint = 0; r < rowsCount; r++) {
								_rowsHeight[r] = goHeight + _paddingItemTop + _paddingItemBottom;
							}
						}
					break;
					default:
					case ROW_HEIGHT_POLICY_BY_MAX_CELL:
						if (!_rowsHeight[curRow]) {
							_rowsHeight[curRow] = 0;
						}
						if ((goHeight + _paddingItemTop + _paddingItemBottom) > _rowsHeight[curRow]) {
							_rowsHeight[curRow] = goHeight + _paddingItemTop + _paddingItemBottom;
						}
					break;
				}
				curCol++;
			}
			// рассчет width и height на основе получившихся размеров ячеек
			var w: uint = 0;
			for (i = 0; i < columnsCount; i++) {
				w += getColumnWidth(i);
				if (i < columnsCount - 1) {
					w += _indentBetweenCols;
				}
			}
			var newWidth: uint = w;
			var h: uint = 0;
			for (i = 0; i < rowsCount; i++) {
				h += getRowHeight(i);
				if (i < rowsCount - 1) {
					h += _indentBetweenRows;
				}
			}
			var newHeight: uint = h;
			//изменение _rowsHeight _columnsWidth в соответствии с _widthPolicy _heightPolicy
			if (_columnsWidth.length > 0) {
				if (updWidthPolicy) {
					switch (_widthPolicy) {
						case WIDTH_POLICY_STRETCH_BY_WIDTH:
							var k: Number = width / newWidth;
							var realWidth: uint = 0;
							for (i = 0; i < _columnsWidth.length; i++) {
								_columnsWidth[i] = Math.round(_columnsWidth[i] * k);
								realWidth += _columnsWidth[i] + _paddingItemLeft + _paddingItemRight;
								if (i < _columnsWidth.length - 1) {
									realWidth += _indentBetweenCols;
								}
							}
							if (realWidth != width) {
								var l: uint = _columnsWidth.length - 1;
								_columnsWidth[l] = _columnsWidth[l] + (width - realWidth);
							}
						break;
						case WIDTH_POLICY_ABSOLUTE:
						
						break;
						case WIDTH_POLICY_AUTO_SIZE:
						default:
							width = newWidth;
						break;
					}
				}
			}
			else if (_widthPolicy == WIDTH_POLICY_AUTO_SIZE) {
				width = GameObject.MIN_WIDTH;
			}
			if (_rowsHeight.length > 0) {
				if (updHeightPolicy) {
					switch (_heightPolicy) {
						case HEIGHT_POLICY_STRETCH_BY_HEIGHT:
							k = height / newHeight;
							var realHeight: uint = 0;
							for (i = 0; i < _rowsHeight.length; i++) {
								_rowsHeight[i] = Math.round(_rowsHeight[i] * k);
								realHeight += _rowsHeight[i] + _paddingItemTop + _paddingItemBottom;
								if (i < _rowsHeight.length - 1) {
									realHeight += _indentBetweenRows;
								}
							}
							if (realHeight != height) {
								l = _rowsHeight.length - 1;
								_rowsHeight[l] = _rowsHeight[l] + (height - realHeight);
							}
						break;
						case HEIGHT_POLICY_ABSOLUTE:
						
						break;
						case HEIGHT_POLICY_AUTO_SIZE:
						default:
							height = newHeight;
						break;
					}
				}
			}
			else if (_widthPolicy == HEIGHT_POLICY_AUTO_SIZE) {
				height = GameObject.MIN_HEIGHT;
			}
			//_debugContainer.graphics.clear();
			for each(var go: GameObject in _gameObjects) {
				if (contains(go)) {
					//removeChild(go);
					removeComponent(go);
				}
			}
			// заполнение объектами
			curCol = 0;
			curRow = 0;
			var cellRectX: uint = 0;
			var cellRectY: uint = 0;
			for each(go in _gameObjects) {
				if (_maxColumnsCount && curCol >= _maxColumnsCount) {
					cellRectX = 0;
					curCol = 0;
					cellRectY += _rowsHeight[curRow] + _indentBetweenRows; // + 2 * _paddingItem
					curRow++;
				}
				if (_maxRowsCount && curRow >= _maxRowsCount) {
					return;
				}
				//go.x = cellRectX + _paddingItem;
				//go.y = cellRectY + _paddingItem;
				//go.width = _columnsWidth[curCol];
				//go.height = _rowsHeight[curRow];
//				go.textHorizontalAlign = _horizontalItemsAlign;
//				go.textVerticalAlign = _verticalItemsAlign;
				switch (_horizontalItemsAlign) {
					case View.ALIGN_HOR_LEFT:
						go.x = cellRectX + _paddingItemLeft;
					break;
					case View.ALIGN_HOR_RIGHT:
						go.x = cellRectX + _columnsWidth[curCol] - go.width;
					break;
					default:
					case View.ALIGN_HOR_CENTER:
						go.x = cellRectX + (_columnsWidth[curCol] - go.width) / 2; //+ _paddingItem
					break;
				}
				switch (_verticalItemsAlign) {
					case View.ALIGN_VER_TOP:
						go.y = cellRectY + _paddingItemTop;
					break;
					case View.ALIGN_VER_BOTTOM:
						go.y = cellRectY + _rowsHeight[curRow] - go.height;
					break;
					default:
					case View.ALIGN_VER_CENTER:
						go.y = cellRectY + (_rowsHeight[curRow] - go.height) / 2; // + _paddingItem
					break;
				}
				//go.setSelect(true, false, null, new Rectangle(cellRectX - go.x + _paddingItem, cellRectY - go.y + _paddingItem, _columnsWidth[curCol], _rowsHeight[curRow]));
				go.setSelect(true, false, null, new Rectangle(cellRectX - go.x, cellRectY - go.y, _columnsWidth[curCol] + _paddingItemRight + _paddingItemLeft, _rowsHeight[curRow]));
				addComponent(go);
				//addChild(go);
				cellRectX += _columnsWidth[curCol] + _indentBetweenCols; //2 * _paddingItem +
				curCol++;
			}
		}
		
		private function itemMouseClickListener(event: GameObjectEvent): void {
			selectItem(event.gameObject);
		}
		
		protected function selectItem(value: GameObject): void {
			var index: int = _gameObjects.indexOf(value);
			if (index != -1) {
				_selectedItem = _items[index];
				_selectedRowIndex = index / columnsCount;
				//_selectedColumnIndex = index - (_selectedRowIndex * columnsCount);
				_selectedColumnIndex = index % columnsCount;
				var gbEvent: GridBoxEvent = new GridBoxEvent(GridBoxEvent.TYPE_ITEM_SELECTED);
				gbEvent.gameObject = value;
				gbEvent.item = _items[index];
				gbEvent.columnIndex = _selectedColumnIndex;
				gbEvent.rowIndex = _selectedRowIndex;
				dispatchEvent(gbEvent);
			}
		}
		
		protected function itemMouseDoubleClickListener(event: GameObjectEvent): void {
			selectItem(event.gameObject);
			var gbEvent: GridBoxEvent = new GridBoxEvent(GridBoxEvent.TYPE_ITEM_DOUBLECLICK);
			gbEvent.gameObject = event.gameObject;
			gbEvent.item = _selectedItem;
			gbEvent.columnIndex = _selectedColumnIndex;
			gbEvent.rowIndex = _selectedRowIndex;
			dispatchEvent(gbEvent);	
		}
		
		private function createGameObject(value: *): GameObject {
			if (value is Number) {
				value = value.toString();
			}
			if (value is String) {
				var label: Label = new Label(scene, value);
				if (_textFormat) {
					label.setTextFormat(_textFormat, _embed, _antiAliasType);
				}
				label.setSelect(true);
				label.setHover(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				label.setFocus(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				return label;
			}
			else if (value is Bitmap) {
				var go: GameObject = new GameObject(scene);
				go.bitmap = value;
				go.width = value.width;
				go.height = value.height;
				go.setSelect(true);
				go.setHover(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				go.setFocus(true, true, null, View.ALIGN_HOR_NONE | View.ALIGN_VER_NONE, GameObject.SIZE_MODE_SELECT);
				return go;
			}
			else if (value is GameObject) {
				value.setSelect(true);
//				value.setFocus(true, true, null, GameObject.SIZE_MODE_SELECT);
//				value.setHover(true, true, null, GameObject.SIZE_MODE_SELECT);
				return value;
			}
			else {
				throw ArgumentError('Illegal argument type');
			}
			return null;
		}
	}
}