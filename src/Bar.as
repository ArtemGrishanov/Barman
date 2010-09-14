package {
	import com.bar.api.Server;
	import com.bar.model.Core;
	import com.bar.ui.UIBarPlace;
	import com.bar.ui.windows.PreloaderForm;
	import com.bar.util.Images;
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.socialnet.SocialNet;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;

	public class Bar extends GameScene
	{
		public static const WIDTH: Number = 730;
		public static const HEIGHT: Number = 730;
		
		public static var viewer_id: String = '9028622';
		public static var fullName: String = 'Артем Гришанов';
		public static var photoPath: String = 'http://cs295.vkontakte.ru/u9028622/a_f6aef0ce.jpg';
//		public static const host: String = '127.0.0.1';
//		public static const port: int = 1139;
		public static const host: String = '81.177.33.114';
		public static const port: int = 1139;
		public static const vk_id: String = '9028622';
		public static const password: String = 'password';
		public static var server: Server;
		public static var core: Core;
		public static var socialNet: SocialNet;
		public static var multiLoader: MultiLoader;
		
		private var _preloaderShown:Boolean;
		public var uiBarPlace: UIBarPlace;
		private var preloaderForm: PreloaderForm;
		
		public function Bar()
		{
			// TODO FIX
			scaleX = 0.8;
			scaleY = 0.8;
			
			MultiLoader.usingContext = true;
			multiLoader = new MultiLoader();
			socialNet = new SocialNet(SocialNet.NET_SANDBOX);
//			server = new Server(host, port, true);
//			server.connect(vk_id, password);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
//			var test: TestModel = new TestModel();
			
//			var test: Test = new Test(this);
//			test.testDragAndDrop();
//			test.testMove();
			
//			server.userAttrsChanged(2, 111, 120);
//			server.sendVKAttrs('Артем Гришанов', 'vkontakte.ru/images/1.jpg');
//			server.moneyCentChanged(160);
//			server.inviteFriend('1122334455');

//			server.clientCome(345565, 'YoungMan', '6756', 'Марина Дура', 'vodka', 0);
//			server.clientCome(123445, 'EmoGirl', '6789', 'Марина Дура', 'vodka', 1);
//			server.clientServed(345565);
//			server.clientDenied(12345);
			
//			server.productionLicensed('vodka');
//			server.productionAddedToBar(6357, 'beerLight', 1, 100, 100);
//			server.productionAddedToBar(633344, 'beerLight', 1, 120, 100);
//			server.productionAddedToBar(7653, 'vodka', 4, 140, 100);
			//server.productionDeleted(6357);
			
//			server.decorAddedToBar(23955, 'Picture1');
//			server.decorAddedToBar(87655, 'Audio');
//			server.decorDeleted(87655);
//			server.decorDeleted(23955);
//			server.resetGame();
//			server.loadBar('9028622');
			
		}
		
		public function onAddedToStage(e: Event): void {
			var wrapper: Object = this.parent.parent;
//	    	if (Util.wrapper.application) {
//	    		appObject = Util.wrapper.application;
//	    		Util.wrapper.external.resizeWindow(Constants.APP_WIDTH, Constants.APP_HEIGHT);
//	    		
//	    		api_result = appObject.parameters.api_result;
//	    		VKontakte.apiUrl = appObject.parameters.api_url;
//	    		Util.viewer_id = appObject.parameters.viewer_id;
//	    		Util.user_id = appObject.parameters.user_id;
//	    		
//	    		if (Util.viewer_id != Util.user_id) {
//	    			Util.api.invite();
//	    		}
//	    		
//	    		Util.wrapper.addEventListener('onApplicationAdded', onApplicationAdded);
//	    		Util.wrapper.addEventListener('onSettingsChanged', onSettingsChanged);
//	    	}
	    	multiLoader.addEventListener(ErrorEvent.ERROR, multiloaderError);
	    	multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			for each (var image: String in Images.PRE_IMAGES) {
				multiLoader.load(image, image, 'Bitmap');
			}
		}
		
		private function multiloaderError(event: ErrorEvent):void {
//			TODO: show alert
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (multiLoader.isLoaded) {
				multiLoader.removeEventListener(ErrorEvent.ERROR, multiloaderError);
				multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
				
				if (_preloaderShown) {
					preloaderForm.destroy();
					removeChild(preloaderForm);
					core = new Core(viewer_id, fullName, photoPath, server);
					uiBarPlace = new UIBarPlace(this);
					core.load();
					addChild(uiBarPlace);
//					if (Util.wrapper.application) {
//						if (appObject.parameters.is_app_user) {
//							checkAppSettings();
//						}
//						else {
//							Util.wrapper.external.showInstallBox();
//						}
//					}
//					if (Util.wrapper.application) Util.vkontakte.isAppUser();
//					else Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
				}
				else {
					_preloaderShown = true;
					preloaderForm = new PreloaderForm(this);
					addChild(preloaderForm);
					multiLoader.addEventListener(ErrorEvent.ERROR, multiloaderError);
					multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
					for each (var image: String in Images.IMAGES) {
						multiLoader.load(image, image, 'Bitmap');
					}
				}
			}
		}
		
//		public function checkAppSettings():void {
//			if ((appObject.parameters.api_settings & SETTINGS_NOTICE_ACCEPT) == 0 ||
//			(appObject.parameters.api_settings & SETTINGS_FRIENDS_ACCESS) == 0 ||
//			(appObject.parameters.api_settings & SETTINGS_PHOTO_ACCESS) == 0)
//			{
//				var installSettings:int = 0;
//				installSettings |= SETTINGS_NOTICE_ACCEPT;
//				installSettings |= SETTINGS_FRIENDS_ACCESS;
//				installSettings |= SETTINGS_PHOTO_ACCESS;
//				Util.wrapper.external.showSettingsBox(installSettings);
//			}
//			else {
//				if (api_result) {
//					var json:Object = JSON.deserialize(api_result);
//					Util.user = json.response[0];
//					Util.api.registerUser(Util.user);
//				}
//				else {
//					Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
//				}
//			}
//		}
	}
}
