package com.bar.ui.tooltips
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.Move;
	import com.flashmedia.basics.actions.Visible;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Point;

	public class ToolTip extends GameLayer
	{
		public static const CONTENT_LEFT_INDENT: Number = 12;
		public static const CONTENT_RIGHT_INDENT: Number = 8;
		public static const CONTENT_TOP_INDENT_POINTER_DOWN: Number = 12;
		public static const CONTENT_TOP_INDENT_POINTER_UP: Number = 20;
		
		public static const POINTER_DOWN: Number = 1;
		public static const POINTER_UP: Number = 2;
		
		//public var gameObject: GameObject;
		public var _distanceLength: Number = 5;
		public var pointer: int;
		public var srcX: Number;
		public var srcY: Number;
		public var distX: Number;
		public var distY: Number;
//		public var moveAction: Move;
		public var visAction: Visible;
		public var bitmapPointerDown: Bitmap;
		public var bitmapPointerUp: Bitmap;
		public var contentArea: GameLayer;
		
		public function ToolTip(value:GameScene)
		{
			super(value);
			visible = false;
//			moveAction = new Move(scene, 'm1', this, Move.MOVE_TO_POINT);
			visAction = new Visible(scene, 'vis', this);
			bitmapPointerUp = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.HINT_DOWN));
			bitmapPointerDown = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.HINT_UP));
			width = bitmapPointerDown.width;
			height = bitmapPointerDown.height;
			contentArea = new GameLayer(scene);
			contentArea.x = CONTENT_LEFT_INDENT;
			contentArea.width = width - CONTENT_LEFT_INDENT - CONTENT_RIGHT_INDENT;
			addChild(contentArea);
		}
		
		public function hide(): void {
			visible = false;
//			moveAction.stop();
			visAction.stop();
		}
		
		public function surfaceXY(sx: Number, sy: Number, distanceLength: Number = 5): void {
			srcX = sx - width / 2;
			srcY = sy;
			_distanceLength = distanceLength;
//			moveAction.stop();
			visAction.stop();
			visible = true;
			//gameObject = go;
			update();
			x = distX;
			if (pointer == POINTER_DOWN) {
				y = distY + _distanceLength;
			}
			else {
				y = distY - _distanceLength;
			}
			visAction.duration = 400;
			visAction.start();
			visAction.fromAlpha = 0;
			visAction.toAlpha = 1;
//			moveAction.point = new Point(distX, distY);
//			moveAction.speed = moveAction.distance / 6;
//			moveAction.start();
		}
		
		public function surfaceGameObject(go: GameObject, distanceLength: Number = 5): void {
			surfaceXY(go.x + go.width / 2, go.y + go.height / 2, distanceLength);
		}
		
		protected function update(): void {
			distX = srcX;
			distY = srcY - _distanceLength - height;
			pointer = POINTER_DOWN;
//			if (distY < 0) {
//				distY = srcY + _distanceLength;
//				pointer = POINTER_UP;
//			}
//			if (pointer == POINTER_DOWN) {
				contentArea.y = CONTENT_TOP_INDENT_POINTER_DOWN;
				bitmap = bitmapPointerDown;
//			}
//			else {
//				contentArea.y = CONTENT_TOP_INDENT_POINTER_UP;
//				bitmap = bitmapPointerUp;
//			}
		}
	}
}