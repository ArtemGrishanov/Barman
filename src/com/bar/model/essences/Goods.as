package com.bar.model.essences
{
	import com.bar.model.Balance;
	
	public class Goods
	{
		public var id: Number;
		public var typeGoods: GoodsType;
		/**
		 * Продукции, которая сейчас находится в этом товаре.
		 * Может все, что должно быть в составе, а может Goods еще готовится и в нем нет ничего.
		 *    ['productionType'] - тип продукции
		 *    ['addedPartsCount'] - количество порций
		 */
		public var addedProdParts: Array;
		
		public function Goods(_typeGoods: GoodsType)
		{
			id = Balance.getUnicId();
			typeGoods = _typeGoods;
			addedProdParts = new Array();
		}
		
		/**
		 * Добавить Продукцию в товар. Берутся столько порций из продукции, сколько возможно.
		 * Но может их и не хватить.
		 * С продукции production списывается возможное количество порция
		 * @return - возвращает, сколько порций было реально добавлено в товар.
		 * 0 - такая порция не нужна в товаре, или такая продукция уже полностью добавлена ранее.
		 */
		public function addProduction(production: Production): uint {
			var result: uint = 0;
			var thisProdPartsCount: uint = typeGoods.getPartsCount(production.typeProduction.type);
			var addedProd: Object = null;
			for each (var o: Object in addedProdParts) {
				if (o['productionType'] == production.typeProduction.type) {
					addedProd = o;
					break;
				}
			}
			if (!addedProd) {
				addedProd = {'productionType': production.typeProduction.type, 'addedPartsCount': 0};
				addedProdParts.push(addedProd);
			}
			if (addedProd['addedPartsCount'] < thisProdPartsCount) {
				if (addedProd['addedPartsCount'] + production.partsCount > thisProdPartsCount) {
					production.partsCount -= (thisProdPartsCount - addedProd['addedPartsCount']);
					addedProd['addedPartsCount'] = thisProdPartsCount;
					result = thisProdPartsCount;
				}
				else {
					addedProd['addedPartsCount'] += production.partsCount;
					result = production.partsCount;
					production.partsCount = 0;
				}
				return result;
			}
			return 0;
		}
		
		/**
		 * Получить типы продукции и количество частей, которых не достает для приготовления этого товара.
		 * @return array
		 *    ['productionType'] String
		 *    ['partsCount'] int
		 */
		public function get needProduction(): Array {
			var result: Array = new Array();
			for each (var o: Object in typeGoods.composition) {
				var pt: String = o['productionType'];
				var finded: Boolean = false;
				for each (var a: Object in addedProdParts) {
					if (pt == a['productionType']) {
						finded = true;
						if (a['addedPartsCount'] < typeGoods.getPartsCount(pt)) {
							result.push({'productionType': pt, 'partsCount': (typeGoods.getPartsCount(pt) - a['addedPartsCount'])});
						}
					}
				}
				if (!finded) {
					result.push({'productionType': pt, 'partsCount': typeGoods.getPartsCount(pt)});
				}
			}
			return result;
		}
		
		/**
		 * Показывает, готов ли товар. То есть все порции добавлены.
		 * true - товар готов
		 */
		public function get completed(): Boolean {
			for each (var comp: Object in typeGoods.composition) {
				var typeCompl: Boolean = false;
				for each (var adp: Object in addedProdParts) {
					if (adp['productionType'] == comp['productionType']) {
						typeCompl = adp['addedPartsCount'] == comp['partsCount'];
						break;
					}
				}
				if (!typeCompl) {
					return false;
				}
			}
			return true;
		}

	}
}