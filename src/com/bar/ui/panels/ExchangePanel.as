package com.bar.ui.panels
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ExchangePanel extends GameLayer
	{
		public static const WIDTH: Number = 150;
		public static const HEIGHT: Number = 30;
		
//		public static const NAME_TF_Y: Number = 6;
//		public static const GOODS_TF_X: Number = 60;
//		public static const GOODS_TF_Y: Number = 25;
//		public static const PRICE_TF_X: Number = 60;
//		public static const PRICE_TF_Y: Number = 40;
//		public static const GOODS_CENTER_X: Number = 25;
//		public static const GOODS_CENTER_Y: Number = 40;
//		public static const EXP_ICON_CENTER_X: Number = 52;
//		public static const EXP_ICON_CENTER_Y: Number = 35;
//		public static const MONEY_ICON_CENTER_X: Number = 52;
//		public static const MONEY_ICON_CENTER_Y: Number = 48;
		
		private var nameTf: TextField;
		private var moneyBitmap: Bitmap;
		
		public function ExchangePanel(value: GameScene, votes: Number, cents: Number = 0, euro: Number = 0)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			
			//todo fix
			graphics.beginFill(0x888888, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 8, 8);
			graphics.endFill();
			
			nameTf = new TextField();
			if (cents > 0) {
				moneyBitmap = BitmapUtil.cloneBitmap(new Bitmap(new BitmapData(15, 15, false, 0x00ff00)));
				nameTf.text = ' ' + cents.toString() + ' = ' + votes.toString() + ' голос';
			}
			else if (euro > 0) {
				moneyBitmap = BitmapUtil.cloneBitmap(new Bitmap(new BitmapData(15, 15, false, 0x0aff0a)));
				nameTf.text = ' ' + euro.toString() + ' = ' + votes.toString() + ' голос';
			}
			addChild(moneyBitmap);
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(nameTf);
			moneyBitmap.x = (width - (nameTf.width + moneyBitmap.width)) / 2;
			moneyBitmap.y = (height - moneyBitmap.height) / 2;
			nameTf.x = moneyBitmap.x + moneyBitmap.width;
			nameTf.y = (height - nameTf.height) / 2;
		}
	}
}