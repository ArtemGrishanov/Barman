package com.bar.ui.windows
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;

	public class Window extends GameLayer
	{
		public var cancelButton: GameObject;
//		public var leftButton: GameObject;
//		public var rightButton: GameObject;
		
		public function Window(value:GameScene, w: Number, h: Number)
		{
			super(value);
			
			width = w;
			height = h;
			
			visible = false;
			
			cancelButton = new GameObject(scene);
			cancelButton.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.BTN_CLOSE));
			cancelButton.x = width - cancelButton.width / 2;
			cancelButton.y = -cancelButton.height / 2;
			cancelButton.setSelect(true, true);
			cancelButton.setHover(true, false);
			cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelBtnClick);
			cancelButton.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onItemSetHover);
			cancelButton.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onItemLostHover);
			cancelButton.visible = true;
			addChild(cancelButton);
//			leftButton = new GameObject(scene);
//			leftButton.setSelect(true, true);
//			leftButton.setHover(true, false);
//			leftButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
//			leftButton.visible = false;
//			addChild(leftButton);
//			rightButton = new GameObject(scene);
//			rightButton.setSelect(true, true);
//			rightButton.setHover(true, false);
//			rightButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
//			rightButton.visible = false;
//			addChild(rightButton);
			
			bitmap = BitmapUtil.scaleImageWidthHeight(Bar.multiLoader.get(Images.WINDOW), width, height, false);
		}
		
//		protected function setCancelButton(x: Number, y: Number, cancelBtnBitmap: Bitmap): void {
//			cancelButton.x = x;
//			cancelButton.y = y;
//			cancelButton.bitmap = cancelBtnBitmap;
//			cancelButton.visible = cancelButton.bitmap != null;
//		}
		
//		protected function setLeftButton(x: Number, y: Number, leftBtnBitmap: Bitmap): void {
//			leftButton.x = x;
//			leftButton.y = y;
//			leftButton.bitmap = leftBtnBitmap;
//			leftButton.visible = leftButton.bitmap != null;
//		}
//		
//		protected function setRightButton(x: Number, y: Number, rightBtnBitmap: Bitmap): void {
//			rightButton.x = x;
//			rightButton.y = y;
//			rightButton.bitmap = rightBtnBitmap;
//			rightButton.visible = rightButton.bitmap != null;
//		}
		
		protected function onCancelBtnClick(event: GameObjectEvent): void {
			if (isModal) {
				scene.resetModal(this);
			}
			visible = false;
		}
		
		protected function onLeftBtnClick(event: GameObjectEvent): void {
			
		}
		
		protected function onRightBtnClick(event: GameObjectEvent): void {
			
		}
		
		public function onItemSetHover(event: GameObjectEvent): void {
			event.gameObject.applyFilter(new GlowFilter(0xffffff, 1, 10, 10));
		}
		
		public function onItemLostHover(event: GameObjectEvent): void {
			event.gameObject.removeFilter(GlowFilter);
		}
	}
}