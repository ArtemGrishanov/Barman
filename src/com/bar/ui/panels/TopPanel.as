package com.bar.ui.panels
{
	import com.bar.model.Balance;
	import com.efnx.events.MultiLoaderEvent;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
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
		public static const EXP_BITMAP_X: int = 75;
		public static const EXP_BITMAP_Y: int = 45;
		public static const NAME_TF_X: int = 70;
		public static const NAME_TF_Y: int = 5;
		public static const CENTS_ICON_X: int = 200;
		public static const CENTS_ICON_Y: int = 5;
		public static const CENTS_TF_X: int = 210;
		public static const CENTS_TF_Y: int = 5;
		public static const EURO_ICON_X: int = 250;
		public static const EURO_ICON_Y: int = 5;
		public static const EURO_TF_X: int = 260;
		public static const EURO_TF_Y: int = 5;
		public static const LOVE_ICON_X: int = 300;
		public static const LOVE_ICON_Y: int = 5;
		public static const LOVE_TF_X: int = 310;
		public static const LOVE_TF_Y: int = 5;
		public static const LEVEL_TF_X: int = 70;
		public static const LEVEL_TF_Y: int = 20;
		public static const EXP_TF_X: int = 90;
		public static const EXP_TF_Y: int = 25;
		
		private var nameTf: TextField;
		private var centsTf: TextField;
		private var euroTf: TextField;
		private var loveTf: TextField;
		private var levelTf: TextField;
		private var expTf: TextField;
		private var avatarBitmap: Bitmap;
		private var emptyExpBitmap: Bitmap;
		private var fullExpGameObject: GameObject;
		private var centsIcoGameObject: GameObject;
		private var euroIcoGameObject: GameObject;
		private var loveIcoGameObject: GameObject;
		
		private var vk: VKontakte;
		
		public function TopPanel(value:GameScene)
		{
			super(value);
			width = Bar.WIDTH;
			height = HEIGHT;
			
			//todo fix
			graphics.beginFill(0xc5c4c4, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 15, 15);
			graphics.endFill();
			
			nameTf = new TextField();
			nameTf.text = '';
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.x = NAME_TF_X;
			nameTf.y = NAME_TF_Y;
			addChild(nameTf);
			centsTf = new TextField();
			centsTf.text = '';
			centsTf.autoSize = TextFieldAutoSize.LEFT;
			centsTf.x = CENTS_TF_X;
			centsTf.y = CENTS_TF_Y;
			addChild(centsTf);
			euroTf = new TextField();
			euroTf.text = '';
			euroTf.autoSize = TextFieldAutoSize.LEFT;
			euroTf.x = EURO_TF_X;
			euroTf.y = EURO_TF_Y;
			addChild(euroTf);
			loveTf = new TextField();
			loveTf.text = '';
			loveTf.autoSize = TextFieldAutoSize.LEFT;
			loveTf.x = LOVE_TF_X;
			loveTf.y = LOVE_TF_Y;
			addChild(loveTf);
			levelTf = new TextField();
			levelTf.text = '1';
			levelTf.autoSize = TextFieldAutoSize.LEFT;
			levelTf.setTextFormat(new TextFormat('Arial', 30));
			levelTf.x = LEVEL_TF_X;
			levelTf.y = LEVEL_TF_Y;
			addChild(levelTf);
			expTf = new TextField();
			expTf.text = '';
			expTf.autoSize = TextFieldAutoSize.LEFT;
			expTf.setTextFormat(new TextFormat('Arial', 12, 0xffffff));
			expTf.x = EXP_TF_X;
			expTf.y = EXP_TF_Y;
			addChild(expTf);
			
			centsIcoGameObject = new GameObject(scene);
			centsIcoGameObject.bitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa0f));
			centsIcoGameObject.x = CENTS_ICON_X;
			centsIcoGameObject.y = CENTS_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(centsIcoGameObject);
			euroIcoGameObject = new GameObject(scene);
			euroIcoGameObject.bitmap = new Bitmap(new BitmapData(10, 10, false, 0x00aa0f));
			euroIcoGameObject.x = EURO_ICON_X;
			euroIcoGameObject.y = EURO_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(euroIcoGameObject);
			loveIcoGameObject = new GameObject(scene);
			loveIcoGameObject.bitmap = new Bitmap(new BitmapData(10, 10, false, 0xdd0a0f));
			loveIcoGameObject.x = LOVE_ICON_X;
			loveIcoGameObject.y = LOVE_ICON_Y;
//			centsIcoGameObject.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, licenseButtonClick);
			addChild(loveIcoGameObject);
			
			//todo
			emptyExpBitmap = new Bitmap(new BitmapData(80, 10, false, 0x555555));
			emptyExpBitmap.x = EXP_BITMAP_X;
			emptyExpBitmap.y = EXP_BITMAP_Y;
			addChild(emptyExpBitmap);
			fullExpGameObject = new GameObject(scene);
			fullExpGameObject.bitmap = new Bitmap(new BitmapData(80, 10, false, 0xdd0000));
			fullExpGameObject.x = EXP_BITMAP_X;
			fullExpGameObject.y = EXP_BITMAP_Y;
			addChild(fullExpGameObject);
			
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
			avatarBitmap = BitmapUtil.scaleImageWidthHeight(value, AVATAR_WIDTH, AVATAR_HEIGHT, true);
			avatarBitmap.x = AVATAR_X + (AVATAR_WIDTH - avatarBitmap.width) / 2;
			avatarBitmap.y = AVATAR_Y + (AVATAR_HEIGHT - avatarBitmap.height) / 2;;
			addChild(avatarBitmap);
		}
		
		public function set level(value: Number): void {
			levelTf.text = value.toString();
		}
		
		public function set exp(value: Number): void {
			expTf.text = value.toString() + '/' + Balance.levelExp[Bar.core.myBarPlace.user.level];
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