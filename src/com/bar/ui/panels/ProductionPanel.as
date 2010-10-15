package com.bar.ui.panels
{
	import com.bar.model.essences.ProductionType;
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ProductionPanel extends GameLayer
	{
		public static const WIDTH: Number = 130;
		public static const HEIGHT: Number = 60;

		public static const NAME_TF_X: Number = 28;
		public static const NAME_TF_Y: Number = 0;
		public static const PARTS_TF_X: Number = 56;
		public static const PARTS_TF_Y: Number = 35;
		public static const PRICE_TF_X: Number = 56;
		public static const PRICE_TF_Y: Number = 17;
		public static const PROD_CENTER_X: Number = 16;
		public static const PROD_CENTER_Y: Number = 28;
		public static const PARTS_ICON_CENTER_X: Number = 47;
		public static const PARTS_ICON_CENTER_Y: Number = 44;
		public static const MONEY_ICON_CENTER_X: Number = 42;
		public static const MONEY_ICON_CENTER_Y: Number = 25;
		public static const LEVEL_ICON_CENTER_X: Number = 108;
		public static const LEVEL_ICON_CENTER_Y: Number = 33;
		public static const LEVEL_TF_CENTER_X: Number = 109;
		public static const LEVEL_TF_CENTER_Y: Number = 37;
		public static const LICENSE_LAYER_HEIGHT: Number = 40;
		public static const LICENSE_TEXT_Y: Number = 5;
		public static const LICENSE_BUTTON_Y: Number = 25;
		
		public var productionType: ProductionType;
		private var nameTf: TextField;
		private var partsCountTf: TextField;
		private var priceTf: TextField;
		private var levelTf: TextField;
		
		private var partsBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var levelBitmap: Bitmap;
		private var productionBitmap: Bitmap;
		
//		private var enabledSprite: Sprite;
		private var enabled: Boolean;
		private var viewLicense: Boolean;
//		private var licenseGameLayer: GameLayer;
//		private var licenseTf: TextField;
		public var licenseButton: GameObject;
		
		
		private var mainMenu: MainMenuPanel;
		
		public function ProductionPanel(value: GameScene, prodType: ProductionType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			productionType = prodType;
			mainMenu = menu;
			setHover(false, false);
			
			//todo fix
			bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL));
			enabled = true;
			
			//var prodBD: BitmapData = new BitmapData(40, 60, true, 0x00ffffff);
			//var matrix: Matrix = new Matrix();
    		//matrix.rotate(-0.1);
    		//prodBD.draw(BitmapUtil.scaleImage(prodType.bitmap, 0.8, 0.8), matrix, null, null, null, true);
    		//productionBitmap = new Bitmap(prodBD);
    		productionBitmap = BitmapUtil.scaleImage(prodType.bitmap, 0.8, 0.8);
			productionBitmap.x = PROD_CENTER_X - productionBitmap.width / 2;
			productionBitmap.y = PROD_CENTER_Y - productionBitmap.height / 2;
			addChild(productionBitmap);
			
			nameTf = new TextField();
			nameTf.selectable = false;
			nameTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			nameTf.text = prodType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = NAME_TF_X;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
			
			partsCountTf = new TextField();
			partsCountTf.x = PARTS_TF_X;
			partsCountTf.y = PARTS_TF_Y;
			partsCountTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			partsCountTf.text = prodType.partsCount.toString();
			partsCountTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(partsCountTf);
			priceTf = new TextField();
			priceTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			priceTf.x = PRICE_TF_X;
			priceTf.y = PRICE_TF_Y;
			partsBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PORTION));
			partsBitmap.x = PARTS_ICON_CENTER_X - partsBitmap.width / 2;
			partsBitmap.y = PARTS_ICON_CENTER_Y - partsBitmap.height / 2;
			addChild(partsBitmap);
			levelBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LEV_ICO));
			levelBitmap.x = LEVEL_ICON_CENTER_X - levelBitmap.width / 2;
			levelBitmap.y = LEVEL_ICON_CENTER_Y - levelBitmap.height / 2;
			addChild(levelBitmap);
			levelTf = new TextField();
			levelTf.selectable = false;
			levelTf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			levelTf.autoSize = TextFieldAutoSize.LEFT;
			levelTf.text = prodType.accessLevel.toString();
			levelTf.x = LEVEL_TF_CENTER_X - levelTf.width / 2;
			levelTf.y = LEVEL_TF_CENTER_Y - levelTf.height / 2;
			addChild(levelTf);
			if (prodType.priceEuro > 0) {
				priceTf.text = prodType.priceEuro.toString();
				moneyBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_EURO));
			}
			else {
				priceTf.text = prodType.priceCent.toString();
				moneyBitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_CENTS));
			}
			moneyBitmap.x = MONEY_ICON_CENTER_X - moneyBitmap.width / 2;
			moneyBitmap.y = MONEY_ICON_CENTER_Y - moneyBitmap.height / 2;
			addChild(moneyBitmap);
			priceTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(priceTf);
//			enabledSprite = new Sprite();
//			enabledSprite.graphics.beginFill(0xaaaaaa, 0.5);
//			enabledSprite.graphics.drawRoundRect(0, 0, width, height, 8, 8);
//			enabledSprite.graphics.endFill();
//			enabledSprite.visible = false;
//			addChild(enabledSprite);

//			licenseGameLayer = new GameLayer(scene);
//			licenseTf = new TextField();
			licenseButton = new GameObject(scene);
			if (productionType.needLicense()) {
//				licenseGameLayer.width = width;
//				licenseGameLayer.height = LICENSE_LAYER_HEIGHT;
//				licenseGameLayer.y = (height - licenseGameLayer.height) / 2;
//				licenseGameLayer.graphics.beginFill(0x5555aa, 1.0);
//				licenseGameLayer.graphics.drawRect(0, 0, licenseGameLayer.width, licenseGameLayer.height);
//				licenseGameLayer.graphics.endFill();
//				view.addDisplayObject(licenseGameLayer, 'licenseLayer', GameObject.VISUAL_SELECT_Z_ORDER + 10);
//				licenseTf.text = 'Лицензия: ';
//				if (prodType.licenseCostCent > 0) {
//					licenseTf.appendText(prodType.licenseCostCent.toString() + ' центов'); 
//				}
//				else {
//					licenseTf.appendText(prodType.licenseCostEuro.toString() + ' евро');
//				}
//				licenseTf.autoSize = TextFieldAutoSize.LEFT;
//				licenseTf.x = (licenseGameLayer.width - licenseTf.width) / 2;
//				licenseTf.y = LICENSE_TEXT_Y;
//				licenseGameLayer.addChild(licenseTf);
				viewLicense = true;
				licenseButton.setSelect(true, true);
				licenseButton.setHover(true, false);
				licenseButton.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_LICENSE));
				licenseButton.x = (WIDTH - licenseButton.width) / 2;
				licenseButton.y = (HEIGHT - licenseButton.height) / 2;
//				licenseButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
				addChild(licenseButton);
			}
		}
		
		public function set enabledProduction(value: Boolean): void {
			//enabledSprite.visible = !value;
			enabled = value;
			if (enabled) {
				bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL));
				setSelect(true);
				setHover(true, false);
				licenseButton.visible = viewLicense;
			}
			else {
				bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.SHOP_PANEL_GRAY));
				setSelect(false);
				setHover(false, false);
				licenseButton.visible = false;
			}
		}
		
		public function get enabledProduction(): Boolean {
			//return !enabledSprite.visible;
			return enabled;
		}
		
		public function set licensed(value: Boolean): void {
			if (productionType.needLicense() && enabled) {
				//licenseGameLayer.visible = !value;
				licenseButton.visible = !value;
				viewLicense = !value;
			}
		}
		
		public function get canBuy(): Boolean {
			return enabled && !viewLicense;
		}
		
//		protected function licenseButtonClick(event: GameObjectEvent): void {
//			if (mainMenu) {
//				mainMenu.onLicenseButtonClick(productionType);
//			}
//		}
		
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