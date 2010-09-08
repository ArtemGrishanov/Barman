package com.flashmedia.socialnet
{
	import com.flashmedia.socialnet.SocialNetUser;
	
	import flash.events.Event;

	public class SocialNetEvent extends Event
	{
		public static const ERROR: String = 'error';
		public static const USER_INFO: String = 'user_info';
		public static const GET_FRIENDS: String = 'get_friends';
		
		public var method: String;
		/**
		 * Array of SocialNetUser. Info about users.
		 */
		public var users: Array;
		/**
		 * Array of Number.
		 */
		public var friensdIds: Array;
		public var errorCode: int;
		public var errorMessage: String;
		
		public function SocialNetEvent(type:String, errorCode:int=0, errorMessage:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.method = method;
			this.errorCode = errorCode;
			this.errorMessage = errorMessage;
		}
	}
}