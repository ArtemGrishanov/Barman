package com.flashmedia.gui
{
	import flash.events.Event;

	public class ComboBoxEvent extends Event
	{
		public static const ITEM_SELECT:String = 'ITEM_SELECT';
		public function ComboBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}