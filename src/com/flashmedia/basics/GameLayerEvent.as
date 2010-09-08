package com.flashmedia.basics
{
	public class GameLayerEvent extends GameObjectEvent
	{
		public static const TYPE_SCROLL: String = 'type_scroll';
		
		private var _horizontalPosition: Number;
		private var _verticalPosition: Number;
		
		public function GameLayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set horizontalPosition(value: Number): void {
			_horizontalPosition = value;
		}
		
		public function get horizontalPosition(): Number {
			return _horizontalPosition;
		}
		
		public function set verticalPosition(value: Number): void {
			_verticalPosition = value;
		}
		
		public function get verticalPosition(): Number {
			return _verticalPosition;
		}
	}
}