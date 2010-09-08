package com.flashmedia.basics
{
	import flash.events.Event;

	public class GameObjectEvent extends Event
	{
		public static const TYPE_SIZE_CHANGED: String = 'type_size_changed';
		public static const TYPE_KEY_DOWN: String = 'type_key_down';
		public static const TYPE_KEY_UP: String = 'type_key_up';
//		public static const TYPE_MOUSE_HOVER: String = 'type_mouse_hover';
		public static const TYPE_MOUSE_CLICK: String = 'type_mouse_click';
		public static const TYPE_MOUSE_DOWN: String = 'type_mouse_down';
		public static const TYPE_MOUSE_UP: String = 'type_mouse_up';
		public static const TYPE_MOUSE_DOUBLECLICK: String = 'type_mouse_doubleclick';
		public static const TYPE_MOUSE_MOVE: String = 'type_mouse_move';
		public static const TYPE_SET_FOCUS: String = 'type_set_focus';
		public static const TYPE_LOST_FOCUS: String = 'type_lost_focus';
		public static const TYPE_SET_HOVER: String = 'type_set_hover';
		public static const TYPE_LOST_HOVER: String = 'type_lost_hover';
		public static const TYPE_ANIMATION_STARTED: String = 'type_animation_started';
		public static const TYPE_ANIMATION_COMPLETED: String = 'type_animation_completed';
		public static const TYPE_DRAG_STARTED: String = 'type_drag_started';
		public static const TYPE_DRAGGING: String = 'type_dragging';
		public static const TYPE_DRAG_STOPPED: String = 'type_drag_stopped';
		
		private var _gameObject: GameObject;
		private var _keyCode: uint;
		private var _localMouseX: int;
		private var _localMouseY: int;
		
		public function GameObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get gameObject(): GameObject {
			return _gameObject;
		}
		
		public function set gameObject(value: GameObject): void {
			_gameObject = value;
		}
		
		public function get keyCode(): uint {
			return _keyCode;
		}
		
		public function set keyCode(value: uint): void {
			_keyCode = value;
		}
		
		/**
		 * Локальная координата мыши X
		 */
		public function get localMouseX(): int {
			return _localMouseX;
		}
		
		/**
		 * Локальная координата мыши X
		 */
		public function set localMouseX(value: int): void {
			_localMouseX = value;
		}
		
		/**
		 * Локальная координата мыши Y
		 */
		public function get localMouseY(): int {
			return _localMouseY;
		}
		
		/**
		 * Локальная координата мыши Y
		 */
		public function set localMouseY(value: int): void {
			_localMouseY = value;
		}
	}
}