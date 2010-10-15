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
					vkontakte.getProfiles(uids);
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
					var friendsIds: Array = [57856825, 12402413, 4134197, 4930084];
//					var friendsIds: Array = [1234239, 4546611];
					dispatchFriendsEvent(friendsIds);
				break;
				case NET_NONE:
				default:
					//todo nothing
			}
		}
		
		/**
		 * users - Array of SocialNetUser
		 */
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
						var socialUsers: Array = new Array();
						for each (var o: Object in response) {
							var uid: Number = (o.hasOwnProperty('uid') ? o.uid : NaN);
							var nickname: String = (o.hasOwnProperty('nickname') ? o.nickname : null);
							var first_name: String = (o.hasOwnProperty('first_name') ? o.first_name : null);
							var last_name: String = (o.hasOwnProperty('last_name') ? o.last_name : null);
							var sex: Number = (o.hasOwnProperty('sex') ? o.sex : null);
							var bdate: String = (o.hasOwnProperty('bdate') ? o.bdate : null);
							var photo_big: String = (o.hasOwnProperty('photo_big') ? o.photo_big : null);
							var photo_medium: String = (o.hasOwnProperty('photo_medium') ? o.photo_medium : null);
							var photo: String = (o.hasOwnProperty('photo') ? o.photo : null);

							var su: SocialNetUser = new SocialNetUser(uid, nickname, first_name, last_name, sex, bdate);
							su.photoBigUrl = photo_big;
							su.photoMediumUrl = photo_medium;
							su.photoUrl = photo;
							socialUsers.push(su); 
						}
						dispatchUserInfoEvent(socialUsers);
					break;
					case 'getFriends':
						dispatchFriendsEvent(response as Array);
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