package com.bar.model
{
	import com.bar.model.essences.Client;
	import com.bar.model.essences.ClientType;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	import com.util.Selector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Balance
	{
		/**
		 * Период таймера в движке
		 * МИЛЛИСЕКУНДЫ
		 */
		public static var coreTimerPeriod: Number = 2000;
		/**
		 * Начальные деньги
		 */
		public static var startMoneyCent: uint = 1000;
		public static var startMoneyEuro: uint = 5;
		/**
		 * Деньги за ежедневный заход в приложение
		 */
		public static var moneyCentDayVisit: uint = 100;
		/**
		 * Уровень с которого начинается игра 
		 */
		public static var startLevel: uint = 1;
		/**
		 * Опыт с которого начинается игра 
		 */
		public static var startExperience: uint = 0;
		/**
		 * Максимальный уровень в игре 
		 */
		public static var maxLevel: uint = 10;
		/**
		 * Количество опыта для получения каждого уровня
		 * При переходе от уровня к уровню опыт не сбрасывается. Растет все время по ходу игры.
		 */
		public static var levelExp: Array = new Array (0, 10, 30, 60, 100, 150, 210, 280, 370, 480, 580);
		/**
		 * Начальное количество любви
		 */
		public static var startLove: uint = 100;
		/**
		 * Количество любви, которое снимется, если клиента, откажутся обслуживать.
		 */
		public static var loveForDenyClient: int = -3;
		/**
		 * Максимальное количество клиентов в баре
		 */
		public static var maxClientsCount: uint = 4;
		/**
		 * Минимальная скорость прихода клиентов. Человек/минуту
		 * К ней прибавляется еще скорость от любви и количества приглашенных.
		 */
		public static var minClientSpeed: Number = 5;
		/**
		 * Период, по истечении которого у клиента уменьшается настроение
		 * СЕКУНДЫ
		 */
		public static var periodToLowMood: uint = 5;
		/**
		 * Базовая, минимальная вероятность выдачи чаевых
		 */
		public static var baseTipProb: Number = 0.3;
		/**
		 * Максимальное настроение клиента
		 */
		public static const maxClientMood: int = 5;
		/**
		 * Время "жизни" чаевых. Секунды.
		 */
		public static const tipsLifeTime: int = 5;
//		/**
//		 * Минимальное количество клиентов, приходящих в клиентский период
//		 */
//		public static var minClientsCountInClientPeriod: Number = 3;
//		/**
//		 * Клиентский период, для рассчета скорости прихода клиентов
//		 * СЕКУНДЫ 
//		 */
//		public static var clientPeriod: Number = 10;
		public static var clientTypes: Array;
		public static var decorTypes: Array;
		public static var productionTypes: Array;
		public static var goodsTypes: Array;

		{
			initClientTypes();
			initDecorTypes();
			initProductionTypes();
			initGoodsTypes();
		}

		public function Balance()
		{
		}
		
//		/**
//		 * Загрузка настроек с сервера
//		 */
//		public static function loadBalance(): void {
//			
//		}
		
		/**
		 * Возвращает типы клиентов в игре
		 */
		public static function initClientTypes(): void {
			clientTypes = new Array();
			clientTypes.push(new ClientType('man-kachok', ClientType.MALE, -97, -231, new Bitmap(new BitmapData(50, 50, false, 0xdede44))));
			clientTypes.push(new ClientType('sexy-blond', ClientType.FEMALE, -97, -231, new Bitmap(new BitmapData(30, 50, false, 0xffd004))));
		}
		
		/**
		 * Возвращает типы декора в игре
		 */
		public static function initDecorTypes(): void {
			decorTypes = new Array();
			decorTypes.push(new DecorType('picture1', 'Картина 1', 0, 0, 0, 0, 0, 0, 10, 535, 155));
			decorTypes.push(new DecorType('shkaf1', 'Шкаф 1', 0, 0, 0, 0, 0, 0, 5, 241, 60));
			decorTypes.push(new DecorType('wall1', 'Стена 1', 0, 0, 0, 0, 0, 0, 2, 0, 60));
			decorTypes.push(new DecorType('bartable1', 'Барная стойка 1', 0, 0, 0, 0, 0, 0, 20, 0, 428));
			decorTypes.push(new DecorType('stul1', 'Стул 1', 0, 0, 0, 0, 0, 0, 23, 50, 523));
			decorTypes.push(new DecorType('stul1', 'Стул 1', 0, 0, 0, 0, 0, 0, 23, 230, 523));
			decorTypes.push(new DecorType('stul1', 'Стул 1', 0, 0, 0, 0, 0, 0, 23, 410, 523));
			decorTypes.push(new DecorType('stul1', 'Стул 1', 0, 0, 0, 0, 0, 0, 23, 590, 523));
			decorTypes.push(new DecorType('lamp1', 'Лампа 1', 0, 0, 0, 0, 0, 0, 40, 83, 60));
			decorTypes.push(new DecorType('lamp1', 'Лампа 1', 0, 0, 0, 0, 0, 0, 40, 565, 60));
			decorTypes.push(new DecorType('woman_body', 'Бармен Девушка', 0, 0, 0, 0, 0, 0, 5, 56, 185));
			decorTypes.push(new DecorType('woman_pants1', 'Трусы 1', 0, 0, 0, 0, 0, 0, 6, 112, 374));
			decorTypes.push(new DecorType('woman_bust1', 'Ливчик 1', 0, 0, 0, 0, 0, 0, 6, 103, 264));
			decorTypes.push(new DecorType('woman_tshirt1', 'Блузка 1', 0, 0, 0, 0, 0, 0, 8, 97, 255));
			decorTypes.push(new DecorType('woman_skirt1', 'Юбка 1', 0, 0, 0, 0, 0, 0, 7, 111, 359));
			decorTypes.push(new DecorType('bartable_back1', 'Барная стойка задняя 1', 0, 0, 0, 0, 0, 0, 4, 0, 401));
			//decorTypes.push(new DecorType('Audio', 'Магнитофон', 2, 30, 20, 0.08, 800, 0, 350, 120));
		}
		
		/**
		 * Возвращает типы продукции в игре
		 */
		public static function initProductionTypes(): void {
			productionTypes = new Array();
			//1 level
			productionTypes.push(new ProductionType('beer', 'Светлое пиво', 50, 0, 1, 1, 0, 0));
			productionTypes.push(new ProductionType('vodka', 'Водка', 200, 0, 10, 1, 500, 0));
			productionTypes.push(new ProductionType('orange', 'Апельсиновый сок', 120, 0, 4, 1, 0, 0));
			productionTypes.push(new ProductionType('soda', 'Содовая', 40, 0, 1, 1, 0, 0));
			//2 level
			productionTypes.push(new ProductionType('viski', 'Виски', 320, 0, 8, 2, 1000, 0));
			productionTypes.push(new ProductionType('limon', 'Лимоны', 200, 0, 20, 2, 0, 0));
			productionTypes.push(new ProductionType('sirop', 'Сироп', 150, 0, 10, 2, 0, 0));
		}
		
		/**
		 * Возвращает типы товаров(коктейлей) в игре
		 */
		public static function initGoodsTypes(): void {
			goodsTypes = new Array();
			//1 level
			goodsTypes.push(new GoodsType('beer', 'Пиво', [{'productionType': 'beer', 'partsCount': 1}], 70, 1, 1, 10));
			goodsTypes.push(new GoodsType('vodka', 'Водка 100 грамм', [{'productionType': 'vodka', 'partsCount': 1}], 30, 1, 1, 10));
			goodsTypes.push(new GoodsType('soda', 'Содовая', [{'productionType': 'soda', 'partsCount': 1}], 55, 1, 1, 0));
			goodsTypes.push(new GoodsType('orange', 'Апельсиновый сок', [{'productionType': 'orange', 'partsCount': 1}], 45, 1, 1, 0));
			goodsTypes.push(new GoodsType('ersh', 'Ерш', [{'productionType': 'beer', 'partsCount': 1}, {'productionType': 'vodka', 'partsCount': 1}], 100, 2, 1, 15));
			goodsTypes.push(new GoodsType('otvertka', 'Отвертка', [{'productionType': 'vodka', 'partsCount': 1}, {'productionType': 'orange', 'partsCount': 1}], 70, 2, 1, 15));
			//2 level
			goodsTypes.push(new GoodsType('viski', 'Виски', [{'productionType': 'viski', 'partsCount': 1}], 60, 1, 2, 10));
			goodsTypes.push(new GoodsType('millionair', 'Миллионер', [{'productionType': 'viski', 'partsCount': 1}, {'productionType': 'sirop', 'partsCount': 1}, {'productionType': 'limon', 'partsCount': 1}], 95, 2, 2, 15));
			goodsTypes.push(new GoodsType('vodka-tonic', 'Водка-Тоник', [{'productionType': 'vodka', 'partsCount': 1}, {'productionType': 'soda', 'partsCount': 1}], 105, 2, 2, 15));
			goodsTypes.push(new GoodsType('jameson-viski-sayer', 'Джемесон Виски', [{'productionType': 'viski', 'partsCount': 1}, {'productionType': 'sirop', 'partsCount': 1}, {'productionType': 'limon', 'partsCount': 1}, {'productionType': 'orange', 'partsCount': 1}], 135, 3, 2, 15));
		}
		
		/**
		 * Возвращает начальные набор продукции
		 */
		public static function getStartProduction(): Array {
			var production: Array = new Array();
			production.push(new Production(productionTypes[0] as ProductionType));
			production.push(new Production(productionTypes[0] as ProductionType));
			production.push(new Production(productionTypes[0] as ProductionType));
			production.push(new Production(productionTypes[1] as ProductionType));
			return production;
		}
		
		/**
		 * Получить тип продукции по ее имени
		 * Иногда несостыковки, где-то передается String - имя, а где то ProductionType
		 */
		public static function getProductionTypeByName(name: String): ProductionType {
			for each (var p: ProductionType in productionTypes) {
				if (p.type == name) {
					return p;
				}
			}
			return null;
		}
		
		/**
		 * Получить тип клиента по ее имени
		 */
		public static function getClientTypeByName(name: String): ClientType {
			for each (var c: ClientType in clientTypes) {
				if (c.type == name) {
					return c;
				}
			}
			return null;
		}
		
		/**
		 * Получить тип товара по его имени
		 */
		public static function getGoodsTypeByName(name: String): GoodsType {
			for each (var g: GoodsType in goodsTypes) {
				if (g.type == name) {
					return g;
				}
			}
			return null;
		}
		
		/**
		 * Получить тип декора по его имени
		 */
		public static function getDecorTypeByName(name: String): DecorType {
			for each (var d: DecorType in decorTypes) {
				if (d.type == name) {
					return d;
				}
			}
			return null;
		}
		
		/**
		 * Получить количество любви за настроение клиента.
		 */
		public static function getLoveForMood(mood: Number): Number {
			return mood;
		}
		
		/**
		 * Выдает вероятность того, что клиент придет в данный момент
		 * Предполагается, что эта функция вызывается каждый тик таймера.
		 * И в итоге вероятность сработает примерно clientSpeed раз
		 * clientSpeed - скорость прихода чел/мин
		 */
		public static function getClientComeProb(clientSpeed: Number): Number {
			return (coreTimerPeriod / 1000 * clientSpeed) / 60;
		}
		
		/**
		 * Сумма чаевых, уплаченных клиентом.
		 * 0 - клиент не оставил чаевых.
		 */
		public static function tipsSum(barPlace: BarPlace, client: Client): Number {
			var p: Number = baseTipProb + barPlace.user.love * 0.001 + barPlace.tipProb + client.mood * 0.05;
			if (Selector.prob(p)) {
				return (int)(client.orderGoodsType.priceCent * 0.1);
			}
			//love: Number, barmanTips: Number, decorTips: Number, orderTime: Number
			return 0;
		}
	
		/**
		 * Количество любви от быстро обслуженных клиентов
		 */
		public static function loveSpeedService(): Number {
			return 1;
		}
		
//		/**
//		 * Клиент выбирает, что ему заказать
//		 * @return Индекс в массиве goods
//		 */
//		 public static function clientChooseGoods(goods: Array): uint {
//		 	return 0;
//		 }
		 
		 /**
		  * Получить уникальный идентификатор
		  */
		 public static function getUnicId(): Number {
		 	return Math.round(Math.random() * 1000000);
		 }
		
	}
}