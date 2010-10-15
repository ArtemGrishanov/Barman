package com.bar.ui.panels
{
	import com.bar.model.Balance;
	import com.bar.model.essences.GoodsType;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.ActionEvent;
	import com.flashmedia.basics.actions.Wipe;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	public class ClientOrderPanel extends GameLayer
	{
		public static const WIDTH: Number = 210;
		public static const HEIGHT: Number = 200;
		public static const GOODS_X: Number = 10;
		public static const GOODS_Y_TOP_INDENT: Number = 7;
		public static const PROD_MAX_HEIGHT: Number = 65;
		public static const PROD_X_INDENT: Number = 7;
		public static const PROD_Y_TOP_INDENT: Number = 14;
		public static const PROD_Y_BOTTOM_INDENT: Number = 10;
		
		public var cancelButton: GameObject;
		public var goodsGameObject: GameObject;
		public var goodsGameObjectGray: GameObject;
		public var prodGameObjects: Array;
//		public var clientGameObject: GameObject;
		public var goodsComponentsCount: int;
		public var wipeAction: Wipe;
		public var lastAddedProduction: Production;

		public function ClientOrderPanel(value: GameScene)
		{
			super(value);
			width = WIDTH;
			height = HEIGHT;
			bitmap = BitmapUtil.scaleWith9Grid(Bar.multiLoader.get(Images.WINDOW),
											new Rectangle(50, 50, 490, 400),
											width, height);
			cancelButton = createRoundButton(BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_CLOSE)));
			cancelButton.x = width - cancelButton.width / 2;
			cancelButton.y = -cancelButton.height / 2;
			cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelBtnClick);
			addChild(cancelButton);
			visible = false;
		}
		
		private function onCancelBtnClick(event: GameObjectEvent): void {
			var orderEvent: ClientOrderPanelEvent = new ClientOrderPanelEvent(ClientOrderPanelEvent.EVENT_CANCEL);
			dispatchEvent(orderEvent);
		}
		
		public function addProduction(production: Production): void {
			lastAddedProduction = production;
			for each(var go: GameObject in prodGameObjects) {
				if (go.type == production.typeProduction.type) {
					removeChild(go);
					prodGameObjects.splice(prodGameObjects.indexOf(go), 1);
					updateProductionX();
					var partLength: Number = goodsGameObject.height / goodsComponentsCount;
					var fromD: Number = partLength * (prodGameObjects.length + 1);
					wipeAction.setDistance(fromD, -partLength);
					wipeAction.start();
				}
			}
		}

		public function showGoods(goodsType: GoodsType, xx: Number, yy: Number): void {
			x = xx;
			y = yy;
			if (goodsGameObject && contains(goodsGameObject)) {
				removeChild(goodsGameObject);
			}
			if (goodsGameObjectGray && contains(goodsGameObjectGray)) {
				removeChild(goodsGameObjectGray);
			}
			goodsComponentsCount = goodsType.composition.length;
			width = WIDTH;
			height = HEIGHT;
//			clientGameObject = clientGO;
			if (prodGameObjects) {
				for each (var g: GameObject in prodGameObjects) {
					if (contains(g)) {
						removeChild(g);
					}
				}
			}
			var yy: Number = GOODS_Y_TOP_INDENT;
			//todo изображение напитка
			goodsGameObject = new GameObject(scene);
			goodsGameObject.y = yy;
			goodsGameObject.bitmap = BitmapUtil.cloneBitmap(goodsType.bitmap);
			yy += goodsGameObject.height + PROD_Y_TOP_INDENT;
			var mask: Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawRect(0, 0, goodsGameObject.width, goodsGameObject.height);
			mask.graphics.endFill();
			goodsGameObject.mask = mask;
			prodGameObjects = new Array();
			for each(var comp: Object in goodsType.composition) {
				var pt: ProductionType = Balance.getProductionTypeByName(comp['productionType'] as String);
				var prodGO: GameObject = new GameObject(scene);
				prodGO.type = pt.type;
				//todo scale PROD_MAX_HEIGHT
				prodGO.bitmap = BitmapUtil.cloneBitmap(pt.bitmap);
				prodGameObjects.push(prodGO);
				addChild(prodGO);
			}
			updateProductionX();
//			x = clientGameObject.x + (clientGameObject.width - width) / 2;
//			y = clientGameObject.y + (clientGameObject.height - height) / 2;
			goodsGameObject.x = (width - goodsGameObject.width) / 2;
			for each(var go: GameObject in prodGameObjects) {
				go.y = yy + PROD_MAX_HEIGHT - go.height;
			}
			wipeAction = new Wipe(scene, '', goodsGameObject, Wipe.WIPE_UP);
			wipeAction.addEventListener(ActionEvent.TYPE_ENDED, actionEnded);
			yy = GOODS_Y_TOP_INDENT;
			goodsGameObjectGray = new GameObject(scene);
			goodsGameObjectGray.y = yy;
			goodsGameObjectGray.bitmap = BitmapUtil.cloneBitmap(goodsType.bitmap);
			// make goods icon gray
			var cmf: ColorMatrixFilter = new ColorMatrixFilter([
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0.3,0.3,0.3,0,0,
				0,  0,  0,  1,0
				]);
			goodsGameObjectGray.applyFilter(cmf);
			addChild(goodsGameObjectGray);
			addChild(goodsGameObject);
			yy += goodsGameObjectGray.height + PROD_Y_TOP_INDENT;
			goodsGameObjectGray.x = (width - goodsGameObjectGray.width) / 2;
			visible = true;
		}
		
		private function updateProductionX(): void {
			var sumWidth: Number = 0;
			for each(var go: GameObject in prodGameObjects) {
				sumWidth += go.width;
			}
			if (prodGameObjects.length > 1) {
				sumWidth += PROD_X_INDENT * (prodGameObjects.length - 1)
			}
			if (width < sumWidth) {
				width = sumWidth;
			}
			var xx: Number = (width - sumWidth) / 2;
			for each(var g: GameObject in prodGameObjects) {
				g.x = xx;
				xx += g.width + PROD_X_INDENT;
			}
		}

		private function createRoundButton(bitmap: Bitmap): GameObject {
			var mask: Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawCircle(bitmap.width / 2, bitmap.height / 2, bitmap.width / 2);
			mask.graphics.endFill();
			var btn: GameObject = new GameObject(scene);
			btn.setSelect(true, true, mask);
			btn.setHover(true, false);
			btn.bitmap = bitmap;
			btn.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onButtonLostHover);
			btn.addEventListener(GameObjectEvent.TYPE_MOUSE_DOWN, onButtonDown);
			btn.addEventListener(GameObjectEvent.TYPE_MOUSE_UP, onButtonUp);
			btn.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
			btn.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			return btn;
		}
		
		public function onButtonLostHover(event: GameObjectEvent): void {
			//event.gameObject.y += 2;
		}
		
		public function onButtonDown(event: GameObjectEvent): void {
//			event.gameObject.y += 2;
		}
		
		public function onButtonUp(event: GameObjectEvent): void {
//			event.gameObject.y -= 2;
		}
		
		public function onItemSetHover(event: GameObjectEvent): void {
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
		}
		
		public function onItemLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(GlowFilter);
		}
		
		private function actionEnded(event: ActionEvent): void {
			var orderEvent: ClientOrderPanelEvent = new ClientOrderPanelEvent(ClientOrderPanelEvent.EVENT_PRODUCTION_ADDED);
			orderEvent.production = lastAddedProduction;
			dispatchEvent(orderEvent);
			return;
		}
	}
}