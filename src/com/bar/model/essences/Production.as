package com.bar.model.essences
{
	import com.bar.model.Balance;
	
	public class Production
	{
		public var id: Number;
		public var typeProduction: ProductionType;
		/**
		 * Сколько частей продукции сейчас в ней находится.
		 */
		public var partsCount: uint;
		/**
		 * Координаты продукции в баре. Где она находится - ведь клиент может перетаскивать ее.
		 */
		public var cellIndex: int;
		public var rowIndex: int;
		
		public function Production(_typeProduction: ProductionType, _partsCount: int = -1)
		{
			id = Balance.getUnicId();
			typeProduction = _typeProduction;
			if (_partsCount < 0) {
				partsCount = typeProduction.partsCount;
			}
			else {
				if (_partsCount > _typeProduction.partsCount) {
					_partsCount = _typeProduction.partsCount;
				}
				partsCount = _partsCount;
			}
		}
		
		public function clone(): Production {
			var p: Production = new Production(typeProduction, partsCount);
			p.id = id;
			return p;
		}

	}
}