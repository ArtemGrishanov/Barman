package com.flashmedia.basics
{
	import flash.events.Event;
	
	public class GameSceneEvent extends Event
	{
		public static const TYPE_TICK: String = 'type_tick';
		public static const TYPE_MOUSE_MOVE: String = 'type_mouse_move';
		public static const TYPE_MOUSE_CLICK: String = 'type_mouse_click';
		
		private var _scene: GameScene;
		private var _stageMouseX: int;
		private var _stageMouseY: int;
		
		public function GameSceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get scene(): GameScene {
			return _scene;
		}
		
		public function set scene(value: GameScene): void {
			_scene = value;
		}
		
		/**
		 * Глобальная координата мыши X
		 */
		public function get stageMouseX(): int {
			return _stageMouseX;
		}
		
		/**
		 * Глобальная координата мыши X
		 */
		public function set stageMouseX(value: int): void {
			_stageMouseX = value;
		}
		
		/**
		 * Глобальная координата мыши Y
		 */
		public function get stageMouseY(): int {
			return _stageMouseY;
		}
		
		/**
		 * Глобальная координата мыши Y
		 */
		public function set stageMouseY(value: int): void {
			_stageMouseY = value;
		}
	}
}