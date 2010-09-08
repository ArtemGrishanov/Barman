package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObjectEvent;

	public class GridBoxEvent extends GameObjectEvent
	{
		public static const TYPE_ITEM_DOUBLECLICK: String = 'type_item_doubleclick';
		public static const TYPE_ITEM_SELECTED: String = 'type_item_selected';
		public static const TYPE_SCROLL: String = 'type_scroll';
		
		private var _item:*;
		private var _columnIndex: uint;
		private var _rowIndex: uint;
		
		public function GridBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set item(value:*): void {
			_item = value;
		}
		
		public function get item(): * {
			return _item;
		}
		
		public function set columnIndex(value: uint): void {
			_columnIndex = value;
		}
		
		public function get columnIndex(): uint{
			return _columnIndex;
		}
		
		public function set rowIndex(value: uint): void {
			_rowIndex = value;
		}
		
		public function get rowIndex(): uint{
			return _rowIndex;
		}
	}
}