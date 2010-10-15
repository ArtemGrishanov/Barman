package com.bar.ui.panels
{
	import com.bar.model.essences.GoodsType;
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class GoodsPanel extends GameLayer
	{
		public static const WIDTH: Number = 130;
		public static const HEIGHT: Number = 60;

		public static const NAME_TF_X: Number = 33;
		public static const NAME_TF_CENTER_Y: Number = 7;
		public static const PRICE_TF_X: Number = 58;
		public static const PRICE_TF_CENTER_Y: Number = 26;
		public static const EXP_TF_X: Number = 58;
		public static const EXP_TF_CENTER_Y: Number = 43;
		public static const LEVEL_TF_CENTER_X: Number = 110;
		public static const LEVEL_TF_CENTER_Y: Number = 40;
		
		public static const GOODSICO_CENTER_X: Number = 19;
		public static const GOODSICO_CENTER_Y: Number = 32;
		public static const MONEY_ICON_CENTER_X: Number = 47;
		public static const MONEY_ICON_CENTER_Y: Number = 27;
		public static const EXP_ICON_CENTER_X: Number = 47;
		public static const EXP_ICON_CENTER_Y: Number = 45;
		public static const LEVEL_ICON_CENTER_X: Number = 110;
		public static const LEVEL_ICON_CENTER_Y: Number = 35;
		
		public var goodsType: GoodsType;
		private var nameTf: TextField;
		private var priceTf: TextField;
		private var levelTf: TextField;
		private var expTf: TextField;
		
		private var goodsBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var levelBitmap: Bitmap;
		private var priceBitmap: Bitmap;
		private var expBitmap: Bitmap;
		
		private var enabled: Boolean;
		
		private var mainMenu: MainMenuPanel;
		
		
		public function GoodsPanel(value: GameScene, gType: GoodsType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			this.goodsType = gType;
			mainMenu = menu;
			setHover(false, false);
			
			bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL));
			enabled = true;
			
    		goodsBitmap = BitmapUtil.scaleImage(goodsType.bitmap, 0.5, 0.5);
			goodsBitmap.x = GOODSICO_CENTER_X - goodsBitmap.width / 2;
			goodsBitmap.y = GOODSICO_CENTER_Y - goodsBitmap.height / 2;
			addChild(goodsBitmap);
			
			nameTf = new TextField();
			nameTf.selectable = false;
			nameTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			nameTf.text = goodsType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = NAME_TF_X;
			nameTf.y = NAME_TF_CENTER_Y - nameTf.height / 2;
			addChild(nameTf);
			
			levelBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LEV_ICO));
			levelBitmap.x = LEVEL_ICON_CENTER_X - levelBitmap.width / 2;
			levelBitmap.y = LEVEL_ICON_CENTER_Y - levelBitmap.height / 2;
			addChild(levelBitmap);
			
			levelTf = new TextField();
			levelTf.selectable = false;
			levelTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff, true);
			levelTf.text = goodsType.accessLevel.toString();
			levelTf.autoSize = TextFieldAutoSize.LEFT;
			levelTf.x = LEVEL_TF_CENTER_X - levelTf.width / 2;
			levelTf.y = LEVEL_TF_CENTER_Y - levelTf.height / 2;
			addChild(levelTf);
			
			expTf = new TextField();
			expTf.selectable = false;
			expTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			expTf.text = goodsType.expCount.toString();
			expTf.autoSize = TextFieldAutoSize.LEFT;
			expTf.x = EXP_TF_X;
			expTf.y = EXP_TF_CENTER_Y - expTf.height / 2;
			addChild(expTf);
			
			priceTf = new TextField();
			priceTf.selectable = false;
			priceTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			priceTf.text = goodsType.priceCent.toString();
			priceTf.autoSize = TextFieldAutoSize.LEFT;
			priceTf.x = PRICE_TF_X;
			priceTf.y = PRICE_TF_CENTER_Y - priceTf.height / 2;
			addChild(priceTf);
			
			expBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LEV_PLUS));
			expBitmap.x = EXP_ICON_CENTER_X - expBitmap.width / 2;
			expBitmap.y = EXP_ICON_CENTER_Y - expBitmap.height / 2;
			addChild(expBitmap);

			moneyBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_CENTS));
			moneyBitmap.x = MONEY_ICON_CENTER_X - moneyBitmap.width / 2;
			moneyBitmap.y = MONEY_ICON_CENTER_Y - moneyBitmap.height / 2;
			addChild(moneyBitmap);
			
//			super(value);
//			width = WIDTH;
//			height = HEIGHT;
//			goodsType = gType;
//			mainMenu = menu;
//			
//			//todo fix
//			graphics.beginFill(0xfda952, 1.0);
//			graphics.drawRoundRect(0, 0, width, height, 8, 8);
//			graphics.endFill();
//			
//			goodsBitmap = BitmapUtil.scaleImage(gType.bitmap, NaN, 0.45);
//			goodsBitmap.x = GOODS_CENTER_X - goodsBitmap.width / 2;
//			goodsBitmap.y = GOODS_CENTER_Y - goodsBitmap.height / 2;
//			addChild(goodsBitmap);
//			nameTf = new TextField();
//			nameTf.text = gType.name;
//			nameTf.autoSize = TextFieldAutoSize.LEFT;
//			nameTf.x = (width - nameTf.width) / 2;
//			nameTf.y = NAME_TF_Y;
//			addChild(nameTf);
//			expTf = new TextField();
//			expTf.x = GOODS_TF_X;
//			expTf.y = GOODS_TF_Y;
//			expTf.text = gType.expCount.toString();
//			expTf.autoSize = TextFieldAutoSize.LEFT;
//			addChild(expTf);
//			priceTf = new TextField();
//			priceTf.x = PRICE_TF_X;
//			priceTf.y = PRICE_TF_Y;
//			expBitmap = new Bitmap(new BitmapData(10, 10, false, 0xaaaaaa));
//			expBitmap.x = EXP_ICON_CENTER_X - expBitmap.width / 2;
//			expBitmap.y = EXP_ICON_CENTER_Y - expBitmap.height / 2;
//			addChild(expBitmap);
//			priceTf.text = gType.priceCent.toString();
//			moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
//			moneyBitmap.x = MONEY_ICON_CENTER_X - moneyBitmap.width / 2;
//			moneyBitmap.y = MONEY_ICON_CENTER_Y - moneyBitmap.height / 2;
//			addChild(moneyBitmap);
//			priceTf.autoSize = TextFieldAutoSize.LEFT;
//			addChild(priceTf);
//			enabledSprite = new Sprite();
//			enabledSprite.graphics.beginFill(0xaaaaaa, 0.5);
//			enabledSprite.graphics.drawRoundRect(0, 0, width, height, 8, 8);
//			enabledSprite.graphics.endFill();
//			enabledSprite.visible = false;
//			addChild(enabledSprite);
		}
		
		public function set enabledGoods(value: Boolean): void {
			//enabledSprite.visible = !value;
			enabled = value;
			if (enabled) {
				bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL));
				setSelect(true);
				setHover(true, false);
			}
			else {
				bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL_GRAY));
				setSelect(false);
				setHover(false, false);
			}
		}
		
		public function get enabledGoods(): Boolean {
			return enabled;
		}
		
		protected override function mouseOverListener(event:MouseEvent):void {
			if (_hoverEnabled) {
				super.mouseOverListener(event);
				applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
			}
		}
		
		protected override function mouseOutListener(event:MouseEvent):void {
			if (_hoverEnabled) {
				super.mouseOutListener(event);
				removeFilter(GlowFilter);
			}
		}
	}
}