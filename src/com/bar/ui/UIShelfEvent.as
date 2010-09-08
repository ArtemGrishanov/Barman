package com.bar.ui
{
	import com.flashmedia.basics.GameObject;
	
	import flash.events.Event;

	public class UIShelfEvent extends Event
	{
		public static const EVENT_PRODUCTION_PLACE_CHANGED: String = 'place_changed';
	
		public var gameObject: GameObject;
		public var rowIndex: int;
		public var cellIndex: int;
		
		public function UIShelfEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}