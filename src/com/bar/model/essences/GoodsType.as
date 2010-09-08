package com.bar.model.essences
{
	import flash.display.Bitmap;
	
	public class GoodsType
	{
		public var type: String = '';
		public var name: String = '';
		/**
		 * Состав товара
		 * Элемент массива:
		 *    ['productionType'] - тип продукции
		 *    ['partsCount'] - количество порций
		 */
		public var composition: Array = new Array();
		/**
		 * Цена товара. Товар продается только за игровые деньги.
		 */
		public var priceCent: Number = 1;
		/**
		 * Количество опыта, который дает товар
		 */
		public var expCount: Number = 1;
		public var accessLevel: uint = 1;
		/**
		 * Влияние на опьянение +/-
		 */
		public var intoxication: Number = 0;
		public var bitmap: Bitmap;
		
		public function GoodsType(_type: String,
							_name: String,
							_composition: Array,
							_priceCent: Number = 10,
							_expCount: Number = 1,
							_accessLevel: uint = 1,
							_intoxication: Number = 0)
		{
			type = _type;
			name = _name;
			composition = _composition;
			priceCent = _priceCent;
			expCount = _expCount;
			accessLevel = _accessLevel;
			intoxication = _intoxication;
		}
		
		/**
		 * Возвращает количество частей данной продукции, которые нужны для приготовления данного товара
		 */
		public function getPartsCount(typeProduction: String): uint {
			for each (var o: Object in composition) {
				if (o['productionType'] == typeProduction) {
					return o['partsCount'] as uint;
				}
			}
			return 0;
		}

	}
}