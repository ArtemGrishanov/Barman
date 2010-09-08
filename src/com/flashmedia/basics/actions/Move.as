package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Перемещение GameObject на заданную дистанцию
	 */
	public class Move extends Action {
		
		public static const MOVE_INSTANTLY: uint = 1;
		public static const MOVE_BY_TIME: uint = 2;
		public static const MOVE_ON_DISTANCE: uint = 3;
		public static const MOVE_TO_POINT: uint = 4;

		private var _moveType: uint;
		private var _point: Point;
		private var _distance: Number;
		private var _cos: Number;
		private var _sin: Number;
		private var _dX: Number;
		private var _dY: Number;
		private var _speed: Number;
		
		public function Move(scene:GameScene, name:String, dispObject:DisplayObject, moveType: uint = MOVE_INSTANTLY)
		{
			super(scene, name, dispObject);
			_moveType = moveType;
		}
		
		public function start(): void {
			_startAction();
		}
		
		public function stop(): void {
			_stopAction();
		}
		
		/**
		 * Скорость перемещения.
		 * Пикселей/тик
		 */
		public function set speed(value: Number): void {
			_speed = value;
		}
		
		public function set point(value: Point): void {
			_point = value;
			_distance = Math.sqrt(Math.pow(_point.y - _dispObject.y, 2) + Math.pow(_point.x - _dispObject.x, 2));
			_cos = (_point.x - _dispObject.x) / _distance;
			_sin = (_point.y - _dispObject.y) / _distance;
		}
		
		public function get distance(): Number {
			return _distance;
		}
		
		protected override function _startAction(iterationsCount: int = 1): void {
			super._startAction(iterationsCount);
		}
		
		protected override function onTick(event: GameSceneEvent): void {
			super.onTick(event);
			switch (_state) {
				case STATE_STOPPED:
				break;
				case STATE_STARTED:
					trace('move action started');
					switch (_moveType) {
						case MOVE_INSTANTLY:
							//todo
						break;
						case MOVE_BY_TIME:
							//todo
						break;
						case MOVE_TO_POINT:
//							_dispObject
//							_point
//							_speed
//							var xDir: int = (_point.x >= _dispObject.x) ? 1: -1;
//							var yDir: int = (_point.y >= _dispObject.y) ? 1: -1;
//							trace('x:' + _dispObject.x.toFixed(0) + ' point:' + _point.x.toFixed(0) + ' cos:' + _cos);
//							trace('y:' + _dispObject.y.toFixed(0) + ' point:' + _point.y.toFixed(0) + ' cos:' + _sin);
							if (_dispObject.x.toFixed(0) == _point.x.toFixed(0) && _dispObject.y.toFixed(0) == _point.y.toFixed(0)) {
								trace('END POINT...');
								super._endAction();
								break;
							}
							_dispObject.x += _speed * _cos;
							_dispObject.y += _speed * _sin;
							if ((_dispObject.x > _point.x && _cos >= 0) || (_dispObject.x < _point.x && _cos < 0)) {
								_dispObject.x = _point.x;
							}
							if ((_dispObject.y > _point.y && _sin >= 0) || (_dispObject.y < _point.y && _sin < 0)) {
								_dispObject.y = _point.y;
							}
						break;
						case MOVE_ON_DISTANCE:
							//todo
						break;
					}
				break;
				case STATE_PAUSED:
				break;
		}
	}
}
}