package com.bar.ui.panels
{
	import com.bar.model.essences.DecorType;
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

	public class DecorPanel extends GameLayer
	{
		public static const WIDTH: Number = 130;
		public static const HEIGHT: Number = 60;

		public static const NAME_TF_X: Number = 37;
		public static const NAME_TF_CENTER_Y: Number = 8;
		public static const LOVE_TF_X: Number = 54;
		public static const LOVE_TF_CENTER_Y: Number = 43;
		public static const PRICE_TF_X: Number = 54;
		public static const PRICE_TF_CENTER_Y: Number = 27;
		public static const LEVEL_TF_X: Number = 103;
		public static const LEVEL_TF_CENTER_Y: Number = 27;
		public static const TIPS_TF_X: Number = 103;
		public static const TIPS_TF_CENTER_Y: Number = 43;
		
		public static const DECICO_CENTER_X: Number = 20;
		public static const DECICO_CENTER_Y: Number = 32;
		public static const LOVE_ICON_CENTER_X: Number = 46;
		public static const LOVE_ICON_CENTER_Y: Number = 45;
		public static const MONEY_ICON_CENTER_X: Number = 46;
		public static const MONEY_ICON_CENTER_Y: Number = 27;
		public static const LEVEL_ICON_CENTER_X: Number = 95;
		public static const LEVEL_ICON_CENTER_Y: Number = 27;
		public static const TIPS_ICON_CENTER_X: Number = 92;
		public static const TIPS_ICON_CENTER_Y: Number = 45;
		
		public var decorType: DecorType;
		private var nameTf: TextField;
		private var loveTf: TextField;
		private var priceTf: TextField;
		private var levelTf: TextField;
		private var tipsTf: TextField;
		
		private var loveBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var levelBitmap: Bitmap;
		private var tipsBitmap: Bitmap;
		private var decorBitmap: Bitmap;
		
		private var enabled: Boolean;
		
		private var mainMenu: MainMenuPanel;
		
		public function DecorPanel(value: GameScene, decorType: DecorType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			this.decorType = decorType;
			mainMenu = menu;
			setHover(false, false);
			
			bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL));
			enabled = true;
			
			if (decorType.bitmapSmall) {
	    		decorBitmap = decorType.bitmapSmall;
				decorBitmap.x = DECICO_CENTER_X - decorBitmap.width / 2;
				decorBitmap.y = DECICO_CENTER_Y - decorBitmap.height / 2;
				addChild(decorBitmap);
			}
			
			nameTf = new TextField();
			nameTf.selectable = false;
			nameTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			nameTf.text = decorType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = NAME_TF_X;
			nameTf.y = NAME_TF_CENTER_Y - nameTf.height / 2;
			addChild(nameTf);
			
			loveTf = new TextField();
			loveTf.selectable = false;
			loveTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			loveTf.text = decorType.loveCount.toString();
			loveTf.autoSize = TextFieldAutoSize.LEFT;
			loveTf.x = LOVE_TF_X;
			loveTf.y = LOVE_TF_CENTER_Y - loveTf.height / 2;
			addChild(loveTf);
			
			levelTf = new TextField();
			levelTf.selectable = false;
			levelTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			levelTf.text = decorType.expCount.toString();
			levelTf.autoSize = TextFieldAutoSize.LEFT;
			levelTf.x = LEVEL_TF_X;
			levelTf.y = LEVEL_TF_CENTER_Y - levelTf.height / 2;
			addChild(levelTf);
			
			tipsTf = new TextField();
			tipsTf.selectable = false;
			tipsTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			if (decorType.tipProbCount == 0) {
				tipsTf.text = "0%";
			} else {
				tipsTf.text = (decorType.tipProbCount * 100).toPrecision(1) + "%";
			}
			tipsTf.autoSize = TextFieldAutoSize.LEFT;
			tipsTf.x = TIPS_TF_X;
			tipsTf.y = TIPS_TF_CENTER_Y - tipsTf.height / 2;
			addChild(tipsTf);
			
			priceTf = new TextField();
			priceTf.selectable = false;
			priceTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			priceTf.autoSize = TextFieldAutoSize.LEFT;
			priceTf.x = PRICE_TF_X;
			addChild(priceTf);
			
			loveBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LOVE));
			loveBitmap.x = LOVE_ICON_CENTER_X - loveBitmap.width / 2;
			loveBitmap.y = LOVE_ICON_CENTER_Y - loveBitmap.height / 2;
			addChild(loveBitmap);
			
			levelBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LEV_PLUS));
			levelBitmap.x = LEVEL_ICON_CENTER_X - levelBitmap.width / 2;
			levelBitmap.y = LEVEL_ICON_CENTER_Y - levelBitmap.height / 2;
			addChild(levelBitmap);
			
			tipsBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_TIPS));
			tipsBitmap.x = TIPS_ICON_CENTER_X - tipsBitmap.width / 2;
			tipsBitmap.y = TIPS_ICON_CENTER_Y - tipsBitmap.height / 2;
			addChild(tipsBitmap);

			if (decorType.priceEuro > 0) {
				priceTf.text = decorType.priceEuro.toString();
				moneyBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_EURO));
			}
			else {
				priceTf.text = decorType.priceCent.toString();
				moneyBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_CENTS));
			}
			priceTf.y = PRICE_TF_CENTER_Y - priceTf.height / 2;
			
			moneyBitmap.x = MONEY_ICON_CENTER_X - moneyBitmap.width / 2;
			moneyBitmap.y = MONEY_ICON_CENTER_Y - moneyBitmap.height / 2;
			addChild(moneyBitmap);
		}
		
		public function set enabledDecor(value: Boolean): void {
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
		
		public function get enabledDecor(): Boolean {
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