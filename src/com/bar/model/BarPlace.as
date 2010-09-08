package com.bar.model
{
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.Goods;
	import com.bar.model.essences.Production;
	import com.util.Selector;
	
	public class BarPlace
	{
		/**
		 * Данные пользователя, кому принадлежит бар
		 */
		public var user: User;
		public var production: Array;
		public var productionBackup: Array;
		public var clients: Array;
		public var clientsHistory: Array;
		public var decor: Array;
		public var barman: Barman;
		/**
		 * Чаевые, которые дали клиенты, но еще не забрал бармен.
		 * ['tipsMoneyCent'] - количество денег
		 * ['tipsMoneyEuro'] - количество денег
		 * ['clientId'] - ид клиента, кто оставил на чай
		 * ['position'] - позиция, на которой оставлены чаевые
		 * ['time'] - время создания
		 */
		public var tips: Array;
		
		public function BarPlace(_user: User)
		{
			user = _user;
			clients = new Array();
			clientsHistory = new Array();
			production = new Array();
			productionBackup = new Array();
			decor = new Array();
			barman = new Barman();
			tips = new Array();
		}
		
		/**
		 * Сохранить состояние продукции бара
		 */
		public function createProductionBackup(): void {
			productionBackup = new Array();
			for each (var p: Production in production) {
				productionBackup.push(p.clone());
			}
		}
		
		/**
		 * Восстановить состояние продукции из бекапа
		 */
		public function restoreProductionFromBackup(): void {
			production = productionBackup;
		}

		/**
		 * Можно ли приготовить товар из того, что есть в баре (на полке)
		 */
		public function canMakeGoods(goods: Goods): Boolean {
			return (deficitProdTypesForGoods(goods) == null);
		}

//		/**
//		 * Можно ли приготовить товар из того, что есть в баре (на полке)
//		 */
//		public function canMakeGoodsType(typeGoods: GoodsType): Boolean {
//			var result: Array = new Array();
//			for each (var t: Object in typeGoods.composition) {
//				var existPartsCount: uint = t['partsCount'];
//				for each (var p: Production in production) {
//					if (t['productionType'] == p.typeProduction.type && existPartsCount > 0) {
//						if (p.partsCount >= existPartsCount) {
//							existPartsCount = 0;
//						} else {
//							existPartsCount -= p.partsCount;
//						}
//					}
//				}
//				if (existPartsCount > 0) {
//					return false;
//				}
//			}
//			return true;
//		}
		
		/**
		 * Получить типы продукции, которых не хватает для приготовления текущего заказа.
		 * @return array
		 *    ['productionType']
		 *    ['partsCount']
		 * array - то, что надо купить в магазе
		 * null - нет нехватки, продукт можно приготовить
		 * Не должно быть такого, что для приготовления товара нужно 2 и более ед. одной полной продукции!
		 */
		public function deficitProdTypesForGoods(goods: Goods): Array {
			if (goods) {
				var result: Array = new Array();
				var needProdTypes: Array = goods.needProduction;
				for each (var t: Object in needProdTypes) {
					var needParts: int = t['partsCount'];
					for each (var p: Production in production) {
						if ((t['productionType'] == p.typeProduction.type) && (p.partsCount > 0)) {
							needParts -= p.partsCount;
						}
					}
					if (needParts > 0) {
						result.push({'productionType': t['productionType'], 'partsCount': needParts});
					}
				}
				return (result.length > 0) ? result : null;
			}
			return null;
		}
		
		/**
		 * Получить экземпляры конкретной продукции (которая стоит на полке) для приготовления текущего заказа.
		 * @return - Production array
		 */
		public function productionForGoods(goods: Goods): Array {
			if (goods) {
				var result: Array = new Array();
				var needProdTypes: Array = goods.needProduction;
				for each (var t: Object in needProdTypes) {
					for each (var p: Production in production) {
						if ((t['productionType'] == p.typeProduction.type) && (p.partsCount > 0)) {
							result.push(p);
						}
					}
				}
				return result;
			}
			return null;
		}
	
		/**
		 * Возвращает суммарную вероятность чаевых от всех бонусов бара (декора).
		 */	
		public function get tipProb(): Number {
			var prs: Array = new Array();
			for each (var d: Decor in decor) {
				prs.push(d.typeDecor.tipProbCount);
			}
			return Selector.sumProbs(prs);
		}
		
		/**
		 * Возвращает, куплен ли уже такой декор
		 */
		public function decorExist(typeDecor: DecorType): Boolean {
			for each (var d: Decor in decor) {
				if (d.typeDecor.type == typeDecor.type) {
					return true;
				}
			}
			return false;
		}
	}
}