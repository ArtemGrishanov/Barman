package com.bar.model
{
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.ProductionType;
	
	import flash.display.Bitmap;
	
	public class User
	{
		public var level: Number = Balance.startLevel;
		public var experience: uint = Balance.startExperience;
		public var love: Number = Balance.startLove;
		public var invites: uint = 0;
		public var moneyCent: Number = Balance.startMoneyCent;
		public var moneyEuro: Number = Balance.startMoneyEuro;
		/**
		 * Содержит имена типов продукции, которые лицензированы пользователем.
		 * ['String']
		 */
		public var licensedProdTypes: Array;
		/**
		 * Ид пользователя в соц сети
		 */
		public var id_user: String = '9028622';
		public var fullName: String = '';
		public var photoPath: String = '';
		public var photo: Bitmap;
		
		public function User(_id_user: String,
							_fullName: String,
							_level: Number = 1,
							_experience: Number = 0,
							_love: Number = 0,
							_invites: Number = 0,
							_moneyCent: Number = 0,
							_moneyEuro: Number = 0,
							_licensedProdTypes: Array = null,
							_photo: Bitmap = null)
		{
			id_user = _id_user;
			fullName = _fullName;
			level = _level;
			experience = _experience;
			love = _love;
			invites = _invites;
			moneyCent = _moneyCent;
			moneyEuro = _moneyEuro;
			photo = _photo;
			licensedProdTypes = _licensedProdTypes;
			if (!licensedProdTypes) {
				licensedProdTypes = new Array();
			}
		}
		
		/**
		 * Загрузить с сервера параметры пользователя
		 * experience, love
		 */
		public function loadUserParams(): void {
			
		}
		
		/**
		 * Проверяет, лицензирован ли какой-то конкретный вид продукции.
		 */
		public function isLicensed(typeProduction: ProductionType): Boolean {
			for each (var t: String in licensedProdTypes) {
				if (t == typeProduction.type) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Возвращает, может ли пользовтель лицензировать определенный тип продукции.
		 */
		public function canLicenseProduction(typeProduction: ProductionType): Boolean {
		 	var haveCents: Boolean = true;
			if (typeProduction.licenseCostCent > 0) {
				haveCents = (moneyCent >= typeProduction.licenseCostCent);
			}
			var haveEuro: Boolean = true;
			if (typeProduction.licenseCostEuro > 0) {
				haveEuro = (moneyEuro >= typeProduction.licenseCostEuro);
			}
			return haveCents && haveEuro;
		}
		
		/**
		 * Возвращает, может ли пользовтель купить определенный тип продукции.
		 */
		public function canBuyProduction(typeProduction: ProductionType): Boolean {
		 	var haveCents: Boolean = true;
			if (typeProduction.priceCent > 0) {
				haveCents = (moneyCent >= typeProduction.priceCent);
			}
			var haveEuro: Boolean = true;
			if (typeProduction.priceEuro > 0) {
				haveEuro = (moneyEuro >= typeProduction.priceEuro);
			}
			return haveCents && haveEuro;
		}
		
		/**
		 * Возвращает, может ли пользовтель купить определенный тип декора.
		 */
		public function canBuyDecor(typeDecor: DecorType): Boolean {
		 	var haveCents: Boolean = true;
			if (typeDecor.priceCent > 0) {
				haveCents = (moneyCent >= typeDecor.priceCent);
			}
			var haveEuro: Boolean = true;
			if (typeDecor.priceEuro > 0) {
				haveEuro = (moneyEuro >= typeDecor.priceEuro);
			}
			return haveCents && haveEuro;
		}
	}
}