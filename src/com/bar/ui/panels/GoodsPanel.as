package com.bar.ui.panels
{
	import com.bar.model.essences.GoodsType;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class GoodsPanel extends GameLayer
	{
		public static const WIDTH: Number = 70;
		public static const HEIGHT: Number = 70;
		
		public static const NAME_TF_Y: Number = 6;
		public static const GOODS_TF_X: Number = 60;
		public static const GOODS_TF_Y: Number = 25;
		public static const PRICE_TF_X: Number = 60;
		public static const PRICE_TF_Y: Number = 40;
		public static const GOODS_CENTER_X: Number = 25;
		public static const GOODS_CENTER_Y: Number = 40;
		public static const EXP_ICON_CENTER_X: Number = 52;
		public static const EXP_ICON_CENTER_Y: Number = 35;
		public static const MONEY_ICON_CENTER_X: Number = 52;
		public static const MONEY_ICON_CENTER_Y: Number = 48;
		
		public var goodsType: GoodsType;
		private var nameTf: TextField;
		private var expTf: TextField;
		private var priceTf: TextField;
		private var intxTf: TextField;
		
		private var expBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var goodsBitmap: Bitmap;
		private var intxBitmap: Bitmap;
		private var enabledSprite: Sprite;
		
		private var mainMenu: MainMenuPanel;
		
		public function GoodsPanel(value: GameScene, gType: GoodsType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			goodsType = gType;
			mainMenu = menu;
			
			//todo fix
			graphics.beginFill(0xfda952, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 8, 8);
			graphics.endFill();
			
			goodsBitmap = BitmapUtil.scaleImage(gType.bitmap, NaN, 0.45);
			goodsBitmap.x = GOODS_CENTER_X - goodsBitmap.width / 2;
			goodsBitmap.y = GOODS_CENTER_Y - goodsBitmap.height / 2;
			addChild(goodsBitmap);
			nameTf = new TextField();
			nameTf.text = gType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = (width - nameTf.width) / 2;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
			expTf = new TextField();
			expTf.x = GOODS_TF_X;
			expTf.y = GOODS_TF_Y;
			expTf.text = gType.expCount.toString();
			expTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(expTf);
			priceTf = new TextField();
			priceTf.x = PRICE_TF_X;
			priceTf.y = PRICE_TF_Y;
			expBitmap = new Bitmap(new BitmapData(10, 10, false, 0xaaaaaa));
			expBitmap.x = EXP_ICON_CENTER_X - expBitmap.width / 2;
			expBitmap.y = EXP_ICON_CENTER_Y - expBitmap.height / 2;
			addChild(expBitmap);
			priceTf.text = gType.priceCent.toString();
			moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
			moneyBitmap.x = MONEY_ICON_CENTER_X - moneyBitmap.width / 2;
			moneyBitmap.y = MONEY_ICON_CENTER_Y - moneyBitmap.height / 2;
			addChild(moneyBitmap);
			priceTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(priceTf);
			enabledSprite = new Sprite();
			enabledSprite.graphics.beginFill(0xaaaaaa, 0.5);
			enabledSprite.graphics.drawRoundRect(0, 0, width, height, 8, 8);
			enabledSprite.graphics.endFill();
			enabledSprite.visible = false;
			addChild(enabledSprite);
		}
		
		public function set enabled(value: Boolean): void {
			enabledSprite.visible = !value;
		}
		
		public function get enabled(): Boolean {
			return !enabledSprite.visible;
		}
	}
}