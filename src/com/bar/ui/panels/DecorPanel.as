package com.bar.ui.panels
{
	import com.bar.model.essences.DecorType;
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

	public class DecorPanel extends GameLayer
	{
		public static const WIDTH: Number = 70;
		public static const HEIGHT: Number = 70;
		
		public static const NAME_TF_Y: Number = 2;
		public static const LEVEL_TF_Y: Number = 55;
		public static const EXP_TF_X: Number = 50;
		public static const EXP_TF_Y: Number = 14;
		public static const LOVE_TF_X: Number = 50;
		public static const LOVE_TF_Y: Number = 28;
		public static const TIPPROB_TF_X: Number = 50;
		public static const TIPPROB_TF_Y: Number = 42;
		public static const PRICE_TF_X: Number = 50;
		public static const PRICE_TF_Y: Number = 56;
		
		public static const DECOR_CENTER_X: Number = 23;
		public static const DECOR_CENTER_Y: Number = 40;
		public static const LOVE_ICON_X: Number = 44;
		public static const LOVE_ICON_Y: Number = 28;
		public static const TIPPROB_ICON_X: Number = 44;
		public static const TIPPROB_ICON_Y: Number = 42;
		public static const MONEY_ICON_X: Number = 44;
		public static const MONEY_ICON_Y: Number = 56;
		public static const EXP_ICON_X: Number = 44;
		public static const EXP_ICON_Y: Number = 14;
		
		public var decorType: DecorType;
		private var nameTf: TextField;
		private var levelTf: TextField;
		private var expTf: TextField;
		private var loveTf: TextField;
		private var tipProbTf: TextField;
		private var priceTf: TextField;
		
		private var levelBitmap: Bitmap;
		private var moneyBitmap: Bitmap;
		private var expBitmap: Bitmap;
		private var loveBitmap: Bitmap;
		private var tipProbBitmap: Bitmap;
		private var decorBitmap: Bitmap;
		private var enabledSprite: Sprite;
		
		private var mainMenu: MainMenuPanel;
		
		public function DecorPanel(value: GameScene, decorType: DecorType, menu: MainMenuPanel)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			this.decorType = decorType;
			mainMenu = menu;
			
			//todo fix
			graphics.beginFill(0xfda952, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 8, 8);
			graphics.endFill();
			
			decorBitmap = BitmapUtil.cloneBitmap(decorType.bitmapSmall);
			decorBitmap.x = DECOR_CENTER_X - decorBitmap.width / 2;
			decorBitmap.y = DECOR_CENTER_Y - decorBitmap.height / 2;
			addChild(decorBitmap);
			
			expTf = new TextField();
			expTf.text = decorType.expCount.toString();
			expTf.autoSize = TextFieldAutoSize.LEFT;
			expTf.x = EXP_TF_X;
			expTf.y = EXP_TF_Y;
			addChild(expTf);
			expBitmap = new Bitmap(new BitmapData(10, 10, false, 0x2a2aff));
			expBitmap.x = EXP_ICON_X;
			expBitmap.y = EXP_ICON_Y;
			addChild(expBitmap);
			
			loveTf = new TextField();
			loveTf.text = decorType.expCount.toString();
			loveTf.autoSize = TextFieldAutoSize.LEFT;
			loveTf.x = LOVE_TF_X;
			loveTf.y = LOVE_TF_Y;
			addChild(loveTf);
			loveBitmap = new Bitmap(new BitmapData(10, 10, false, 0xaa1111));
			loveBitmap.x = LOVE_ICON_X;
			loveBitmap.y = LOVE_ICON_Y;
			addChild(loveBitmap);
			
			tipProbTf = new TextField();
			tipProbTf.text = decorType.expCount.toString();
			tipProbTf.autoSize = TextFieldAutoSize.LEFT;
			tipProbTf.x = TIPPROB_TF_X;
			tipProbTf.y = TIPPROB_TF_Y;
			addChild(tipProbTf);
			tipProbBitmap = new Bitmap(new BitmapData(10, 10, false, 0x2aa32a));
			tipProbBitmap.x = TIPPROB_ICON_X;
			tipProbBitmap.y = TIPPROB_ICON_Y;
			addChild(tipProbBitmap);
			
			priceTf = new TextField();
			priceTf.x = PRICE_TF_X;
			priceTf.y = PRICE_TF_Y;
			if (decorType.priceEuro > 0) {
				priceTf.text = decorType.priceEuro.toString();
				moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
			}
			else {
				priceTf.text = decorType.priceCent.toString();
				moneyBitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa00));
			}
			moneyBitmap.x = MONEY_ICON_X;
			moneyBitmap.y = MONEY_ICON_Y;
			addChild(moneyBitmap);
			priceTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(priceTf);
			
			enabledSprite = new Sprite();
			enabledSprite.graphics.beginFill(0xaaaaaa, 0.7);
			enabledSprite.graphics.drawRoundRect(0, 0, width, height, 8, 8);
			enabledSprite.graphics.endFill();
			enabledSprite.visible = false;
			addChild(enabledSprite);
			
			levelTf = new TextField();
			levelTf.visible = false;
			levelTf.text = decorType.accessLevel.toString() + " уровень";
			levelTf.autoSize = TextFieldAutoSize.LEFT;
			levelTf.x = (width - levelTf.width) / 2;
			levelTf.y = LEVEL_TF_Y;
			addChild(levelTf);
			
			nameTf = new TextField();
			nameTf.text = decorType.name;
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = (width - nameTf.width) / 2;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
		}
		
		public function set enabled(value: Boolean): void {
			enabledSprite.visible = !value;
			levelTf.visible = !value;
		}
		
		public function get enabled(): Boolean {
			return !enabledSprite.visible;
		}
	}
}