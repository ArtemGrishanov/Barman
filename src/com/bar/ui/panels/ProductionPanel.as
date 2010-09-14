package com.bar.ui.panels
{
	import com.bar.model.essences.ProductionType;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ProductionPanel extends GameLayer
	{
		public static const WIDTH: Number = 70;
		public static const HEIGHT: Number = 70;
		
		public static const NAME_TF_Y: Number = 6;
		public static const PARTS_TF_X: Number = 60;
		public static const PARTS_TF_Y: Number = 25;
		public static const PRICE_TF_X: Number = 60;
		public static const PRICE_TF_Y: Number = 40;
		public static const PROD_CENTER_X: Number = 25;
		public static const PROD_CENTER_Y: Number = 40;
		public static const PARTS_ICON_CENTER_X: Number = 52;
		public static const PARTS_ICON_CENTER_Y: Number = 35;
		public static const MONEY_ICON_CENTER_X: Number = 52;
		public static const MONEY_ICON_CENTER_Y: Number = 48;
		public static const LICENSE_LAYER_HEIGHT: Number = 40;
		public static const LICENSE_TEXT_Y: Number = 5;
		public static const LICENSE_BUTTON_Y: Number = 25;
		
		public var productionType: ProductionType;
		private var nameTf: TextField;
		private var partsCountTf: TextField;
		private var priceTf: TextField;
		
		private var partsBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var productionBitmap: Bitmap;
		private var enabledSprite: Sprite;
		
		private var licenseGameLayer: GameLayer;
		private var licenseTf: TextField;
		public var licenseButton: GameObject;
		
		private var mainMenu: MainMenuPanel;
		
		public function ProductionPanel(value: GameScene, prodType: ProductionType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			productionType = prodType;
			mainMenu = menu;
			
			//todo fix
			graphics.beginFill(0xfda952, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 8, 8);
			graphics.endFill();
			
			productionBitmap = BitmapUtil.cloneBitmap(prodType.bitmap);
			productionBitmap.x = PROD_CENTER_X - productionBitmap.width / 2;
			productionBitmap.y = PROD_CENTER_Y - productionBitmap.height / 2;
			addChild(productionBitmap);
			nameTf = new TextField();
			nameTf.text = prodType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = (width - nameTf.width) / 2;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
			partsCountTf = new TextField();
			partsCountTf.x = PARTS_TF_X;
			partsCountTf.y = PARTS_TF_Y;
			partsCountTf.text = prodType.partsCount.toString();
			partsCountTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(partsCountTf);
			priceTf = new TextField();
			priceTf.x = PRICE_TF_X;
			priceTf.y = PRICE_TF_Y;
			partsBitmap = new Bitmap(new BitmapData(10, 10, false, 0xaaaaaa));
			partsBitmap.x = PARTS_ICON_CENTER_X - partsBitmap.width / 2;
			partsBitmap.y = PARTS_ICON_CENTER_Y - partsBitmap.height / 2;
			addChild(partsBitmap);
			if (prodType.priceEuro > 0) {
				priceTf.text = prodType.priceEuro.toString();
				moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
			}
			else {
				priceTf.text = prodType.priceCent.toString();
				moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
			}
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
			licenseGameLayer = new GameLayer(scene);
			licenseTf = new TextField();
			licenseButton = new GameObject(scene);
			if (productionType.needLicense()) {
				licenseGameLayer.width = width;
				licenseGameLayer.height = LICENSE_LAYER_HEIGHT;
				licenseGameLayer.y = (height - licenseGameLayer.height) / 2;
				licenseGameLayer.graphics.beginFill(0x5555aa, 1.0);
				licenseGameLayer.graphics.drawRect(0, 0, licenseGameLayer.width, licenseGameLayer.height);
				licenseGameLayer.graphics.endFill();
				view.addDisplayObject(licenseGameLayer, 'licenseLayer', GameObject.VISUAL_SELECT_Z_ORDER + 10);
				licenseTf.text = 'Лицензия: ';
				if (prodType.licenseCostCent > 0) {
					licenseTf.appendText(prodType.licenseCostCent.toString() + ' центов'); 
				}
				else {
					licenseTf.appendText(prodType.licenseCostEuro.toString() + ' евро');
				}
				licenseTf.autoSize = TextFieldAutoSize.LEFT;
				licenseTf.x = (licenseGameLayer.width - licenseTf.width) / 2;
				licenseTf.y = LICENSE_TEXT_Y;
				licenseGameLayer.addChild(licenseTf);
				licenseButton.setSelect(true, true);
				licenseButton.setHover(true, true);
				licenseButton.bitmap = new Bitmap(new BitmapData(40, 10, false, 0x99aaff));;
				licenseButton.x = (licenseGameLayer.width - licenseButton.width) / 2;
				licenseButton.y = LICENSE_BUTTON_Y;
				licenseButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
				licenseGameLayer.addChild(licenseButton);
			}
		}
		
		public function set enabled(value: Boolean): void {
			enabledSprite.visible = !value;
		}
		
		public function get enabled(): Boolean {
			return !enabledSprite.visible;
		}
		
		public function set licensed(value: Boolean): void {
			if (productionType.needLicense()) {
				licenseGameLayer.visible = !value;
			}
		}
		
		protected function licenseButtonClick(event: GameObjectEvent): void {
			if (mainMenu) {
				mainMenu.onLicenseButtonClick(productionType);
			}
		}
	}
}