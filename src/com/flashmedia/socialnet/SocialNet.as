package com.flashmedia.socialnet
{
	import com.flashmedia.socialnet.vk.VKontakte;
	import com.flashmedia.socialnet.vk.VKontakteEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * В дальнейшем сделать класс фасад для работы и интерфейсом соц сетей. 
	 */
	public class SocialNet extends EventDispatcher
	{
		/**
		 * Нет сети - никакие данные не возвращаются.
		 */
		public static const NET_NONE: String = 'none';
		/**
		 * Эмуляция сети. Возвращаются тестовые данные.
		 */
		public static const NET_SANDBOX: String = 'sandbox';
		public static const NET_VKONTAKTE: String = 'vkontakte';
		public static const NET_MOIMIR: String = 'moimir';
		private var net: String;
		private var debug: Boolean;
		
		public static var wrapper: Object;
		public static var user: SocialNetUser;
		public static var user_id: String = '9028622';//77625236;//57856825;//11854430;//9028622;//11757602;//9028622;//4136593;
		public static var viewer_id: String = '9028622';//77625236;//57856825;//11854430;
		
		private var vkontakte: VKontakte;
		
		public function SocialNet(_net: String = '', _debug: Boolean = false, target: IEventDispatcher = null)
		{
			super(target);
			debug = _debug;
			net = _net;
			if (net == '') {
				//todo автоопределение сети
				net = NET_NONE;
			}
			vkontakte = new VKontakte(viewer_id);
			vkontakte.addEventListener(VKontakteEvent.COMPLETED, onVkontakteRequestCompleted);
			vkontakte.addEventListener(VKontakteEvent.ERROR, onVkontakteRequestError);
		}
		
		public function getUserInfo(uids: Array = null): void {
			if (!uids) {
				uids = new Array();
				uids.push(viewer_id);
			}
			switch (net) {
				case NET_VKONTAKTE:
					vkontakte.getFriends();
				break;
				case NET_MOIMIR:
					
				break;
				case NET_SANDBOX:
					var users: Array = new Array();
					for (var i: uint = 0; i < uids.length; i++) {
						var u: SocialNetUser = new SocialNetUser(uids[i] as Number, 'Nickname' + i, 'FirstName' + i, 'LastName' + i, SocialNetUser.SEX_MALE, '01.01.1990');
						users.push(u);
					}
					dispatchUserInfoEvent(users);
				break;
				case NET_NONE:
				default:
					//todo nothing
			}
		}
		
		public function getFriends(): void {
			switch (net) {
				case NET_VKONTAKTE:
					vkontakte.getFriends();
				break;
				case NET_MOIMIR:
				
				break;
				case NET_SANDBOX:
					var friendsIds: Array = [1234239, 4546611, 564345, 4563650, 4235456, 93736563, 22554674, 9876633];
//					var friendsIds: Array = [1234239, 4546611];
					dispatchFriendsEvent(friendsIds);
				break;
				case NET_NONE:
				default:
					//todo nothing
			}
		}
		
		private function dispatchUserInfoEvent(users: Array): void {
			var event: SocialNetEvent = new SocialNetEvent(SocialNetEvent.USER_INFO);
			event.users = users;
			dispatchEvent(event);
		}
		
		private function dispatchFriendsEvent(friendsIds: Array): void {
			var event: SocialNetEvent = new SocialNetEvent(SocialNetEvent.GET_FRIENDS);
			event.friensdIds = friendsIds;
			dispatchEvent(event);
		}
		
		private function onVkontakteRequestError(event: VKontakteEvent):void {
			if (debug) {
				trace('VKontakte request error: ' + event.errorCode + ' ' + event.errorMessage);
			}
		}
		
		private function onVkontakteRequestCompleted(event: VKontakteEvent):void {
			var response:Object = event.response;
			try {
				switch (event.method) {
					case 'getProfiles':
						
					break;
					case 'getFriends':
						
					break;
					case 'getAppFriends':
						
					break;
				}
			}
			catch (e:Error) {
				if (debug) {
					trace(e.message);
				}
			}
		}
	}
}