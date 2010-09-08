package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	public class Glow extends Action
	{
		public static const COLOR: Number = 0xffffff;
		public static const FROM_ALPHA: Number = 0;
		public static const TO_ALPHA: Number = 1;
		public static const BLUR_X: Number = 8;
		public static const BLUR_Y: Number = 8;
		public static const STRENGTH: Number = 2;
		
		private var _glowFilter: GlowFilter;
		private var _color: Number;
		private var _fromAlpha: Number;
		private var _toAlpha: Number;
		private var _alphaStep: Number;
		private var _blurX: Number;
		private var _blurY: Number;
		private var _strength: Number;
		
		public function Glow(scene:GameScene, name:String, dispObject:DisplayObject)
		{
			super(scene, name, dispObject);
			_color = COLOR;
			_fromAlpha = FROM_ALPHA;
			_toAlpha = TO_ALPHA;
			_blurX = BLUR_X;
			_blurY = BLUR_Y;
			_strength = STRENGTH;
		}
		
		public function start(): void {
			_glowFilter = new GlowFilter(_color, _fromAlpha, _blurX, _blurY, _strength, BitmapFilterQuality.HIGH, false, false);
			_dispObject.filters = [_glowFilter];
			_alphaStep = (_toAlpha - _fromAlpha) / (duration * _scene.realTps / 1000);
			_startAction();
		}
		
		public function stop(): void {
			super._stopAction();
		}
		
		public function set strength(value: Number): void {
			_strength = value;
		}
		
		public function set blurX(value: Number): void {
			_blurX = value;
		}
		
		public function set blurY(value: Number): void {
			_blurY = value;
		}
		
		public function set color(value: Number): void {
			_color = value;
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
					if (_glowFilter.alpha != _toAlpha) {
						_glowFilter.alpha = _toAlpha;
					}
				break;
				case STATE_STARTED:
					_glowFilter.alpha += _alphaStep;
					_dispObject.filters = [_glowFilter];
				break;
				case STATE_PAUSED:
				break;
			}
		}
		
	}
}