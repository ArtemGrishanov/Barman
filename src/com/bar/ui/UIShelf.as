package com.bar.ui
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.ActionEvent;
	import com.flashmedia.basics.actions.Move;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UIShelf extends GameLayer
	{
		public static const GAME_OBJECT_TYPE: String = 'production';
		
		public static const SHELF_X: Number = 250;
		public static const SHELF_Y: Number = 94;
		public static const SHELF_W: Number = 236;
		public static const SHELF_H: Number = 231;
		public static const SHELF_ROW_COUNT: Number = 3;
		public static const SHELF_CELL_COUNT: Number = 7;
		
		public static const BACK_X: Number = 0;
		public static const BACK_Y: Number = 0;
		
		public var w: Number;
		public var h: Number;
		public var rowCount: Number;
		public var cellCount: Number;
		public var rowHeight: Number;
		public var cellWidth: Number;
		
		/**
		 * ['x']
		 * ['y']
		 * ['go'] - gameObject
		 */
		public var rows: Array;
		public var back: Bitmap;
		/**
		 * Подсветки
		 * Array [Bitmap]
		 */
		public var highlights: Array;
		
		public function UIShelf(value:GameScene)
		{
			super(value);
			setSelect(true);
			
			x = SHELF_X;
			y = SHELF_Y;
			width = SHELF_W;
			height = SHELF_H;
			rowCount = SHELF_ROW_COUNT;
			cellCount = SHELF_CELL_COUNT;
			rows = new Array();
			rowHeight = SHELF_H / SHELF_ROW_COUNT;
			cellWidth = SHELF_W / SHELF_CELL_COUNT;
			for (var r: int = 0; r < rowCount; r++) {
				var cells: Array = new Array();
				for (var c: int = 0; c < cellCount; c++) {
					var cObj: Object = new Object();
					cObj['x'] = c * cellWidth;
					cObj['y'] = r * rowHeight;
					cObj['go'] = null;
					cells.push(cObj);
				}
				rows.push(cells);
			}
			highlights = new Array();
			
			graphics.lineStyle(2, 0xff0000);
			graphics.drawRect(0,0,width,height / 3);
			graphics.drawRect(0,height / 3,width,height / 3);
			graphics.drawRect(0, 2 * height / 3,width,height / 3);
		}
		
		public function setBackground(b: Bitmap): void {
			back = b;
		}
		
		public function highlightCell(rowIndex: int, cellIndex: int, hBmp: Bitmap = null): void {
			var hBitmap: Bitmap = hBmp;
			if (!hBitmap) {
				hBitmap = new Bitmap(new BitmapData(cellWidth, rowHeight, true, 0xbbff0000));
			}
			hBitmap.x = rows[rowIndex][cellIndex]['x'] + (cellWidth - hBitmap.width) / 2;
			hBitmap.y = rows[rowIndex][cellIndex]['y'] + (rowHeight - hBitmap.height) / 2;
			highlights.push(hBitmap);
			addChild(hBitmap);
		}
		
		public function resetAllHighlights(): void {
			for each (var b: Bitmap in highlights) {
				removeChild(b);
			}
			highlights.splice(0, highlights.length);
		}
		
		/**
		 * Возвращает ячейку, подходящую для размещения объекта-продукции
		 * goX, goY - глобальные координаты объекта
		 * return Object['cellIndex'] ['rowIndex']
		 * null - не удается подобрать место. Нет места.
		 */
		public function getFreeNearestCell(goX: Number, goY: Number): Object {
//			var goX: Number = go.x + go.width / 2;
//			var goY: Number = go.y + go.height / 2;
			var cellIndex: int = -1;
			var rowIndex: int = -1;
			var minDistance: Number = -1;
			for (var r: int = 0; r < rowCount; r++) {
				for (var c: int = 0; c < cellCount; c++) {
					var cObj: Object = rows[r][c];
					if (cObj['go'] == null) {
						var cX: Number = x + cObj['x'] + cellWidth / 2;
						var cY: Number = y + cObj['y'] + rowHeight / 2;
						var dist: Number = Math.sqrt(Math.pow((goX - cX),2) + Math.pow((goY - cY),2));
						if (minDistance == -1) {
							minDistance = dist;
							cellIndex = c;
							rowIndex = r;
						}
						if (minDistance > dist) {
							minDistance = dist;
							cellIndex = c;
							rowIndex = r;
						}
					}
				}
			}
			if (minDistance >= 0) {
				return {"cellIndex": cellIndex, "rowIndex": rowIndex};
			}
			return null;
		}
		
		public function addProduction(gameObject: GameObject, animate: Boolean = true, rowIndex: int = -1, cellIndex: int = -1): Boolean {
			var xx: Number = gameObject.x + gameObject.width / 2;
			var yy: Number = gameObject.y + gameObject.height / 2;
			// если на этом месте что-то есть - не добавляем сюда
			if (rowIndex != -1 && cellIndex != -1 && rows[rowIndex][cellIndex]['go']) {
				rowIndex = -1;
				cellIndex = -1;
			}
			// если место явно не указано - ищем
			if (rowIndex == -1 || cellIndex == -1) {
				var o: Object = getFreeNearestCell(xx, yy);
				if (o) {
					rowIndex = o['rowIndex'];
					cellIndex = o['cellIndex'];
				}
			}
			// если нашли место или оно было указано явно - добавляем
			if (rowIndex != -1 && cellIndex != -1) {
				var gX: Number = x + rows[rowIndex][cellIndex]['x'] + (cellWidth - gameObject.width) / 2;
				var gY: Number = y + rows[rowIndex][cellIndex]['y'] + rowHeight - gameObject.height;
				if (animate) {
					if (moveProdAction) {
						moveProdAction.stop();
					}
					moveProdAction = new Move(scene, 'm1', gameObject, Move.MOVE_TO_POINT);
					moveProdAction.addEventListener(ActionEvent.TYPE_ENDED, function moveEnded(e: ActionEvent): void {
						e.target.removeEventListener(ActionEvent.TYPE_ENDED, moveEnded);
						var gameObject: GameObject = e.dispObject as GameObject;;
						for (var r: int = 0; r < rowCount; r++) {
							for (var c: int = 0; c < cellCount; c++) {
								var cObj: Object = rows[r][c];
								if (cObj['go'] == gameObject) {
									var event: UIShelfEvent = new UIShelfEvent(UIShelfEvent.EVENT_PRODUCTION_PLACE_CHANGED);
									event.rowIndex = r;
									event.cellIndex = c;
									event.gameObject = gameObject;
									dispatchEvent(event);
									return;
								}
							}
						}
					});
					moveProdAction.point = new Point(gX, gY);
					moveProdAction.speed = moveProdAction.distance / 4;
					moveProdAction.start();
				}
				else {
					gameObject.x = gX;
					gameObject.y = gY;
					var event: UIShelfEvent = new UIShelfEvent(UIShelfEvent.EVENT_PRODUCTION_PLACE_CHANGED);
					event.rowIndex = rowIndex;
					event.cellIndex = cellIndex;
					event.gameObject = gameObject;
					dispatchEvent(event);
				}
				rows[rowIndex][cellIndex]['go'] = gameObject;
				return true;
			}
			return false;
		}
		
		public function deleteProduction(p: GameObject): Boolean {
			for (var r: int = 0; r < rowCount; r++) {
				for (var c: int = 0; c < cellCount; c++) {
					var cObj: Object = rows[r][c];
					if (cObj['go'] == p) {
						cObj['go'] = null;
						return true;
					}
				}
			}
			return false;
		}
		
//		public var dragProdObject: GameObject;
		public function onDragStartedProductionObject(event: GameObjectEvent): void {
//			if (moveProdAction && moveProdAction.isActive) {
//				trace('onDragStartedProductionObject == return');
//				return;
//			}
//			dragProdObject = event.gameObject;
			deleteProduction(event.gameObject);
		}
		
		public function onDragProductionObject(event: GameObjectEvent): void {
//			if (!dragProdObject) {
//				return;
//			}
			var xx: Number = event.gameObject.x + event.gameObject.width / 2;
			var yy: Number = event.gameObject.y + event.gameObject.height / 2;
			resetAllHighlights();
			if (UIUtil.inRect(new Point(xx, yy), new Rectangle(x - 10, y - 10, width + 20, height + 20))) {
				var o: Object = getFreeNearestCell(xx, yy);
				if (o) {
					highlightCell(o['rowIndex'], o['cellIndex']);
				}
			}
		}
		
		public var moveProdAction: Move;
		public function onProductionMouseUp(event: GameObjectEvent): void {
//			var xx: Number = event.gameObject.x + event.gameObject.width / 2;
//			var yy: Number = event.gameObject.y + event.gameObject.height / 2;
//			if (UIUtil.inRect(new Point(xx, yy), new Rectangle(x - 10, y - 10, width + 20, height + 20))) {
//				resetAllHighlights();
//				addProduction(event.gameObject);
//			}
		}
	}
}