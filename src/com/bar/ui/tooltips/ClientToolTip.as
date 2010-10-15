package com.bar.ui.tooltips
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ClientToolTip extends ToolTip
	{
		public static const WIDTH: Number = 180;
		public static const HEIGHT: Number = 200;
		public static const NAME_TF_Y: Number = 8;
		public static const PRODUCTION_TF_Y: Number = -7;
		public static const PRODUCTION_BITMAP_CENTER_Y: Number = 67;
		public static const BOTTOM_INDENT: Number = 5;
		
//		private var nameTf: TextField;
		private var productionTf: TextField;
		private var productionBitmap: Bitmap;
		
		public function ClientToolTip(value:GameScene)
		{
			super(value);
			bitmapPointerDown = BitmapUtil.scaleWith9Grid(bitmapPointerDown, new Rectangle(10, 10, 125, 55), 150, 160);
			bitmap = bitmapPointerDown;
			contentArea.width = width - CONTENT_LEFT_INDENT - CONTENT_RIGHT_INDENT;
//			nameTf = new TextField();
//			nameTf.y = NAME_TF_Y;
//			nameTf.text = '';
//			nameTf.autoSize = TextFieldAutoSize.LEFT;
//			contentArea.addChild(nameTf);
			productionTf = new TextField();
			productionTf.y = PRODUCTION_TF_Y;
			productionTf.text = '';
			productionTf.autoSize = TextFieldAutoSize.LEFT;
			productionTf.defaultTextFormat = new TextFormat("Arial", 14);
			contentArea.addChild(productionTf);
			width = WIDTH;
			height = HEIGHT;
		}
		
		public function setAttrs(name: String, prodName: String, prodImage: Bitmap): void {
			//TODO Имена реальных пользователей будут в след версии.
//			nameTf.text = name;
			productionTf.text = prodName;
//			nameTf.x = (contentArea.width - nameTf.width) / 2;
			productionTf.x = (contentArea.width - productionTf.width) / 2;
			if (productionBitmap && contains(productionBitmap)) {
				contentArea.removeChild(productionBitmap);
			}
			productionBitmap = prodImage;
			if (productionBitmap && contains(productionBitmap)) {
				contentArea.removeChild(productionBitmap);	
			}
			contentArea.addChild(productionBitmap);
			productionBitmap.x = (contentArea.width - productionBitmap.width) / 2;
			productionBitmap.y = PRODUCTION_BITMAP_CENTER_Y - productionBitmap.height / 2;
			height = productionBitmap.y + productionBitmap.height + BOTTOM_INDENT;
			super.update();
		}
	}
}