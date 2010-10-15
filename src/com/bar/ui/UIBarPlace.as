package com.bar.ui
{
	import com.bar.model.Balance;
	import com.bar.model.CoreEvent;
	import com.bar.model.essences.Client;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	import com.bar.ui.panels.ClientButtonsPanel;
	import com.bar.ui.panels.ClientOrderPanel;
	import com.bar.ui.panels.ClientOrderPanelEvent;
	import com.bar.ui.panels.GoodsPanel;
	import com.bar.ui.panels.MainMenuPanel;
	import com.bar.ui.panels.MainMenuPanelEvent;
	import com.bar.ui.panels.ProductionPanel;
	import com.bar.ui.panels.TopPanel;
	import com.bar.ui.tooltips.ClientToolTip;
	import com.bar.ui.tooltips.ProductionToolTip;
	import com.bar.ui.windows.ExchangeWindow;
	import com.bar.ui.windows.FriendsWindow;
	import com.bar.ui.windows.Window;
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.Visible;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class UIBarPlace extends GameLayer
	{
		public static const CLIENT_BUTTONS_Y: Number = 450;
		
		public static const CLIENT_SIT_Y: Number = 553;
		public static const CLIENT_SIT_CENTER_X: Array = [94, 275, 455, 635];
		
		public static const TIPS_POSITION_Y: Number = 442;
		public static const TIPS_POSITION_X: Array = [114, 257, 434, 583, 500];
		
		public static const BAR_TABLE_Y: Number = 436;
		
//		public static const PRODUCTION_POSITION_X: Number = 200;
//		public static const PRODUCTION_POSITION_Y: Number = 50;
		
		public static const SHELF_Z_ORDER: Number = 10;
		public static const PRODUCTION_Z_ORDER: Number = 24;
		public static const PRODUCTION_ACTIVE_Z_ORDER: Number = 100;
		public static const TOOLTIP_Z_ORDER: Number = 45;
		public static const CLIENT_BTN_PANEL_Z_ORDER: Number = 35;
		public static const TIPS_Z_ORDER: Number = 23;
		public static const CLIENT_Z_ORDER: Number = 25;
		public static const CLIENT_SERVE_PANEL_Z_ORDER: Number = 38;
		public static const MAIN_MENU_PANEL_Z_ORDER: Number = 37;
		public static const EXCHANGE_WINDOW_Z_ORDER: Number = 60;
		public static const FRIENDS_WINDOW_Z_ORDER: Number = 60;
		public static const TOP_PANEL_Z_ORDER: Number = 37;
		public static const PRODUCTION_SHOP_WINDOW_Z_ORDER: Number = 38;
		public static const TUTORIAL_WINDOW_Z_ORDER: Number = 80;
		public static const TUTORIAL_ARROW_Z_ORDER: Number = 81;
		public static const UP_LEVEL_WINDOW_Z_ORDER: Number = 90;
		
		public var goClients: Array;
		public var goTips: Array;
		public var tipsClientIds: Array;
		public var goProduction: Array;
		public var goDecor: Array;
		public var prodCount: int;
		public var shelf: UIShelf;
		
		public var ttProductionGameObject: GameObject;
		public var ttProduction: ProductionToolTip;
		public var ttClientGameObject: GameObject;
		public var ttClient: ClientToolTip;
		
		public var cBntPanel: ClientButtonsPanel;
		public var cOrderPanel: ClientOrderPanel;
		public var clientGameObject: GameObject;
		public var mainMenuPanel: MainMenuPanel;
		public var topPanel: TopPanel;
		public static var exchangeWindow: ExchangeWindow;
		public static var friendsWindow: FriendsWindow;
		//public var productionShopWindow: ProductionShopWindow;
		//todo fix
//		public var go1: GameObject;
//		public var go2: GameObject;
		
		private static var instance: UIBarPlace;
		public static function getInstance(): UIBarPlace {
			return instance;
		}
		
		public function UIBarPlace(value:GameScene)
		{
			super(value);
			instance = this;
			
			scene.addEventListener(MouseEvent.CLICK, sceneMouseClick);
			scene.addEventListener(MouseEvent.MOUSE_MOVE, sceneMouseMove);
			
			//todo resourse loading
			Balance.clientTypes[0].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT1));
			Balance.clientTypes[1].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT2));
			Balance.clientTypes[2].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT3));
			Balance.clientTypes[3].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT4));
			Balance.clientTypes[4].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT5));
			Balance.clientTypes[5].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT6));
			
			//1 level
			Balance.goodsTypes[0].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BEER));
			Balance.goodsTypes[1].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_VODKA));
			Balance.goodsTypes[2].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_SODA));
			Balance.goodsTypes[3].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ORANGE));
			Balance.goodsTypes[4].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ERSH));
			Balance.goodsTypes[5].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_OTVERTKA));
			//2 level
			Balance.goodsTypes[6].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_VISKI));
			Balance.goodsTypes[7].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MILLIONAIR));
			Balance.goodsTypes[8].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_VODKA_TONIC));
			Balance.goodsTypes[9].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_JAMESON_VISKI_SAYER));
			//3 level
			Balance.goodsTypes[10].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_GIN));
			Balance.goodsTypes[11].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_SEX_BEACH));
			Balance.goodsTypes[12].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_GIN_TONIC));
			Balance.goodsTypes[13].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_PARADIZO));
			Balance.goodsTypes[14].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_VANILA_ICE));
			//4 level
			Balance.goodsTypes[15].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_COFFEE));
			Balance.goodsTypes[16].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ORANGE_LIKER));
			Balance.goodsTypes[17].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_IRISH_COFFEE));
			Balance.goodsTypes[18].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_WHITE_LEDY));
			//5 level
			Balance.goodsTypes[19].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_TEKILA));
			Balance.goodsTypes[20].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_TEKILA_SUNRISE));
			Balance.goodsTypes[21].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MARGARITA));
			Balance.goodsTypes[22].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_GRANAT_MIX));
			//6 level
			Balance.goodsTypes[23].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ROM));
			Balance.goodsTypes[24].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MAI_TAI));
			Balance.goodsTypes[25].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MOHITO));
			Balance.goodsTypes[26].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_GAVANA));
			//7 level
			Balance.goodsTypes[27].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_TOMATO));
			Balance.goodsTypes[28].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_COFFEE_LIKER));
			Balance.goodsTypes[29].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ROCKET));
			Balance.goodsTypes[30].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BLOOD_MARY));
			//8 level
			Balance.goodsTypes[31].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ENERGETIC));
			Balance.goodsTypes[32].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BLUE));
			Balance.goodsTypes[33].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MARGARITA_BLUE));
			Balance.goodsTypes[34].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_VODKA_BULL));
			//9 level
			Balance.goodsTypes[35].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_SAMBUKA));
			Balance.goodsTypes[36].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BLACK_RUS));
			Balance.goodsTypes[37].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BLUE_LAGUNA));
			//10 level
			Balance.goodsTypes[38].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_BALEIYS));
			Balance.goodsTypes[39].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_B52));
			Balance.goodsTypes[40].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_POSLE6));
			//11 level
			Balance.goodsTypes[41].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_KONJAK));
			Balance.goodsTypes[42].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_SIDE_CAR));
			Balance.goodsTypes[43].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ABK));
			Balance.goodsTypes[44].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_FRENCH_MOHITO));
			//12 level
			Balance.goodsTypes[45].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ABSENT));
			Balance.goodsTypes[46].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_MAGNUM44));
			Balance.goodsTypes[47].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_ABSENT_BULL));
			Balance.goodsTypes[48].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.GOODS_OBLAKA));
			
			//1 level
			Balance.productionTypes[0].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_BEER));
			Balance.productionTypes[1].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_VODKA));
			Balance.productionTypes[2].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ORANGE));
			Balance.productionTypes[3].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SODA));
			//2 level
			Balance.productionTypes[4].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_VISKI));
			Balance.productionTypes[5].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_LIMON));
			Balance.productionTypes[6].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SIROP));
			//3 level
			Balance.productionTypes[7].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ICE));
			Balance.productionTypes[8].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_JIN));
			//4 level
			Balance.productionTypes[9].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_COFFEE));
			Balance.productionTypes[10].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SLIVKI));
			Balance.productionTypes[11].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ORANGE_LIKER));
			//5 level
			Balance.productionTypes[12].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SIROP_GRENADIN));
			Balance.productionTypes[13].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_TEKILA));
			//6 level
			Balance.productionTypes[14].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_MINT_CAP));
			Balance.productionTypes[15].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ROM));
			//7 level
			Balance.productionTypes[16].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_TOMATO));
			Balance.productionTypes[17].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_COFFEE_LIKER));
			//8 level
			Balance.productionTypes[18].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ENERGETIC));
			Balance.productionTypes[19].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_BLUE_KUROSAO));
			//9 level
			Balance.productionTypes[20].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SAMBUKA));
			//10 level
			Balance.productionTypes[21].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_BEILEYS));
			//11 level
			Balance.productionTypes[22].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_KONJAK));
			//12 level
			Balance.productionTypes[23].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ABSENT));
			
			//Decor
			Balance.decorTypes[0].bitmap = Bar.multiLoader.get(Images.PICTURE1);
			Balance.decorTypes[0].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_PICTURE1));;
			Balance.decorTypes[1].bitmap = Bar.multiLoader.get(Images.SHKAF1);
			Balance.decorTypes[1].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_SHKAF1));
			Balance.decorTypes[2].bitmap = Bar.multiLoader.get(Images.WALL1);
			Balance.decorTypes[2].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_WALL1));;
			Balance.decorTypes[3].bitmap = Bar.multiLoader.get(Images.BARTABLE1);
			Balance.decorTypes[3].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_BARTABLE1));;
			for (var i: int = 4; i <= 7; i++) {
				Balance.decorTypes[i].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.STUL1_BACK));
				Balance.decorTypes[i].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_STUL1));
			}
			for (i = 8; i <= 9; i++) {
				Balance.decorTypes[i].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LAMP1));
				Balance.decorTypes[i].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_LAMP1));
			}
			Balance.decorTypes[10].bitmap = Bar.multiLoader.get(Images.WOMAN_BODY);
			Balance.decorTypes[11].bitmap = Bar.multiLoader.get(Images.WOMAN_PANTS1);
			Balance.decorTypes[12].bitmap = Bar.multiLoader.get(Images.WOMAN_BUST1);
			Balance.decorTypes[13].bitmap = Bar.multiLoader.get(Images.WOMAN_TSHIRT1);
			Balance.decorTypes[14].bitmap = Bar.multiLoader.get(Images.WOMAN_SKIRT1);
//			Balance.decorTypes[15].bitmap = Bar.multiLoader.get(Images.BARTABLE_BACK1);
			Balance.decorTypes[15].bitmap = Bar.multiLoader.get(Images.PICTURE2);
			Balance.decorTypes[15].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_PICTURE2));
			Balance.decorTypes[16].bitmap = Bar.multiLoader.get(Images.PICTURE3);
			Balance.decorTypes[16].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_PICTURE3));
			for (i = 17; i <= 20; i++) {
				Balance.decorTypes[i].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.STUL1_FOREWARD));
			}
			Balance.decorTypes[21].bitmap = Bar.multiLoader.get(Images.WALL2);
			Balance.decorTypes[21].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_WALL2));
			Balance.decorTypes[22].bitmap = Bar.multiLoader.get(Images.WALL3);
			Balance.decorTypes[22].bitmapSmall = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.DECICO_WALL3));
			//todo remove
//			graphics.lineStyle(2, 0xff0000);
//			graphics.moveTo(0, BAR_TABLE_Y);
//			graphics.lineTo(Bar.WIDTH, BAR_TABLE_Y);
//			graphics.drawRect(0, 0, Bar.WIDTH, Bar.HEIGHT);
			
			// создание пустых клиентов			
			goClients = new Array(Balance.maxClientsCount);
			for (i = 0; i < Balance.maxClientsCount; i++) {
				var uiClient: UIClient = new UIClient(scene);
				uiClient.visible = false;
				uiClient.zOrder = CLIENT_Z_ORDER;
//				uiClient.x = CLIENT_POSITION_X[i];
//				uiClient.y = CLIENT_POSITION_Y;
				uiClient.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onClientMouseClick);
				uiClient.addEventListener(GameObjectEvent.TYPE_LOST_FOCUS, onClientLostFocus);
				uiClient.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onClientSetHover);
				uiClient.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onClientLostHover);
				goClients[i] = uiClient;
				addChild(uiClient);
			}
			//создание декора
			goDecor = new Array(Balance.decorTypes.length);
			for (i = 0; i < Balance.decorTypes.length; i++) {
				var dt: DecorType = Balance.decorTypes[i] as DecorType;
				var go: GameObject = new GameObject(scene);
				go.type = dt.type;
				go.bitmap = dt.bitmap;
				go.visible = false;
				go.zOrder = dt.zOrder;
				go.x = dt.x;
				go.y = dt.y;
				go.alpha = 0.5;
				goDecor[i] = go;
				addChild(go);
			}
			//создание пустых чаевых
			goTips = new Array(Balance.maxClientsCount);
			tipsClientIds = new Array(Balance.maxClientsCount);
			for (i = 0; i < Balance.maxClientsCount; i++) {
				go = new GameObject(scene);
				go.visible = false;
				go.setSelect(true);
				go.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.TIPS));
				go.zOrder = TIPS_Z_ORDER;
				go.x = TIPS_POSITION_X[i];
				go.y = TIPS_POSITION_Y;
				go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onTipsMouseClick);
				go.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
				go.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
				goTips[i] = go;
				tipsClientIds[i] = 0;
				addChild(go);
			}
			
			goProduction = new Array();
			prodCount = 0;
			shelf = new UIShelf(scene);
			shelf.addEventListener(UIShelfEvent.EVENT_PRODUCTION_PLACE_CHANGED, onShelfProductionPlaceChanged);
			shelf.zOrder = SHELF_Z_ORDER;
			addChild(shelf);
			
			mainMenuPanel = new MainMenuPanel(scene);
			mainMenuPanel.zOrder = MAIN_MENU_PANEL_Z_ORDER;
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_ITEM_CLICK, mainMenuItemClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_PRODUCTION_CLICK, mainMenuProductionClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_LICENSE, mainMenuLicense);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_CLICK, mainMenuDecorClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_OVER, mainMenuDecorOver);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_OUT, mainMenuDecorOut);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_INVITE_FRIEND, mainMenuInviteFriend);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_FRIEND_CLICK, mainMenuFriendClick);
			addChild(mainMenuPanel);
			
			topPanel = new TopPanel(scene);
			topPanel.zOrder = TOP_PANEL_Z_ORDER;
			//todo set avatar
//			topPanel.avatar = new Bitmap(new BitmapData(40, 40, false, 0x340aee));
//			topPanel.addEventListener(MainMenuPanelEvent.EVENT_ITEM_CLICK, mainMenuItemClick);
			addChild(topPanel);
			
			exchangeWindow = new ExchangeWindow(scene);
			exchangeWindow.x = (Bar.WIDTH - exchangeWindow.width) / 2;
			exchangeWindow.y = (Bar.HEIGHT - exchangeWindow.height) / 2;
			exchangeWindow.visible = false;
			exchangeWindow.zOrder = EXCHANGE_WINDOW_Z_ORDER;
			addChild(exchangeWindow);
			
			friendsWindow = new FriendsWindow(scene);
			friendsWindow.x = (Bar.WIDTH - friendsWindow.width) / 2;
			friendsWindow.y = (Bar.HEIGHT - friendsWindow.height) / 2;
			friendsWindow.visible = false;
			friendsWindow.zOrder = FRIENDS_WINDOW_Z_ORDER;
			addChild(friendsWindow);
			
//			productionShopWindow = new ProductionShopWindow(scene);
//			productionShopWindow.zOrder = PRODUCTION_SHOP_WINDOW_Z_ORDER;
//			productionShopWindow.visible = false;
//			productionShopWindow.addProduction(Balance.productionTypes, Bar.core.myBarPlace.user.licensedProdTypes);
//			productionShopWindow.addEventListener(ProductionShopWindowEvent.EVENT_PRODUCTION_CLICK, productionShopWindowClick);
//			productionShopWindow.addEventListener(ProductionShopWindowEvent.EVENT_LICENSE, productionShopWindowLicense);
//			addChild(productionShopWindow);
			
			cBntPanel = new ClientButtonsPanel(scene);
			cBntPanel.zOrder = CLIENT_BTN_PANEL_Z_ORDER;
			cBntPanel.y = CLIENT_BUTTONS_Y;
			cBntPanel.visible = false;
			cBntPanel.serveButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onServeClientBtnClick);
			cBntPanel.denyButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onDenyClientBtnClick);
			addChild(cBntPanel);
			
			cOrderPanel = new ClientOrderPanel(scene);
			cOrderPanel.zOrder = CLIENT_SERVE_PANEL_Z_ORDER;
			cOrderPanel.visible = false;
			cOrderPanel.addEventListener(ClientOrderPanelEvent.EVENT_PRODUCTION_ADDED, onProductionAdded);
			cOrderPanel.addEventListener(ClientOrderPanelEvent.EVENT_CANCEL, onServeCancel);
			addChild(cOrderPanel);
			
			ttProduction = new ProductionToolTip(scene);
			ttProduction.zOrder = TOOLTIP_Z_ORDER;
			addChild(ttProduction);
			
			ttClient = new ClientToolTip(scene);
			ttClient.zOrder = TOOLTIP_Z_ORDER;
			addChild(ttClient);
			
			Bar.core.addEventListener(CoreEvent.EVENT_BAR_LOADED, barLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_DECOR_LOADED, decorLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_LOADED, productionLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_GOODS_LOADED, goodsLoaded);
			Bar.core.addEventListener(CoreEvent.EVENT_NEW_CLIENT, newClient);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_STATUS_CHANGED, clientStatusChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_DENIED, clientDenied);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_DELETED, clientDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_START_SERVING, clientStartServing);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_STOP_SERVING, clientStopServing);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_SERVED, clientServed);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_PAY_TIP, clientPayTip);
			Bar.core.addEventListener(CoreEvent.EVENT_CLIENT_MOOD_CHANGED, clientMoodChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_LICENSED, productionLicensed);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_ADDED_TO_BAR, addProductionToBar);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_UPDATED, productionUpdated);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_ADDED_TO_CUR_GOODS, productionAddedToCurGoods);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_EMPTY, productionEmpty);
			Bar.core.addEventListener(CoreEvent.EVENT_PRODUCTION_DELETED, productionDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_MONEY_CENT_CHANGED, userMoneyCentChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_MONEY_EURO_CHANGED, userMoneyEuroChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_EXP_CHANGED, userExpChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LEVEL_CHANGED, userLevelChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LOVE_CHANGED, userLoveChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_BARMAN_TAKE_TIP, barmanTakeTip);
			Bar.core.addEventListener(CoreEvent.EVENT_TIPS_DELETED, tipsDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_DECOR_ADDED_TO_BAR, addDecorToBar);
		}
		
		public function sceneMouseMove(event: MouseEvent): void {
			if (ttProduction.visible && ttProduction.visAction.isStopped) {
				ttProduction.hide();
			}
		}
		
		private var dontHideCBtn: Boolean;
		public function sceneMouseClick(event: MouseEvent): void {
			if (cBntPanel.visible && !dontHideCBtn) {
				cBntPanel.visible = false;
			}
			dontHideCBtn = false;
		}
		
		public function mainMenuProductionClick(event: MainMenuPanelEvent): void {
			Bar.core.buyProduction(event.productionType);
		}
		
		public function mainMenuLicense(event: MainMenuPanelEvent): void {
			Bar.core.licenseProduction(event.productionType);
		}
		
		public function mainMenuDecorClick(event: MainMenuPanelEvent): void {
			Bar.core.buyDecor(event.decorType);	
		}
		
		public function mainMenuDecorOver(event: MainMenuPanelEvent): void {
			if (!Bar.core.myBarPlace.decorExist(event.decorType) && Bar.core.myBarPlace.user.level >= event.decorType.accessLevel) {
				// скрыть существующий декор этой категории при предпросмотре
				for each (var d: Decor in Bar.core.myBarPlace.decor) {
					if (d.typeDecor.category == event.decorType.category) {
						for each (go in goDecor) {
							if (go.type == d.typeDecor.type) {
								go.visible = false;
							}
						}
					}
				}
				// предпросмотр декора
				for each (var go: GameObject in goDecor) {
					if (go.type == event.decorType.type) {
						go.visible = true;
					}
				}
			}
		}
		
		public function mainMenuDecorOut(event: MainMenuPanelEvent): void {
			if (!Bar.core.myBarPlace.decorExist(event.decorType) && Bar.core.myBarPlace.user.level >= event.decorType.accessLevel) {
				for each (var go: GameObject in goDecor) {
					if (go.type == event.decorType.type) {
						go.visible = false;
					}
				}
				// вернуть существующий декор этой категории при предпросмотре
				for each (var d: Decor in Bar.core.myBarPlace.decor) {
					if (d.typeDecor.category == event.decorType.category) {
						for each (go in goDecor) {
							if (go.type == d.typeDecor.type) {
								go.visible = true;
							}
						}
					}
				}
			}
		}
		
		public function mainMenuItemClick(event: MainMenuPanelEvent): void {
			switch (event.menuItem) {
				case MainMenuPanel.MENU_WINE_SHOP:
					//productionShopWindow.visible = true;
				break;
				case MainMenuPanel.MENU_BAR_ASSORTIMENT:
				
				break;
				case MainMenuPanel.MENU_NEWS:
				
				break;
			}
		}
		
		public function mainMenuInviteFriend(event: MainMenuPanelEvent): void {
			//TODO
		}
		
		public function mainMenuFriendClick(event: MainMenuPanelEvent): void {
			//TODO
		}
		
		public function onShelfProductionPlaceChanged(event: UIShelfEvent): void {
			Bar.core.moveProduction(event.gameObject.id, event.cellIndex, event.rowIndex);
		}
		
		public function onServeCancel(event: ClientOrderPanelEvent): void {
			Bar.core.stopClientServing(clientGameObject.id);
		}
		
		/**
		 * Завершена анимация приготовления в окне обслуживания
		 */
		public function onProductionAdded(event: ClientOrderPanelEvent): void {
			Bar.core.makeGoods(event.production);
		}
		
		public function onServeClientBtnClick(event: GameObjectEvent): void {
			Bar.core.startClientServing(clientGameObject.id);
		}
		
		public function onDenyClientBtnClick(event: GameObjectEvent): void {
			Bar.core.denyClient(clientGameObject.id);
		}
		
		public function onDragStartedProductionObject(event: GameObjectEvent): void {
			event.gameObject.zOrder = PRODUCTION_ACTIVE_Z_ORDER;
			ttProduction.hide();
		}
		
		public function onProductionMouseUp(event: GameObjectEvent): void {
			var xx: Number = event.gameObject.x + event.gameObject.width / 2;
			var yy: Number = event.gameObject.y + event.gameObject.height / 2;
			if (cOrderPanel.visible && UIUtil.inRect(new Point(xx, yy), new Rectangle(cOrderPanel.x - 10, cOrderPanel.y - 10, cOrderPanel.width + 20, cOrderPanel.height + 20))) {
				var p: Production = Bar.core.getProductionById(event.gameObject.id);
				cOrderPanel.addProduction(p);
				shelf.addProduction(event.gameObject, true, p.rowIndex, p.cellIndex);
				// Bar.core.makeGoods(p); вызовется, когда завершится анимация приготовления
			}
			else {
				shelf.resetAllHighlights();
				shelf.addProduction(event.gameObject);
			}
			event.gameObject.zOrder = PRODUCTION_Z_ORDER;
		}
		
		public function onProductionMouseHover(event: GameObjectEvent): void {
			var cmf: ColorMatrixFilter = new ColorMatrixFilter([
			1,0,0,0,80,
			0,1,0,0,60,
			0,0,1,0,40,
			0,0,0,1,0
			]);
			event.gameObject.applyFilter(cmf);
			if (!event.gameObject.isDragging) {
				var p: Production = Bar.core.getProductionById(event.gameObject.id);
				ttProduction.setAttrs(p.typeProduction.name, p.partsCount);
				ttProduction.surfaceXY(event.gameObject.x + event.gameObject.width / 2,
												event.gameObject.y, 20);
			}
		}
		
		public function onProductionLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(ColorMatrixFilter);
			//ttProduction.hide();
		}
		
		public function addClient(c: Client): void {
			var uiClient: UIClient = goClients[c.position] as UIClient;
			uiClient.clientUser = c;
			uiClient.visible = true;
			var visAction: Visible = new Visible(scene, 'visClient', uiClient);
			visAction.duration = 1000;
			visAction.start();
			
//			var go: GameObject = new GameObject(scene);
//			go.id = c.id;
//			go.zOrder = CLIENT_Z_ORDER;
//			go.setSelect(true);
//			go.setFocus(true, false);
//			go.setHover(true);
//			go.bitmap = BitmapUtil.cloneBitmap(c.typeClient.bitmap);
//			var t:TextField = new TextField();
//			t.text = c.typeClient.type;
//			t.autoSize = TextFieldAutoSize.LEFT;
//			go.setTextField(t);
//			go.x = CLIENT_POSITION_X[c.position];
//			go.y = CLIENT_POSITION_Y;
//			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onClientMouseClick);
//			go.addEventListener(GameObjectEvent.TYPE_LOST_FOCUS, onClientLostFocus);
//			go.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onClientSetHover);
//			go.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onClientLostHover);
//			goClients[c.position] = go;
//			addChild(go);
		}
		
		public function onItemSetHover(event: GameObjectEvent): void {
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
		}
		
		public function onItemLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(GlowFilter);
		}
		
		public function onClientSetHover(event: GameObjectEvent): void {
			//todo изменение прозрачности
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
			var c: Client = Bar.core.getClientById(event.gameObject.id);
			ttClient.setAttrs(c.name, c.orderGoodsType.name, Balance.getGoodsTypeByName(c.orderGoodsType.type).bitmap);
			ttClient.surfaceXY(CLIENT_SIT_CENTER_X[(event.gameObject as UIClient).client.position], CLIENT_SIT_Y - 220, 10);
		}
		
		public function onClientLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(GlowFilter);
			ttClient.hide();
		}
		
		public function onClientLostFocus(event: GameObjectEvent): void {
			//cBntPanel.visible = false;
		}
		
		public function onClientMouseClick(event: GameObjectEvent): void {
			ttClient.hide();
			clientGameObject = event.gameObject;
			var c: UIClient = event.gameObject as UIClient;
			cBntPanel.x = CLIENT_SIT_CENTER_X[c.client.position] - cBntPanel.width / 2;
//			cBntPanel.x = event.gameObject.x + event.gameObject.width / 2 - cBntPanel.width / 2;
//			cBntPanel.y = event.gameObject.y + event.gameObject.height / 2 - cBntPanel.height / 2;
			cBntPanel.visible = true;
			dontHideCBtn = true;
		}
		
		public function onTipsMouseClick(event: GameObjectEvent): void {
			Bar.core.takeTips(tipsClientIds[goTips.indexOf(event.gameObject)]);
		}
		
		public function deleteClient(c: Client): void {
//			var go: GameObject = scene.getChildById(c.id);
//			removeChild(go);
			var uiClient: UIClient = goClients[c.position] as UIClient;
			uiClient.visible = false;
		}
		
		public function addProduction(p: Production): void {
			prodCount++;
			var go: GameObject = new GameObject(scene);
			go.id = p.id;
			go.zOrder = PRODUCTION_Z_ORDER;
			go.setSelect(true);
			go.canDrag = true;
			go.setFocus(true, false);
			go.setHover(true, false);
			go.type = UIShelf.GAME_OBJECT_TYPE;
			go.bitmap = BitmapUtil.cloneBitmap(p.typeProduction.bitmap);
//			var t:TextField = new TextField();
//			t.text = p.typeProduction.type;
//			t.autoSize = TextFieldAutoSize.LEFT;
//			t.selectable = false;
//			go.setTextField(t);
			go.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, shelf.onDragStartedProductionObject);
			go.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, onDragStartedProductionObject);
			go.addEventListener(GameObjectEvent.TYPE_DRAGGING, shelf.onDragProductionObject);
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, shelf.onProductionMouseUp);
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, onProductionMouseUp);
			go.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onProductionMouseHover);
			go.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onProductionLostHover);
			goProduction.push(go);
			addChild(go);
			shelf.addProduction(go, false, p.rowIndex, p.cellIndex);
		}
		
		public function deleteProduction(p: Production): void {
			prodCount--;
			var go: GameObject = scene.getChildById(p.id);
			goProduction.splice(goProduction.indexOf(go), 1);
			shelf.deleteProduction(go);
			removeChild(go);
		}
		
		public function highLightNeedProduction(): void {
			if (Bar.core.currentGoods) {
				for each (var go: GameObject in goProduction) {
					go.removeFilter(GlowFilter);
				}
				var needProduction: Array = Bar.core.currentGoods.needProduction;
				for each (var np: Object in needProduction) {
					for each (var p: Production in Bar.core.myBarPlace.production) {
						if (p.typeProduction.type == np['productionType']) {
							scene.getChildById(p.id).applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
						}
					}
				}
			}
			else {
				for each (go in goProduction) {
					go.removeFilter(GlowFilter);
				}
			}
		}
		
		//-----------------------------------------------------------
		//-------------------- Core Events --------------------------
		//-----------------------------------------------------------
		
		
		public function barLoaded(event: CoreEvent): void {
			trace('Bar Loaded: ' + event.barPlace.user.fullName);
			topPanel.userName = event.barPlace.user.fullName;
			topPanel.cents = event.barPlace.user.moneyCent;
			topPanel.euro = event.barPlace.user.moneyEuro;
			topPanel.love = event.barPlace.user.love;
			topPanel.level = event.barPlace.user.level;
			topPanel.exp = event.barPlace.user.experience;
//			trace('    Owner: ' + event.barPlace.user.fullName + '. Level: ' + event.barPlace.user.level);
			for each (var p: Production in event.barPlace.production) {
				//trace('    Production: ' + p.typeProduction.name + '(' + p.partsCount + ') ' + p.id);
				addProduction(p);
			}
			mainMenuPanel.addProduction(Balance.productionTypes, Bar.core.myBarPlace.user.licensedProdTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.addDecor(Balance.decorTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.addGoods(Balance.goodsTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.setDecorForSell(Bar.core.enableForBuyDecor());
			for each (var d: Decor in event.barPlace.decor) {
				for each (var go: GameObject in goDecor) {
					if (go.type == d.typeDecor.type) {
						go.visible = true;
						go.alpha = 1.0;
					}
				}
			}
			for each (var c: Client in event.barPlace.clients) {
				addClient(c);
			}
			if (Bar.viewer_id == event.barPlace.user.id_user) {
				//TODO при переходах с бара на бар всегда будет показываться туториал
				if (Bar.core.firstLaunch) {
					showTutorial(TUTORIAL_HELLO);
				}
			}
			else {
				
			}
			mainMenuPanel.requestFriends();
		}
		
		public function decorLoaded(event: CoreEvent): void {
			
		}
		
		public function productionLoaded(event: CoreEvent): void {
			
		}
		
		public function goodsLoaded(event: CoreEvent): void {
			
		}
		
		public function newClient(event: CoreEvent): void {
			trace('New Client: ' + event.client.name + '. Order: ' + event.client.orderGoodsType.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
			addClient(event.client);
		}
		
		public function clientStartServing(event: CoreEvent): void {
			trace('Start Serving Client: ' + event.client.name + '. Order: ' + event.client.orderGoodsType.name);
			cBntPanel.visible = false;
			var xx: Number = 0;
			switch (event.client.position) {
				case 0:
				xx = 30;
				break;
				case 3:
				xx = -40;
				break;
			}
			cOrderPanel.showGoods(event.client.orderGoodsType,
									CLIENT_SIT_CENTER_X[event.client.position] - cOrderPanel.width / 2 + xx,
									clientGameObject.y + (clientGameObject.height - cOrderPanel.height) / 2);
			highLightNeedProduction();
		}
		
		public function clientStopServing(event: CoreEvent): void {
			trace('Stop Serving Client: ' + event.client.name + '. Order: ' + event.client.orderGoodsType.name);
			cOrderPanel.visible = false;
			highLightNeedProduction();
		}
		
		public function clientServed(event: CoreEvent): void {
			trace('Client Served: ' + event.client.name);
			cOrderPanel.visible = false;
			deleteClient(event.client);
			highLightNeedProduction();
			if (Bar.core.firstLaunch && event.firstClientServed) {
				showTutorial(TUTORIAL_AFTER_FIRST_SERVE);
			}
		}
		
		public function clientStatusChanged(event: CoreEvent): void {
			switch (event.client.status) {
				case Client.STATUS_WAITING:
					
				break;
				case Client.STATUS_ORDERING:
					
				break;
				case Client.STATUS_EATING:
					
				break;
			}
		}
		
		public function clientPayTip(event: CoreEvent): void {
			trace('$$$ Tips Cents:: ' + event.tipMoneyCent + ' - ' + event.client.name);
			//Bar.core.takeTips(event.client.id);
			var tipGo: GameObject = (goTips[event.tipPosition] as GameObject);
			tipGo.visible = true;
			tipsClientIds[event.tipPosition] = event.clientId;
		}
		
		public function clientDeleted(event: CoreEvent): void {
			//trace('Client deleted:: ' + event.client.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
			//deleteClient(event.client);
		}
		
		public function clientDenied(event: CoreEvent): void {
			trace('Client denied:: ' + event.client.name + '. In bar: ' + Bar.core.myBarPlace.clients.length + ' clients.');
//			modelStat.lastLevel.clientsDenied.push(event.client);
			cBntPanel.visible = false;
			deleteClient(event.client);
		}
		
		public function clientMoodChanged(event: CoreEvent): void {
			trace('Mood changed:: ' + event.client.mood + '(0-' + Balance.maxClientMood + ') ' + event.client.name);
			var uiClient: UIClient = goClients[event.client.position] as UIClient;
			uiClient.moodClient = event.client.mood;
		}
		
		public function addProductionToBar(event: CoreEvent): void {
			trace('Production added to bar:: Production: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
			addProduction(event.production);
		}
		
		public function productionUpdated(event: CoreEvent): void {
			//TODO возврат продукции на полке в исходное состояние
			for each (var p: Production in event.barPlace.production) {
				var prodGO: GameObject = scene.getChildById(p.id);
				if (!prodGO) {
					//TODO координаты
					addProduction(p);
				}
			}
		}
		
		public function productionAddedToCurGoods(event: CoreEvent): void {
			highLightNeedProduction();
			trace('Production added to cur goods:: Production: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
		}
		
		public function productionEmpty(event: CoreEvent): void {
			trace('Production Empty:: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
			Bar.core.deleteProduction(event.production.id);
		}
		
		public function productionDeleted(event: CoreEvent): void {
			trace('Production Deleted:: ' + event.production.typeProduction.name + '(' + event.production.partsCount + ') ' + event.production.id);
			deleteProduction(event.production);
		}
		
		public function userMoneyCentChanged(event: CoreEvent): void {
			var d: Number = event.newMoneyCent - event.oldMoneyCent;
			trace('$$$ Money Cents: ' + event.newMoneyCent + ' (' + ((event.newMoneyCent > event.oldMoneyCent)?'+':'') + d + ')');
			topPanel.cents = event.newMoneyCent;
//			modelStat.lastLevel.moneyCent = event.newMoneyCent;
//			if (d >= 0) {
//				modelStat.lastLevel.moneyCentUp += d;
//			}
//			else {
//				modelStat.lastLevel.moneyCentDown += d;
//			}
		}
		
		public function userMoneyEuroChanged(event: CoreEvent): void {
			var d: Number = event.newMoneyEuro - event.oldMoneyEuro;
			trace('$$$ Money Euro: ' + event.newMoneyEuro + ' (' + ((event.newMoneyEuro > event.oldMoneyEuro)?'+':'') + d + ')');
			topPanel.euro = event.newMoneyEuro;
		}
		
		public function userLevelChanged(event: CoreEvent): void {
			var d: Number = event.newLevel - event.oldLevel;
			trace('Level: ' + event.newLevel + ' (' + ((event.newLevel > event.oldLevel)?'+':'') + d + ')');
			topPanel.level = event.newLevel;
			mainMenuPanel.setLevel(Bar.core.myBarPlace.user.licensedProdTypes, event.newLevel);
			if (Bar.core.firstLaunch) {
				showTutorial(TUTORIAL_LEVEL2_UP);
			}
			showUpLevel(event.newLevel);
//			modelStat.lastLevel.endLevel();
//			trace(modelStat.lastLevel.toString());
//			modelStat.startNewLevel(event.newLevel);
		}
		
		public function userLoveChanged(event: CoreEvent): void {
			var d: Number = event.newLove - event.oldLove;
			trace('Love: ' + event.newLove + ' (' + ((event.newLove > event.oldLove)?'+':'') + d + ')');
//			modelStat.lastLevel.loveCount += d;
			topPanel.love = event.newLove;
		}
		
		public function userExpChanged(event: CoreEvent): void {
			var d: Number = event.newExp - event.oldExp;
			topPanel.exp = event.newExp;
			trace('Experience: ' + event.newExp + ' (' + ((event.newExp > event.oldExp)?'+':'') + d + ')');
		}
		
		public function barmanTakeTip(event: CoreEvent): void {
			trace('Barman take tip: ' + event.tipMoneyCent + '. From client: ' + event.clientId);
			(goTips[event.tipPosition] as GameObject).visible = false;
		}
		
		public function tipsDeleted(event: CoreEvent): void {
			trace('Tips Deleted. Position: ' + event.tipPosition);
			(goTips[event.tipPosition] as GameObject).visible = false;
		}
		
		public function addDecorToBar(event: CoreEvent): void {
			trace('Decor added to bar:: Decor: ' + event.decor.typeDecor.name + '. Id:' + event.decor.id);
//			modelStat.lastLevel.decor.push(event.decor);
			// при замещении декора из одной категории - старый декор необходимо сделать полупрозрачным
			for each (var dt: DecorType in Balance.decorTypes) {
				if (
					(dt.category == event.decor.typeDecor.category)
					&& (dt.type != event.decor.typeDecor.type)
				) {
					for each (go in goDecor) {
						if (go.type == dt.type) {
							go.visible = false;
							go.alpha = 0.5;
						}
					}
				}
			}
			// обновить декор в магазине на главной панели
			mainMenuPanel.setDecorForSell(Bar.core.enableForBuyDecor());
			for each (var go: GameObject in goDecor) {
				if (go.type == event.decor.typeDecor.type) {
					go.visible = true;
					go.alpha = 1.0;
				}
			}
		}
		
		public function productionLicensed(event: CoreEvent): void {
			trace('Production Licensed: ' + event.typeProduction.type + ' Cost: ' + event.typeProduction.licenseCostCent + 'c. ' + event.typeProduction.licenseCostEuro + 'e.');
//			modelStat.lastLevel.licensedProdTypes.push(event.typeProduction);
			mainMenuPanel.licenseProduction(event.typeProduction);
		}
		
		//-----------------------------------------------------------------------
		//-----------------------------------------------------------------------
		// Окна туториала
		//-----------------------------------------------------------------------
		//-----------------------------------------------------------------------
		
		public static const TUTORIAL_HELLO: String = 't_hello';
		public static const TUTORIAL_ATTRS: String = 't_attrs';
		public static const TUTORIAL_SERVING: String = 't_serving';
		public static const TUTORIAL_AFTER_FIRST_SERVE: String = 't_after_first_serve';
		public static const TUTORIAL_LEVEL2_UP: String = 't_level2_up';
		
		public static const TUTORIAL_WIDTH: Number = 300;
		public static const TUTORIAL_HEIGHT: Number = 300;
		public static const TUTORIAL_TEXT_WIDTH: Number = 250;
		public static const TUTORIAL_TEXT_Y: Number = 25;
		public static const TUTORIAL_BTN_Y: Number = 277;
		public var tutorialWindow: Window;
		public var tutorialArrow: GameObject;
		public var tutorialNextButton: GameObject;
		public var tutorialGoButton: GameObject;
		public var tutorialMessageTextField: TextField;
		public var tutorialState: String;
		public function showTutorial(state: String): void {
			tutorialState = state;
			if (!tutorialWindow) {
				tutorialWindow = new Window(scene, TUTORIAL_WIDTH, TUTORIAL_HEIGHT);
				tutorialWindow.zOrder = TUTORIAL_WINDOW_Z_ORDER;
				tutorialWindow.x = (Bar.WIDTH - tutorialWindow.width) / 2;
				tutorialWindow.y = (Bar.HEIGHT - tutorialWindow.height) / 2;
				addChild(tutorialWindow);
			}
			tutorialWindow.visible = true;
			if (!tutorialArrow) {
				tutorialArrow = new GameObject(scene);
				tutorialArrow.zOrder = TUTORIAL_ARROW_Z_ORDER;
				addChild(tutorialArrow);
			}
			tutorialArrow.visible = false;
			if (!tutorialNextButton) {
				tutorialNextButton = new GameObject(scene);
				tutorialNextButton.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_NEXT));
				tutorialNextButton.x = (TUTORIAL_WIDTH - tutorialNextButton.width) / 2;
				tutorialNextButton.y = TUTORIAL_BTN_Y;
				tutorialNextButton.setSelect(true);
				tutorialWindow.addChild(tutorialNextButton);
				tutorialNextButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
					switch (tutorialState) {
						case TUTORIAL_HELLO:
							showTutorial(TUTORIAL_ATTRS);
						break;
						case TUTORIAL_ATTRS:
							showTutorial(TUTORIAL_SERVING);
						break;
						case TUTORIAL_SERVING:
						break;
						case TUTORIAL_AFTER_FIRST_SERVE:
						break;
						case TUTORIAL_LEVEL2_UP:
						break;
					}
				});
			}
			tutorialNextButton.visible = false;
			if (!tutorialGoButton) {
				tutorialGoButton = new GameObject(scene);
				tutorialGoButton.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_PLAY));
				tutorialGoButton.x = (TUTORIAL_WIDTH - tutorialGoButton.width) / 2;
				tutorialGoButton.y = TUTORIAL_BTN_Y;
				tutorialGoButton.setSelect(true);
				tutorialWindow.addChild(tutorialGoButton);
				tutorialGoButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
					switch (tutorialState) {
						case TUTORIAL_HELLO:
						break;
						case TUTORIAL_ATTRS:
						break;
						case TUTORIAL_SERVING:
							hideTutorial();
						break;
						case TUTORIAL_AFTER_FIRST_SERVE:
							hideTutorial();
						break;
						case TUTORIAL_LEVEL2_UP:
							hideTutorial();
						break;
					}
				});
			}
			tutorialGoButton.visible = false;
			if (!tutorialMessageTextField) {
				tutorialMessageTextField = new TextField();
				tutorialMessageTextField.defaultTextFormat = new TextFormat("Arial", 14);
				tutorialMessageTextField.width = TUTORIAL_TEXT_WIDTH;
				tutorialMessageTextField.wordWrap = true;
				tutorialMessageTextField.selectable = false;
				tutorialMessageTextField.autoSize = TextFieldAutoSize.CENTER;
				tutorialMessageTextField.x = (tutorialWindow.width - tutorialMessageTextField.width) / 2;
				tutorialMessageTextField.y = TUTORIAL_TEXT_Y;
				tutorialWindow.addChild(tutorialMessageTextField);
			}
			tutorialMessageTextField.visible = false;
//			if (tutorialWindow.contains(messageTextField)) {
//				tutorialWindow.removeChild(messageTextField);
//			}
			switch (tutorialState) {
				case TUTORIAL_HELLO:
					tutorialMessageTextField.text = 'Привет!\n' + 
						'Поздравляю, у тебя теперь есть свой бар.\n' +
						'Здесь ты сможешь принимать посетителей и зарабатывать деньги!\n' +
						'Обустраивай свой бар - сделай его самым лучшим!';
					tutorialMessageTextField.visible = true;
					tutorialNextButton.visible = true;
					break;
				case TUTORIAL_ATTRS:
					//TODO arrow
					//TODO иконки характеристик
					tutorialMessageTextField.text = 'Тебе как владельцу стоит знать все основные характеристики:\n' + 
							'Уровень - отображается рядом с твоим аватаром\n' + 
							'Опыт - прибавляется от каждого приготовленного коктейля.'
							'Любовь - уровень любви твоих клиентов. Чем больше любовь, тем выше количество посетителей.\n' + 
							'Центы - основной вид денег для покупки продукции в магазине.\n' + 
							'Евро - служат для покупки специальных предметов интерьера и оплаты некоторых услуг.';
					tutorialMessageTextField.visible = true;
					tutorialNextButton.visible = true;
					break;
				case TUTORIAL_SERVING:
					//TODO arrow
					//TODO иконка кнопки обслужить
					tutorialMessageTextField.text = 'А вот и твой первый посетитель!\n' + 
							'Кликай на посетителя, а затем на кнопку "Обслужить".\n' + 
							'Для приготовления коктейля перетаскивай нужную продукцию с полки на панель с изображением коктейля.';
					tutorialMessageTextField.visible = true;
					tutorialGoButton.visible = true;
					break;
				case TUTORIAL_AFTER_FIRST_SERVE:
					//TODO arrow to shop
					//TODO иконка магазина продукции
					tutorialMessageTextField.text = 'Отлично!\n' + 
							'Посетитель ушел в хорошем настроении и наверняка зайдет еще :)\n' + 
							'Если у тебя закончилась какая-то продукция, ты можешь купить ее в магазине.\n' + 
							'Теперь ты знаешь все необходимое для начала работы. Набери 2 уровень!';
					tutorialMessageTextField.visible = true;
					tutorialGoButton.visible = true;
					break;
				case TUTORIAL_LEVEL2_UP:
					tutorialMessageTextField.text = 'Некоторые виды алкогольной продукции требуют лицензии на них.\n' +
						'Купи лецензию и сможешь приобретать этот товар в свой бар.\n\n' +
						'Также ты можешь обустраивать свой бар, приобретая новые предметы в "Магазине интерьера".\n' +
						'Это позволит повысить количество посетителей и их любовь к тебе.\n' + 
						'Сделай свой бар самым красивым!';
					tutorialMessageTextField.visible = true;
					tutorialGoButton.visible = true;
					break;
			}
//			tutorialWindow.addChild(messageTextField);
		}
		
		public function hideTutorial(): void {
			tutorialWindow.visible = false;
			tutorialArrow.visible = false;
		}
		
		//-----------------------------------------------------------------------
		//-----------------------------------------------------------------------
		// Окна переходов между уровенями
		//-----------------------------------------------------------------------
		//-----------------------------------------------------------------------
		
		public static const UP_LEVEL_WIDTH: Number = 700;
		public static const UP_LEVEL_HEIGHT: Number = 300;
		public static const UP_LEVEL_TEXT_WIDTH: Number = 500;
		public static const UP_LEVEL_TEXT_Y: Number = 30;
		public static const UP_LEVEL_BTN_Y: Number = 250;
		public static const UP_LEVEL_GOODS_Y: Number = 100;
		public static const UP_LEVEL_PRODUCTION_Y: Number = 190;
		public static const UP_LEVEL_BETWEEN_PANELS: Number = 5;
		public var upLevelWindow: Window;
		public var upLevelGoButton: GameObject;
		public var upLevelMessageTextField: TextField;
		public var upLevel: Number;
		public var upLevelProduction: Array;
		public var upLevelGoods: Array;
		
		public function showUpLevel(level: Number): void {
			upLevel = level;
			if (!upLevelWindow) {
				upLevelWindow = new Window(scene, UP_LEVEL_WIDTH, UP_LEVEL_HEIGHT);
				upLevelWindow.zOrder = UP_LEVEL_WINDOW_Z_ORDER;
				upLevelWindow.x = (Bar.WIDTH - upLevelWindow.width) / 2;
				upLevelWindow.y = (Bar.HEIGHT - upLevelWindow.height) / 2;
				addChild(upLevelWindow);
			}
			upLevelWindow.visible = true;
			if (!upLevelGoButton) {
				upLevelGoButton = new GameObject(scene);
				upLevelGoButton.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_PLAY));
				upLevelGoButton.x = (UP_LEVEL_WIDTH - upLevelGoButton.width) / 2;
				upLevelGoButton.y = TUTORIAL_BTN_Y;
				upLevelGoButton.setSelect(true);
				upLevelWindow.addChild(upLevelGoButton);
				upLevelGoButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
					hideUpLevel();
				});
			}
			upLevelGoButton.visible = true;
			if (!upLevelMessageTextField) {
				upLevelMessageTextField = new TextField();
				upLevelMessageTextField.defaultTextFormat = new TextFormat("Arial", 14);
				upLevelMessageTextField.width = UP_LEVEL_TEXT_WIDTH;
				upLevelMessageTextField.wordWrap = true;
				upLevelMessageTextField.selectable = false;
				upLevelMessageTextField.autoSize = TextFieldAutoSize.CENTER;
				upLevelMessageTextField.x = (upLevelWindow.width - upLevelMessageTextField.width) / 2;
				upLevelMessageTextField.y = TUTORIAL_TEXT_Y;
				upLevelWindow.addChild(upLevelMessageTextField);
			}
			upLevelMessageTextField.text = 'Поздравляем! Теперь посетители могут заказать новые коктейли и напитки!\n' +
				'А в магазине ты сможешь купить новую продукцию.';
			upLevelMessageTextField.visible = true;
			if (!upLevelProduction) {
				upLevelProduction = new Array();
			}
			else {
				for each (pp in upLevelProduction) {
					if (upLevelWindow.contains(pp)) {
						upLevelWindow.removeChild(pp);
						upLevelProduction.splice(upLevelProduction.indexOf(pp), 1);
					}
				}
			}
			for each (var pt: ProductionType in Balance.productionTypes) {
				if (upLevel == pt.accessLevel) {
					upLevelProduction.push(new ProductionPanel(scene, pt, null));
				}
			}
			var xx: Number = (UP_LEVEL_WIDTH - (upLevelProduction.length * ProductionPanel.WIDTH + (upLevelProduction.length - 1) * UP_LEVEL_BETWEEN_PANELS)) / 2;
			for each (var pp: ProductionPanel in upLevelProduction) {
				pp.x = xx;
				pp.y = UP_LEVEL_PRODUCTION_Y; 
				pp.enabledProduction = true;
				pp.licensed = true;
				xx += ProductionPanel.WIDTH + UP_LEVEL_BETWEEN_PANELS;
				upLevelWindow.addChild(pp);
			}
			if (!upLevelGoods) {
				upLevelGoods = new Array();
			}
			else {
				for each (gp in upLevelGoods) {
					if (upLevelWindow.contains(gp)) {
						upLevelWindow.removeChild(gp);
						upLevelGoods.splice(upLevelGoods.indexOf(gp), 1);
					}
				}
			}
			for each (var gt: GoodsType in Balance.goodsTypes) {
				if (upLevel == gt.accessLevel) {
					upLevelGoods.push(new GoodsPanel(scene, gt, null));
				}
			}
			xx = (UP_LEVEL_WIDTH - (upLevelGoods.length * GoodsPanel.WIDTH + (upLevelGoods.length - 1) * UP_LEVEL_BETWEEN_PANELS)) / 2;
			for each (var gp: GoodsPanel in upLevelGoods) {
				gp.x = xx;
				gp.y = UP_LEVEL_GOODS_Y; 
				gp.enabledGoods = true;
				xx += GoodsPanel.WIDTH + UP_LEVEL_BETWEEN_PANELS;
				upLevelWindow.addChild(gp);
			}
		}
		
		public function hideUpLevel(): void {
			upLevelWindow.visible = false;
		}
	}
}
