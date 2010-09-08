package com.flashmedia.basics
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	//TODO возможно потребуется кроп слоя по краям
	public class GameLayer extends GameObject
	{
		public static const SCROLL_POLICY_NONE: String = 'scroll_policy_none';
		public static const SCROLL_POLICY_AUTO: String = 'scroll_policy_auto';
		public static const SCROLL_STEP: uint = 10;
		
		public static const SIZE_MODE_ABSOLUTE: int = 0;
		public static const SIZE_MODE_WIDTH_BY_CONTENT: int = 2;
		public static const SIZE_MODE_HEIGHT_BY_CONTENT: int = 4;
		
		protected static const MIN_SCROLL_SPEED: Number = 2;
		
		protected var _horizontalScrollPolicy: String;
		protected var _verticalScrollPolicy: String;
		protected var _horizontalScrollStep: uint;
		protected var _verticalScrollStep: uint;
		protected var _smoothScroll: Number;
		protected var _topScrollIndent: Number;
		protected var _leftScrollIndent: Number;
		protected var _rightScrollIndent: Number;
		protected var _bottomScrollIndent: Number;
		protected var _sizeMode: int;
		protected var _deltaX: Number = 0;
		protected var _deltaY: Number = 0;
		
		public function GameLayer(value: GameScene)
		{
			super(value);
//			_cropBySize = true;
			_type = 'GameLayer';
			_horizontalScrollPolicy = SCROLL_POLICY_AUTO;
			_verticalScrollPolicy = SCROLL_POLICY_AUTO;
			_horizontalScrollStep = SCROLL_STEP;
			_verticalScrollStep = SCROLL_STEP;
			_smoothScroll = 0;
			_topScrollIndent = 0;
			_leftScrollIndent = 0;
			_rightScrollIndent = 0;
			_bottomScrollIndent = 0;
			_sizeMode = SIZE_MODE_ABSOLUTE;
			_scene.addEventListener(GameSceneEvent.TYPE_TICK, onTick);
		}
		
		public function getChildById(id: Number): GameObject {
			for (var i: int = 0; i < numChildren; i++) {
				var d: DisplayObject = getChildAt(i);
				if (d is GameLayer) {
					var res: GameObject = (d as GameLayer).getChildById(id);
					if (res) {
						return res;
					}
				}
				if (d is GameObject && (d as GameObject).id == id) {
					return (d as GameObject);
				}
			}
			return null;
		}
		
		/*
			Вообще правильно работать с _view. Там уже есть все необходимое
			Сортировку можно не дублировать.
			Однако нужно реализовать опреации с индексом во View, плюс неучитывать стандартные спрайты
		*/
		public override function addChild(child: DisplayObject): DisplayObject {
			super.addChild(child);
			if (child is GameObject) {
				(child as GameObject).setGameLayer(this);
				sortChildsByZ();
			}
			updateSize();
			return child;
		}
		
		public override function addChildAt(child: DisplayObject, index: int): DisplayObject {
			super.addChildAt(child, index);
			if (child is GameObject) {
				(child as GameObject).setGameLayer(this);
				sortChildsByZ();
			}
			updateSize();
			return child;
		}
		
		public override function removeChild(child: DisplayObject): DisplayObject {
			var d: DisplayObject = super.removeChild(child);
			updateSize();
			return d;
		}
		
		public override function removeChildAt(index: int): DisplayObject {
			var d: DisplayObject = super.removeChildAt(index);
			updateSize();
			return d;
		}
		
		public function set verticalScrollPolicy(value: String): void {
			_verticalScrollPolicy = value;
		}
		
		public function get verticalScrollPolicy(): String {
			return _verticalScrollPolicy;
		}
		
		public function set horizontalScrollPolicy(value: String): void {
			_horizontalScrollPolicy = value;
		}
		
		public function get horizontalScrollPolicy(): String {
			return _horizontalScrollPolicy;
		}
		
		public function set verticalScrollStep(value: uint): void {
			_verticalScrollStep = value;
		}
		
		public function get verticalScrollStep(): uint {
			return _verticalScrollStep;
		}
		
		public function set horizontalScrollStep(value: uint): void {
			_horizontalScrollStep = value;
		}
		
		public function get horizontalScrollStep(): uint {
			return _horizontalScrollStep;
		}
		
		public function set sizeMode(value: int): void {
			_sizeMode = value;
			updateSize();
		}
		
		public function get sizeMode(): int {
			return _sizeMode;
		}
		
		/**
		 * Плавность прокрутки. Значение (0.0 - 1.0)
		 * 0.0 - нет плавности, моментальная прокрутка.
		 * 1.0 - очень плавная (медленная) прокрутка.
		 */
		public function set smoothScroll(value: Number): void {
			//TODO реализация плавности - это уже анимация. Потом сделать.
			if (value > 1) {
				value = 1;
			}
			else if (value < 0) {
				value = 0;
			}
			_smoothScroll = value;
		}
		
		public function get smoothScroll(): Number {
			return _smoothScroll;
		}

		/**
		 * Установить допустимые отступы для прокрутки с каждой стороны.
		 */
		public function scrollIndents(topScrollIndent: Number, leftScrollIndent: Number, rightScrollIndent: Number, bottomScrollIndent: Number): void {
			_topScrollIndent = topScrollIndent;
			_leftScrollIndent = leftScrollIndent;
			_rightScrollIndent = rightScrollIndent;
			_bottomScrollIndent = bottomScrollIndent;
			scroll(_leftScrollIndent, _topScrollIndent);
		}
		
		/**
		 * Изменить координаты прямоугольника прокрутки. Мгновенно.
		 */
		private function changeScrollRectCoords(deltaX: Number, deltaY: Number): void {
			if (scrollRect) {
				var rect: Rectangle = scrollRect;
				rect.x += deltaX;
				rect.y += deltaY;
				if (rect.y < _topScrollIndent) {
					rect.y = _topScrollIndent;
				}
				if (_height > rect.height) {
					if (rect.y > _height - rect.height - _bottomScrollIndent) {
						rect.y = _height - rect.height - _bottomScrollIndent;
					}
				}
				else {
					if (rect.y > 0) {
						rect.y = 0;
					}
				}
				if (rect.x < _leftScrollIndent) {
					rect.x = _leftScrollIndent;
				}
				if (_width > rect.width) {
					if (rect.x > _width - rect.width - _rightScrollIndent) {
						rect.x = _width - rect.width - _rightScrollIndent;
					}
				}
				else {
					if (rect.x > 0) {
						rect.x = 0;
					}
				}
				if (scrollRect.x != rect.x || scrollRect.y != rect.y) {
					scrollRect = rect;
					var event: GameLayerEvent = new GameLayerEvent(GameLayerEvent.TYPE_SCROLL);
					event.gameObject = this;
					event.verticalPosition = verticalPosition;
					event.horizontalPosition = horizontalPosition;
					dispatchEvent(event);
				}
			}
		}
		
		/**
		 * Сделать один шаг в анимации прокрутки.
		 */
		
		private var sumDX: Number = 0;
		private function scrollAnim(): void {
			var dX: Number = _deltaX * (1 - _smoothScroll);
			var dY: Number = _deltaY * (1 - _smoothScroll);
			if (dX >= 0) {
				dX = (dX < MIN_SCROLL_SPEED) ? MIN_SCROLL_SPEED : dX;
			}
			else {
				dX = (-dX < MIN_SCROLL_SPEED) ? -MIN_SCROLL_SPEED : dX;
			}
			if (dY >= 0) {
				dY = (dY < MIN_SCROLL_SPEED) ? MIN_SCROLL_SPEED : dY;
			}
			else {
				dY = (-dY < MIN_SCROLL_SPEED) ? -MIN_SCROLL_SPEED : dY;
			}
			if (Math.abs(_deltaX) < MIN_SCROLL_SPEED) {
				dX = _deltaX;
			}
			if (Math.abs(_deltaY) < MIN_SCROLL_SPEED) {
				dY = _deltaY;
			}
			changeScrollRectCoords(dX, dY);
			sumDX += dX;
			_deltaX -= dX;
			_deltaY -= dY;
			if (_deltaX == 0) {
				trace('sumDX = ' + sumDX);				
			}
		}
		 
		/**
		 * Прокрутить слой на заданную величину
		 */
		public function scroll(deltaX: Number, deltaY: Number): void {
			sumDX = 0;
			if (_smoothScroll == 0.0) {
				changeScrollRectCoords(deltaX, deltaY);
			}
			else {
				_deltaX = deltaX;
				_deltaY = deltaY;
			}
		}
		
		protected function onTick(event: GameSceneEvent): void {
			if (_deltaX != 0 || _deltaY != 0) {
				scrollAnim();
			}
		}
		
		public function set verticalPosition(value: Number): void {
			if (scrollRect) {
				var y: int = value * (_height - _topScrollIndent - _bottomScrollIndent - scrollRect.height) + _topScrollIndent;
				scroll(0, y - scrollRect.y);
			}
		}
		
		public function get verticalPosition(): Number {
			if (scrollRect) {
				return (scrollRect.y - _topScrollIndent) / (_height - _topScrollIndent - _bottomScrollIndent - scrollRect.height);
			}
			return 0;
		}
		
		public function set horizontalPosition(value: Number): void {
			if (scrollRect) {
				var x: int = value * (_width - _leftScrollIndent - _rightScrollIndent - scrollRect.width) + _leftScrollIndent;
				scroll(x - scrollRect.x, 0);
			}
		}
		
		public function get horizontalPosition(): Number {
			if (scrollRect) {
				return (scrollRect.x - _leftScrollIndent) / (_width - _leftScrollIndent - _rightScrollIndent - scrollRect.width);
			}
			return 0;
		}

//		/**
//		 * Установить область прокрутки.
//		 * Размер области прокрутки не может быть больше самого слоя.
//		 */
//		public override function set scrollRect(value: Rectangle): void {
//			
//		}
		
		internal function sortChildsByZ(): void {
			var count: int = numChildren;
			var tempChilds: Array = new Array();
			for (var i: int = 0; i < count; i++) {
				if (getChildAt(i) is GameObject) {
					tempChilds.push(getChildAt(i) as GameObject);
				}
			}
			tempChilds.sortOn('zOrder', Array.NUMERIC);
			for (i = 0; i < tempChilds.length; i++) {
				super.addChild(tempChilds[i]);
			}
		}

		protected override function keyboardListener(event: KeyboardEvent): void {
			super.keyboardListener(event);
			if (_verticalScrollPolicy == GameLayer.SCROLL_POLICY_AUTO) {
				if (event.keyCode == Keyboard.UP) {
					scroll(0, -_verticalScrollStep);
				}
				else if (event.keyCode == Keyboard.DOWN) {
					scroll(0, _verticalScrollStep);
				}
			}
			if (_horizontalScrollPolicy == GameLayer.SCROLL_POLICY_AUTO) {
				if (event.keyCode == Keyboard.LEFT) {
					scroll(-_horizontalScrollStep, 0);
				}
				else if (event.keyCode == Keyboard.RIGHT) {
					scroll(_horizontalScrollStep, 0);
				}
			}
		}
		
		protected override function drawDebugInfo(): void {
			//TODO дописать функция, чтобы было видно scrollRect, top\left\right\bottom-Indent, positions
			super.drawDebugInfo();
		}
		
		/**
		 * Функция пересчета размеров слоя в зависимости от настройки sizeMode
		 * Хотя стандартный класс Sprite обладает способностью "следить" за изменением размеров на основе содержимого
		 * но в GameObject эта модель была специально перестроена, и размеры не засисят от содержимого
		 */
		private function updateSize(): void {
			if (_sizeMode != SIZE_MODE_ABSOLUTE) {
				//TODO требуется сбросить width height иначе сработает _borders - самый большой спрайт
				width = MIN_WIDTH;
				height = MIN_HEIGHT;
				var maxWidth: uint = 0;
				var maxHeight: uint = 0;
				for (var i: uint = 0; i < numChildren; i++) {
					var d: DisplayObject = getChildAt(i);
					//TODO стандартные спрайты мешают
					if (d == _debugContainer) {
						continue;
					}
					if ((d.x + d.width) > maxWidth) {
						maxWidth = d.x + d.width; 
					}
					if ((d.y + d.height) > maxHeight) {
						maxHeight = d.y + d.height; 
					}
				}
				if ((_sizeMode & SIZE_MODE_WIDTH_BY_CONTENT) == SIZE_MODE_WIDTH_BY_CONTENT) {
					width = maxWidth;
				}
				if ((_sizeMode & SIZE_MODE_HEIGHT_BY_CONTENT) == SIZE_MODE_HEIGHT_BY_CONTENT) {
					height = maxHeight;
				}
			}
		}
	}
}