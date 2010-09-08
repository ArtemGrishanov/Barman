package com.bar.ui.panels
{
	import com.bar.model.essences.Production;
	
	import flash.events.Event;

	public class ClientOrderPanelEvent extends Event
	{
		public static const EVENT_CANCEL: String = 'cancel';
		public static const EVENT_PRODUCTION_ADDED: String = 'production_added';
		
		public var production: Production;
		
		public function ClientOrderPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}