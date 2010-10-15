package com.bar.model.essences
{
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	
	public class DecorType
	{
		public var type: String = '';
		public var name: String = '';
		/**
		 * Категория. Декор одной категории и разного типа заменяется при установке.
		 */
		public var category: String = '';
		public var accessLevel: uint;
		public var expCount: Number = 1;
		public var loveCount: Number = 1;
		public var tipProbCount: Number = 0.05;
		public var priceCent: Number;
		public var priceEuro: Number;
		/**
		 * Жесткое расположение декора в баре по координатам
		 */
		public var x: Number;
		public var y: Number;
		/**
		 * Регулирует наложение декора один на другой.
		 */
		public var zOrder: Number;
		/**
		 * Изображение, которое показывается в баре
		 */
		private var _bitmap: Bitmap;
		/**
		 * Иконка, которая показывается в магазине.
		 * Если иконка не задана, декор не показывается в магазине.
		 */
		public var bitmapSmall: Bitmap;
		
		public function DecorType(_type: String,
								_name: String,
								_category: String = null,
								_accessLevel: uint = 0,
								_expCount: Number = 1,
								_loveCount: Number = 1,
								_tipProbCount: Number = 0.05,
								_priceCent: Number = 10,
								_priceEuro: Number = 0,
								_zOrder: Number = 1,
								_x: Number = 0,
								_y: Number = 0,
								_bitmap: Bitmap = null,
								_bitmapSmall: Bitmap = null)
		{
			type = _type;
			name = _name;
			category = _category;
			accessLevel = _accessLevel;
			expCount = _expCount;
			loveCount = _loveCount;
			tipProbCount = _tipProbCount;
			priceCent = _priceCent;
			priceEuro = _priceEuro;
			zOrder = _zOrder;
			x = _x;
			y = _y;
			this._bitmap = _bitmap;
			bitmapSmall = _bitmapSmall;
		}
		
		public function set bitmap(value: Bitmap): void {
			_bitmap = value;
			//bitmapSmall = BitmapUtil.scaleImageWidthHeight(_bitmap, 30, 30, true);
		}
		
		public function get bitmap(): Bitmap {
			return _bitmap;
		}
	}
}