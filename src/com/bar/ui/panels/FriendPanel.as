package com.bar.ui.panels
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.socialnet.SocialNetUser;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FriendPanel extends GameObject
	{
		public static const WIDTH: Number = 74;
		public static const HEIGHT: Number = 65;
		
//		public static const LEVEL_TF_X: int = 7;
		public static const LEVEL_TF_Y: int = 15;
		public static const LEVEL_ICON_X: int = -7;
		public static const LEVEL_ICON_Y: int = -6;
		
		public static const NAME_TF_Y: Number = 6;
		
		public var user: SocialNetUser;
		public var userId: Number;
		public var userLevel: Number;
//		private var nameTf: TextField;
		
		private var levelTf: GameObject;
		private var levelIcon: GameObject;
		private var userAvatar: GameObject;
		
		private var mainMenu: MainMenuPanel;
		
		public function FriendPanel(value: GameScene, menu: MainMenuPanel, id: Number = NaN, level: Number = NaN)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			mainMenu = menu;
			userId = id;
			userLevel = level;
			
			userAvatar = new GameObject(scene);
			userAvatar.zOrder = 1;
			addChild(userAvatar);
			
			if (id) {
				levelIcon = new GameObject(scene);
				levelIcon.zOrder = 2;
				levelIcon.bitmap = BitmapUtil.scaleImage(Bar.multiLoader.get(Images.TOOLBAR_LEV_ICO), 0.8, 0.8);
				levelIcon.x = LEVEL_ICON_X;
				levelIcon.y = LEVEL_ICON_Y;
				addChild(levelIcon);
				if (level) {
					levelTf = new GameObject(scene);
					levelTf.zOrder = 3;
					var t: TextField = new TextField();
					t.autoSize = TextFieldAutoSize.LEFT;
					t.selectable = false;
					t.defaultTextFormat = new TextFormat('Arial', 11, 0xffffff, true);
					t.text = level.toString();
					levelTf.setTextField(t, View.ALIGN_HOR_CENTER);
					levelTf.width = t.width;
					levelTf.height = t.height;
					levelTf.x = LEVEL_ICON_X + (levelIcon.width - levelTf.width) / 2;
					levelTf.y = LEVEL_TF_Y;
					addChild(levelTf);
				}
			}
//			if (userId) {
//				Bar.socialNet.addEventListener(SocialNetEvent.USER_INFO, onSocialNetUserInfo);
//				Bar.socialNet.getUserInfo([userId]);
//			}
//			else {
//				//todo invite form
//				// form with "plus" button
//			}
//			nameTf = new TextField();
//			nameTf.text = prodType.name;
//			nameTf.autoSize = TextFieldAutoSize.LEFT;
//			nameTf.x = (width - nameTf.width) / 2;
//			nameTf.y = NAME_TF_Y;
//			addChild(nameTf);
		}
		
		public function set avatar(value: Bitmap): void {
			userAvatar.bitmap = value;
		}
		
		public function get avatar(): Bitmap {
			return userAvatar.bitmap;
		}
		
//		protected function onSocialNetUserInfo(event: SocialNetEvent): void {
//			for each (var u: SocialNetUser in event.users) {
//				if (userId == u.id) {
//					user = u;
//					Bar.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onPhotoLoad);
//					Bar.multiLoader.load(user.photoBigUrl, user.photoBigUrl, 'Bitmap'); 
//					//todo load photo
//					//userPhoto = new Bitmap(new BitmapData(WIDTH, HEIGHT, false, 0x3eff3e));
//					//addChild(userPhoto);
//				}
//			}
//		}
//		
//		protected function onPhotoLoad(event: MultiLoaderEvent): void {
//			if (Bar.multiLoader.isLoaded) {
//				removeEventListener(MultiLoaderEvent.COMPLETE, onPhotoLoad);
//				addChild(BitmapUtil.scaleImageWidthHeight(Bar.multiLoader.get(user.photoBigUrl), WIDTH, HEIGHT));
//			}
//		}
	}
}