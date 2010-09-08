package com.bar.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class UIUtil
	{
		public function UIUtil()
		{
		}

		public static function inRect(p: Point, rect: Rectangle): Boolean {
			return p.x >= rect.x && p.x <= (rect.x + rect.width) && p.y >= rect.y && p.y <= (rect.y + rect.height);
		}
	}
}