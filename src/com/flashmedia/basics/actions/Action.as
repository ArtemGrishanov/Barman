package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	public class Action extends EventDispatcher
	{
		public const STATE_STOPPED: uint = 10;
		public const STATE_STARTED: uint = 11;
		public const STATE_PAUSED: uint = 12;
		public const DURATION: uint = 1000;
		
		protected var _scene: GameScene;
		protected var _name: String;
		protected var _dispObject: DisplayObject;
		protected var _state: uint;
		protected var _repeatCount: int;
		protected var _curIteration: int;
		/**
		 * Длительность в миллисекундах
		 */
		protected var _duration: uint;
		protected var _curDuration: Number;
		protected var _lastTickTimeStamp: Number;
		
		public function Action(scene: GameScene, name:String, dispObject: DisplayObject)
		{
			_scene = scene;
			_name = name;
			_dispObject = dispObject;
			_repeatCount = 1;
			_curIteration = 0;
			_state = STATE_STOPPED;
			_duration = DURATION;
			_curDuration = 0;
			_scene.addEventListener(GameSceneEvent.TYPE_TICK, onTick);
		}
		
		public function get nameAction(): String {
			return _name;
		}
		
		/**
		 * duration - миллисекунды
		 */
		public function set duration(value: uint): void {
			_duration = value;
		}
		
		public function get duration(): uint {
			return _duration;
		}
		
		public function get isActive(): Boolean {
			return _state == STATE_STARTED;
		}
		
		public function get isStopped(): Boolean {
			return _state == STATE_STOPPED;
		}
		
		public function get isPaused(): Boolean {
			return _state == STATE_PAUSED;
		}
		
		protected function _startAction(repeatCount: int = 1): void {
			switch (_state) {
				case STATE_STARTED:
				case STATE_PAUSED:
					_stopAction();
				break;
				case STATE_STOPPED:
				
				break;
			}
			_repeatCount = repeatCount;
			if (_repeatCount != 0) {
				_curDuration = 0;
				_lastTickTimeStamp = -1;
				_state = STATE_STARTED;
			}
			var event: ActionEvent = new ActionEvent(ActionEvent.TYPE_STARTED);
			event.dispObject = _dispObject;
			dispatchEvent(event);
		}
		
		protected function _pauseAction(): void {
			_state = STATE_PAUSED;
			var event: ActionEvent = new ActionEvent(ActionEvent.TYPE_PAUSED);
			event.dispObject = _dispObject;
			dispatchEvent(event);
		}
		
		protected function _stopAction(): void {
			_curIteration = 0;
			_state = STATE_STOPPED;
			var event: ActionEvent = new ActionEvent(ActionEvent.TYPE_ENDED);
			event.dispObject = _dispObject;
			dispatchEvent(event);
		}
		
		protected function _endAction(): void {
			_curDuration = 0;
			if (_repeatCount < 0 || _curIteration < (_repeatCount - 1)) {
				_curIteration++;
				_lastTickTimeStamp = -1;
				_state = STATE_STARTED;
			}
			else {
				_stopAction();
			}
			//todo dispaltch
		}
		
		protected function onTick(event: GameSceneEvent): void {
			var nowTime: Number = new Date().getTime();
			if (_lastTickTimeStamp == -1) {
				_lastTickTimeStamp = nowTime;
			}
			switch (_state) {
				case STATE_STOPPED:
				break;
				case STATE_STARTED:
					_curDuration += (nowTime - _lastTickTimeStamp);
					if (_curDuration >= duration) {
						_endAction();
					}
				break;
				case STATE_PAUSED:
				
				break;
			}
			_lastTickTimeStamp = nowTime;
		}
		
		//		protected function _stopIterationIntervalAction(): void {
//			//todo dispatch
//			if (_curIteration < (_iterationsCount - 1)) {
//				_curIteration++;
//				_startIterationIntervalAction();
//			}
//			else {
//				_stopIntervalAction();
//			}
//		}
//		
	}
}