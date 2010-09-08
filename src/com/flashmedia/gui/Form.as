package com.flashmedia.gui
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameLayerEvent;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/*
		TODO при прокрутке с помощью ScrollBar сбрасывается Focus с компонентов на форме
	*/
	public class Form extends GameLayer
	{
		public static const SCROLL_STEP_VERTICAL: uint = 10;
		public static const SCROLL_STEP_HORIZONTAL: uint = 10;
		
//		public static const PADDING_LEFT: uint = 5;
//		public static const PADDING_TOP: uint = 5;
//		public static const PADDING_RIGHT: uint = 5;
//		public static const PADDING_BOTTOM: uint = 5;
		
		//TODO политика прокрутки
		protected var _style: int;
		protected var _verticalScrollBar: ScrollBar;
		protected var _horizontalScrollBar: ScrollBar;
		protected var _contentLayer: GameLayer;
		protected var _paddingLeft: uint;
		protected var _paddingTop: uint;
		protected var _paddingRight: uint;
		protected var _paddingBottom: uint;
		
		public function Form(value: GameScene, x: int, y: int, width: int, height: int)
		{
			super(value);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			//TODO какой использовать фон для формы?
			//fillBackground(BACKGROUNG_COLOR, 0.9);
			updateContentLayer();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			updateContentLayer();
		}
		
		public override function set height(value: Number): void {
			super.height = value;
			updateContentLayer();
		}
		
		public function get verticalScrollBar(): ScrollBar {
			return _verticalScrollBar;
		}
		
		public function get horizontalScrollBar(): ScrollBar {
			return _horizontalScrollBar;
		}
		
		public function set paddingLeft(value: uint): void {
			_paddingLeft = value;
			updateContentLayer();
		}
		
		public function set paddingTop(value: uint): void {
			_paddingTop = value;
			updateContentLayer();
		}
		
		public function set paddingRight(value: uint): void {
			_paddingRight = value;
			updateContentLayer();
		}
		
		public function set paddingBottom(value: uint): void {
			_paddingBottom = value;
			updateContentLayer();
		}
		
//		public override function set sizeMode(value: int): void {
//			_contentLayer.sizeMode = value;
//		} 
		
		/*
			TODO пока не удается исправить на override addChild так как нарушаются все вызовы
			addChild из View
		*/
		public function addComponent(child: DisplayObject): DisplayObject {
//			if (child.x + child.width > _contentLayer.width) {
//				_contentLayer.width = child.x + child.width;
//			}
//			if (child.y + child.height > _contentLayer.height) {
//				_contentLayer.height = child.y + child.height;
//			}
			var r: DisplayObject = _contentLayer.addChild(child)
			updateContentLayer();
			return r;
		}
		
//		public override function addChild(child: DisplayObject): DisplayObject {
//			var r: DisplayObject = _contentLayer.addChild(child)
//			updateContentLayer();
//			return r;
//		}
		
		public function removeComponent(child: DisplayObject): DisplayObject {
			if (_contentLayer.contains(child)) {
				var d: DisplayObject = _contentLayer.removeChild(child);
				updateContentLayer();
				return d;
			}
			return null;
		}
		
//		public override function removeChild(child: DisplayObject): DisplayObject {
//			var d: DisplayObject = _contentLayer.removeChild(child);
//			updateContentLayer();
//			return d;
//		}
		
		private function updateContentLayer(): void {
			if (!_contentLayer) {
				_contentLayer = new GameLayer(scene);
				_contentLayer.sizeMode = GameLayer.SIZE_MODE_WIDTH_BY_CONTENT | GameLayer.SIZE_MODE_HEIGHT_BY_CONTENT;
				_contentLayer.addEventListener(GameLayerEvent.TYPE_SCROLL, onContentLayerScroll);
//				_contentLayer.debug = true;
				_contentLayer.setSelect(true);
				_contentLayer.verticalScrollStep = SCROLL_STEP_VERTICAL;
				_contentLayer.horizontalScrollStep = SCROLL_STEP_HORIZONTAL;
				_contentLayer.scrollIndents(0, 0, 0, 0);
				_view.addDisplayObject(_contentLayer, 'contentLayer', VISUAL_DISPLAY_OBJECT_Z_ORDER);
			}
			_contentLayer.x = _paddingLeft;
			_contentLayer.y = _paddingTop;
			var scrollRectWidth: int = width - _paddingLeft - _paddingRight;
			var scrollRectHeight: int = height - _paddingBottom - _paddingTop;
			if (_contentLayer.height > scrollRectHeight && scrollRectHeight > 1) {
				if (!_verticalScrollBar) {
					_verticalScrollBar = new ScrollBar(scene, 0, 0, 15, 15);
					_verticalScrollBar.addEventListener(ScrollBarEvent.TYPE_SCROLL, onVerticalScrollBarScroll);
					_verticalScrollBar.addEventListener(GameObjectEvent.TYPE_SIZE_CHANGED, onVerticalScrollSizeChanged);
				}
				scrollRectWidth -= _verticalScrollBar.width;
				if (!_view.contains('verticalScroll')) {
					_view.addDisplayObject(_verticalScrollBar, 'verticalScroll', VISUAL_DISPLAY_OBJECT_Z_ORDER);
				}
				_verticalScrollBar.x = _paddingLeft + scrollRectWidth;
				_verticalScrollBar.y = _paddingTop;
				_verticalScrollBar.height = scrollRectHeight;
				if (_contentLayer.width > scrollRectWidth && _horizontalScrollBar) {
					_verticalScrollBar.height -= _horizontalScrollBar.height;
				}
			}
			else {
				_view.removeDisplayObject('verticalScroll');
			}
			if (_contentLayer.width > scrollRectWidth && scrollRectWidth > 1) {
				if (!_horizontalScrollBar) {
					_horizontalScrollBar = new ScrollBar(scene, 0, 0, 15, 15, ScrollBar.TYPE_HORIZONTAL);
					_horizontalScrollBar.addEventListener(ScrollBarEvent.TYPE_SCROLL, onHorizontalScrollBarScroll);
					_horizontalScrollBar.addEventListener(GameObjectEvent.TYPE_SIZE_CHANGED, onHorizontalScrollSizeChanged);
				}
				scrollRectHeight -= _horizontalScrollBar.height;
				if (!_view.contains('horizontalScroll')) {
					_view.addDisplayObject(_horizontalScrollBar, 'horizontalScroll', VISUAL_DISPLAY_OBJECT_Z_ORDER);
				}
				_horizontalScrollBar.x = _paddingLeft;
				_horizontalScrollBar.y = _paddingTop + scrollRectHeight;
				_horizontalScrollBar.width = scrollRectWidth;
//				if (_contentLayer.height > scrollRectHeight) {
//					_horizontalScrollBar.width -= 15;
//				}
			}
			else {
				_view.removeDisplayObject('horizontalScroll');
			}
			_contentLayer.scrollRect = new Rectangle(0, 0, scrollRectWidth, scrollRectHeight);
			_contentLayer.verticalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
			_contentLayer.horizontalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
		}
		
		private function onContentLayerScroll(event: GameLayerEvent): void {
			if (_verticalScrollBar) {
				_verticalScrollBar.position = event.verticalPosition;
			}
			if (_horizontalScrollBar) {
				_horizontalScrollBar.position = event.horizontalPosition;
			}
		}
		
		private function onVerticalScrollBarScroll(event: ScrollBarEvent): void {
			_contentLayer.verticalPosition = event.position;
		}
		
		private function onHorizontalScrollBarScroll(event: ScrollBarEvent): void {
			_contentLayer.horizontalPosition = event.position;
		}
		
		/*
			TODO можно объединить код из onVerticalScrollSizeChanged и onHorizontalScrollSizeChanged
		*/
		private function onVerticalScrollSizeChanged(event: GameObjectEvent): void {
			var scrollRectWidth: int = width - _paddingLeft - _paddingRight;
			var scrollRectHeight: int = height - _paddingBottom - _paddingTop;
			if (_view.contains('verticalScroll') && _contentLayer.width > scrollRectWidth) {
				scrollRectWidth -= _verticalScrollBar.width;
				_verticalScrollBar.x = _paddingLeft + scrollRectWidth;
				if (_horizontalScrollBar) {
					_horizontalScrollBar.width = scrollRectWidth;
				}
			}
			if (_view.contains('horizontalScroll') && _contentLayer.height > scrollRectHeight) {
				scrollRectHeight -= _horizontalScrollBar.height;
				_horizontalScrollBar.y = _paddingTop + scrollRectHeight;
				if (_verticalScrollBar) {
					_verticalScrollBar.height = scrollRectHeight;
				}
			}
			_contentLayer.scrollRect = new Rectangle(0, 0, scrollRectWidth, scrollRectHeight);
		}
		
		private function onHorizontalScrollSizeChanged(event: GameObjectEvent): void {
			var scrollRectWidth: int = width - _paddingLeft - _paddingRight;
			var scrollRectHeight: int = height - _paddingBottom - _paddingTop;
			if (_view.contains('verticalScroll') && _contentLayer.width > scrollRectWidth) {
				scrollRectWidth -= _verticalScrollBar.width;
				_verticalScrollBar.x = _paddingLeft + scrollRectWidth;
				if (_horizontalScrollBar) {
					_horizontalScrollBar.width = scrollRectWidth;
				}
			}
			if (_view.contains('horizontalScroll') && _contentLayer.height > scrollRectHeight) {
				scrollRectHeight -= _horizontalScrollBar.height;
				_horizontalScrollBar.y = _paddingTop + scrollRectHeight;
				if (_verticalScrollBar) {
					_verticalScrollBar.height = scrollRectHeight;
				}
			}
			_contentLayer.scrollRect = new Rectangle(0, 0, scrollRectWidth, scrollRectHeight);
		}
		
		public function refresh():void {
		}
		
		public function show():void {
		}
	}
}