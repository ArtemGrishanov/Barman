package com.flashmedia.basics.actions
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.GameSceneEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public class Animation extends Action
	{
		protected var _frames: Array;
		protected var _durations: Array;
		protected var _curFrame: int;
		protected var _startFrame: int;
		protected var _endFrame: int;
		protected var _frameStartTime: Number;
		
		/**
		 * dispObject - Bitmap или Sprite
		 */
		public function Animation(scene: GameScene, name: String, dispObject: GameObject)
		{
			super(scene, name, dispObject);
			_frames = new Array();
			_durations = new Array();
			_curFrame = 0;
			_frameStartTime = undefined;
		}
		
		public function addFrame(d: DisplayObject, duration: int): void {
			_frames.push(d);
			_durations.push(duration);
		}
		
		public function removeFrame(value: uint): void {
			_frames.splice(value, 1);
			_durations.push(value, 1);
		}
		
		public function get framesCount(): uint {
			return _frames.length;
		}
		
		public function start(iterationsCount: int = 1, startFrame: int = -1, endFrame: int = -1): void {
			var changeCurFrame: Boolean = (startFrame != -1);
			if (startFrame < 0) {
				startFrame = 0;
			} else if (startFrame > (_frames.length - 1)) {
				startFrame = _frames.length - 1;
			}
			if (endFrame < 0 || endFrame > (_frames.length - 1)) {
				endFrame = _frames.length - 1
			}
			if (endFrame < startFrame) {
				endFrame = startFrame
			}
			_startFrame = startFrame;
			if (changeCurFrame) {
				_curFrame = _startFrame;
				changeFrame();
			}
			_endFrame = endFrame;
			_frameStartTime = new Date().time;
			super._startAction(iterationsCount);
		}
		
		public function pause(): void {
			super._pauseAction();
		}
		
		public function stop(): void {
			super._stopAction();
			_curFrame = _startFrame;
			changeFrame();
		}
		
		protected override function onTick(event: GameSceneEvent): void {
			super.onTick(event);
			switch (_state) {
				case STATE_STOPPED:
				break;
				case STATE_STARTED:
					var now: Date = new Date();
					if (now.time - _frameStartTime >= (_durations[_curFrame] as int)) {
						_curFrame++
						_frameStartTime = now.time;
						if (_curFrame > _endFrame) {
							super._endAction();
							_curFrame = (isStopped) ? _endFrame: _startFrame;
						}
						changeFrame();
					}
				break;
				case STATE_PAUSED:
				break;
			}
		}
		
		private function changeFrame(): void {
			(_dispObject as GameObject).bitmap = _frames[_curFrame] as Bitmap;
//			var frameSpr: Sprite = (_frames[_curFrame] as Sprite);
//			frameSpr.x = 200;
//			frameSpr.y = 200;
//			_scene.addChild(frameSpr);
//			var bd: BitmapData = new BitmapData(frameSpr.width, frameSpr.height);
//			bd.draw(frameSpr);
//			(_dispObject as Sprite).graphics.clear();
//			(_dispObject as Sprite).graphics.beginBitmapFill(bd);
//			(_dispObject as Sprite).graphics.endFill();
		}
	}
}