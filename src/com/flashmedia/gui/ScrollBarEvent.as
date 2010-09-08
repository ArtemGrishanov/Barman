package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObjectEvent;
	
	public class ScrollBarEvent extends GameObjectEvent
	{
		public static const TYPE_SCROLL: String = 'type_item_selected';
		
		private var _position: Number;
		
		public function ScrollBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function set position(value: Number): void {
			_position = value;
		}
		
		public function get position(): Number {
			return _position;
		}
	}
}