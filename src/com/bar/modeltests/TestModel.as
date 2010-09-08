package com.bar.modeltests
{
	import com.bar.api.Server;
	import com.bar.model.Balance;
	import com.bar.model.Core;
	import com.bar.model.CoreEvent;
	import com.bar.model.essences.Client;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	import com.util.Selector;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TestModel
	{
		public var timer: Timer;
		public var modelStat: ModelStatistics;
		
		public function TestModel()
		{
			//социальное
			//todo заход в бар другого пользователя
			//todo возможность напиться
			//todo глобальная лента (каталог) баров со своим сообщением
			//todo глобальная лента (каталог) напившихся пользователей
			//todo ежедневный заход в приложение - бонусы
			//todo при заходе в приложение показ сообщения (раз в день, каждый раз)
			//todo ТОПы пользователей
			//todo флирт с посетителями (подробнее в гд)
			//todo обмен личными сообщениями
			
			//бар
			//todo прочие действия по обслуживанию бара (подробнее в гд)
			//todo сбор простейшей статистики
			
			//trace(Selector.sumProbs([0.1, 0.05, 0.05, 0.1, 0.04]));
			modelStat = new ModelStatistics();
			modelStat.startNewLevel(1);
			
			timer = new Timer(2000, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			//core = new Core(Bar.viewer_id, Bar.fullName, Bar.photoPath, srv);
			Bar.core.addEventListener(CoreEvent.EVENT_BAR_LOADED, barLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_DECOR_LOADED, decorLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_LOADED, productionLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_GOODS_LOADED, goodsLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_NEW_CLIENT, newClient);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_STATUS_CHANGED, clientStatusChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_DENIED, clientDenied);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_DELETED, clientDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_START_SERVING, clientStartServing);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_STOP_SERVING, clientStopServing);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_SERVED, clientServed);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_PAY_TIP, clientPayTip);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_MOOD_CHANGED, clientMoodChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_LICENSED, productionLicensed);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_ADDED_TO_BAR, addProductionToBar);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_UPDATED, productionUpdated);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_ADDED_TO_CUR_GOODS, productionAddedToCurGoods);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_EMPTY, productionEmpty);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_DELETED, productionDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_MONEY_CENT_CHANGED, userMoneyCentChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_EXP_CHANGED, userExpChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LEVEL_CHANGED, userLevelChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LOVE_CHANGED, userLoveChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_BARMAN_TAKE_TIP, barmanTakeTip);
			Bar.core.addEventListener(CoreEvent.EVENT_DECOR_ADDED_TO_BAR, addDecorToBar);
			
//			var pt1: ProductionType = new ProductionType('beerLight', 'Светлое пиво', 20, 1, 1, 0);
//			var pt2: ProductionType = new ProductionType('vodka', 'Водка', 70, 5, 2, 500);
//			
//			var gt: GoodsType = new GoodsType('beerLight', 'Светлое Пиво', [{'productionType': 'beerLight', 'partsCount': 1}], 30, 1, 1, 10);
//			var gt1: GoodsType = new GoodsType('ersh', 'Ерш', [{'productionType': 'beerLight', 'partsCount': 1}, {'productionType': 'vodka', 'partsCount': 2}], 40, 2, 2, 15);
//			var g: Goods = new Goods(gt1);
//			var p1: Production = new Production(pt1, 1);
//			var p2: Production = new Production(pt2);
//			g.addProduction(p1);
//			np = g.needProduction;
//			var addedParts: uint = 0;
//			var np: Array = null;
//			addedParts = g.addProduction(p2);
//			np = g.needProduction;
//			var compl: Boolean = g.completed;

//			Bar.core.changeClientStatus('client_id', 'new_status');
//			Bar.core.serveClient('client_id');
//			Bar.core.denyClient('client_id');
//			Bar.core.addProductionToGoods('production_id', 'goods_id');
//			Bar.core.loadBar('57856825');
//			Bar.core.buyDecor('decor_type');
//			Bar.core.buyProduction('prod_type');
		}
		
		public function onTimer(event: TimerEvent): void {
			if (Bar.core.myBarPlace.clients.length > 0) {
				//обслуживание клиентов
				if (Selector.prob(0.3)) {
					var c: Client = (Bar.core.myBarPlace.clients[Selector.chooseFromRange(0,Bar.core.myBarPlace.clients.length - 1)] as Client);
					Bar.core.startClientServing(c.id);
				}
				//покупка декора
				if (Selector.prob(0.5)) {
					for each (var dt: DecorType in Bar.core.decorTypes) {
						if (!Bar.core.myBarPlace.decorExist(dt) && Bar.core.myBarPlace.user.moneyCent > (dt.priceCent + 500 * Bar.core.myBarPlace.user.level + 500)) {
							Bar.core.buyDecor(dt);
						}
					}
				}
			}
		}
		
		
		public function barLoaded(event: CoreEvent): void {
			trace('Bar Loaded: ' + event.barPlace.user.fullName);
			trace('    Owner: ' + event.barPlace.user.fullName + '. Level: ' + event.barPlace.user.level);
			for each (var p: Production in event.barPlace.production) {
				trace('    Production: ' + p.typeProduction.name + '(' + p.partsCount + ') ' + p.id);
			}
			if (Bar.viewer_id == event.user_id) {
				
			}
			else {
				
			}
		}
		
		public function decorLoaded(event: CoreEvent): void {
		}
		
		public function productionLoaded(event: CoreEvent): void {
		}
		
		public function goodsLoaded(event: CoreEvent): void {
		}
		
		public function newClient(event: CoreEvent): void {
			trace('New Client: ' + event.client.name + ' Position: ' + event.client.position + ' Order: ' + event.client.orderGoodsType.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
		}
		
		public function clientStartServing(event: CoreEvent): void {
			trace('---------------------------');
			trace('Start Serving Client: ' + event.client.name + '. Order: ' + event.client.orderGoodsType.name);
			
			var dpt: Array = Bar.core.myBarPlace.deficitProdTypesForGoods(Bar.core.currentGoods);
			if (dpt) {
				for each (var dptElem: Object in dpt) {
					var tp: ProductionType = Balance.getProductionTypeByName(dptElem['productionType']);
					if (tp.needLicense() && !Bar.core.myBarPlace.user.isLicensed(tp)) {
						if (Bar.core.myBarPlace.user.canLicenseProduction(tp)) {
							Bar.core.licenseProduction(tp);
						}
						else {
							trace('Can not license production: ' + tp.type);
							Bar.core.denyClient(Bar.core.servingClient.id);
							return;
						}
					}
					Bar.core.buyProduction(tp);
				}
			}
			if (!Bar.core.myBarPlace.canMakeGoods(Bar.core.currentGoods)) {
				trace('========== !!! Can not serve. Help !!! ==============');
				Bar.core.stopClientServing(Bar.core.servingClient.id);
			}
			
			var arr: Array = Bar.core.myBarPlace.productionForGoods(Bar.core.currentGoods);
			trace('Available production: ');
			for each (var p: Production in arr) {
				trace('    Production: ' + p.typeProduction.name + '(' + p.partsCount + ') ' + p.id);
			}
//			if (Selector.prob(0.1)) {
//				Bar.core.stopClientServing(Bar.core.servingClient.id);
//			}
//			else {
				for each (p in arr) {
					//todo была ошибка servingClient = null
					Bar.core.makeGoods(p);
				}
//			}
		}
		
		public function clientStopServing(event: CoreEvent): void {
			trace('Stop Serving Client: ' + event.client.name + '. Order: ' + event.client.orderGoodsType.name);
			trace('----------------------------');
		}
		
		public function clientServed(event: CoreEvent): void {
			trace('Client Served: ' + event.client.name);
			trace('----------------------------');
			modelStat.lastLevel.goods.push(event.goods);
			modelStat.lastLevel.clientsServed.push(event.client);
		}
		
		public function clientStatusChanged(event: CoreEvent): void {
			switch (event.client.status) {
				case Client.STATUS_WAITING:
					
				break;
				case Client.STATUS_ORDERING:
					
				break;
				case Client.STATUS_EATING:
					
				break;
			}
		}
		
		public function clientPayTip(event: CoreEvent): void {
			trace('$$$ Tips Cents:: ' + event.tipMoneyCent + ' - ' + event.client.name);
			Bar.core.takeTips(event.client.id);
		}
		
		public function clientDeleted(event: CoreEvent): void {
			//trace('Client deleted:: ' + event.client.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
		}
		
		public function clientDenied(event: CoreEvent): void {
			trace('Client denied:: ' + event.client.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
			modelStat.lastLevel.clientsDenied.push(event.client);
		}
		
		public function clientMoodChanged(event: CoreEvent): void {
			trace('Mood changed:: ' + event.client.mood + '(' + Client.MIN_MOOD + '-' + Client.MAX_MOOD + ') ' + event.client.name);
		}
		
		public function addProductionToBar(event: CoreEvent): void {
			trace('Production added to bar:: Production: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
		}
		
		public function productionUpdated(event: CoreEvent): void {
		}
		
		public function productionAddedToCurGoods(event: CoreEvent): void {
			trace('Production added to cur goods:: Production: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
		}
		
		public function productionEmpty(event: CoreEvent): void {
			trace('Production Empty:: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
			Bar.core.deleteProduction(event.production.id);
		}
		
		public function productionDeleted(event: CoreEvent): void {
			trace('Production Deleted:: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
		}
		
		public function userMoneyCentChanged(event: CoreEvent): void {
			var d: Number = event.newMoneyCent - event.oldMoneyCent;
			trace('$$$ Money Cents: ' + event.newMoneyCent + ' (' + ((event.newMoneyCent > event.oldMoneyCent)?'+':'') + d + ')');
			modelStat.lastLevel.moneyCent = event.newMoneyCent;
			if (d >= 0) {
				modelStat.lastLevel.moneyCentUp += d;
			}
			else {
				modelStat.lastLevel.moneyCentDown += d;
			}
		}
		
		public function userLevelChanged(event: CoreEvent): void {
			var d: Number = event.newLevel - event.oldLevel;
			trace('Level: ' + event.newLevel + ' (' + ((event.newLevel > event.oldLevel)?'+':'') + d + ')');
			modelStat.lastLevel.endLevel();
			trace(modelStat.lastLevel.toString());
			modelStat.startNewLevel(event.newLevel);
		}
		
		public function userLoveChanged(event: CoreEvent): void {
			var d: Number = event.newLove - event.oldLove;
			trace('Love: ' + event.newLove + ' (' + ((event.newLove > event.oldLove)?'+':'') + d + ')');
			modelStat.lastLevel.loveCount += d;
		}
		
		public function userExpChanged(event: CoreEvent): void {
			var d: Number = event.newExp - event.oldExp;
			trace('Experience: ' + event.newExp + ' (' + ((event.newExp > event.oldExp)?'+':'') + d + ')');
		}
		
		public function barmanTakeTip(event: CoreEvent): void {
			trace('Barman take tip: ' + event.tipMoneyCent + '. From client: ' + event.clientId);
		}
		
		public function addDecorToBar(event: CoreEvent): void {
			trace('Decor added to bar:: Decor: ' + event.decor.typeDecor.name + '. Id:' + event.decor.id);
			modelStat.lastLevel.decor.push(event.decor);
		}
		
		public function productionLicensed(event: CoreEvent): void {
			trace('Production Licensed: ' + event.typeProduction.type + ' Cost: ' + event.typeProduction.licenseCostCent + 'c. ' + event.typeProduction.licenseCostEuro + 'e.');
			modelStat.lastLevel.licensedProdTypes.push(event.typeProduction);
		}
	}
}