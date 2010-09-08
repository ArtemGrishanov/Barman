package com.flashmedia.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapUtil
	{
		public static const ZOOM_PERMIT: String = 'scale_policy_no_stretch';
		public static const ZOON_DENY: String = 'scale_policy_stretch';
		public static const PROPORTION_SAVE: String = 'scale_policy_no_stretch';
		public static const PROPORTION_DONT_SAVE: String = 'scale_policy_no_stretch';
		
		
		public function BitmapUtil()
		{
		}
		
		public static function cloneBitmap(image:Bitmap):Bitmap {
			return new Bitmap(image.bitmapData);
		}
		
//		public static function cloneImageNamed(imageName:String):Bitmap {
//			return new Bitmap(Util.multiLoader.get(imageName).bitmapData);
//		}

		public static function scaleImage(bitmap: Bitmap, scaleWidth: Number = NaN, scaleHeight: Number = NaN, keepProportion: Boolean = true): Bitmap {
			return scaleImageWidthHeight(bitmap, bitmap.width * scaleWidth, bitmap.height * scaleHeight, keepProportion);
		}

		public static function scaleImageWidthHeight(bitmap: Bitmap, width: Number = NaN, height: Number = NaN, keepProportion: Boolean = true): Bitmap {
			if (!width && !height) {
				return cloneBitmap(bitmap);
			}
			if (!width && height) {
				if (keepProportion) {
					width = bitmap.width * height / bitmap.height;
				}
				else {
					width = bitmap.width;
				}
			}
			if (!height && width) {
				if (keepProportion) {
					height = bitmap.height * width / bitmap.width;
				}
				else {
					height = bitmap.height;
				}
			}
			if (keepProportion) {
				var k1: Number = width / bitmap.width;
				var k2: Number = height / bitmap.height;
				if (k1 > k2) {
					width = bitmap.width * k2;
				}
				else if (k1 < k2) {
					height = bitmap.height * k1;
				}
			}
			var matrix: Matrix = new Matrix();
			matrix.scale(width / bitmap.width, height / bitmap.height);
			var result: Bitmap = new Bitmap(new BitmapData(width, height, true, 0x00ffffff));
			result.bitmapData.draw(bitmap, matrix, null, null, null, true);
			return result;
		}
		
		public static function createImage(top:Bitmap, mid:Bitmap, bottom:Bitmap, height:uint):Bitmap {
			var data:BitmapData = new BitmapData(top.width, height);
			var rect:Rectangle = new Rectangle(0, 0, top.width, top.height);
			var point:Point = new Point(0, 0);
			data.copyPixels(top.bitmapData, rect, point);
			
			rect = new Rectangle(0, 0, mid.width, mid.height);
			var i:int;
			var count:int = height - bottom.height;
			for (i = top.height; i < count; ++i) {
				point = new Point(0, i);
				data.copyPixels(mid.bitmapData, rect, point);
			}
			
			rect = new Rectangle(0, 0, bottom.width, bottom.height);
			point = new Point(0, height - bottom.height);
			data.copyPixels(bottom.bitmapData, rect, point);
			
			var result:Bitmap = new Bitmap(data);
			return result;
		}
	}
}