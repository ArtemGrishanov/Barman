package com.flashmedia.basics
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/*
		TODO добавить свойство - selectable - обрабатывает ли спрайт сам действие пользователя, или передает дальше.
		//TODO метод прослойку в GameObject чтобы скрыть класс View	
		//TODO стандартные спрайты - специальное своййство, чтобы их отличать
		//TODO explicitWidth explicitHeight
	*/
	/**
	 * При клике на один из частей View, реакция передается в gameObject для обработки.
	 */
	public final class View
	{
		public static const ALIGN_HOR_NONE: int = 0;
		public static const ALIGN_HOR_LEFT: int = 1;
		public static const ALIGN_HOR_CENTER: int = 2;
		public static const ALIGN_HOR_RIGHT: int = 4;
		public static const ALIGN_VER_NONE: int = 0;
		public static const ALIGN_VER_TOP: int = 8;
		public static const ALIGN_VER_CENTER: int = 16;
		public static const ALIGN_VER_BOTTOM: int = 32;
		
		private var _gameObject: GameObject;
		private var _visuals: Array;
		private var _mainDisplayObject: DisplayObject;
		
		public function View(value: GameObject)
		{
			_gameObject = value;
			_visuals = new Array();
		}
		
		public function contains(value: String): Boolean {
			return getVisualByName(value) != null;
		}

		//TODO layoutObjectName не всегда корректно работает, пока не использовать.
		public function addDisplayObject(value: DisplayObject, name: String, zOrder: int = 1, layoutMode: int = 0, layoutObjectName: String = '', isMain: Boolean = false): void {
			var o: Object = new Object();
			o['name'] = name;
			o['zOrder'] = zOrder;
			o['displayObject'] = value;
			o['layoutMode'] = layoutMode;
			o['layoutObjectName'] = layoutObjectName;
			if (isMain) {
				_mainDisplayObject = value;
			}
			for (var i: uint = 0; i < _visuals.length; i++) {
				if (_visuals[i]['zOrder'] > zOrder) {
					_visuals.splice(i, 0, o);
					//TODO пересчет каждый раз
					layoutVisuals();
					_gameObject.addChildAt(value, i);
					return;
				}
			}
			_visuals.push(o);
			//TODO пересчет каждый раз
			layoutVisuals();
			_gameObject.addChild(value);
		}
		
		public function removeDisplayObject(value: String): void {
			for (var i: uint = 0; i < _visuals.length; i++) {
				if (_visuals[i]['name'] == value) {
					var d: DisplayObject = _visuals[i]['displayObject'] as DisplayObject
					if (_gameObject.contains(d)) {
						_gameObject.removeChild(d);
					}
					_visuals.splice(i, 1);
					break;
				}
			}
		}
		
		public function setDisplayObjectZOrder(name: String, zOrder: int): void {
			var o: Object = getVisualByName(name);
			if (o) {
				o['zOrder'] = zOrder;
				sortVisuals();
			}
		}
		
		public function setDisplayObjectLayout(name: String, layoutMode: int): void {
			var o: Object = getVisualByName(name);
			if (o) {
				o['layoutMode'] = layoutMode;
				layoutVisuals();
			}
		}
		
		private function getVisualByName(value: String): Object {
			for each (var o: Object in _visuals) {
				if (o['name'] == value) {
					return o;
				}
			}
			return null;
		}
		
		public function sortVisuals(): void {
			_visuals.sortOn('zOrder', Array.NUMERIC);
			for each (var o: Object in _visuals) {
				_gameObject.addChild(o['displayObject'] as DisplayObject);
			}
		}
		
		private function layoutVisualByName(value: String = ''): void {
			var o: Object = getVisualByName(value);
			if (o) {
				var displayObject: DisplayObject = o['displayObject'];
				var s: Object = getVisualByName(o['layoutObjectName']);
				var layoutObject: DisplayObject = s ? s['displayObject'] : _mainDisplayObject;
				var layoutMode: int = o['layoutMode'] as int;
				if ((layoutMode & ALIGN_HOR_LEFT) == ALIGN_HOR_LEFT) {
					displayObject.x = layoutObject.x;
				}
				else if ((layoutMode & ALIGN_HOR_CENTER) == ALIGN_HOR_CENTER) {
					displayObject.x = (layoutObject.width - displayObject.width) / 2;
				}
				else if ((layoutMode & ALIGN_HOR_RIGHT) == ALIGN_HOR_RIGHT) {
					displayObject.x = layoutObject.x + layoutObject.width - displayObject.width;
				}
				if ((layoutMode & ALIGN_VER_TOP) == ALIGN_VER_TOP) {
					displayObject.y = layoutObject.y;
				}
				else if ((layoutMode & ALIGN_VER_CENTER) == ALIGN_VER_CENTER) {
					displayObject.y = (layoutObject.height - displayObject.height) / 2;
				}
				else if ((layoutMode & ALIGN_VER_BOTTOM) == ALIGN_VER_BOTTOM) {
					displayObject.y = layoutObject.y + layoutObject.height - displayObject.height;
				}
			}
		}
		
		public function layoutVisuals(): void {
			for each (var o: Object in _visuals) {
				layoutVisualByName(o['name']);
			}
		}
		
//		private function onMouseClick(event: MouseEvent): void {
//			_gameObject.
//		}
	}
}