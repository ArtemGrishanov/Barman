package com.bar.ui.tooltips
{
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ClientToolTip extends ToolTip
	{
		public static const NAME_TF_Y: Number = 8;
		public static const PRODUCTION_TF_Y: Number = 20;
		public static const PRODUCTION_BITMAP_Y: Number = 40;
		public static const BOTTOM_INDENT: Number = 5;
		
		private var nameTf: TextField;
		private var productionTf: TextField;
		private var productionBitmap: Bitmap;
		
		public function ClientToolTip(value:GameScene, w:Number, h:Number)
		{
			super(value, w, h);
			nameTf = new TextField();
			nameTf.y = NAME_TF_Y;
			nameTf.text = '';
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(nameTf);
			productionTf = new TextField();
			productionTf.y = PRODUCTION_TF_Y;
			productionTf.text = '';
			productionTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(productionTf);
		}
		
		public function setAttrs(name: String, prodName: String, prodImage: Bitmap): void {
			nameTf.text = name;
			productionTf.text = prodName;
			nameTf.x = (width - nameTf.width) / 2;
			productionTf.x = (width - productionTf.width) / 2;
			if (productionBitmap && contains(productionBitmap)) {
				removeChild(productionBitmap);
			}
			productionBitmap = prodImage;
			if (productionBitmap && contains(productionBitmap)) {
				removeChild(productionBitmap);	
			}
			addChild(productionBitmap);
			productionBitmap.x = (width - productionBitmap.width) / 2;
			productionBitmap.y = PRODUCTION_BITMAP_Y;
			height = productionBitmap.y + productionBitmap.height + BOTTOM_INDENT;
			super.update();
		}
	}
}