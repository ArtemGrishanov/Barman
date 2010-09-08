package com.flashmedia.socialnet.vk
{
	import flash.events.Event;

	public class VKontakteEvent extends Event
	{
		public static const ERROR:String = 'VKontakteEvent::ERROR';
//		public static const FRIEDNS_PROFILES_LOADED:String = 'VKontakteEvent::FRIEDNS_PROFILES_LOADED';
		public static const COMPLETED:String = 'VKontakteEvent::COMPLETED';
		
		public var method:String;
		public var response:Object;
		public var errorCode:int;
		public var errorMessage:String;
		
		public function VKontakteEvent(type:String, method:String, response:Object,  errorCode:int=0, errorMessage:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.method = method;
			this.response = response;
			this.errorCode = errorCode;
			this.errorMessage = errorMessage;
		}
	}
}