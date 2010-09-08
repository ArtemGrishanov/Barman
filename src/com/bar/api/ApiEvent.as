package com.facecontrol.api
{
	import flash.events.Event;

	public class ApiEvent extends Event
	{
		public static const COMPLETED:String = 'ApiEvent::COMPLETED';
		public static const ERROR:String = 'ApiEvent::ERROR';
		
		public var response:Object;
		public var errorCode:int;
		public var errorMessage:String;
		
		public function ApiEvent(type:String, data:Object, errorCode:int=0, errorMessage:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.response = data;
			this.errorCode = errorCode;
			this.errorMessage = errorMessage;
		}
	}
}