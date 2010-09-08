package com.bar.ui.panels
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class ClientButtonsPanel extends GameLayer
	{
		public static const WIDTH: Number = 100;
		public static const HEIGHT: Number = 20;
		
		public var serveButton: GameObject;
//		public var cancelButton: GameObject;
		public var denyButton: GameObject;
		public var toBarButton: GameObject;
		
		public function ClientButtonsPanel(value:GameScene)
		{
			super(value);
			serveButton = createRoundButton(new Bitmap(new BitmapData(20, 20, false, 0x33ff22)));
			addChild(serveButton);
//			cancelButton = createRoundButton(new Bitmap(new BitmapData(20, 20, false, 0xff1122)));
//			addChild(cancelButton);
			denyButton = createRoundButton(new Bitmap(new BitmapData(20, 20, false, 0x334422)));
			denyButton.x = 40;
			addChild(denyButton);
			toBarButton = createRoundButton(new Bitmap(new BitmapData(20, 20, false, 0xa3ffd2)));
			toBarButton.x = 80;
			addChild(toBarButton);
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
			return btn;
		}
		
		public function onButtonLostHover(event: GameObjectEvent): void {
//			event.gameObject.y -= 2;
		}
		
		public function onButtonDown(event: GameObjectEvent): void {
			event.gameObject.y += 2;
		}
		
		public function onButtonUp(event: GameObjectEvent): void {
			event.gameObject.y -= 2;
		}
	}
}