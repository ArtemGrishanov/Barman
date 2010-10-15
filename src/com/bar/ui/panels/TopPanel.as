package com.bar.ui.panels
{
	import com.bar.model.Balance;
	import com.bar.util.Images;
	import com.efnx.events.MultiLoaderEvent;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.socialnet.vk.VKontakte;
	import com.flashmedia.socialnet.vk.VKontakteEvent;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TopPanel extends GameLayer
	{
		public static const HEIGHT: int = 60;
		public static const AVATAR_X: int = 5;
		public static const AVATAR_Y: int = 5;
		public static const AVATAR_WIDTH: int = 50;
		public static const AVATAR_HEIGHT: int = 50;
		public static const EXP_BITMAP_X: int = 59;
		public static const EXP_BITMAP_Y: int = 29;
		public static const BLICK_BITMAP_X: int = 66;
		public static const BLICK_BITMAP_Y: int = 33;
		public static const FULL_EXP_BITMAP_X: int = 61;
		public static const FULL_EXP_BITMAP_Y: int = 33;
		public static const NAME_TF_X: int = 72;
		public static const NAME_TF_Y: int = 7;
		
		public static const CENTS_ICON_X: int = 360;
		public static const CENTS_ICON_Y: int = 8;
		public static const CENTS_TF_X: int = 388;
		public static const CENTS_TF_Y: int = 8;
		public static const EURO_ICON_X: int = 437;
		public static const EURO_ICON_Y: int = 8;
		public static const EURO_TF_X: int = 477;
		public static const EURO_TF_Y: int = 8;
		public static const LOVE_ICON_X: int = 300;
		public static const LOVE_ICON_Y: int = 10;
		public static const LOVE_TF_X: int = 320;
		public static const LOVE_TF_Y: int = 8;
		public static const LEVEL_ICON_X: int = 43;
		public static const LEVEL_ICON_Y: int = 3;
		public static const LEVEL_TF_X: int = 52;
		public static const LEVEL_TF_Y: int = 30;
		public static const EXP_TF_X: int = 145;
		public static const EXP_TF_Y: int = 34;
		
		private var nameTf: TextField;
		private var centsTf: TextField;
		private var euroTf: TextField;
		private var loveTf: TextField;
		private var levelTf: TextField;
		private var expTf: GameObject;
		private var avatarBitmap: Bitmap;
		private var emptyExpBitmap: Bitmap;
		private var blickBitmap: GameObject;
		private var fullExpGameObject: GameObject;
		private var levelIcoGameObject: GameObject;
		private var centsIcoGameObject: GameObject;
		private var euroIcoGameObject: GameObject;
		private var loveIcoGameObject: GameObject;
		
		private var vk: VKontakte;
		
		public function TopPanel(value:GameScene)
		{
			super(value);
			width = Bar.WIDTH;
			height = HEIGHT;
			
			bitmap = Bar.multiLoader.get(Images.TOOLBAR_BACK);
			
			nameTf = new TextField();
			nameTf.autoSize = TextFieldAutoSize.LEFT;
            nameTf.selectable = false;
			nameTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			nameTf.x = NAME_TF_X;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
			centsTf = new TextField();
			centsTf.text = '0';
			centsTf.autoSize = TextFieldAutoSize.LEFT;
            centsTf.selectable = false;
			centsTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			centsTf.x = CENTS_TF_X;
			centsTf.y = CENTS_TF_Y;
			addChild(centsTf);
			euroTf = new TextField();
			euroTf.text = '0';
			euroTf.autoSize = TextFieldAutoSize.LEFT;
            euroTf.selectable = false;
			euroTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			euroTf.x = EURO_TF_X;
			euroTf.y = EURO_TF_Y;
			addChild(euroTf);
			loveTf = new TextField();
			loveTf.text = '0';
			loveTf.autoSize = TextFieldAutoSize.LEFT;
            loveTf.selectable = false;
			loveTf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
			loveTf.autoSize = TextFieldAutoSize.LEFT;
			loveTf.x = LOVE_TF_X;
			loveTf.y = LOVE_TF_Y;
			addChild(loveTf);
			levelTf = new TextField();
			levelTf.autoSize = TextFieldAutoSize.LEFT;
            levelTf.selectable = false;
			levelTf.defaultTextFormat = new TextFormat("Arial", 14, 0xffffff, true);
			levelTf.text = '1';
			levelTf.x = LEVEL_TF_X;
			levelTf.y = LEVEL_TF_Y;
			addChild(levelTf);
			
			levelIcoGameObject = new GameObject(scene);
			levelIcoGameObject.zOrder = 3;
			levelIcoGameObject.bitmap = Bar.multiLoader.get(Images.TOOLBAR_LEV_ICO);
			levelIcoGameObject.x = LEVEL_ICON_X;
			levelIcoGameObject.y = LEVEL_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(levelIcoGameObject);
			centsIcoGameObject = new GameObject(scene);
			centsIcoGameObject.bitmap = Bar.multiLoader.get(Images.TOOLBAR_CENTS);
			centsIcoGameObject.x = CENTS_ICON_X;
			centsIcoGameObject.y = CENTS_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(centsIcoGameObject);
			euroIcoGameObject = new GameObject(scene);
			euroIcoGameObject.bitmap = Bar.multiLoader.get(Images.TOOLBAR_EURO);
			euroIcoGameObject.x = EURO_ICON_X;
			euroIcoGameObject.y = EURO_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(euroIcoGameObject);
			loveIcoGameObject = new GameObject(scene);
			loveIcoGameObject.bitmap = Bar.multiLoader.get(Images.TOOLBAR_HEART);
			loveIcoGameObject.x = LOVE_ICON_X;
			loveIcoGameObject.y = LOVE_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(loveIcoGameObject);
			
			//todo
			emptyExpBitmap = Bar.multiLoader.get(Images.TOOLBAR_LEV_BACK);
			emptyExpBitmap.x = EXP_BITMAP_X;
			emptyExpBitmap.y = EXP_BITMAP_Y;
			addChild(emptyExpBitmap);
			
			fullExpGameObject = new GameObject(scene);
			fullExpGameObject.bitmap = new Bitmap(new BitmapData(204, 18, false, 0xd52525));
			fullExpGameObject.x = FULL_EXP_BITMAP_X;
			fullExpGameObject.y = FULL_EXP_BITMAP_Y;
			addChild(fullExpGameObject);
			
			blickBitmap = new GameObject(scene);
			blickBitmap.bitmap = Bar.multiLoader.get(Images.TOOLBAR_LEV_BLICK);
			blickBitmap.zOrder = 2;
			blickBitmap.x = BLICK_BITMAP_X;
			blickBitmap.y = BLICK_BITMAP_Y;
			addChild(blickBitmap);
			
			expTf = new GameObject(scene);
			expTf.zOrder = 3;
			var t: TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			t.defaultTextFormat = new TextFormat('Arial', 11, 0xffffff, true);
			expTf.setTextField(t, View.ALIGN_HOR_CENTER);
			expTf.x = EXP_TF_X;
			expTf.y = EXP_TF_Y;
			addChild(expTf);
			
			vk = new VKontakte(Bar.viewer_id);
			vk.addEventListener(VKontakteEvent.COMPLETED, onVKProfileCompleted);
			vk.getProfiles([Bar.viewer_id]);
		}
		
		public function onVKProfileCompleted(event: VKontakteEvent): void {
			if (event.method == 'getProfiles') {
				Bar.multiLoader.load(event.response[0].photo_big, 'user_avatar', 'Bitmap');
				Bar.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			}
		}
		
		private function multiLoaderCompleteListener(event: MultiLoaderEvent):void {
			if (event.entry == 'user_avatar') {
				Bar.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
				avatar = Bar.multiLoader.get('user_avatar');
			}
		}
		
		public function set avatar(value: Bitmap): void {
			if (avatarBitmap && contains(avatarBitmap)) {
				removeChild(avatarBitmap);
			}
			avatarBitmap = BitmapUtil.fillByRect(value, AVATAR_WIDTH, AVATAR_HEIGHT);
			avatarBitmap.x = AVATAR_X + (AVATAR_WIDTH - avatarBitmap.width) / 2;
			avatarBitmap.y = AVATAR_Y + (AVATAR_HEIGHT - avatarBitmap.height) / 2;;
			addChild(avatarBitmap);
			addChild(levelIcoGameObject);
			addChild(levelTf);
		}
		
		public function set level(value: Number): void {
			levelTf.text = value.toString();
		}
		
		public function set exp(value: Number): void {
			expTf.textField.text = value.toString() + '/' + Balance.levelExp[Bar.core.myBarPlace.user.level];
			expTf.x = fullExpGameObject.x + (fullExpGameObject.width - expTf.width) / 2;
			var mask: Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawRect(0, 0, fullExpGameObject.width * Bar.core.myBarPlace.user.experience / Balance.levelExp[Bar.core.myBarPlace.user.level], fullExpGameObject.height);
			mask.graphics.endFill();
			fullExpGameObject.bitmapMask = mask;
		}
		
		public function set userName(value: String): void {
			nameTf.text = value;
		}
		
		public function set cents(value: Number): void {
			centsTf.text = value.toString();
		}
		
		public function set euro(value: Number): void {
			euroTf.text = value.toString();
		}
		
		public function set love(value: Number): void {
			//todo animation
			loveTf.text = value.toString();
		}
		
	}
}