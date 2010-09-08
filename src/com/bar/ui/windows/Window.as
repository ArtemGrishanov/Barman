package com.bar.ui.windows
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Window extends GameLayer
	{
		public var cancelButton: GameObject;
		public var leftButton: GameObject;
		public var rightButton: GameObject;
		
		public function Window(value:GameScene, w: Number, h: Number)
		{
			super(value);
			
			width = w;
			height = h;
			
			visible = false;
			
			cancelButton = new GameObject(scene);
			cancelButton.bitmap = new Bitmap(new BitmapData(20, 20, false, 0xff0000));
			cancelButton.x = width - cancelButton.width / 2;
			cancelButton.y = -cancelButton.height / 2;
			cancelButton.setSelect(true, true);
			cancelButton.setHover(true, false);
			cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelBtnClick);
			cancelButton.visible = true;
			addChild(cancelButton);
			leftButton = new GameObject(scene);
			leftButton.setSelect(true, true);
			leftButton.setHover(true, false);
			leftButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
			leftButton.visible = false;
			addChild(leftButton);
			rightButton = new GameObject(scene);
			rightButton.setSelect(true, true);
			rightButton.setHover(true, false);
			rightButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
			rightButton.visible = false;
			addChild(rightButton);
			
			updateWindow();
		}
		
//		protected function setCancelButton(x: Number, y: Number, cancelBtnBitmap: Bitmap): void {
//			cancelButton.x = x;
//			cancelButton.y = y;
//			cancelButton.bitmap = cancelBtnBitmap;
//			cancelButton.visible = cancelButton.bitmap != null;
//		}
		
		protected function setLeftButton(x: Number, y: Number, leftBtnBitmap: Bitmap): void {
			leftButton.x = x;
			leftButton.y = y;
			leftButton.bitmap = leftBtnBitmap;
			leftButton.visible = leftButton.bitmap != null;
		}
		
		protected function setRightButton(x: Number, y: Number, rightBtnBitmap: Bitmap): void {
			rightButton.x = x;
			rightButton.y = y;
			rightButton.bitmap = rightBtnBitmap;
			rightButton.visible = rightButton.bitmap != null;
		}

		protected function updateWindow(): void {
			graphics.clear();
			graphics.beginFill(0x888888, 0.8);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
		}
		
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
		
	}
}