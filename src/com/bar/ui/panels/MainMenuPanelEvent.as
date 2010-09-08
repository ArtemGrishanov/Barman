package com.bar.ui.panels
{
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.ProductionType;
	import com.flashmedia.socialnet.SocialNetUser;
	
	import flash.events.Event;

	public class MainMenuPanelEvent extends Event
	{
		public static const EVENT_ITEM_CLICK: String = 'item_click';
		public static const EVENT_PRODUCTION_CLICK: String = 'production_click';
		public static const EVENT_LICENSE: String = 'production_license';
		public static const EVENT_DECOR_CLICK: String = 'decor_click';
		public static const EVENT_DECOR_OVER: String = 'decor_over';
		public static const EVENT_DECOR_OUT: String = 'decor_out';
		public static const EVENT_INVITE_FRIEND: String = 'invite_friend';
		public static const EVENT_FRIEND_CLICK: String = 'friend_click';
	
		public var productionType: ProductionType;
		public var decorType: DecorType;
		public var menuItem: String;
		public var user: SocialNetUser;
		
		public function MainMenuPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}