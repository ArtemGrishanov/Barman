package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Wipe extends Action
	{
		public static const WIPE_LEFT: String = 'wipe_left';
		public static const WIPE_RIGHT: String = 'wipe_right';
		public static const WIPE_UP: String = 'wipe_up';
		public static const WIPE_DOWN: String = 'wipe_down';
		
		private var _direction: String;
		private var _startDistance: Number;
		private var _distance: Number;
		private var _curDistance: Number;
		private var _step: Number;
		private var _mask: Sprite;
		
		public function Wipe(scene:GameScene, name:String, dispObject:DisplayObject, direction:String = WIPE_RIGHT)
		{
			super(scene, name, dispObject);
			_direction = direction;
			_mask = new Sprite();
			switch (_direction) {
				case WIPE_LEFT:
					_distance = -_dispObject.width;
					_startDistance = _dispObject.width;
				break;
				case WIPE_RIGHT:
					_distance = _dispObject.width;
					_startDistance = -_dispObject.width;
				break;
				case WIPE_UP:
					_distance = -_dispObject.height;
					_startDistance = _dispObject.height;
				break;
				case WIPE_DOWN:
					_distance = _dispObject.height;
					_startDistance = -_dispObject.height;
				break;
			}
		}
		
		public function setDistance(startDistance: Number, distance: Number): void {
			_startDistance = startDistance;
			_distance = distance;
		}
		
		public function start(): void {
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0, 0, _dispObject.width, _dispObject.height);
			_mask.graphics.endFill();
			switch (_direction) {
				case WIPE_LEFT:
					_mask.x = _startDistance;
					_mask.y = 0;
				break;
				case WIPE_RIGHT:
					_mask.x = -_startDistance;
					_mask.y = 0;
				break;
				case WIPE_UP:
					_mask.x = 0;
					_mask.y = _startDistance;
				break;
				case WIPE_DOWN:
					_mask.x = 0;
					_mask.y = -_startDistance;
				break;
			}
			if (!(_dispObject as GameObject).contains(_mask)) {
				(_dispObject as GameObject).addChild(_mask);
			}
			_curDistance = 0;
			_step = _distance / (duration * _scene.realTps / 1000);
			_startAction();
		}
		
		public function stop(): void {
			super._stopAction();
		}
		
		protected override function onTick(event: GameSceneEvent): void {
			super.onTick(event);
			switch (_state) {
				case STATE_STOPPED:
				break;
				case STATE_STARTED:
					switch (_direction) {
						case WIPE_LEFT:
							_mask.x += _step;
						break;
						case WIPE_RIGHT:
							_mask.x += _step;
						break;
						case WIPE_UP:
							_mask.y += _step;
						break;
						case WIPE_DOWN:
							_mask.y += _step;
						break;
					}
					_curDistance += _step;
					if ((_distance >= 0 && _curDistance >= _distance) || (_distance < 0 && _curDistance <= _distance)) {
						_endAction();
					}
					else {
						_dispObject.mask = _mask;
					}
				break;
				case STATE_PAUSED:
				break;
			}
		}
		
	}
}