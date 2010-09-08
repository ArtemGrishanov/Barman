package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.DisplayObject;

	public class Visible extends Action
	{
		public const FROM_ALPHA: Number = 0;
		public const TO_ALPHA: Number = 1;
		
		protected var _fromAlpha: Number;
		protected var _toAlpha: Number;
		protected var _alphaStep: Number;
		
		public function Visible(scene:GameScene, name:String, dispObject:DisplayObject)
		{
			super(scene, name, dispObject);
			_fromAlpha = FROM_ALPHA;
			_toAlpha = TO_ALPHA;
		}
		
		public function start(): void {
			_dispObject.alpha = _fromAlpha;
			_alphaStep = (_toAlpha - _fromAlpha) / (duration * _scene.realTps / 1000);
			_startAction();
		}
		
		public function stop(): void {
			_stopAction();
		}
		
		public function set fromAlpha(value: Number): void {
			_fromAlpha = value;
		}
		
		public function set toAlpha(value: Number): void {
			_toAlpha = value;
		}
		
		protected override function onTick(event: GameSceneEvent): void {
			super.onTick(event);
			switch (_state) {
				case STATE_STOPPED:
					if (_dispObject.alpha != _toAlpha) {
						_dispObject.alpha = _toAlpha;
					}
				break;
				case STATE_STARTED:
					_dispObject.alpha += _alphaStep;
				break;
				case STATE_PAUSED:
				break;
			}
		}
	}
}