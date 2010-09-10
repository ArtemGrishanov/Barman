package com.bar.ui
{
	import com.bar.model.Balance;
	import com.bar.model.CoreEvent;
	import com.bar.model.essences.Client;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.Production;
	import com.bar.ui.panels.ClientButtonsPanel;
	import com.bar.ui.panels.ClientOrderPanel;
	import com.bar.ui.panels.ClientOrderPanelEvent;
	import com.bar.ui.panels.MainMenuPanel;
	import com.bar.ui.panels.MainMenuPanelEvent;
	import com.bar.ui.panels.TopPanel;
	import com.bar.ui.tooltips.ClientToolTip;
	import com.bar.ui.tooltips.ProductionToolTip;
	import com.bar.ui.windows.ExchangeWindow;
	import com.bar.ui.windows.Window;
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.Visible;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class UIBarPlace extends GameLayer
	{
		public static const CLIENT_SIT_Y: Number = 529;
		public static const CLIENT_SIT_CENTER_X: Array = [94, 275, 455, 635];
		
		public static const TIPS_POSITION_Y: Number = 430;
		public static const TIPS_POSITION_X: Array = [100, 200, 300, 400, 500];
		
		public static const BAR_TABLE_Y: Number = 436;
		
//		public static const PRODUCTION_POSITION_X: Number = 200;
//		public static const PRODUCTION_POSITION_Y: Number = 50;
		
		public static const SHELF_Z_ORDER: Number = 10;
		public static const PRODUCTION_Z_ORDER: Number = 24;
		public static const PRODUCTION_ACTIVE_Z_ORDER: Number = 100;
		public static const TOOLTIP_Z_ORDER: Number = 45;
		public static const CLIENT_BTN_PANEL_Z_ORDER: Number = 35;
		public static const TIPS_Z_ORDER: Number = 12;
		public static const CLIENT_Z_ORDER: Number = 25;
		public static const CLIENT_SERVE_PANEL_Z_ORDER: Number = 37;
		public static const MAIN_MENU_PANEL_Z_ORDER: Number = 37;
		public static const EXCHANGE_WINDOW_Z_ORDER: Number = 60;
		public static const TOP_PANEL_Z_ORDER: Number = 37;
		public static const PRODUCTION_SHOP_WINDOW_Z_ORDER: Number = 38;
		public static const TUTORIAL_WINDOW_Z_ORDER: Number = 80;
		public static const TUTORIAL_ARROW_Z_ORDER: Number = 81;
		
		public var goClients: Array;
		public var goTips: Array;
		public var tipsClientIds: Array;
		public var goProduction: Array;
		public var goDecor: Array;
		public var prodCount: int;
		public var shelf: UIShelf;
		public var ttProduction: ProductionToolTip;
		public var ttClient: ClientToolTip;
		public var cBntPanel: ClientButtonsPanel;
		public var cOrderPanel: ClientOrderPanel;
		public var clientGameObject: GameObject;
		public var mainMenuPanel: MainMenuPanel;
		public var topPanel: TopPanel;
		public static var exchangeWindow: ExchangeWindow;
		//public var productionShopWindow: ProductionShopWindow;
		//todo fix
//		public var go1: GameObject;
//		public var go2: GameObject;
		
		public function UIBarPlace(value:GameScene)
		{
			super(value);
			
			//todo resourse loading
			Balance.clientTypes[0].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT1));
			Balance.clientTypes[1].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.CLIENT1));
			
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
			
			//1 level
			Balance.productionTypes[0].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_BEER));
			Balance.productionTypes[1].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_VODKA));
			Balance.productionTypes[2].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_ORANGE));
			Balance.productionTypes[3].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SODA));
			//2 level
			Balance.productionTypes[4].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_VISKI));
			Balance.productionTypes[5].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_LIMON_CAP));
			Balance.productionTypes[6].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.PROD_SIROP));
			//3 level
			
			
			Balance.decorTypes[0].bitmap = Bar.multiLoader.get(Images.PICTURE1);
//			Balance.decorTypes[0].bitmapSmall = new Bitmap(new BitmapData(20, 20, false, 0xffd1d4));
			Balance.decorTypes[1].bitmap = Bar.multiLoader.get(Images.SHKAF1);
//			Balance.decorTypes[1].bitmapSmall = new Bitmap(new BitmapData(20, 20, false, 0xa3d0e4));
			Balance.decorTypes[2].bitmap = Bar.multiLoader.get(Images.WALL1);
//			Balance.decorTypes[2].bitmapSmall = new Bitmap(new BitmapData(20, 20, false, 0xa3d0e4));
			Balance.decorTypes[3].bitmap = Bar.multiLoader.get(Images.BARTABLE1);
//			Balance.decorTypes[3].bitmapSmall = new Bitmap(new BitmapData(20, 20, false, 0xa3d0e4));
			for (var i: int = 4; i <= 7; i++) {
				Balance.decorTypes[i].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.STUL1));
//				Balance.decorTypes[i].bitmapSmall = BitmapUtil.cloneBitmap(new Bitmap(new BitmapData(20, 20, false, 0xa3d0e4)));
			}
			for (i = 8; i <= 9; i++) {
				Balance.decorTypes[i].bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LAMP1));
//				Balance.decorTypes[i].bitmapSmall = BitmapUtil.cloneBitmap(new Bitmap(new BitmapData(20, 20, false, 0xa3d0e4)));
			}
			Balance.decorTypes[10].bitmap = Bar.multiLoader.get(Images.WOMAN_BODY);
			Balance.decorTypes[11].bitmap = Bar.multiLoader.get(Images.WOMAN_PANTS1);
			Balance.decorTypes[12].bitmap = Bar.multiLoader.get(Images.WOMAN_BUST1);
			Balance.decorTypes[13].bitmap = Bar.multiLoader.get(Images.WOMAN_TSHIRT1);
			Balance.decorTypes[14].bitmap = Bar.multiLoader.get(Images.WOMAN_SKIRT1);
			Balance.decorTypes[15].bitmap = Bar.multiLoader.get(Images.BARTABLE_BACK1);
			Balance.decorTypes[16].bitmap = Bar.multiLoader.get(Images.PICTURE2);
			Balance.decorTypes[17].bitmap = Bar.multiLoader.get(Images.PICTURE3);
			
			//todo remove
			graphics.lineStyle(2, 0xff0000);
			graphics.moveTo(0, BAR_TABLE_Y);
			graphics.lineTo(Bar.WIDTH, BAR_TABLE_Y);
			graphics.drawRect(0, 0, Bar.WIDTH, Bar.HEIGHT);
			
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
				go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0x00ee00));
				go.zOrder = TIPS_Z_ORDER;
				go.x = TIPS_POSITION_X[i];
				go.y = TIPS_POSITION_Y;
				go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onTipsMouseClick);
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
			mainMenuPanel.addProduction(Balance.productionTypes, Bar.core.myBarPlace.user.licensedProdTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.addDecor(Balance.decorTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.addGoods(Balance.goodsTypes, Bar.core.myBarPlace.user.level);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_ITEM_CLICK, mainMenuItemClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_PRODUCTION_CLICK, mainMenuProductionClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_LICENSE, mainMenuLicense);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_CLICK, mainMenuDecorClick);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_OVER, mainMenuDecorOver);
			mainMenuPanel.addEventListener(MainMenuPanelEvent.EVENT_DECOR_OUT, mainMenuDecorOut);
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
			
//			productionShopWindow = new ProductionShopWindow(scene);
//			productionShopWindow.zOrder = PRODUCTION_SHOP_WINDOW_Z_ORDER;
//			productionShopWindow.visible = false;
//			productionShopWindow.addProduction(Balance.productionTypes, Bar.core.myBarPlace.user.licensedProdTypes);
//			productionShopWindow.addEventListener(ProductionShopWindowEvent.EVENT_PRODUCTION_CLICK, productionShopWindowClick);
//			productionShopWindow.addEventListener(ProductionShopWindowEvent.EVENT_LICENSE, productionShopWindowLicense);
//			addChild(productionShopWindow);
			
			cBntPanel = new ClientButtonsPanel(scene);
			cBntPanel.zOrder = CLIENT_BTN_PANEL_Z_ORDER;
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
			
			ttProduction = new ProductionToolTip(scene, 100, 40);
			ttProduction.zOrder = TOOLTIP_Z_ORDER;
			addChild(ttProduction);
			
			ttClient = new ClientToolTip(scene, 100, 40);
			ttClient.zOrder = TOOLTIP_Z_ORDER;
			addChild(ttClient);
			
//			var c1: Client = new Client(Balance.clientTypes[0], '12345', 'Вася Пупкин', false, new Date().getTime() / 1000, Balance.goodsTypes[0], 1);
//			c1.orderGoodsType = Balance.goodsTypes[2]; 
//			addClient(c1);
//			
//			go1 = new GameObject(scene);
//			go2 = new GameObject(scene);
//			
//			go1.zOrder = PRODUCTION_Z_ORDER;
//			go1.setSelect(true);
//			go1.canDrag = true;
//			go1.setFocus(true);
//			go1.setHover(true);
//			go1.type = UIShelf.GAME_OBJECT_TYPE;
//			go1.bitmap = BitmapUtil.cloneBitmap(Balance.productionTypes[0].bitmap);
//			go1.x = 200;
//			go1.y = 200;
//			go1.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, shelf.onDragStartedProductionObject);
//			go1.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, onDragStartedProductionObject);
//			go1.addEventListener(GameObjectEvent.TYPE_DRAGGING, shelf.onDragProductionObject);
//			go1.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, shelf.onProductionMouseUp);
//			go1.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, onProductionMouseUp);
//			go1.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onProductionMouseHover);
//			go1.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onProductionLostHover);
//			addChild(go1);
//			
//			go2.zOrder = PRODUCTION_Z_ORDER;
//			go2.setSelect(true);
//			go2.canDrag = true;
//			go2.setFocus(true);
//			go2.setHover(true);
//			go2.type = UIShelf.GAME_OBJECT_TYPE;
//			go2.bitmap = BitmapUtil.cloneBitmap(Balance.productionTypes[1].bitmap);
//			go2.x = 230;
//			go2.y = 10;
//			go2.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, shelf.onDragStartedProductionObject);
//			go2.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, onDragStartedProductionObject);
//			go2.addEventListener(GameObjectEvent.TYPE_DRAGGING, shelf.onDragProductionObject);
//			go2.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, shelf.onProductionMouseUp);
//			go2.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, onProductionMouseUp);
//			go2.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onProductionMouseHover);
//			go2.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onProductionLostHover);
//			addChild(go2);
			
//			shelf.addProduction(go1, false);
//			shelf.addProduction(go2, false);
			
			
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
			Bar.core.addEventListener(CoreEvent.EVENT_USER_EXP_CHANGED, userExpChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LEVEL_CHANGED, userLevelChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_USER_LOVE_CHANGED, userLoveChanged);
			Bar.core.addEventListener(CoreEvent.EVENT_BARMAN_TAKE_TIP, barmanTakeTip);
			Bar.core.addEventListener(CoreEvent.EVENT_TIPS_DELETED, tipsDeleted);
			Bar.core.addEventListener(CoreEvent.EVENT_DECOR_ADDED_TO_BAR, addDecorToBar);
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
				ttProduction.surface(event.gameObject);
			}
		}
		
		public function onProductionLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(ColorMatrixFilter);
			ttProduction.hide();
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
		
		public function onClientSetHover(event: GameObjectEvent): void {
			//todo изменение прозрачности
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
			var c: Client = Bar.core.getClientById(event.gameObject.id);
			ttClient.setAttrs(c.name, c.orderGoodsType.name, Balance.getGoodsTypeByName(c.orderGoodsType.type).bitmap);
			ttClient.surface(event.gameObject);
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
			cBntPanel.x = event.gameObject.x + event.gameObject.width / 2 - cBntPanel.width / 2;
			cBntPanel.y = event.gameObject.y + event.gameObject.height / 2 - cBntPanel.height / 2;
			cBntPanel.visible = true;
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
				if (Bar.core.firstLaunch) {
					showTutorial(TUTORIAL_HELLO);
				}
			}
			else {
				
			}
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
			cOrderPanel.showGoods(event.client.orderGoodsType, clientGameObject);
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
		
		public function userLevelChanged(event: CoreEvent): void {
			var d: Number = event.newLevel - event.oldLevel;
			trace('Level: ' + event.newLevel + ' (' + ((event.newLevel > event.oldLevel)?'+':'') + d + ')');
			topPanel.level = event.newLevel;
			mainMenuPanel.setLevel(Bar.core.myBarPlace.user.licensedProdTypes, event.newLevel);
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
		
		public static const TUTORIAL_HELLO: String = 't_hello';
		public static const TUTORIAL_ATTRS: String = 't_attrs';
		public static const TUTORIAL_SERVING: String = 't_serving';
		public static const TUTORIAL_WIDTH: Number = 300;
		public static const TUTORIAL_HEIGHT: Number = 300;
		public var tutorialWindow: Window;
		public var tutorialArrow: GameObject;
		public function showTutorial(state: String): void {
			if (!tutorialWindow) {
				tutorialWindow = new Window(scene, TUTORIAL_WIDTH, TUTORIAL_HEIGHT);
				tutorialWindow.visible = true;
				tutorialWindow.zOrder = TUTORIAL_WINDOW_Z_ORDER;
				tutorialWindow.x = (Bar.WIDTH - tutorialWindow.width) / 2;
				tutorialWindow.y = (Bar.HEIGHT - tutorialWindow.height) / 2;
			}
			if (!tutorialArrow) {
				tutorialArrow = new GameObject(scene);
				tutorialArrow.zOrder = TUTORIAL_ARROW_Z_ORDER;
				tutorialArrow.visible = false;
			}
			switch (state) {
				case TUTORIAL_HELLO:
					var tf: TextField = new TextField();
					tf.width = 200;
					tf.wordWrap = true;
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.text = 'Привет! Поздравляю, у тебя теперь есть свой бар. ' +
						'Здесь ты сможешь принимать посетителей и зарабатывать деньги!' +
						'Обустраивай свой бар - сделай его самым лучшим!';
					tf.x = (tutorialWindow.width - tf.width) / 2;
					tf.y = (tutorialWindow.height - tf.height) / 2;
					tutorialWindow.addChild(tf);
					break;
				case TUTORIAL_ATTRS:
					
					break;
				case TUTORIAL_SERVING:
					
					break;
			}
			addChild(tutorialWindow);
		}
		
		public function hideTutorial(): void {
			tutorialWindow.visible = false;
			tutorialArrow.visible = false;
		}
	}
}
