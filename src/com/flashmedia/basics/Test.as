package com.flashmedia.basics
{
	import com.flashmedia.basics.actions.intervalactions.Animation;
	import com.flashmedia.basics.actions.intervalactions.Move;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Test
	{
		private var _scene: GameScene;
		public var gm1: GameObject;
		public var gm2: GameObject;
		public var gm3: GameObject;
		public var gm4: GameObject;
		public var gm5: GameObject;
		public var gm6: GameObject;
		public var gl1: GameLayer;
		
		public function Test(value: GameScene)
		{
			_scene = value;
		}
		
		public function testDragAndDrop(): void {
			var g: GameObject = new GameObject(_scene);
			g.bitmap = new Bitmap(new BitmapData(50, 50, false, 0xff0000));
			g.setSelect(true);
			g.setFocus(true, true);
			g.setHover(true, true);
			g.canDrag = true;
//			g.addEventListener(GameObjectEvent.TYPE_DRAG_STARTED, function (event: GameObjectEvent): void {
//				trace('start');
//			});
//			g.addEventListener(GameObjectEvent.TYPE_DRAGGING, function (event: GameObjectEvent): void {
//				trace('dragging');
//			});
//			g.addEventListener(GameObjectEvent.TYPE_DRAG_STOPPED, function (event: GameObjectEvent): void {
//				trace('stopped');
//			});
			_scene.addChild(g);
			
			var w: GameObject = new GameObject(_scene);
			w.bitmap = new Bitmap(new BitmapData(50, 50, false, 0x00ff00));
			w.setSelect(true);
			w.setFocus(true, true);
			w.setHover(true, true);
			w.canDrag = true;
			_scene.addChild(w);
		}
		
		public function testMove(): void {
			var g: GameObject = new GameObject(_scene);
			g.bitmap = new Bitmap(new BitmapData(50, 50, false, 0xff0000));
			g.setSelect(true);
			g.setFocus(true, true);
			g.setHover(true, true);
			g.canDrag = true;
			_scene.addChild(g);
			
			var moveAction: Move = new Move(_scene, 'm1', g, Move.MOVE_TO_POINT);
			_scene.addEventListener(GameSceneEvent.TYPE_MOUSE_CLICK, function (event: GameSceneEvent): void {
				moveAction.point = new Point(event.stageMouseX, event.stageMouseY);
				moveAction.speed = moveAction.distance / 8;
				moveAction.start();
			});
		}
		
		public function testAnimation(): void {
			var frame1: Sprite = new Sprite();
			frame1.graphics.beginFill(0xff0000);
			frame1.graphics.drawCircle(0,0,40);
			frame1.graphics.endFill();
			var frame2: Sprite = new Sprite();
			frame2.graphics.beginFill(0x00ff00);
			frame2.graphics.drawCircle(0,0,40);
			frame2.graphics.endFill();
			var frame3: Sprite = new Sprite();
			frame3.graphics.beginFill(0x0000ff);
			frame3.graphics.drawCircle(0,0,40);
			frame3.graphics.endFill();
			var b1: Bitmap = new Bitmap(new BitmapData(50, 50, false, 0xff0000));
			var b2: Bitmap = new Bitmap(new BitmapData(50, 50, false, 0x00ff00));
			var b3: Bitmap = new Bitmap(new BitmapData(50, 50, false, 0x0000ff));
			var stop: Sprite = new Sprite();
			stop.x = 200;
			stop.graphics.beginFill(0xaaffff);
			stop.graphics.drawCircle(0,0,40);
			stop.graphics.endFill();
			stop.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				gm1.stopAnimation();
			});
			_scene.addChild(stop);
			var play: Sprite = new Sprite();
			play.x = 300;
			play.graphics.beginFill(0xffaaff);
			play.graphics.drawCircle(0,0,40);
			play.graphics.endFill();
			play.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				gm1.startAnimation('round', -1);
			});
			_scene.addChild(play);
			var pause: Sprite = new Sprite();
			pause.x = 400;
			pause.graphics.beginFill(0xffffaa);
			pause.graphics.drawCircle(0,0,40);
			pause.graphics.endFill();
			pause.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				gm1.pauseAnimation();
			});
			_scene.addChild(pause);
			
			gm1 = new GameObject(_scene);
			gm1.debug = true;
			_scene.addChild(gm1);
			
//			var spr: Sprite = new Sprite();
//			spr.graphics.beginFill(0xffffff);
//			spr.graphics.drawCircle(0,0,40);
//			spr.graphics.endFill();
//			spr.x = 100;
//			spr.y = 100;
//			_scene.addChild(spr);
//			var b: Bitmap = new Bitmap();
//			_scene.addChild(b);
			
			var anm1: Animation = new Animation(_scene, 'round', gm1);
//			anm1.addFrame(frame1, 1000);
//			anm1.addFrame(frame2, 1000);
//			anm1.addFrame(frame3, 1000);
			anm1.addFrame(b1, 700);
			anm1.addFrame(b2, 700);
			anm1.addFrame(b3, 700);
//			anm1.start();
			
			gm1.addAnimation(anm1);
			gm1.startAnimation('round', -2, 0, anm1.framesCount - 1); // и по ссылке тоже
//			gm1.pauseAnimation(); // остановить на текущем кадре
//			gm1.stopAnimation(); // остановить и перевести вначало

			gm1.addEventListener(GameObjectEvent.TYPE_ANIMATION_STARTED, function (event: GameObjectEvent): void {
				trace(GameObjectEvent.TYPE_ANIMATION_STARTED);
			});
			gm1.addEventListener(GameObjectEvent.TYPE_ANIMATION_COMPLETED, function (event: GameObjectEvent): void {
				trace(GameObjectEvent.TYPE_ANIMATION_COMPLETED);
			});
		}

		/*
		public function testGameObjects(): void {
			
			gl1 = new GameLayer(this);
			gl1.debug = false;
			gl1.fillBackground(0xdedede, 1.0);
			gl1.x = 200;
			gl1.y = 100;
			gl1.selectable = true;
			gl1.width = 300;
			gl1.height = 300;
			gl1.scrollRect = new Rectangle(0, 0, 250, 250);
			gl1.verticalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
			gl1.horizontalScrollPolicy = GameLayer.SCROLL_POLICY_AUTO;
			gl1.verticalScrollStep = 30;
			gl1.horizontalScrollStep = 10;
			gl1.scrollIndents(-20, -15, -15, -20);
			gl1.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameLayerKeyDownListener);
			gl1.canFocus = true;
			gl1.canHover = true;
			addChild(gl1);
			
			gm1 = new GameObject(this);
			gm1.debug = false;
			gm1.type = 'Button';
			gm1.name = 'b123';
			gm1.visible = true;
			gm1.bitmap = new Bitmap(new BitmapData(300, 50, false, 0x00ff22), PixelSnapping.ALWAYS, true);
			gm1.bitmapMask = getEllipseMask(gm1.width, gm1.height);
			gm1.x = 106;
			gm1.y = 107;
			gm1.width = 100;
			gm1.height = 100;
			gm1.selectable = true;
			gm1.selectAutosize = true;
			gm1.selectMask = getEllipseMask(200, 200);
			gm1.selectRect = new Rectangle(-50, -50, 200, 200);
			gm1.fillBackground(0xfcffff, 0.6);
			gm1.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			gm1.zOrder = 2;
			gm1.canFocus = true;
			gm1.canHover = true;
			gl1.addChild(gm1);
			
			gm2 = new GameObject(this);
			gm2.debug = true;
			gm2.selectable = true;
			gm2.type = 'Button';
			gm2.name = 'b987';
			gm2.visible = true;
			gm2.bitmap = new Bitmap(new BitmapData(100, 100, false, 0x34f022), PixelSnapping.ALWAYS, true);
			gm2.bitmapMask = getEllipseMask(gm1.width, gm1.height);
			gm2.x = 250;
			gm2.y = 180;
			gm2.width = 100;
			gm2.height = 100;
			gm2.selectAutosize = true;
			gm2.selectMask = getEllipseMask(110, 110);
			gm2.selectRect = new Rectangle(10, 10, 60, 60);
			gm2.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			gm2.zOrder = 1;
			gm2.canFocus = true;
			gm2.canHover = true;
			gl1.addChild(gm2);
			
			gm3 = new GameObject(this);
			gm3.debug = true;
			gm3.type = 'Field';
			gm3.name = 'GameObject3';
			gm3.visible = true;
			gm3.bitmap = new Bitmap(new BitmapData(100, 20, false, 0xff1020), PixelSnapping.ALWAYS, true);
			gm3.x = 250;
			gm3.y = 180;
			gm3.width = 100;
			gm3.height = 20;
			gm3.selectAutosize = true;
			gm3.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			gm3.zOrder = -1;
			gm3.selectable = false;
			gl1.addChild(gm3);
			
//			sp = new Sprite();
//			sp.name = "Sp";
//			sp.x = 600;
//			sp.y = 300;
//			sp.graphics.beginFill(0xdddddd);
//			sp.graphics.drawRect(0, 0, 50, 50);
//			sp.addEventListener(MouseEvent.CLICK, function (): void {
//				trace('click');
//				stage.focus = sp;
//			});
//			addChild(sp);
			
			gm4 = new GameObject(this);
			gm4.name = 'red';
			gm4.bitmap = new Bitmap(new BitmapData(100, 100, false, 0xff1020), PixelSnapping.ALWAYS, true);
			gm4.x = 100;
			gm4.y = 350;
			gm4.selectable = true;
			gm4.selectAutosize = true;
			gm4.canFocus = true;
			gm4.canHover = true;
			gm4.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			addChild(gm4);
			
			gm5 = new GameObject(this);
			gm5.name = 'green';
			gm5.bitmap = new Bitmap(new BitmapData(100, 100, false, 0x01ff00), PixelSnapping.ALWAYS, true);
			gm5.x = 250;
			gm5.y = 350;
			gm5.selectable = true;
			gm5.selectAutosize = true;
			gm5.canFocus = true;
			gm5.canHover = true;
			gm5.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			addChild(gm5);
			
			gm6 = new GameObject(this);
			gm6.name = 'blue';
			gm6.bitmap = new Bitmap(new BitmapData(100, 100, false, 0x3210ff), PixelSnapping.ALWAYS, true);
			gm6.x = 400;
			gm6.y = 350;
			gm6.selectable = true;
			gm6.selectAutosize = true;
			gm6.canFocus = true;
			gm6.canHover = true;
			gm6.addEventListener(GameObjectEvent.TYPE_KEY_DOWN, gameObjectKeyDownListener);
			addChild(gm6);
		}
		*/
	}
}