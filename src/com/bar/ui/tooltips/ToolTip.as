package com.bar.ui.tooltips
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.Move;
	import com.flashmedia.basics.actions.Visible;
	
	import flash.geom.Point;

	public class ToolTip extends GameLayer
	{
		public static const INDENT: Number = 10;
		public static const POINTER_DOWN: Number = 1;
		public static const POINTER_UP: Number = 2;
		
		public var gameObject: GameObject;
		public var pointer: int;
		public var distX: Number;
		public var distY: Number;
		public var moveAction: Move;
		public var visAction: Visible;
		
		public function ToolTip(value:GameScene, w: Number, h: Number)
		{
			super(value);
			width = w;
			height = h;
			visible = false;
			moveAction = new Move(scene, 'm1', this, Move.MOVE_TO_POINT);
			visAction = new Visible(scene, 'vis', this);
		}
		
		public function hide(): void {
			visible = false;
			moveAction.stop();
			visAction.stop();
		}
		
		public function surface(go: GameObject): void {
			moveAction.stop();
			visAction.stop();
			visible = true;
			gameObject = go;
			update();
			x = distX;
			if (pointer == POINTER_DOWN) {
				y = distY + INDENT;
			}
			else {
				y = distY - INDENT;
			}
			
			visAction.duration = 400;
			visAction.start();
			visAction.fromAlpha = 0;
			visAction.toAlpha = 1;
			moveAction.point = new Point(distX, distY);
			moveAction.speed = moveAction.distance / 6;
			moveAction.start();
		}
		
		protected function update(): void {
			if (gameObject) {
				distX = gameObject.x + (gameObject.width - width) / 2;
				distY = gameObject.y - INDENT - height;
				pointer = POINTER_DOWN;
				if (distY < 0) {
					distY = gameObject.y + gameObject.height + INDENT;
					pointer = POINTER_UP;
				}
			}
			else {
				distX = (Bar.WIDTH - width) / 2;
				distY = (Bar.HEIGHT - height) / 2;
			}
			
			//todo
			graphics.clear();
			graphics.beginFill(0x00ffff, 0.5);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
		}
	}
}