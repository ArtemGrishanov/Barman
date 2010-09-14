package com.bar.model
{
	import com.bar.api.Server;
	import com.bar.api.ServerEvent;
	import com.bar.model.essences.Client;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.Goods;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	import com.util.Selector;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Core extends EventDispatcher
	{
		/**
		 * Типы основных сущностей в игре
		 */
		public var clientTypes: Array;
		public var decorTypes: Array;
		public var goodsTypes: Array;
		public var productionTypes: Array;
		
		public var myBarPlace: BarPlace;
		public var userBarPlace: BarPlace;
		public var timer: Timer;
		
		public var isLoaded: Boolean;
//		public var clientsCountToAdd: uint;
//		public var clientPeriodTimeStamp: Number;
		
		/**
		 * Клиент, которого обслуживают в данный момент.
		 * Если никого, то null
		 */
		public var servingClient: Client;
		/**
		 * Товар, который в данный момент готовится
		 */
		public var currentGoods: Goods;
		/**
		 * Объект-Сервер. Для обеспечения сетевого взаимодействия с сервером
		 */
		public var server: Server;
		/**
		 * Признак первого запуска игры.
		 * Расставить начальную продукцию. Отослать данные о пользователе.
		 */
		public var firstLaunch: Boolean;
		/**
		 * Обслужили ли первого клиента. Первый клиент появляется сразу и сидит один пока его не обслужат.
		 */
		public var firstClientServed: Boolean;
		/**
		 * Определяет, был ли добавлен начальный набор продукции в бар
		 */
		public var addedStartProduction: Boolean;
		
		public function Core(viewerId: String, fullName: String, photoPath: String, srv: Server)
		{
			isLoaded = false;
			addedStartProduction = false;
			myBarPlace = new BarPlace(new User(viewerId, fullName));
			myBarPlace.user.photoPath = photoPath;
			server = srv;
			if (server) {
				// если что, то сервер пришлет уведомление, что запуск первый
				firstLaunch = false;
				server.addEventListener(ServerEvent.EVENT_BAR_LOADED, barLoaded);
				server.addEventListener(ServerEvent.EVENT_FIRST_LAUNCH, firstLaunched);
			}
			else {
				// сервер не доступен - не можем наверняка определить первый это запуск или нет. Считаем что первый.
				firstLaunch = true;
				firstClientServed = false;
			}
			timer = new Timer(Balance.coreTimerPeriod, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		/**
		 * 1. Загрузка типов: товаров, продукции, декора, клиентов
		 * 2. Загрузка бара главного пользователя (расположение элементов, параметры пользователя)
		 */
		public function load(): void {
			clientTypes = Balance.clientTypes;
			decorTypes = Balance.decorTypes;
			productionTypes = Balance.productionTypes;
			goodsTypes = Balance.goodsTypes;
			loadBar(myBarPlace.user.id_user);
		}
		
		public function onTimer(event: TimerEvent): void {
			if (isLoaded) {
				var nowTime: Number = new Date().getTime() / 1000;
				if (firstLaunch && !firstClientServed && myBarPlace.clients.length == 0) {
					createNewClient();
				}
				if (!firstLaunch || firstClientServed) {
					if (myBarPlace.clients.length < Balance.maxClientsCount) {
						//todo clientSpeed от любви и количества приглашенных.
						if (Selector.prob(Balance.getClientComeProb(Balance.minClientSpeed))) {
							createNewClient();
						}
					}
				}
				//изменение настроения клиентов
				for each (var c: Client in myBarPlace.clients) {
					var realMood: Number = Balance.maxClientMood - (int)((nowTime - c.time) / Balance.periodToLowMood);
					if (realMood > Balance.maxClientMood) {
						realMood = Balance.maxClientMood;
					}
					else if (realMood < 0) {
						realMood = 0;
					}
					if (c.mood != realMood) {
						c.mood = realMood;
						var eventChangeMood: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_MOOD_CHANGED);
						eventChangeMood.client = c;
						dispatchEvent(eventChangeMood);
					}
				}
				//чаевые
				for each (var tip: Object in myBarPlace.tips) {
					if (nowTime - tip['time'] >= Balance.tipsLifeTime) {
						var eventTipsDeleted: CoreEvent = new CoreEvent(CoreEvent.EVENT_TIPS_DELETED);
						eventTipsDeleted.tipPosition = tip['position'];
						eventTipsDeleted.tipMoneyCent = tip['tipsMoneyCent'];
						eventTipsDeleted.tipMoneyEuro = tip['tipsMoneyEuro'];
						eventTipsDeleted.clientId = tip['clientId'];
						dispatchEvent(eventTipsDeleted);
						myBarPlace.tips.splice(myBarPlace.tips.indexOf(tip), 1);
					}
				}
			}
		}
		
		/**
		 * Загрузить бар пользователя c сервера
		 */
		public function loadBar(id_user: String): void {
			if (server) {
				server.loadBar(id_user);
			}
			else {
				var barLoadEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_BAR_LOADED);
				if (id_user == myBarPlace.user.id_user) {
					//todo выдача бонусных денег и любви, за каждодневное посещение
					myBarPlace.user.experience = 0;
					myBarPlace.user.level = Balance.startLevel;
					myBarPlace.user.love = Balance.startLove;
					myBarPlace.user.invites = 0;
					myBarPlace.user.moneyCent = Balance.startMoneyCent;
					myBarPlace.user.moneyEuro = Balance.startMoneyEuro;
					myBarPlace.user.photo = null;
					//myBarPlace.user.licensedProdTypes.push('vodka');
					myBarPlace.production = new Array();
					myBarPlace.production.push(new Production(productionTypes[0] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[0] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[0] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[1] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[2] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[3] as ProductionType));
					myBarPlace.production.push(new Production(productionTypes[3] as ProductionType));
					
					myBarPlace.decor = new Array();
					myBarPlace.decor.push(new Decor(decorTypes[0] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[1] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[2] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[3] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[4] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[5] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[6] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[7] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[8] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[9] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[10] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[11] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[12] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[13] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[14] as DecorType));
					myBarPlace.decor.push(new Decor(decorTypes[15] as DecorType));
					
					barLoadEvent.barPlace = myBarPlace;
				}
				else {
					userBarPlace = new BarPlace(new User('57856825', 'Али Гаджиев', 1, 1, 100, 0, 500, 3, null, null));
					barLoadEvent.barPlace = userBarPlace;
				}
				dispatchEvent(barLoadEvent);
				isLoaded = true;
			}
		}
		
		/**
		 * Создание нового клиента
		 */
		public function createNewClient(): void {
			//todo параметры клиента
			//todo - выбор позиции, куда сесть - последний параметр в конструкторе
			var freePlaces: Array = new Array();
			for (var i: int = 0; i < Balance.maxClientsCount; i++) {
				var isFree: Boolean = true;
				for each (var c: Client in myBarPlace.clients) {
					if (c.position == i) {
						isFree = false;
						break;
					}
				}
				for each (var tip: Object in myBarPlace.tips) {
					if (tip['position'] == i) {
						isFree = false;
						break;
					}
				}
				if (isFree) {
					freePlaces.push(i);
				}
			}
			if (freePlaces.length > 0) {
				var gds: Array = getGoodsForLevel(myBarPlace.user.level);
				var g: GoodsType = gds[Selector.chooseFromRange(0, gds.length - 1)] as GoodsType;
				var client: Client = new Client(clientTypes[Selector.chooseFromRange(0, clientTypes.length - 1)], '57856825', 'Али Гаджиев', true, new Date().getTime() / 1000, g, freePlaces[Selector.chooseFromRange(0, freePlaces.length - 1)]);
				myBarPlace.clients.push(client);
				if (server) {
					server.clientCome(client.id, client.typeClient.type, client.id_vk, client.name, client.orderGoodsType.type, client.position);
				}
				var eventNewClient: CoreEvent = new CoreEvent(CoreEvent.EVENT_NEW_CLIENT);
				eventNewClient.client = client;
				dispatchEvent(eventNewClient);
			}
		}
		
		/**
		 * Изменяет статус клиента по его идентификатору.
		 */
		public function changeClientStatus(idClient: Number, status: String): void {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient && c.status != status) {
					c.status = status;
					var changeClientStatusEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_STATUS_CHANGED);
					changeClientStatusEvent.client = c;
					dispatchEvent(changeClientStatusEvent);
					break;
				}
			}
		}
		
		/**
		 * Удаление клиента
		 */
		private function deleteClient(idClient: Number): void {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient) {
					myBarPlace.clientsHistory.push(c);
					myBarPlace.clients.splice(myBarPlace.clients.indexOf(c), 1);
					var changeClientStatusEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_DELETED);
					changeClientStatusEvent.client = c;
					dispatchEvent(changeClientStatusEvent);
					break;
				}
			}
		}
		
		/**
		 * Отказ обслуживать клиента. Клиент автоматически удалится.
		 * Например, когда нет нужного товара.
		 */
		public function denyClient(idClient: Number): void {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient) {
					if (server) {
						server.clientDenied(c.id);
					}
					var denyClientEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_DENIED);
					denyClientEvent.client = c;
					dispatchEvent(denyClientEvent);
					changeUserLove(Balance.loveForDenyClient);
					deleteClient(idClient);
				}
			}
		}
		
		/**
		 * Возвращает список GoodsType, которые доступны на уровне
		 */
		public function getGoodsForLevel(level: uint): Array {
			var result: Array = new Array();
			for each (var gt: GoodsType in goodsTypes) {
				if (gt.accessLevel <= level) {
					result.push(gt);
				}
			}
			return result;
		}
		
		/**
		 * Получить клиента по ИД
		 */
		public function getClientById(idClient: Number): Client {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient) {
					return c;
				}
			}
			return null;
		}
		
		/**
		 * Начать обслуживание клиента
		 * Если все порции будут собраны, обслуживание прекратится автоматически.
		 */
		public function startClientServing(idClient: Number): void {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient) {
					myBarPlace.createProductionBackup();
					servingClient = c;
					currentGoods = new Goods(servingClient.orderGoodsType);
					var clientStartServingEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_START_SERVING);
					clientStartServingEvent.client = servingClient;
					dispatchEvent(clientStartServingEvent);
					break;
				}
			}
		}
		
		/**
		 * Готовим товар!
		 * Добавляем в текущий товар продукцию с полки.
		 */
		public function makeGoods(production: Production): void {
			if (servingClient) {
				var partsAdded: uint = currentGoods.addProduction(production);
				if (partsAdded > 0) {
					var prodAddedToCurGooods: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_ADDED_TO_CUR_GOODS);
					prodAddedToCurGooods.goods = currentGoods;
					prodAddedToCurGooods.production = production;
					dispatchEvent(prodAddedToCurGooods);
					if (server) {
						server.productionChangeParts(production.id, production.partsCount);
					}
					if (production.partsCount == 0) {
						var eventProdEmpty: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_EMPTY);
						eventProdEmpty.production = production;
						dispatchEvent(eventProdEmpty);
					}
				}
				if (currentGoods.completed) {
					var clientServedEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_SERVED);
					clientServedEvent.client = servingClient;
					clientServedEvent.goods = currentGoods;
					if (!firstClientServed) {
						firstClientServed = true;
						clientServedEvent.firstClientServed = true;
					}
					dispatchEvent(clientServedEvent);
					if (server) {
						server.clientServed(servingClient.id);
					}
					changeUserLove(Balance.getLoveForMood(servingClient.mood));
					changeUserMoney(currentGoods.typeGoods.priceCent, 0);
					var tipMoneyCent: Number = Balance.tipsSum(myBarPlace, servingClient);
					var tipMoneyEuro: Number = 0;
					if (tipMoneyCent > 0) {
						myBarPlace.tips.push({'tipsMoneyCent': tipMoneyCent,
							'tipMoneyEuro': tipMoneyEuro,
							'clientId': servingClient.id,
							'position': servingClient.position,
							'time': new Date().getTime() / 1000});
						var tipEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_PAY_TIP);
						tipEvent.client = servingClient;
						tipEvent.clientId = servingClient.id;
						tipEvent.tipPosition = servingClient.position;
						tipEvent.tipMoneyEuro = tipMoneyEuro;
						tipEvent.tipMoneyCent = tipMoneyCent;
						dispatchEvent(tipEvent);
					}
					deleteClient(servingClient.id);
					changeUserExp(currentGoods.typeGoods.expCount);
					servingClient = null;
					currentGoods = null;
				}
			}
		}
		
		/**
		 * Прекратить обслуживание клиента. Клиент не получит свой заказ.
		 * Весь товар будет возвращен обратно в бар.
		 */
		public function stopClientServing(idClient: Number): void {
			for each(var c: Client in myBarPlace.clients) {
				if (c.id == idClient) {
					currentGoods = null;
					var clientStopServingEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_CLIENT_STOP_SERVING);
					clientStopServingEvent.client = servingClient;
					dispatchEvent(clientStopServingEvent);
					servingClient = null;
					myBarPlace.restoreProductionFromBackup();
					var eventUpdProd: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_UPDATED);
					eventUpdProd.barPlace = myBarPlace;
					dispatchEvent(eventUpdProd);
				}
			}
		}
		
		/**
		 * Удаление продукции с полки пользователя.
		 */
		public function deleteProduction(idProduction: Number): void {
			var i: uint = 0;
			for each (var p: Production in myBarPlace.production) {
				if (p.id == idProduction){
					myBarPlace.production.splice(i, 1);
					var eventProdAdded: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_DELETED);
					eventProdAdded.production = p;
					dispatchEvent(eventProdAdded);
					if (server) {
						server.productionDeleted(idProduction);
					}
					break;
				}
				i++;
			}
		}
		
		/**
		 * Смена места продукции на полке. Например перетаскивание.
		 */
		public function moveProduction(idProduction: Number, cellIndex: Number, rowIndex: Number): void {
			for each (var p: Production in myBarPlace.production) {
				if (p.id == idProduction){
					p.cellIndex = cellIndex;
					p.rowIndex = rowIndex;
					if (server) {
						server.productionChangePlace(idProduction, cellIndex, rowIndex);
					}
				}
			}
		}
		
		/**
		 * Добавить начальный набор продукции в бар
		 */
		public function addStartProduction(): void {
			addedStartProduction = true;
			myBarPlace.production = Balance.getStartProduction();
			for each (var p: Production in myBarPlace.production) {
				if (server) {
					server.productionAddedToBar(p.id, p.typeProduction.type, p.partsCount, p.cellIndex, p.rowIndex);
				}	
			}
		}
		
		/**
		 * Получить продукцию по ИД
		 */
		public function getProductionById(idProduction: Number): Production {
			for each(var p: Production in myBarPlace.production) {
				if (p.id == idProduction) {
					return p;
				}
			}
			return null;
		}
		
		/**
		 * Купить продукцию в бар.
		 * @return - возвращает true, если хватило денег и продукция реально куплена.
		 */
		public function buyProduction(typeProduction: ProductionType): Boolean {
			if (myBarPlace.user.level >= typeProduction.accessLevel &&
					myBarPlace.user.canBuyProduction(typeProduction) &&
					(!typeProduction.needLicense() || (myBarPlace.user.isLicensed(typeProduction)))) {
				var p: Production = new Production(typeProduction);
				myBarPlace.production.push(p);
				var eventProdAdded: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_ADDED_TO_BAR);
				eventProdAdded.production = p;
				dispatchEvent(eventProdAdded);
				changeUserMoney(-typeProduction.priceCent, -typeProduction.priceEuro);
				if (server) {
					server.productionAddedToBar(p.id, typeProduction.type, p.partsCount, p.cellIndex, p.rowIndex);
				}
				return true;
			}
			return false;
		}
		
		/**
		 * Возвращает, какая продукция сейчас доступна для покупки
		 * Пользователю может не хватать денег, уровня и т.п. - продукция недоступна.
		 * @return ProductionType array
		 */
		public function enableForBuyProduction(): Array {
			var result: Array = new Array();
			for each (var p: ProductionType in productionTypes) {
				if (myBarPlace.user.level >= p.accessLevel &&
					myBarPlace.user.canBuyProduction(p) &&
					(!p.needLicense() || (myBarPlace.user.isLicensed(p)))) {
					result.push(p);
				}
			}
			return (result.length > 0) ? result: null;
		}
		
		/**
		 * Возвращает, какой декор сейчас доступен для покупки
		 * Пользователю может не хватать денег, уровня и т.п. - декор недоступен.
		 * @return DecorType array
		 */
		public function enableForBuyDecor(): Array {
			var result: Array = new Array();
			for each (var d: DecorType in decorTypes) {
				if (myBarPlace.user.level >= d.accessLevel &&
					myBarPlace.user.canBuyDecor(d) &&
					!myBarPlace.decorExist(d)
					) {
					result.push(d);
				}
			}
			return (result.length > 0) ? result: null;
		}
		
		/**
		 * Купить декор в бар.
		 * @return - возвращает true, если хватило денег и декор реально куплен.
		 */
		public function buyDecor(typeDecor: DecorType): Boolean {
			var decorAlreadyBuy: Boolean = false;
			for each (var decor: Decor in myBarPlace.decor) {
				if (decor.typeDecor.type == typeDecor.type) {
					decorAlreadyBuy = true;
					break;
				}
			}
			if (decorAlreadyBuy) {
				return false;
			}
			if (myBarPlace.user.level >= typeDecor.accessLevel &&
					myBarPlace.user.canBuyDecor(typeDecor)) {
				// удалить декор соответствующей категории - замещение
				for each (var decor: Decor in myBarPlace.decor) {
					if ((decor.typeDecor.type != typeDecor.type) && (decor.typeDecor.category == typeDecor.category)) {
						myBarPlace.decor.splice(myBarPlace.decor.indexOf(decor), 1);
					}
				}
				var d: Decor = new Decor(typeDecor);
				myBarPlace.decor.push(d);
				var eventDecorAdded: CoreEvent = new CoreEvent(CoreEvent.EVENT_DECOR_ADDED_TO_BAR);
				eventDecorAdded.decor = d;
				dispatchEvent(eventDecorAdded);
				changeUserMoney(-typeDecor.priceCent, -typeDecor.priceEuro);
				changeUserLove(typeDecor.loveCount);
				if (server) {
					server.decorAddedToBar(d.id, typeDecor.type);
				}
				return true;
			}
			return false;
		}
		
		/**
		 * Изменяет опыт пользователя
		 */
		public function changeUserExp(expDelta: Number): void {
			var eventChangeExp: CoreEvent = new CoreEvent(CoreEvent.EVENT_USER_EXP_CHANGED);
			eventChangeExp.oldExp = myBarPlace.user.experience;
			myBarPlace.user.experience += expDelta;
			if (myBarPlace.user.level < Balance.maxLevel &&
				myBarPlace.user.experience >= Balance.levelExp[myBarPlace.user.level]) {
				myBarPlace.user.experience -= Balance.levelExp[myBarPlace.user.level];
				var eventChangeLevel: CoreEvent = new CoreEvent(CoreEvent.EVENT_USER_LEVEL_CHANGED);
				eventChangeLevel.oldLevel = myBarPlace.user.level;
				myBarPlace.user.level++;
				eventChangeLevel.newLevel = myBarPlace.user.level;
				dispatchEvent(eventChangeLevel);
			}
			eventChangeExp.newExp = myBarPlace.user.experience;
			dispatchEvent(eventChangeExp);
			if (server) {
				server.userAttrsChanged(myBarPlace.user.level, myBarPlace.user.experience, myBarPlace.user.love);
			}
		}
		
		/**
		 * Изменяет деньги пользователя.
		 * Это и прибыль с продаж и донат, и, наоборот, покупки в магазине.
		 */
		public function changeUserMoney(moneyCentDelta: Number, moneyEuroDelta: Number): void {
			if (moneyCentDelta != 0) {
				var eventUserMoneyCentChanged: CoreEvent = new CoreEvent(CoreEvent.EVENT_USER_MONEY_CENT_CHANGED);
				eventUserMoneyCentChanged.oldMoneyCent = myBarPlace.user.moneyCent;
				myBarPlace.user.moneyCent += moneyCentDelta;
				eventUserMoneyCentChanged.newMoneyCent = myBarPlace.user.moneyCent;
				dispatchEvent(eventUserMoneyCentChanged);
				if (server) {
					server.moneyCentChanged(myBarPlace.user.moneyCent);
				}
			}
			if (moneyEuroDelta != 0) {
				var eventUserMoneyEuroChanged: CoreEvent = new CoreEvent(CoreEvent.EVENT_USER_MONEY_EURO_CHANGED);
				eventUserMoneyEuroChanged.oldMoneyEuro = myBarPlace.user.moneyEuro;
				myBarPlace.user.moneyEuro += moneyEuroDelta;
				eventUserMoneyEuroChanged.newMoneyEuro = myBarPlace.user.moneyEuro;
				dispatchEvent(eventUserMoneyEuroChanged);
				if (server) {
					server.moneyEuroChanged(myBarPlace.user.moneyEuro);
				}
			}
		}
		
		/**
		 * Изменяет уровень любви пользователя.
		 */
		public function changeUserLove(loveDelta: Number): void {
			var eventUserLoveChanged: CoreEvent = new CoreEvent(CoreEvent.EVENT_USER_LOVE_CHANGED);
			eventUserLoveChanged.oldLove = myBarPlace.user.love;
			myBarPlace.user.love += loveDelta;
			eventUserLoveChanged.newLove = myBarPlace.user.love;
			dispatchEvent(eventUserLoveChanged);
			if (server) {
				server.userAttrsChanged(myBarPlace.user.level, myBarPlace.user.experience, myBarPlace.user.love);
			}
		}
		
		/**
		 * Забрать чаевые, которые оставил клиент.
		 * Чаевые сразу не попадают в кассу. Их надо забрать руками. Для этого этот метод.
		 */
		public function takeTips(clientId: Number): void {
			for each (var o: Object in myBarPlace.tips) {
				if (o['clientId'] == clientId) {
					var takeTipEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_BARMAN_TAKE_TIP);
					takeTipEvent.clientId = clientId;
					takeTipEvent.tipPosition = o['position'];
					takeTipEvent.tipMoneyCent = o['tipsMoneyCent'];
					takeTipEvent.tipMoneyEuro = o['tipsMoneyEuro'];
					dispatchEvent(takeTipEvent);
					changeUserMoney(o['tipsMoneyCent'], o['tipsMoneyEuro']);
					var index: Number = myBarPlace.tips.indexOf(o);
					myBarPlace.tips.splice(index, 1);
				}
			}
		}
		
		/**
		 * Лицензировать определенный вид продукции.
		 */
		public function licenseProduction(typeProduction: ProductionType): Boolean {
			if (!myBarPlace.user.isLicensed(typeProduction) &&
				myBarPlace.user.canLicenseProduction(typeProduction)) {
				changeUserMoney(-typeProduction.licenseCostCent, -typeProduction.licenseCostEuro);
				myBarPlace.user.licensedProdTypes.push(typeProduction.type);
				var eventProductionLicensed: CoreEvent = new CoreEvent(CoreEvent.EVENT_PRODUCTION_LICENSED);
				eventProductionLicensed.typeProduction = typeProduction; 
				dispatchEvent(eventProductionLicensed);
				if (server) {
					server.productionLicensed(typeProduction.type);
				}
				return true;
			}
			return false;
		}
		
		//--------------------------------------------------------------------
		// ServerEvents
		//--------------------------------------------------------------------
		public function barLoaded(event: ServerEvent): void {
			var barLoadEvent: CoreEvent = new CoreEvent(CoreEvent.EVENT_BAR_LOADED);
			if (event.barPlace.user.id_user == myBarPlace.user.id_user) {
				//todo выдача бонусных денег и любви, за каждодневное посещение
				myBarPlace.user.experience = (event.barPlace.user.experience >= 0) ? event.barPlace.user.experience : Balance.startExperience;
				myBarPlace.user.level = (event.barPlace.user.level >= 0) ? event.barPlace.user.level : Balance.startLevel;
				myBarPlace.user.love = (event.barPlace.user.love >= 0) ? event.barPlace.user.love : Balance.startLove;
				myBarPlace.user.invites = (event.barPlace.user.invites >= 0) ? event.barPlace.user.invites : 0;
				myBarPlace.user.moneyCent = (event.barPlace.user.moneyCent >= 0) ? event.barPlace.user.moneyCent : Balance.startMoneyCent;
				myBarPlace.user.moneyEuro = (event.barPlace.user.moneyEuro >= 0) ? event.barPlace.user.moneyEuro : Balance.startMoneyEuro;
				//todo загрузка фото можно сделать отдельным событием, загрузка начинается здесь
				myBarPlace.user.photo = null;
				myBarPlace.clients = event.barPlace.clients;
				myBarPlace.decor = event.barPlace.decor;
				myBarPlace.production = event.barPlace.production;
				myBarPlace.user.licensedProdTypes = event.barPlace.user.licensedProdTypes;
				
				barLoadEvent.barPlace = myBarPlace;
				isLoaded = true;
				if (firstLaunch && !addedStartProduction) {
					addStartProduction();
				}
			}
			else {
				//userBarPlace = new BarPlace(new User('57856825', 'Али Гаджиев', 1, 1, 100, 0, 500, 3, null, null));
				barLoadEvent.barPlace = event.barPlace;
			}
			dispatchEvent(barLoadEvent);
		}
		
		public function firstLaunched(event: ServerEvent): void {
			firstLaunch = true;
			firstClientServed = false;
			if (isLoaded && !addedStartProduction) {
				addStartProduction();
			}
			server.sendVKAttrs(myBarPlace.user.fullName, myBarPlace.user.photoPath);
		}
	}
}