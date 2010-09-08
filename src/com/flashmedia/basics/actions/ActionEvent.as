package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameObject;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class ActionEvent extends Event
	{
		/**
		 * Возникает при паузе в выполнении Action
		 */
		public static const TYPE_PAUSED: String = 'type_paused';
		/**
		 * Возникает при старте Action
		 */
		public static const TYPE_STARTED: String = 'type_started';
//		/**
//		 * Возникает при старте каждой итерации Action.
//		 * Итераций может быть одна, а может и много (зацикливание)
//		 */
//		public static const TYPE_ITERATION_STARTED: String = 'type_iteration_started';
//		/**
//		 * Возникает в конце каждой итерации Action
//		 */
//		public static const TYPE_ITERATION_ENDED: String = 'type_iteration_ended';
		/**
		 * Возникает при полном завершении Action
		 */
		public static const TYPE_ENDED: String = 'type_ended';
		
		private var _dispObject: DisplayObject;
		
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get dispObject(): DisplayObject {
			return _dispObject;
		}
		
		public function set dispObject(value: DisplayObject): void {
			_dispObject = value;
		}
	}
}