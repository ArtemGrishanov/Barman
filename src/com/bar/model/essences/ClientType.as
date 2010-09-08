package com.bar.model.essences
{
	import flash.display.Bitmap;
	
	public class ClientType
	{
		public static const FEMALE: int = 1;
		public static const MALE: int = 2;
		
		public var type: String = '';
		public var sex: String = '';
		public var dx: Number;
		public var dy: Number;
		public var bitmap: Bitmap;
		
		public function ClientType(_type: String, _sex: int, _dx: Number = 0, _dy: Number = 0, _bitmap: Bitmap = null) {
			type = _type;
			dx = _dx;
			dy = _dy;
			bitmap = _bitmap;
		}
		
	}
}