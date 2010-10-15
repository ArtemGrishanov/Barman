package com.bar.api
{
	import com.alienos.sgs.as3.client.SgsEvent;
	import com.alienos.sgs.as3.client.SimpleClient;
	import com.bar.model.Balance;
	import com.bar.model.BarPlace;
	import com.bar.model.User;
	import com.bar.model.essences.Client;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.Production;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * Класс для работы с сервером
	 */
	public class Server extends EventDispatcher
	{
		public static const STATE_CONNECTED: String = 'state_connected';
		public static const STATE_DISCONNECTED: String = 'state_disconnected';
		/**
		 * Ограничение на количество запрашиваемых одновременно идишников друзей.
		 * При большом количестве посылаемых идишников сервер глючит.
		 */
		public static const FRIENDS_LOAD_QUOTE: int = 50;
		
		private var _debug: Boolean;
		private var _state: String;
		private var _host: String;
		private var _port: int;
		private var _login: String;
		private var _password: String;
		private var _client: SimpleClient;
		/**
		 * Array of Channel
		 */
		private var _channels: Array;
		/**
		 * Если запрос инициируется, когда клиент offline, то он ставится в очередь
		 * Как только клиент залогинится, все запросы будут отправлены.
		 * [ByteArray]
		 */
		private var requestQueue: Array;
		/**
		 * Массив идишников друзей, которые осталось запросить
		 */
		private var requestFriendsIds: Array;
		/**
		 * Массив идишников друзей, которые прислал сервер
		 */
		private var loadFriendsIds: Array;
		private var loadFriendsLevels: Array;
		private var loadFriendsExp: Array;
		
		public function Server(host: String, port: int, debug: Boolean = false, target: IEventDispatcher = null)
		{
			super(target);
			_debug = debug;
			_state = STATE_DISCONNECTED;
			_host = host;
			_port = port;
			_client = new SimpleClient(_host, port);
			_client.addEventListener(SgsEvent.LOGIN_SUCCESS, onLoginSuccess);
            _client.addEventListener(SgsEvent.LOGIN_FAILURE, onLoginFailure);
            _client.addEventListener(SgsEvent.LOGIN_REDIRECT, onLoginRedirect);
            _client.addEventListener(SgsEvent.SESSION_MESSAGE, onSessionMessage);
            _client.addEventListener(SgsEvent.LOGOUT, onLogout);
            _client.addEventListener(SgsEvent.CHANNEL_JOIN, onChannelJoin);
            _client.addEventListener(SgsEvent.CHANNEL_MESSAGE, onChannelMessage);
            _client.addEventListener(SgsEvent.CHANNEL_LEAVE, onChannelLeave);
            _channels = new Array();
            requestQueue = new Array();
		}
		
		private function debug(msg: String): void {
			if (_debug) {
				trace(msg);
			}
		}
		
		/**
		 * Подключение к серверу
		 */
		public function connect(login: String, password: String): void {
			_login = login;
			_password = password;
			_client.login(_login, _password);
			
		}
		
		public function disconnect(): void {
			_client.logout();
		}
		
		public function resetGame(): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_RESET_GAME);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function sendVKAttrs(fullName: String, photoPath: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_VK_ATTRS);
			buf.writeUTF(fullName);
			if (photoPath) {
				buf.writeUTF(photoPath);
			}
			else {
				buf.writeUTF('');
			}
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function loadBar(id_vk: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_LOAD_BAR);
			buf.writeUTF(id_vk);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		/**
		 * position - место клиента 0..4
		 */
		public function clientCome(id_client: int, type: String, id_user: String, fullName: String, goodsType: String, position: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_CLIENT_COME);
			buf.writeInt(id_client);
			buf.writeUTF(type);
			buf.writeUTF(id_user);
			buf.writeUTF(fullName);
			buf.writeUTF(goodsType);
			buf.writeInt(position);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function clientServed(id_client: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_CLIENT_SERVED);
			buf.writeInt(id_client);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function clientDenied(id_client: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_CLIENT_DENIED);
			buf.writeInt(id_client);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function productionLicensed(prodType: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_PRODUCTION_LICENSED);
			buf.writeUTF(prodType);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		/**
		 * x,y - место продукции на полке
		 */
		public function productionAddedToBar(idProd: int, prodType: String, partsCount: int, x: int, y: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_PRODUCTION_ADDED_TO_BAR);
			buf.writeInt(idProd);
			buf.writeUTF(prodType);
			buf.writeInt(partsCount);
			buf.writeInt(x);
			buf.writeInt(y);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function productionChangeParts(idProd: int, partsCount: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_PRODUCTION_CHANGE_PARTS);
			buf.writeInt(idProd);
			buf.writeInt(partsCount);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function productionChangePlace(idProd: int, cellIndex: int, rowIndex: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_PRODUCTION_CHANGE_PLACE);
			buf.writeInt(idProd);
			buf.writeInt(cellIndex);
			buf.writeInt(rowIndex);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function productionDeleted(idProd: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_PRODUCTION_DELETED);
			buf.writeInt(idProd);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		/**
		 * level, exp, love
		 */
		public function userAttrsChanged(level: int, exp: int, love: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_USER_ATTRS_CHANGED);
			buf.writeInt(level);
			buf.writeInt(exp);
			buf.writeInt(love);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function moneyCentChanged(moneyCent: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_MONEY_CENT_CHANGED);
			buf.writeInt(moneyCent);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function moneyEuroChanged(moneyEuro: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_MONEY_EURO_CHANGED);
			buf.writeInt(moneyEuro);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function decorAddedToBar(decorId: int, decorType: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_DECOR_ADDED_TO_BAR);
			buf.writeInt(decorId);
			buf.writeUTF(decorType);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function decorDeleted(decorId: int): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_DECOR_DELETED);
			buf.writeInt(decorId);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		public function inviteFriend(id_friend: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_INVITE_FRIEND);
			buf.writeUTF(id_friend);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		/**
		 * Загрузить друзей пользователя.
		 * Отправляются все друзья, возвращаются те, которые зарегистрированы в игре.
		 */
		public function loadFriends(ids: Array): void {
			requestFriendsIds = ids;
			loadFriendsIds = new Array();
			loadFriendsLevels = new Array();
			loadFriendsExp = new Array();
			
			_loadFriends();
		}
		
		private function _loadFriends(): void {
			if (requestFriendsIds.length > 0) {
				var requestedIdsCount: int = requestFriendsIds.length;
				if (requestFriendsIds.length > FRIENDS_LOAD_QUOTE) {
					requestedIdsCount = FRIENDS_LOAD_QUOTE;
				}
				var buf: ByteArray = new ByteArray();
				buf.writeInt(ServerProtocol.C_LOAD_FRIENDS);
				buf.writeInt(requestedIdsCount);
				for (var i: Number = 0; i < requestedIdsCount; i++) {
					buf.writeInt(requestFriendsIds[i]);
				}
				if (_state == STATE_CONNECTED) {
					_client.sessionSend(buf);
				}
				else {
					requestQueue.push(buf);
				}
				requestFriendsIds.splice(0, requestedIdsCount);
			}
		}
		
		/**
		 * Получить ТОП игроков с сервера
		 */
		public function loadTOP(pageIndex: Number, onPageCount: Number): void {
			
		}
		/**
		 * Получить каталог баров
		 */
		public function loadBarCatalog(): void {
			
		}
		
		/**
		 * votes - голоса в целых единицах
		 */
		public function withdrawVotes(votes: int, authKey: String): void {
			var buf: ByteArray = new ByteArray();
			buf.writeInt(ServerProtocol.C_WITHDRAW_VOTES);
			buf.writeInt(votes);
			buf.writeUTF(authKey);
			if (_state == STATE_CONNECTED) {
				_client.sessionSend(buf);
			}
			else {
				requestQueue.push(buf);
			}
		}
		
		/**
		 * Отсылает сообщение серверу
		 */
//		private function send(int): void {
//			var buf: ByteArray = new ByteArray();
//			buf.w(input);
//			_client.sessionSend(buf);
//		}
		
		//--------------------------------------------------------------
		// SgsEvents
		//--------------------------------------------------------------
		public function onLoginSuccess(event: SgsEvent): void {
			_state = STATE_CONNECTED;
			debug("onLoginSuccess");
			if (requestQueue.length > 0) {
				for each (var buf: ByteArray in requestQueue) {
					_client.sessionSend(buf);
				}
			}
		}
		
		public function onLoginFailure(event: SgsEvent): void {
			_state = STATE_DISCONNECTED;
			debug("onLoginFailure");
		}
		
		public function onLoginRedirect(event: SgsEvent): void {
			_state = STATE_DISCONNECTED;
			debug("onLoginRedirect: " + event.host + " :" + event.port);
		}
		
		public function onChannelJoin(event: SgsEvent): void {
			debug("Channel join: [" + event.channel.name + "]");
			_channels.push(event.channel);
		}
		
		public function onChannelMessage(event: SgsEvent): void {
			var buf: ByteArray = event.channelMessage;
            var message: String = buf.readUTFBytes(buf.bytesAvailable);      
            debug("Channel message: [" + event.channel.name +"]: "+message);
		}
		
		public function onChannelLeave(event: SgsEvent): void {
			debug("Channel leave: [" + event.channel.name + "]");
			_channels.removeItemAt(_channels.getItemIndex(event.channel));
		}
		
		public function onSessionMessage(event: SgsEvent): void {
			try {
				var buf: ByteArray = event.sessionMessage;
	            //var message: String = buf.readUTFBytes(buf.bytesAvailable);
	            //debug("onSessionMessage: [" +message+"]");
	            var token: int = buf.readInt();
	            switch (token) {
	            	case ServerProtocol.S_BAR_LOADED:
	            		var firstLaunchInt: int = buf.readInt();
	            		var id_user: String = buf.readUTF();
	            		var fullName: String = buf.readUTF();
	            		var photoPath: String = buf.readUTF();
						var level: int = buf.readInt();
	            		var exp: int = buf.readInt();
	            		var love: int = buf.readInt();
	            		var invites: int = buf.readInt();
	            		var moneyCent: int = buf.readInt();
	            		var moneyEuro: int = buf.readInt();
	            		var clients: Array = new Array();
	            		for (var i: int = 0; i < Balance.maxClientsCount; i++) {
	            			var cId: int = buf.readInt();
	            			if (cId >= 0) {
		            			var cType: String = buf.readUTF();
		            			var cUserId: String = buf.readUTF();
		            			var cName: String = buf.readUTF();
		            			var cGoodsType: String = buf.readUTF();
	            				var c: Client = new Client(Balance.getClientTypeByName(cType), cUserId, cName, false, new Date().getTime() / 1000, Balance.getGoodsTypeByName(cGoodsType), i);
	            				c.id = cId;
	            				clients.push(c);
	            				debug('[S_BAR_LOADED]: Pos:' + i + ' Client:' + c.name + '(' + c.id + ') ' + c.id_vk + ' ' + c.typeClient.type + ' ' + c.orderGoodsType.type);
	            			}
	            		}
	            		var licensedProdTypes: Array = new Array();
	            		var licProdCount: int = buf.readInt();
	            		if (licProdCount > 0) {
	            			for (i = 0; i < licProdCount; i++) {
	            				var licProdType: String = buf.readUTF();
		            			licensedProdTypes.push(licProdType);
		            			debug('[S_BAR_LOADED]: licensed:' + licProdType);
	            			}
	            		}
	            		var production: Array = new Array();
	            		var prodCount: int = buf.readInt();
	            		if (prodCount > 0) {
	            			for (i = 0; i < prodCount; i++) {
	            				var prodId: int = buf.readInt();
	            				var prodType: String = buf.readUTF();
	            				var partsCount: int = buf.readInt();
	            				var cellIndex: int = buf.readInt();
	            				var rowIndex: int = buf.readInt();
	            				var p: Production = new Production(Balance.getProductionTypeByName(prodType), partsCount);
	            				p.id = prodId;
	            				p.cellIndex = cellIndex;
	            				p.rowIndex = rowIndex;
		            			production.push(p);
								debug('[S_BAR_LOADED]: Production:(' + p.id + ') ' + p.typeProduction.type + ' ' + p.partsCount + ' [' + p.cellIndex + ',' + p.rowIndex + ']');
	            			}
	            		}
	            		var decor: Array = new Array();
	            		var decorCount: int = buf.readInt();
	            		if (decorCount > 0) {
	            			for (i = 0; i < decorCount; i++) {
	            				var decorId: int = buf.readInt();
	            				var decorType: String = buf.readUTF();
	            				var d: Decor = new Decor(Balance.getDecorTypeByName(decorType));
	            				d.id = decorId;
		            			decor.push(d);
								debug('[S_BAR_LOADED]: Decor:(' + d.id + ') ' + d.typeDecor.type);
	            			}
	            		}
	            		var u: User = new User(id_user, fullName, level, exp, love, invites, moneyCent, moneyEuro);
	            		u.photoPath = photoPath;
	            		u.licensedProdTypes = licensedProdTypes;
	            		var bp: BarPlace = new BarPlace(u);
	            		bp.clients = clients;
	            		bp.production = production;
	            		bp.decor = decor;
	            		debug('[S_BAR_LOADED]: ' + fullName + '(' + id_user + ') Lev:' + level + ' Exp:' + exp + ' Love:' + love + ' Inv:' + invites + ' Cents:' + moneyCent + ' Euro:' + moneyEuro);
	            		var eventBarLoaded: ServerEvent = new ServerEvent(ServerEvent.EVENT_BAR_LOADED);
	            		eventBarLoaded.firstLaunch = (firstLaunchInt == 1);
	            		eventBarLoaded.barPlace = bp;
	            		dispatchEvent(eventBarLoaded);
	            	break;
//	            	case ServerProtocol.S_FIRST_LAUNCH:
//	            		debug('[S_FIRST_LAUNCH]');
//	            		var eventFirstLaunch: ServerEvent = new ServerEvent(ServerEvent.EVENT_FIRST_LAUNCH);
//	            		dispatchEvent(eventFirstLaunch);
//	            	break;
	            	case ServerProtocol.S_FRIENDS_LOADED:
	            		var friendsCount: Number = buf.readInt();
	            		debug('S_FRIENDS_LOADED: ' + friendsCount);
	            		for (i = 0; i < friendsCount; i++) {
	            			loadFriendsIds.push(buf.readInt());
	            			loadFriendsLevels.push(buf.readInt());
	            			loadFriendsExp.push(buf.readInt());
	            		}
	            		if (requestFriendsIds.length == 0) {
	            			var eventFriendsLoaded: ServerEvent = new ServerEvent(ServerEvent.EVENT_FRIENDS_LOADED);
	            			eventFriendsLoaded.friendsIds = loadFriendsIds;
	            			eventFriendsLoaded.friendsLevels = loadFriendsLevels;
	            			eventFriendsLoaded.friendsExp = loadFriendsExp;
	            			dispatchEvent(eventFriendsLoaded);
	            		}
	            		else {
	            			// грузим друзей дальше, пока не кончится массив requestFriendIds
	            			_loadFriends();
	            		}
	            	break;
	            	default:
	            		debug('Undefined token!');
	            }
   			}
   			catch (e: Error) {
   				debug('Unknown error in session message!');
   			}
		}
		
		public function onLogout(event: SgsEvent): void {
			_state = STATE_DISCONNECTED;
			debug("onLogout()");
		}
	}
}