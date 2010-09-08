package com.bar.model.essences
{
	import flash.display.Bitmap;
	
	public class ProductionType
	{
		public var type: String = '';
		public var name: String = '';
		/**
		 * Стоимость продукции
		 */
		public var priceCent: Number = 1;
		public var priceEuro: Number = 1;
		/**
		 * Количество порций в продукции
		 */
		public var partsCount: uint = 1;
		/**
		 * Уровень, с которого доступна продукция
		 */
		public var accessLevel: uint = 1;
		/**
		 * Стоимость лицензии на продукцию. 0 - без лицензии
		 */
		public var licenseCostCent: Number = 0;
		public var licenseCostEuro: Number = 0;
		public var bitmap: Bitmap;
		
		public function ProductionType(_type: String,
								_name: String,
								_priceCent: Number = 1,
								_priceEuro: Number = 0,
								_partsCount: uint = 1,
								_accessLevel: uint = 1,
								_licenseCostCent: Number = 0,
								_licenseCostEuro: Number = 0)
		{
			type = _type;
			name = _name;
			priceCent = _priceCent;
			priceEuro = _priceEuro;
			partsCount = _partsCount;
			accessLevel = _accessLevel;
			licenseCostCent = _licenseCostCent;
			licenseCostEuro = _licenseCostEuro;
		}
		
		/**
		 * Возвращает, нужно ли лицензировать данный тип продукции.
		 */
		public function needLicense(): Boolean {
			return (licenseCostCent != 0 || licenseCostEuro != 0);
		}
	}
}