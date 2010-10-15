package com.bar.ui.windows
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Form;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PreloaderForm extends Form
	{
		private var _preloader: GameObject;
		private var label: TextField;
		private var _progress: Number;
		private var _totalProgress: Number;
		private var _loadBack: Bitmap;
		private var _loadActive: GameObject;
		private var _loadInactive: GameObject;
		private var _loadMask: Sprite;
		
		public function PreloaderForm(value:GameScene)
		{
			super(value, 0, 0, Bar.WIDTH, Bar.HEIGHT);
			
			_progress = 0;
			_totalProgress = 0;
			
			bitmap = Bar.multiLoader.get(Images.SPLASH);
			
			label = new TextField();
			label.defaultTextFormat = new TextFormat("Arial", 48, 0xffffff, true);
			label.text = '0%';
			label.y = 624;
			label.width = width;
			label.height = height;
			label.selectable = false;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = (Bar.WIDTH - label.width) / 2;
			//label.setTextFormat(new TextFormat(Util.tahoma.fontName, 16, 0xcac4c8));
			addChild(label);
			label.filters = [new GlowFilter(0x000000, 1, 4, 4, 10)];
			
			_loadBack = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LOAD_BACK));
			_loadBack.x = (Bar.WIDTH - _loadBack.width) / 2;
			_loadBack.y = 675;
			addChild(_loadBack);
			
			_loadInactive = new GameObject(scene);
			_loadInactive.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LOAD_MASK));
			_loadInactive.x = (Bar.WIDTH - _loadInactive.width) / 2;
			_loadInactive.y = 680;
			addChild(_loadInactive);
			var mask: Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff, 1);
			mask.graphics.drawRoundRect(0, 0, 241, 26, 26, 26);
			mask.graphics.endFill();
			//mask.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LOAD_ACTIVE));
			_loadInactive.bitmapMask = mask;
			
			_loadActive = new GameObject(scene);
			_loadActive.bitmap = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.LOAD_ACTIVE));
			_loadActive.x = (Bar.WIDTH - _loadActive.width) / 2;
			_loadActive.y = 680;
			addChild(_loadActive);
			
			_loadMask = new Sprite();
			_loadMask.graphics.beginFill(0xffffff, 1);
			_loadMask.graphics.drawRect(0, 0, 241, 26);
			_loadMask.graphics.endFill();
			_loadMask.x = -_loadActive.width;
			_loadActive.bitmapMask = _loadMask;
			
//			_preloader = new GameObject(scene);
//			_preloader.x = (Bar.WIDTH - Bar.multiLoader.get(Images.PRELOADER_ANIM1).width) / 2;
//			_preloader.y = 300;
//			addChild(_preloader);
						
//			var anm: Animation = new Animation(_scene, 'round', _preloader);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM1), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM2), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM3), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM4), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM5), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM6), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM7), 100);
//			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM8), 100);
//			_preloader.addAnimation(anm);
//			_preloader.startAnimation('round', -1, 0, anm.framesCount - 1);
		}
		
		public function set totalProgress(value: Number): void {
			_totalProgress = value;
			label.text = '0%';
			label.x = (Bar.WIDTH - label.width) / 2;
		}
		
		public function get progress(): Number {
			return _progress;
		}
		
		public function set progress(value: Number): void {
			_progress = value;
			var p: Number = 100 * _progress / _totalProgress;
			if (!p || p <= 0) {
				label.text = '0%';
				_loadMask.x = -_loadActive.width;
			}
			else if (p > 100) {
				label.text = '100%';
				_loadMask.x = 0;
			}
			else {
				var pStr: String = p.toFixed(0);
				label.text = pStr+ '%';
				_loadMask.x = -_loadActive.width + p / 100 * _loadActive.width;
			}
			label.x = (Bar.WIDTH - label.width) / 2;
		}
		
		public override function destroy(): void {
			super.destroy();
//			_preloader.stopAnimation();
		}
		
	}
}