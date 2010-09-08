package com.bar.ui.panels
{
	import com.bar.model.essences.ProductionType;
	
	import flash.events.Event;

	public class ProductionPanelEvent extends Event
	{
		public static const EVENT_CLICK: String = 'click';
	
		public var productionType: ProductionType;
		
		public function ProductionPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}