package com.bar.ui.panels
{
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.ProductionType;
	import com.bar.ui.UIBarPlace;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.socialnet.SocialNetEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class MainMenuPanel extends GameLayer
	{
		public static const STATE_FRIENDS: String = 'friends';
		public static const STATE_PRODUCTION: String = 'production';
		public static const STATE_DECOR: String = 'decor';
		public static const STATE_GOODS: String = 'goods';
		
		public static const ROWS_COUNT: Number = 2;
		public static const COLUMNS_COUNT: Number = 8;
		
		public static const MENU_WINE_SHOP: String = 'wine_shop';
		public static const MENU_BAR_ASSORTIMENT: String = 'bar_assortiment';
		public static const MENU_NEWS: String = 'news';
		public static const MENU_MONEY: String = 'money';
		public static const MENU_DECOR_SHOP: String = 'decor_shop';
		
		public static const X: Number = 0;
		public static const Y: Number = 587;
		public static const WIDTH: Number = Bar.WIDTH;
		public static const HEIGHT: Number = 160;
		public static const FRIENDS_LAYER_X: Number = 40;
		public static const FRIENDS_LAYER_Y: Number = 10;
		public static const FRIENDS_LAYER_SCROLL_WIDTH: Number = 620;
		public static const FRIENDS_LAYER_SCROLL_HEIGHT: Number = 140;
		public static const FRIENDS_INDENT_BETWEEN_PANELS: Number = 20;
		
		public static const LEFT_BUTTON_X: Number = 5;
		public static const LEFT_BUTTON_Y: Number = 70;
		public static const RIGHT_BUTTON_X: Number = 680;
		public static const RIGHT_BUTTON_Y: Number = 70;
		
		private var state: String;
		public var itemNames: Array;
		public var itemGameObjects: Array;
		
		/**
		 * Массив, где хранятся ячейки (ProductionPanel)
		 */
		public var productionCells: Array;
		/**
		 * Массив, где хранятся ячейки (GoodsPanel)
		 */
		public var goodsCells: Array;
		/**
		 * Массив, где хранятся ячейки (DecorPanel)
		 */
		public var decorCells: Array;
		/**
		 * Массив, где хранятся ячейки (FriendPanel)
		 */
		public var friendCells: Array;
		public var currentProductionPage: int;
		public var currentGoodsPage: int;
		public var currentDecorPage: int;
		
		public var gridBox: GridBox;
		public var friendsLayer: GameLayer;
		public var usersLayer: GameLayer;
		
		public var cancelButton: GameObject;
		public var leftButton: GameObject;
		public var rightButton: GameObject;
		
		public function MainMenuPanel(value: GameScene)
		{
			super(value);
			x = X;
			y = Y;
			width = WIDTH;
			height = HEIGHT;
			state = STATE_FRIENDS;
			
			//todo fix
			graphics.beginFill(0xc5c4c4, 1.0);
			graphics.drawRoundRect(0, 0, width, height, 15, 15);
			graphics.endFill();
			
			itemNames = new Array();
			itemGameObjects = new Array();
			
			currentProductionPage = 0;
			currentGoodsPage = 0;
			currentDecorPage = 0;
			productionCells = new Array();
			goodsCells = new Array();
			decorCells = new Array();
			friendCells = new Array();
			gridBox = new GridBox(scene, COLUMNS_COUNT, ROWS_COUNT);
			gridBox.indentBetweenCols = 10;
			gridBox.indentBetweenRows = 10;
			addChild(gridBox);
			
			friendsLayer = new GameLayer(scene);
			friendsLayer.x = FRIENDS_LAYER_X;
			friendsLayer.y = FRIENDS_LAYER_Y;
			friendsLayer.visible = false;
			friendsLayer.height = height;
			friendsLayer.smoothScroll = 0.7;
			friendsLayer.scrollRect = new Rectangle(0, 0, FRIENDS_LAYER_SCROLL_WIDTH, FRIENDS_LAYER_SCROLL_HEIGHT);
			addChild(friendsLayer);
			
			usersLayer = new GameLayer(scene);
			usersLayer.visible = false;
			usersLayer.height = height;
			usersLayer.scrollRect = new Rectangle(0, 0, FRIENDS_LAYER_SCROLL_WIDTH, FRIENDS_LAYER_SCROLL_HEIGHT);
			addChild(usersLayer);
			
			cancelButton = new GameObject(scene);
			cancelButton.setSelect(true, true);
			cancelButton.setHover(true, false);
			cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelBtnClick);
			cancelButton.visible = false;
			var cancelBtnBitmap: Bitmap = new Bitmap(new BitmapData(20, 20, false, 0xad1111));
			cancelButton.x = width - cancelBtnBitmap.width / 2;
			cancelButton.y = -cancelBtnBitmap.height / 2;
			cancelButton.bitmap = cancelBtnBitmap;
			cancelButton.visible = false;
			addChild(cancelButton);
			
			leftButton = new GameObject(scene);
			leftButton.x = LEFT_BUTTON_X;
			leftButton.y = LEFT_BUTTON_Y;
			leftButton.bitmap = new Bitmap(new BitmapData(20, 20, false, 0xad1111));
			leftButton.setSelect(true, true);
			leftButton.setHover(true, false);
			leftButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
			leftButton.visible = false;
			addChild(leftButton);
			rightButton = new GameObject(scene);
			rightButton.x = RIGHT_BUTTON_X;
			rightButton.y = RIGHT_BUTTON_Y;
			rightButton.bitmap = new Bitmap(new BitmapData(20, 20, false, 0xad1111));
			rightButton.setSelect(true, true);
			rightButton.setHover(true, false);
			rightButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
			rightButton.visible = false;
			addChild(rightButton);
			
			var go: GameObject = new GameObject(scene);
			go.type = MENU_WINE_SHOP;
			go.setSelect(true);
			go.setHover(true);
			go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0x123af0));
			go.x = 10;
			go.y = -7;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Винный магазин');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_DECOR_SHOP;
			go.setSelect(true);
			go.setHover(true);
			go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0x003af0));
			go.x = 30;
			go.y = -7;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Интерьер');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_BAR_ASSORTIMENT;
			go.setSelect(true);
			go.setHover(true);
			go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0xa240f0));
			go.x = 50;
			go.y = -7;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Меню бара');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_NEWS;
			go.setSelect(true);
			go.setHover(true);
			go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0x1200f0));
			go.x = 70;
			go.y = -7;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Новости');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_MONEY;
			go.setSelect(true);
			go.setHover(true);
			go.bitmap = new Bitmap(new BitmapData(15, 15, false, 0x1006f0));
			go.x = 90;
			go.y = -7;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Пополнить баланс');
			itemGameObjects.push(go);
			
			show(STATE_FRIENDS);
			
			Bar.socialNet.addEventListener(SocialNetEvent.GET_FRIENDS, onSocialNetFriends);
			Bar.socialNet.getFriends();
		}
		
		public function show(newState: String): void {
			state = newState;
			gridBox.visible = false;
			friendsLayer.visible = false;
			usersLayer.visible = false;
			leftButton.visible = false;
			rightButton.visible = false;
			switch (state) {
				case STATE_PRODUCTION:
				case STATE_DECOR:
				case STATE_GOODS:
					gridBox.visible = true;
					cancelButton.visible = true;
					showPage(0);
				break;
				case STATE_FRIENDS:
					friendsLayer.visible = true;
					cancelButton.visible = false;
					leftButton.visible = true;
					rightButton.visible = true;
				break;
				default:
					cancelButton.visible = false;
				break;
			}
		}
		
		private function showPage(pageIndex: int): void {
			gridBox.removeAllItems();
			var maxItemsOnPage: int = ROWS_COUNT * COLUMNS_COUNT;
			var curCell: int = 0;
			switch (state) {
				case STATE_PRODUCTION:
					for each (var p: ProductionPanel in productionCells) {
						if ((curCell >= (pageIndex * maxItemsOnPage)) && (curCell < ((pageIndex + 1) * maxItemsOnPage))) {
							gridBox.addItem(p.productionType.type, productionCells[curCell]);
						}
						curCell++;
					}
				break;
				case STATE_GOODS:
					for each (var g: GoodsPanel in goodsCells) {
						if ((curCell >= (pageIndex * maxItemsOnPage)) && (curCell < ((pageIndex + 1) * maxItemsOnPage))) {
							gridBox.addItem(g.goodsType.type, goodsCells[curCell]);
						}
						curCell++;
					}
				break;
				case STATE_DECOR:
					for each (var d: DecorPanel in decorCells) {
						if ((curCell >= (pageIndex * maxItemsOnPage)) && (curCell < ((pageIndex + 1) * maxItemsOnPage))) {
							gridBox.addItem(d.decorType.type, decorCells[curCell]);
						}
						curCell++;
					}
				break;
			}
		}
		
		public function getPages(): int {
			switch (state) {
				case STATE_PRODUCTION:
					var fp: int = productionCells.length / (COLUMNS_COUNT * ROWS_COUNT);
					return (productionCells.length > (fp * COLUMNS_COUNT * ROWS_COUNT)) ? fp + 1: fp;
				case STATE_GOODS:
					fp = goodsCells.length / (COLUMNS_COUNT * ROWS_COUNT);
					return (goodsCells.length > (fp * COLUMNS_COUNT * ROWS_COUNT)) ? fp + 1: fp;
				case STATE_DECOR:
					fp = decorCells.length / (COLUMNS_COUNT * ROWS_COUNT);
					return (decorCells.length > (fp * COLUMNS_COUNT * ROWS_COUNT)) ? fp + 1: fp;
				default:
					return 0;
			}
		}
		
		public function setLevel(licensedTypes: Array, userLevel: int): void {
			for each (var pp: ProductionPanel in productionCells) {
				if (pp.productionType.accessLevel > userLevel) {
					pp.enabled = false;
				}
				else {
					if (pp.productionType.needLicense()) {
						pp.enabled = licensedTypes.indexOf(pp.productionType.type) != -1;
					}
					else {
						pp.enabled = true;
					}
				}
			}
			for each (var gp: GoodsPanel in goodsCells) {
				gp.enabled = gp.goodsType.accessLevel <= userLevel;
			}
			for each (var dp: DecorPanel in decorCells) {
				dp.enabled = dp.decorType.accessLevel <= userLevel;
			}
		}
		
		/**
		 * Лицензирование продукции. На панели снимается неактивное выделение и убирается кнопка "Лицензировать"
		 */
		public function licenseProduction(productionType: ProductionType): void {
			for each (var p: ProductionPanel in productionCells) {
				if (p.productionType.type == productionType.type) {
					p.enabled = true;
					p.licensed = true;
				}
			}
		}
		
		/**
		 * Установить декор, доступный для покупки
		 */
		public function setDecorForSell(decorTypes: Array): void {
			for each (var d: DecorPanel in decorCells) {
				d.enabled = false;
				for each (var decorType: DecorType in decorTypes) {
					if (d.decorType.type == decorType.type) {
						// enable or disable
						d.enabled = true;
						break;
					}
				}
			}
		}
		
//		/**
//		 * Покупка декора
//		 */
//		public function buyDecor(decorType: DecorType): void {
//			for each (var d: DecorPanel in decorCells) {
//				if (d.decorType.type == decorType.type) {
//					//delete this decor from decorCells
//					decorCells.splice(decorCells.indexOf(d), 1);
//					//Замещаемый декор становится снова доступным в магазине (см. Core)
//					var s: String = 'asas';
//					s.
//				}
//			}
//			if (state == STATE_DECOR) {
//				showPage(currentDecorPage);
//			}
//		}
		
//		/**
//		 * Удаление декора из бара - он снова доступен для покупки
//		 */
//		public function deleteDecorFromBar(decorType: DecorType): void {
//			//TODO somesing
//			
//		}
	
		/**
		 * types - array of ProductionType
		 * licensedTypes - array of String
		 */
		public function addProduction(types: Array, licensedTypes: Array, userLevel: int): void {
			for each (var t: ProductionType in types) {
				var panel: ProductionPanel = new ProductionPanel(scene, t, this);
				panel.setHover(true);
				if (t.accessLevel > userLevel) {
					panel.enabled = false;
				}
				else {
					if (t.needLicense()) {
						panel.enabled = licensedTypes.indexOf(t.type) != -1;
					}
				}
				productionCells.push(panel);
				//panel.licenseButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLicenseButtonClick);
				panel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onProductionPanelClick);
			}
			currentProductionPage = 0;
			//showPage(currentPage);
		}
		
		/**
		 * types - array of GoodsType
		 */
		public function addGoods(types: Array, userLevel: int): void {
			for each (var g: GoodsType in types) {
				if (g.bitmap) {
					var panel: GoodsPanel = new GoodsPanel(scene, g, this);
					panel.setHover(true);
					panel.enabled = g.accessLevel <= userLevel;
					goodsCells.push(panel);
					panel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onGoodsPanelClick);
					panel.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onGoodsPanelHover);
					panel.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onGoodsPanelLostHover);
				}
			}
			currentDecorPage = 0;
			//showPage(currentPage);
		}
		
		/**
		 * types - array of DecorType
		 */
		public function addDecor(types: Array, userLevel: int): void {
			decorCells = new Array();
			for each (var t: DecorType in types) {
				var decorTypeExist: Boolean = false;
				for each (var dp: DecorPanel in decorCells) {
					if (dp.decorType.type == t.type) {
						decorTypeExist = true;
						break;
					}
				}
				if (decorTypeExist) {
					continue;
				}
				if (t.bitmap && t.bitmapSmall) {
					var panel: DecorPanel = new DecorPanel(scene, t, this);
					panel.setHover(true);
					panel.enabled = t.accessLevel <= userLevel;
					decorCells.push(panel);
					panel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onDecorPanelClick);
					panel.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onDecorPanelHover);
					panel.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onDecorPanelLostHover);
				}
			}
			currentDecorPage = 0;
			//showPage(currentPage);
		}
		
		/**
		 * friends - array of SocialNetUser
		 * photos - array of Bitmap
		 */
		public function addFriends(friendsIds: Array): void {
			friendsLayer.width = 0;
			for each (var id: Number in friendsIds) {
				var panel: FriendPanel = new FriendPanel(scene, this, id);
				panel.setHover(true);
				panel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFriendPanelClick);
				if (friendCells.length > 0) {
					panel.x = (friendCells[friendCells.length - 1] as FriendPanel).x + FriendPanel.WIDTH + FRIENDS_INDENT_BETWEEN_PANELS;
				}
				friendCells.push(panel);
				friendsLayer.addChild(panel);
				friendsLayer.width += panel.width + FRIENDS_INDENT_BETWEEN_PANELS;
			}
			if (friendCells.length > 0) {
				friendsLayer.width -= FRIENDS_INDENT_BETWEEN_PANELS;
			}
		}
		
		protected function onLeftBtnClick(event: GameObjectEvent): void {
			switch (state) {
				case STATE_FRIENDS:
					friendsLayer.scroll(-FriendPanel.WIDTH - FRIENDS_INDENT_BETWEEN_PANELS, 0);
				break;
				case STATE_PRODUCTION:
					if (currentProductionPage > 0) {
						currentProductionPage--;
						showPage(currentProductionPage);
					}
				break;
				case STATE_GOODS:
					if (currentGoodsPage > 0) {
						currentGoodsPage--;
						showPage(currentGoodsPage);
					}
				break;
				case STATE_DECOR:
					if (currentDecorPage > 0) {
						currentDecorPage--;
						showPage(currentDecorPage);
					}
				break;
				default:
			}
		}
		
		protected function onRightBtnClick(event: GameObjectEvent): void {
			switch (state) {
				case STATE_FRIENDS:
					friendsLayer.scroll(FriendPanel.WIDTH + FRIENDS_INDENT_BETWEEN_PANELS, 0);
				break;
				case STATE_PRODUCTION:
					if (currentProductionPage < (getPages() - 1)) {
						currentProductionPage++;
						showPage(currentProductionPage);
					}
				break;
				case STATE_GOODS:
					if (currentGoodsPage < (getPages() - 1)) {
						currentGoodsPage++;
						showPage(currentGoodsPage);
					}
				break;
				case STATE_DECOR:
					if (currentDecorPage < (getPages() - 1)) {
						currentDecorPage++;
						showPage(currentDecorPage);
					}
				break;
				default:
			}
		}
		
		protected function onProductionPanelClick(event: GameObjectEvent): void {
			if ((event.gameObject as ProductionPanel).enabled) {
				var mainMenuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_PRODUCTION_CLICK);
				mainMenuEvent.productionType = (event.gameObject as ProductionPanel).productionType;
				dispatchEvent(mainMenuEvent);
			}
		}
		
		protected function onDecorPanelClick(event: GameObjectEvent): void {
			if ((event.gameObject as DecorPanel).enabled) {
				var mainMenuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_CLICK);
				mainMenuEvent.decorType = (event.gameObject as DecorPanel).decorType;
				dispatchEvent(mainMenuEvent);
			}
		}
		
		protected function onGoodsPanelClick(event: GameObjectEvent): void {
//			if ((event.gameObject as DecorPanel).enabled) {
//				var mainMenuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_CLICK);
//				mainMenuEvent.decorType = (event.gameObject as DecorPanel).decorType;
//				dispatchEvent(mainMenuEvent);
//			}
		}
		
		public function onLicenseButtonClick(p: ProductionType): void {
			var licenseEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_LICENSE);
			licenseEvent.productionType = p;
			dispatchEvent(licenseEvent);
		}
		
		public function onFriendPanelClick(event: GameObjectEvent): void {
			var friendPanel: FriendPanel = event.target as FriendPanel;
			if (friendPanel.user) {
				var friendEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_FRIEND_CLICK);
				friendEvent.user = friendPanel.user;
				dispatchEvent(friendEvent);
			}
			else {
				var inviteEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_INVITE_FRIEND);
				dispatchEvent(inviteEvent);
			}
		}
		
		protected function menuItemClick(event: GameObjectEvent): void {
			switch (event.gameObject.type) {
				case MENU_WINE_SHOP:
					show(MainMenuPanel.STATE_PRODUCTION);
				break;
				case MENU_BAR_ASSORTIMENT:
					show(MainMenuPanel.STATE_GOODS);
				break;
				case MENU_NEWS:
					//TODO
				break;
				case MENU_MONEY:
					UIBarPlace.exchangeWindow.visible = true;
					//scene.showModal(UIBarPlace.exchangeWindow);
				break;
				case MENU_DECOR_SHOP:
					show(MainMenuPanel.STATE_DECOR);
				break;
			}
			var menuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_ITEM_CLICK);
			menuEvent.menuItem = event.gameObject.type;
			dispatchEvent(menuEvent);
		}
		
		protected function onCancelBtnClick(event: GameObjectEvent): void {
			show(STATE_FRIENDS);
		}
		
		protected function onDecorPanelHover(event: GameObjectEvent): void {
			var menuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_OVER);
			menuEvent.decorType = (event.gameObject as DecorPanel).decorType;
			dispatchEvent(menuEvent);
		}
		
		protected function onDecorPanelLostHover(event: GameObjectEvent): void {
			var menuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_OUT);
			menuEvent.decorType = (event.gameObject as DecorPanel).decorType;
			dispatchEvent(menuEvent);
		}
		
		protected function onGoodsPanelHover(event: GameObjectEvent): void {
//			var menuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_OVER);
//			menuEvent.decorType = (event.gameObject as DecorPanel).decorType;
//			dispatchEvent(menuEvent);
		}
		
		protected function onGoodsPanelLostHover(event: GameObjectEvent): void {
//			var menuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_DECOR_OUT);
//			menuEvent.decorType = (event.gameObject as DecorPanel).decorType;
//			dispatchEvent(menuEvent);
		}
		
		protected function onSocialNetFriends(event: SocialNetEvent): void {
			//todo запрос на наш сервер, получаем только тех, кто зарегистрирован в игре
			//todo сортировка идишников по рейтингу в игре
			addFriends(event.friensdIds);
		}
	}
}