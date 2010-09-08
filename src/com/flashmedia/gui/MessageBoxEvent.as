package com.flashmedia.gui
{
	import flash.events.Event;

	public class MessageBoxEvent extends Event
	{
		public static const CANCEL_BUTTON_CLICKED: String = 'cancel_button_clicked';
		public static const OTHER_BUTTON_CLICKED: String = 'other_button_clicked';
		
		public function MessageBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}