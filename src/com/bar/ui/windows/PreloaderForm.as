package com.bar.ui.windows
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.Animation;
	import com.flashmedia.gui.Form;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class PreloaderForm extends Form
	{
		private var _preloader: GameObject;
		
		public function PreloaderForm(value:GameScene)
		{
			super(value, 0, 0, Bar.WIDTH, Bar.HEIGHT);
			
//			bitmap = Util.multiLoader.get(Images.SPLASH);
			
			var label: TextField = new TextField();
			label.text = 'Загрузка';
			label.y = 250;
			label.width = width;
			label.height = height;
			label.selectable = false;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = (Bar.WIDTH - label.width) / 2 - 5;
			//label.setTextFormat(new TextFormat(Util.tahoma.fontName, 16, 0xcac4c8));
			addChild(label);
			
			_preloader = new GameObject(scene);
			_preloader.x = (Bar.WIDTH - Bar.multiLoader.get(Images.PRELOADER_ANIM1).width) / 2;
			_preloader.y = 300;
			addChild(_preloader);
						
			var anm: Animation = new Animation(_scene, 'round', _preloader);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM1), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM2), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM3), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM4), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM5), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM6), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM7), 100);
			anm.addFrame(Bar.multiLoader.get(Images.PRELOADER_ANIM8), 100);
			_preloader.addAnimation(anm);
			_preloader.startAnimation('round', -1, 0, anm.framesCount - 1);
			
		}
		
		public override function destroy(): void {
			super.destroy();
			_preloader.stopAnimation();
		}
		
	}
}