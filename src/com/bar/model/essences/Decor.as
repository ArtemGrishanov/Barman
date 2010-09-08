package com.bar.model.essences
{
	import com.bar.model.Balance;
	
	public class Decor
	{
		public var id: Number;
		public var typeDecor: DecorType;
		
		public function Decor(_typeDecor: DecorType)
		{
			id = Balance.getUnicId();
			typeDecor = _typeDecor;
		}

	}
}