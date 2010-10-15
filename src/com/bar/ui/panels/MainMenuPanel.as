package com.bar.ui.panels
{
	import com.bar.api.ServerEvent;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.DecorType;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.ProductionType;
	import com.bar.ui.UIBarPlace;
	import com.bar.util.Images;
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.socialnet.SocialNetEvent;
	import com.flashmedia.socialnet.SocialNetUser;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	public class MainMenuPanel extends GameLayer
	{
		public static const STATE_FRIENDS: String = 'friends';
		public static const STATE_PRODUCTION: String = 'production';
		public static const STATE_DECOR: String = 'decor';
		public static const STATE_GOODS: String = 'goods';
		
		public static const ROWS_COUNT: Number = 2;
		public static const COLUMNS_COUNT: Number = 5;
		
		public static const FRIENDS_VIS_PANELS_COUNT: Number = 5;
		
		public static const MENU_WINE_SHOP: String = 'wine_shop';
		public static const MENU_BAR_ASSORTIMENT: String = 'bar_assortiment';
		public static const MENU_NEWS: String = 'news';
		public static const MENU_MONEY: String = 'money';
		public static const MENU_DECOR_SHOP: String = 'decor_shop';
		public static const MENU_INVITE_FRIENDS: String = 'invite_friend';
		public static const MENU_TOP_BARS: String = 'top_bars';
		public static const MENU_BARS_LENTA: String = 'bars_lenta';
		
		public static const X: Number = 0;
		public static const Y: Number = 551;
		public static const WIDTH: Number = Bar.WIDTH;
		public static const HEIGHT: Number = 179;
		public static const FRIENDS_LAYER_X: Number = 5;
		public static const FRIENDS_LAYER_Y: Number = 65;
		public static const FRIENDS_LAYER_SCROLL_WIDTH: Number = 485;
		public static const FRIENDS_LAYER_SCROLL_HEIGHT: Number = 75;
		public static const FRIENDS_INDENT_BETWEEN_PANELS: Number = 22;
		public static const FRIEND_PANEL_Y: Number = 7;
		
		public static const LEFT_BUTTON_X_FRIENDS: Number = 5;
		public static const LEFT_BUTTON_Y_FRIENDS: Number = 93;
		public static const RIGHT_BUTTON_X_FRIENDS: Number = 492;
		public static const RIGHT_BUTTON_Y_FRIENDS: Number = 93;
		
		public static const LEFT_BUTTON_X_SHOP: Number = 9;
		public static const LEFT_BUTTON_Y_SHOP: Number = 95;
		public static const RIGHT_BUTTON_X_SHOP: Number = 693;
		public static const RIGHT_BUTTON_Y_SHOP: Number = 95;
		
		public static const CANCEL_BTN_X: Number = 673;
		public static const CANCEL_BTN_Y: Number = 8;
		
		public static const GRID_BOX_X: Number = 35;
		public static const GRID_BOX_Y: Number = 47;
		
		public static const LENTA_X: Number = 509;
		public static const LENTA_Y: Number = 42;
		
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
		public var leftPageButton: GameObject;
		public var leftBeginButton: GameObject;
		public var rightButton: GameObject;
		public var rightPageButton: GameObject;
		public var rightBeginButton: GameObject;
		public var lentaBitmap: Bitmap;
		
		public var multiLoader: MultiLoader;
		
		public function MainMenuPanel(value: GameScene)
		{
			super(value);
			x = X;
			y = Y;
			width = WIDTH;
			height = HEIGHT;
			state = STATE_FRIENDS;
			
			bitmap = Bar.multiLoader.get(Images.MM_BACK);
			
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
			gridBox.x = GRID_BOX_X;
			gridBox.y = GRID_BOX_Y;
			gridBox.setPaddings(0, 0, 0, 0);
			gridBox.indentBetweenCols = 0;
			gridBox.indentBetweenRows = 0;
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
			//var cancelBtnBitmap: Bitmap = new Bitmap(new BitmapData(20, 20, false, 0xad1111));
			var cancelBtnBitmap: Bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_CLOSE));
			cancelButton.x = CANCEL_BTN_X;
			cancelButton.y = CANCEL_BTN_Y;
			cancelButton.bitmap = cancelBtnBitmap;
			cancelButton.visible = false;
			cancelButton.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
			cancelButton.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			addChild(cancelButton);
			
			leftButton = new GameObject(scene);
			leftButton.x = LEFT_BUTTON_X_FRIENDS;
			leftButton.y = LEFT_BUTTON_Y_FRIENDS;
			leftButton.bitmap = Bar.multiLoader.get(Images.MM_LEFT1);
			leftButton.setSelect(true, false, null, new Rectangle(-10, -10, leftButton.bitmap.width + 20, leftButton.bitmap.height + 20));
			leftButton.setHover(true, false);
			leftButton.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
			leftButton.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			leftButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
			leftButton.visible = false;
			addChild(leftButton);
			rightButton = new GameObject(scene);
			rightButton.x = RIGHT_BUTTON_X_FRIENDS;
			rightButton.y = RIGHT_BUTTON_Y_FRIENDS;
			rightButton.bitmap = Bar.multiLoader.get(Images.MM_RIGHT1);
			rightButton.setSelect(true, false, null, new Rectangle(-10, -10, rightButton.bitmap.width + 20, rightButton.bitmap.height + 20));
			rightButton.setHover(true, false);
			rightButton.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
			rightButton.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			rightButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
			rightButton.visible = false;
			addChild(rightButton);
			
			lentaBitmap = Bar.multiLoader.get(Images.MM_LENTABACK);
			lentaBitmap.x = LENTA_X;
			lentaBitmap.y = LENTA_Y;
			addChild(lentaBitmap);
			
			var go: GameObject = new GameObject(scene);
			go.type = MENU_WINE_SHOP;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_WINESHOP);
			go.x = 9;
			go.y = -487;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Винный магазин');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_DECOR_SHOP;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_INTSHOP);
			go.x = 5;
			go.y = -424;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Интерьер');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_BAR_ASSORTIMENT;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_BARMENU);
			go.x = 2;
			go.y = -362;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Меню бара');
			itemGameObjects.push(go);
			
			var cmf: ColorMatrixFilter = new ColorMatrixFilter([
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0,  0,  0,  1,0
				]);
			go = new GameObject(scene);
			go.type = MENU_NEWS;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_NEWS);
			go.x = -1;
			go.y = -301;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			go.applyFilter(cmf);
			addChild(go);
			itemNames.push('Новости');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_MONEY;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_MONEY);
			go.x = -1;
			go.y = -237;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			addChild(go);
			itemNames.push('Пополнить баланс');
			itemGameObjects.push(go);
			
			go = new GameObject(scene);
			go.type = MENU_INVITE_FRIENDS;
			go.setSelect(true);
			go.setHover(true, false);
			go.bitmap = Bar.multiLoader.get(Images.MM_ICO_ADDFR);
			go.x = 2;
			go.y = -175;
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, menuItemClick);
			go.applyFilter(cmf);
			addChild(go);
			itemNames.push('Пригласить друга');
			itemGameObjects.push(go);
			
			//TODO top_bars
			//TODO bars_lents
			
			for each (var item: GameObject in itemGameObjects) {
				item.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
				item.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			}
			
			show(STATE_FRIENDS);
			
			multiLoader = new MultiLoader();
		}
		
		public function onItemSetHover(event: GameObjectEvent): void {
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
		}
		
		public function onItemLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(GlowFilter);
		}
		
		public function requestFriends(): void {
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
			lentaBitmap.visible = false;
			switch (state) {
				case STATE_PRODUCTION:
				case STATE_DECOR:
				case STATE_GOODS:
					gridBox.visible = true;
					cancelButton.visible = true;
					leftButton.visible = true;
					rightButton.visible = true;
					leftButton.x = LEFT_BUTTON_X_SHOP;
					leftButton.y = LEFT_BUTTON_Y_SHOP;
					rightButton.x = RIGHT_BUTTON_X_SHOP;
					rightButton.y = RIGHT_BUTTON_Y_SHOP;
					showPage(0);
				break;
				case STATE_FRIENDS:
					lentaBitmap.visible = true;
					friendsLayer.visible = true;
					cancelButton.visible = false;
					leftButton.visible = true;
					leftButton.x = LEFT_BUTTON_X_FRIENDS;
					leftButton.y = LEFT_BUTTON_Y_FRIENDS;
					rightButton.visible = true;
					rightButton.x = RIGHT_BUTTON_X_FRIENDS;
					rightButton.y = RIGHT_BUTTON_Y_FRIENDS;
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
						var decorInBar: Boolean = false;
						for each (var dbar: Decor in Bar.core.myBarPlace.decor) {
							if (dbar.typeDecor.type == d.decorType.type) {
								decorInBar = true;
								break;	
							}
						}
						if (decorInBar) {
							curCell++;
							continue;
						}
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
					pp.enabledProduction = false;
				}
				else {
					pp.enabledProduction = true;
					if (pp.productionType.needLicense()) {
						pp.licensed = licensedTypes.indexOf(pp.productionType.type) != -1;
					}
				}
			}
			for each (var gp: GoodsPanel in goodsCells) {
				gp.enabledGoods = gp.goodsType.accessLevel <= userLevel;
			}
			for each (var dp: DecorPanel in decorCells) {
				dp.enabledDecor = dp.decorType.accessLevel <= userLevel;
			}
		}
		
		/**
		 * Лицензирование продукции. На панели снимается неактивное выделение и убирается кнопка "Лицензировать"
		 */
		public function licenseProduction(productionType: ProductionType): void {
			for each (var p: ProductionPanel in productionCells) {
				if (p.productionType.type == productionType.type) {
//					p.enabledProduction = true;
					p.licensed = true;
				}
			}
		}
		
		/**
		 * Установить декор, доступный для покупки
		 */
		public function setDecorForSell(decorTypes: Array): void {
//			for each (var d: DecorPanel in decorCells) {
//				d.enabledDecor = false;
//				for each (var decorType: DecorType in decorTypes) {
//					if (d.decorType.type == decorType.type) {
//						// enable or disable
//						d.enabledDecor = true;
//						break;
//					}
//				}
//			}
			// нужно заново показать страницу, чтобы только что купленный декор пропал из магазина.
			if (state == STATE_DECOR) {
				show(MainMenuPanel.STATE_DECOR);
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
				if (t.accessLevel > userLevel) {
					panel.enabledProduction = false;
				}
				else {
					panel.enabledProduction = true;
					if (panel.productionType.needLicense()) {
						panel.licensed = licensedTypes.indexOf(panel.productionType.type) != -1;
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
					panel.enabledGoods = g.accessLevel <= userLevel;
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
					panel.enabledDecor = t.accessLevel <= userLevel;
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
		public function addFriends(friendsIds: Array, friendsLevels: Array): void {
			friendsLayer.width = 0;
			var invitedPanelsCount: int = 1;
			if (friendsIds.length < FRIENDS_VIS_PANELS_COUNT) {
				invitedPanelsCount = FRIENDS_VIS_PANELS_COUNT - friendsIds.length;
			}
			for (var i: Number = 0; (i < friendsIds.length) || (invitedPanelsCount > 0); i++) {
				if (i < friendsIds.length) {
					var id: Number = friendsIds[i];
					var level: Number = friendsLevels[i];
					var panel: FriendPanel = new FriendPanel(scene, this, id, level);
				}
				else {
					panel = new FriendPanel(scene, this);
					panel.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.MM_INVITEFRIEND));
					invitedPanelsCount--;
				}
				panel.setHover(true);
				panel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFriendPanelClick);
				if (friendCells.length > 0) {
					panel.x = (friendCells[friendCells.length - 1] as FriendPanel).x + FriendPanel.WIDTH + FRIENDS_INDENT_BETWEEN_PANELS;
				}
				else {
					panel.x = FRIENDS_INDENT_BETWEEN_PANELS;
				}
				panel.y = FRIEND_PANEL_Y;
				friendCells.push(panel);
				friendsLayer.addChild(panel);
				friendsLayer.width += panel.width + FRIENDS_INDENT_BETWEEN_PANELS;
			}
//			var invitedPanelsCount: int = 1;
//			if (friendCells.length < FRIENDS_VIS_PANELS_COUNT) {
//				invitedPanelsCount = FRIENDS_VIS_PANELS_COUNT - friendCells.length;
//			}
//			for (i = 0; i < invitedPanelsCount; i++) {
//				var invitePanel: GameObject = new GameObject(scene);
//				invitePanel.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.MM_INVITEFRIEND));
//				invitePanel.setHover(true);
//				invitePanel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onInvitePanelClick);
//				if (friendCells.length > 0) {
//					invitePanel.x = (friendCells[friendCells.length - 1] as GameObject).x + FriendPanel.WIDTH + FRIENDS_INDENT_BETWEEN_PANELS;
//				}
//				friendCells.push(invitePanel);
//				friendsLayer.addChild(invitePanel);
//				friendsLayer.width += invitePanel.width + FRIENDS_INDENT_BETWEEN_PANELS;
//			}
			if (friendCells.length > 0) {
				friendsLayer.width -= FRIENDS_INDENT_BETWEEN_PANELS;
			}
			Bar.socialNet.addEventListener(SocialNetEvent.USER_INFO, onSocialNetUserInfo);
			Bar.socialNet.getUserInfo(friendsIds);
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
			var p: ProductionPanel = event.gameObject as ProductionPanel;
			if (p.canBuy) {
				var mainMenuEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_PRODUCTION_CLICK);
			}
			else {
				mainMenuEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_LICENSE);
			}
			mainMenuEvent.productionType = p.productionType;
			dispatchEvent(mainMenuEvent);
		}
		
		protected function onDecorPanelClick(event: GameObjectEvent): void {
			if ((event.gameObject as DecorPanel).enabledDecor) {
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
			if (friendPanel.userId) {
				var friendEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_FRIEND_CLICK);
				friendEvent.user = friendPanel.user;
				dispatchEvent(friendEvent);
			}
			else {
				var inviteEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_INVITE_FRIEND);
				dispatchEvent(inviteEvent);
			}
		}
		
//		public function onInvitePanelClick(event: GameObjectEvent): void {
//			var inviteEvent: MainMenuPanelEvent = new MainMenuPanelEvent(MainMenuPanelEvent.EVENT_INVITE_FRIEND);
//			dispatchEvent(inviteEvent);
//		}
		
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
				case MENU_INVITE_FRIENDS:
					//TODO uncomment
					//UIBarPlace.friendsWindow.visible = true;
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
		
		/**
		 * Получены идишники друзей из соц сети
		 */
		protected function onSocialNetFriends(event: SocialNetEvent): void {
			//запрос на наш сервер, получаем только тех, кто зарегистрирован в игре
			if (Bar.server) {
				Bar.server.addEventListener(ServerEvent.EVENT_FRIENDS_LOADED, onServerFriendsLoaded);
				Bar.server.loadFriends(event.friensdIds);
				//TODO uncomment
				//UIBarPlace.friendsWindow.friendsIds = event.friensdIds;
			}
		}
		
		/**
		 * Получены идишники друзей из игры
		 */
		 protected function onServerFriendsLoaded(event: ServerEvent): void {
		 	if (Bar.server) {
			 	Bar.server.removeEventListener(ServerEvent.EVENT_FRIENDS_LOADED, onServerFriendsLoaded);
				//todo сортировка идишников по рейтингу в игре
				var sortedFriendsIds: Array = new Array();
				var sortedFriendsLevels: Array = new Array();
				var sortedFriendsExp: Array = new Array();
				var added: Boolean = false;
				for (var fi: int = 0; fi < event.friendsIds.length; fi++) {
					added = false;
					for (var si: int = 0; si < sortedFriendsIds.length; si++) {
						if (event.friendsLevels[fi] == sortedFriendsLevels[si]) {
							if (event.friendsExp[fi] > sortedFriendsExp[si]) {
								sortedFriendsIds.splice(si, -1, event.friendsIds[fi]);
								sortedFriendsLevels.splice(si, -1, event.friendsLevels[fi]);
								sortedFriendsExp.splice(si, -1, event.friendsExp[fi]);
								added = true;
							}
						}
						else if (event.friendsLevels[fi] > sortedFriendsLevels[si]) {
							sortedFriendsIds.splice(si, -1, event.friendsIds[fi]);
							sortedFriendsLevels.splice(si, -1, event.friendsLevels[fi]);
							sortedFriendsExp.splice(si, -1, event.friendsExp[fi]);
							added = true;
						}
						if (added) {
							break;
						}
					}
					if (!added) {
						sortedFriendsIds.push(event.friendsIds[fi]);
						sortedFriendsLevels.push(event.friendsLevels[fi]);
						sortedFriendsExp.push(event.friendsExp[fi]);
					}
				}
				if (sortedFriendsIds) {
					addFriends(sortedFriendsIds, sortedFriendsLevels);
				}
		 	}
		}
		
		/**
		 * Получена информация о друзьях, которые участвуют в игре
		 */
		protected function onSocialNetUserInfo(event: SocialNetEvent): void {
			multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onPhotoLoad);
			for each (var u: SocialNetUser in event.users) {
				for each (var fp: FriendPanel in friendCells) {
					if (fp.userId == u.id) {
						fp.user = u;
						multiLoader.load(u.photoBigUrl, u.photoBigUrl, 'Bitmap'); 
					}
				}
			}
		}
		
		/**
		 * Получена фото друзей, которые участвуют в игре
		 */
		protected function onPhotoLoad(event: MultiLoaderEvent): void {
			if (multiLoader.isLoaded) {
				removeEventListener(MultiLoaderEvent.COMPLETE, onPhotoLoad);
				for each (var fp: FriendPanel in friendCells) {
					if (fp.user) {
						fp.avatar = BitmapUtil.fillByRect(multiLoader.get(fp.user.photoBigUrl), FriendPanel.WIDTH, FriendPanel.HEIGHT);
						fp.avatar = BitmapUtil.drawBorder(fp.avatar, 0xf1a62e, 1)
					}
				}
			}
		}
	}
}