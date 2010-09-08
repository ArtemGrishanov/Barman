package com.bar.ui.panels
{
	import com.efnx.events.MultiLoaderEvent;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.socialnet.SocialNetEvent;
	import com.flashmedia.socialnet.SocialNetUser;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class FriendPanel extends GameLayer
	{
		public static const WIDTH: Number = 70;
		public static const HEIGHT: Number = 70;
		
		public static const NAME_TF_Y: Number = 6;
		
		public var user: SocialNetUser;
		public var userId: Number;
//		private var nameTf: TextField;
		
		private var userPhoto: Bitmap;
		
		private var mainMenu: MainMenuPanel;
		
		public function FriendPanel(value: GameScene, menu: MainMenuPanel, id: Number = NaN)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			mainMenu = menu;
			userId = id;
			
			//todo fix
			graphics.beginFill(0xfda952, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 8, 8);
			graphics.endFill();
			
			if (userId) {
				Bar.socialNet.addEventListener(SocialNetEvent.USER_INFO, onSocialNetUserInfo);
				Bar.socialNet.getUserInfo([userId]);
				//todo multiloader
			}
			else {
				//todo invite form
			}
//			nameTf = new TextField();
//			nameTf.text = prodType.name;
//			nameTf.autoSize = TextFieldAutoSize.LEFT;
//			nameTf.x = (width - nameTf.width) / 2;
//			nameTf.y = NAME_TF_Y;
//			addChild(nameTf);
		}
		
		protected function onSocialNetUserInfo(event: SocialNetEvent): void {
			for each (var u: SocialNetUser in event.users) {
				if (userId == u.id) {
					user = u;
					//todo load photo
					userPhoto = new Bitmap(new BitmapData(WIDTH, HEIGHT, false, 0x3eff3e));
					addChild(userPhoto);
				}
			}
		}
		
		protected function onImageLoad(event: MultiLoaderEvent): void {
			
		}
	}
}