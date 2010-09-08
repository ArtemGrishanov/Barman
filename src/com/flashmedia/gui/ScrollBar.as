package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ScrollBar extends GameObject
	{
		public static const TYPE_VERTICAL: String = 'type_vertical';
		public static const TYPE_HORIZONTAL: String = 'type_horizontal';
		public static const VIEW_TOP_ICON: int = 2;
		public static const VIEW_BOTTOM_ICON: int = 4;
		public static const VIEW_BACKGROUND: int = 8;
		public static const VIEW_ALL: int = 16;
		
		private var _topIcon: Sprite;
		private var _bottomIcon: Sprite;
		private var _scrollImage: Sprite;
		private var _backImage: Sprite;
		private var _position: Number;
		private var _scrollType: String;
		private var _isActive: Boolean;
		private var _viewImagesPolicy: int;
		private var _draggingScroll: Boolean;
		private var _scrollStep: Number;
		
		private var _backColor: int;
		private var _backAlpha: Number;
		private var _backCornersRadius: uint;
		
		private var _scrollColor: int;
		private var _scrollAlpha: Number;
		private var _scrollCornersRadius: uint;
		private var _scrollThickness: uint;
		
		public function ScrollBar(value: GameScene, x: int, y: int, width: int, height: int, scrollType: String = TYPE_VERTICAL, isActive: Boolean = true, viewImagesPolicy: int = VIEW_ALL)
		{
			super(value);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			//setSelect(true);
			_position = 0;
			_scrollType = scrollType;
			_viewImagesPolicy = viewImagesPolicy;
			_isActive = isActive;
			_draggingScroll = false;
			_scrollStep = 0.1;
			_backColor = undefined;
			_backAlpha = undefined;
			_backCornersRadius = undefined;
			_scrollColor = undefined;
			_scrollAlpha = undefined;
			_scrollCornersRadius = undefined;
			_scrollThickness = undefined;
			update();
		}
		
		//TODO эффективное задание интерфейса бара 
		
		public function set active(value: Boolean): void {
			_isActive = value;
			update();
		}
		
		public function set viewImagesPolicy(value: int): void {
			_viewImagesPolicy = value;
			update();
		}
		
		public override function set height(value: Number): void {
			super.height = value;
			update();
		}
		
		public override function set width(value: Number): void {
			super.width = value;
			update();
		}
		
		public function set scrollStep(value: Number): void {
			_scrollStep = value;
		}
		
		public function set position(value: Number): void {
			if (value > 1.0) {
				value = 1.0;
			}
			else if (value < 0) {
				value = 0;
			}
			if (value != _position) {
				_position = value;
				update();
				var event: ScrollBarEvent = new ScrollBarEvent(ScrollBarEvent.TYPE_SCROLL);
				event.position = position;
				dispatchEvent(event);
			}
		}
		
		public function get position(): Number {
			return _position;
		}
		
		public function set topIcon(value: Bitmap): void {
			if (_topIcon) {
				_topIcon.removeEventListener(MouseEvent.MOUSE_DOWN, onTopIconMouseDown);
			}
			_view.removeDisplayObject('topIcon');
			if (value) {
				_topIcon = new Sprite();
				_topIcon.addChild(value);
			}
			update();
		}
		
		public function set bottomIcon(value: Bitmap): void {
			if (_bottomIcon) {
				_bottomIcon.removeEventListener(MouseEvent.MOUSE_DOWN, onBottomIconMouseDown);
			}
			_view.removeDisplayObject('bottomIcon');
			if (value) {
				_bottomIcon = new Sprite();
				_bottomIcon.addChild(value);
			}
			update();
		}
		
		public function setBackStyle(color: int, alpha: Number = 1.0, cornersRadius: uint = 0): void {
			_backColor = color;
			_backAlpha = alpha;
			_backCornersRadius = cornersRadius;
			update();
		}
		
		public function setScrollStyle(color: int, alpha: Number = 1.0, cornersRadius: uint = 0, thickness: uint = undefined): void {
			_scrollColor = color;
			_scrollAlpha = alpha;
			_scrollCornersRadius = cornersRadius;
			if (thickness) {
				_scrollThickness = thickness;
			}
			else {
				_scrollThickness = width;
			}
			update();
		}
		
		private function update(): void {
			_backImage = null;
			_view.removeDisplayObject('back');
			if ((_viewImagesPolicy & VIEW_BACKGROUND) == VIEW_BACKGROUND || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				_backImage = getBackground();
				_view.addDisplayObject(_backImage, 'back', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER - 1);
			}
			if ((_viewImagesPolicy & VIEW_TOP_ICON) == VIEW_TOP_ICON || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				if (!_topIcon) {
					_topIcon = getStandartIcon();
				}
				if (!_view.contains('topIcon')) {
					_view.addDisplayObject(_topIcon, 'topIcon', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_TOP | View.ALIGN_HOR_LEFT);
				}
				if (_isActive && !_topIcon.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_topIcon.addEventListener(MouseEvent.MOUSE_DOWN, onTopIconMouseDown);
				}
				if (!_isActive && _topIcon.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_topIcon.removeEventListener(MouseEvent.MOUSE_DOWN, onTopIconMouseDown);
				}
			}
			else {
				_topIcon = null;
				_view.removeDisplayObject('topIcon');
			}
			if ((_viewImagesPolicy & VIEW_BOTTOM_ICON) == VIEW_BOTTOM_ICON || (_viewImagesPolicy & VIEW_ALL) == VIEW_ALL) {
				if (!_bottomIcon) {
					_bottomIcon = getStandartIcon();
				}
				if (!_view.contains('bottomIcon')) {
					_view.addDisplayObject(_bottomIcon, 'bottomIcon', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER, View.ALIGN_VER_BOTTOM | View.ALIGN_HOR_RIGHT);
				}
				if (_isActive && !_bottomIcon.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_bottomIcon.addEventListener(MouseEvent.MOUSE_DOWN, onBottomIconMouseDown);
				}
				if (!_isActive && _bottomIcon.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					_bottomIcon.removeEventListener(MouseEvent.MOUSE_DOWN, onBottomIconMouseDown);
				}
			}
			else {
				_bottomIcon = null;
				_view.removeDisplayObject('bottomIcon');
			}
			if (!_scrollImage) {
				_scrollImage = new Sprite();
				_scrollImage.tabEnabled = true;
				_view.addDisplayObject(_scrollImage, 'scroll', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
			}
			if (_isActive && !_scrollImage.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				_scrollImage.addEventListener(MouseEvent.MOUSE_DOWN, onScrollImageMouseDown);
				_scrollImage.addEventListener(MouseEvent.MOUSE_MOVE, onScrollImageMouseMove);
				_scrollImage.addEventListener(MouseEvent.MOUSE_UP, onScrollImageMouseUp);
			}
			if (!_isActive && _scrollImage.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				_scrollImage.removeEventListener(MouseEvent.MOUSE_DOWN, onScrollImageMouseDown);
				_scrollImage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrollImageMouseMove);
				_scrollImage.removeEventListener(MouseEvent.MOUSE_UP, onScrollImageMouseUp);
			}
			_scrollImage.graphics.clear();
			_scrollImage.graphics.beginFill((_scrollColor) ? _scrollColor: 0xff0000, (_scrollAlpha) ? _scrollAlpha: GameObject.FOCUS_ALPHA);
			var r: Number = (_scrollCornersRadius) ? _scrollCornersRadius : 0;
			if (_scrollType == TYPE_HORIZONTAL) {
				_scrollImage.graphics.drawRoundRect(0, (_scrollThickness) ? ((height - _scrollThickness) / 2) : 0, width / 5, (_scrollThickness) ? _scrollThickness : height, r, r);
				_scrollImage.x = ((_topIcon) ? _topIcon.width : 0) + getScrollAreaLength() * _position;
			}
			else {
				_scrollImage.graphics.drawRoundRect((_scrollThickness) ? ((width - _scrollThickness) / 2) : 0, 0, (_scrollThickness) ? _scrollThickness : width, height / 5, r, r);
				_scrollImage.y = ((_topIcon) ? _topIcon.height : 0) + getScrollAreaLength() * _position;
			}
			_scrollImage.graphics.endFill();
		}
		
		private function getScrollAreaLength(): uint {
			var result: int = 0;
			if (_scrollType == TYPE_HORIZONTAL) {
				result = width - 
					((_topIcon) ? _topIcon.width : 0 ) - 
					((_bottomIcon) ? _bottomIcon.width : 0 ) -
					((_scrollImage) ? _scrollImage.width : 0 );
			}
			else {
				result = height - 
					((_topIcon) ? _topIcon.height : 0 ) - 
					((_bottomIcon) ? _bottomIcon.height : 0 ) -
					((_scrollImage) ? _scrollImage.height : 0 );
			}
			return result;
		}
		
		private function onTopIconMouseDown(event: MouseEvent): void {
			position -= _scrollStep;
		}
		
		private function onBottomIconMouseDown(event: MouseEvent): void {
			position += _scrollStep;
		}
		
		private function onScrollImageMouseDown(event: MouseEvent): void {
			_draggingScroll = true;
		}
		
		private function onScrollImageMouseMove(event: MouseEvent): void {
//			if (_draggingScroll) {
//				if (event.localY >= _topIcon.height && event.localY <= (height - _bottomIcon.height)) {
//					_scrollImage.y = event.localY;
//				}
//				 _position = (_scrollImage.y - _topIcon.height) / getScrollAreaHeight(); 
//				//TODO событие onScroll
//				
//			}
		}
		
		private function onScrollImageMouseUp(event: MouseEvent): void {
			_draggingScroll = false;
		}
		
		private function getStandartIcon(): Sprite {
			var s: Sprite = new Sprite();
			s.tabEnabled = true;
			s.graphics.beginFill(FOCUS_COLOR);
			if (_scrollType == TYPE_HORIZONTAL) {
				s.graphics.drawRect(0, 0, height, height);
			}
			else {
				s.graphics.drawRect(0, 0, width, width);
			}
			s.graphics.endFill();
			return s;
		}
		
		private function getBackground(): Sprite {
			var s: Sprite = new Sprite();
			if (_backColor) {
				s.graphics.beginFill(_backColor, (_backAlpha) ? _backAlpha : 1.0);
			}
			else {
				s.graphics.beginFill(GameObject.HOVER_COLOR, GameObject.HOVER_ALPHA);
			}
			var r: Number = (_backCornersRadius) ? _backCornersRadius : 0;
			s.graphics.drawRoundRect(0, 0, width, height, r, r);
			s.graphics.endFill();
			return s;
		}
		
//		private function getStandartScroll(): Sprite {
//			var s: Sprite = new Sprite();
//			s.tabEnabled = true;
//			s.graphics.beginFill(GameObject.FOCUS_COLOR, GameObject.FOCUS_ALPHA);
//			s.graphics.drawRect(0, 0, width, height / 5);
//			s.graphics.endFill();
//			return s;
//		}
	}
}