package com.flashmedia.basics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * Наследуемся от Sprite, чтобы получать пользовательские события (Мышь, Клавиатура ...)
	 * Автоматическое масштабирование, поворот
	 * Альфа, наложения, фильтры, маскирование
	 * Видимость-невидимость
	 */
	public class SpriteLayer extends Sprite
	{
		public static const SELECT_COLOR: uint = 0xffdd00;
		public static const BORDERS_COLOR: uint = 0xff0000;
		
		//TODO scrollRect: Rectangle
		private var _width: uint = 0;
    	private var _height: uint = 0;
    
		private var childX: Number = 10;
		private var childY: Number = 10;
		
		private var _showBorderRect: Boolean;
		private var _showSelectRect: Boolean;
		
		// графическое содержимое
		private var bitmap: Bitmap;
		// область выделения
		private var select: Sprite;
		// границы объекта - отдельный объект, так как при изменении границ нужно удалить, пересоздать и заново добавлять его
		private var border: Sprite;
		
		public function SpriteLayer()
		{
			super();
			// границы объекта
			width = 100;
			height = 100;
			// графическое представление
			bitmap = new Bitmap(new BitmapData(_width, _height), PixelSnapping.ALWAYS, true);
			addChild(bitmap);
			// область выделения
			select = new Sprite();
			select.tabEnabled = true;
			select.graphics.beginFill(SELECT_COLOR);
			select.graphics.drawRect(0, 0, _width, _height);
			select.graphics.endFill();
			select.alpha = 0.0;
			select.addEventListener(KeyboardEvent.KEY_DOWN, keyboardListener);
			addChild(select);
			// визуализация
			_showBorderRect = false;
			_showSelectRect = false;
//			addEventListener(KeyboardEvent.KEY_DOWN, keyboardListener);
//			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function set showBorderRect(value: Boolean): void
		{
			_showBorderRect = value;	
		}
		
		public function set showSelectRect(value: Boolean): void
		{
			_showSelectRect = value;
		}
		
		public override function get width(): Number
		{
	    	return _width;
		}
		
		public override function set width(value: Number): void
		{
	    	_width = value;
	    	if (border != null) {
	    		removeChild(border);
	    	}
	    	border = new Sprite();
			border.graphics.lineStyle(1, BORDERS_COLOR, 0.0);
			border.graphics.drawRect(0, 0, _width, _height);
			addChild(border);
		}
	    
		public override function get height():Number
		{
	    	return _height;
		}
		
		public override function set height(value: Number): void
		{
			//TODO избыточность действий при последовательном задании width & height
	    	_height = value;
	    	if (border != null) {
	    		removeChild(border);
	    	}
	    	border = new Sprite();
			border.graphics.lineStyle(1, BORDERS_COLOR, 0.0);
			border.graphics.drawRect(0, 0, _width, _height);
			addChild(border);
		}
		
		private function keyboardListener(event: KeyboardEvent): void {
			trace('SpriteLayer :: keyDown : ' + event.charCode);
			if (event.charCode == 100) {
				childX += 10;
			}
			else if (event.charCode == 97) {
				childX -= 10;
			}
			else if (event.charCode == 119) {
				childY -= 10;
			}
			else if (event.charCode == 115) {
				childY += 10;
			}
			draw();
			//event.updateAfterEvent();
		}
		
//		private function onAddedToStage(event: Event): void {
//			draw();
//		}
		
		public function draw(): void {
			trace('SpriteLayer :: draw()');
			if (_showBorderRect) {
				graphics.lineStyle(1, BORDERS_COLOR);
				graphics.drawRect(0, 0, _width - 1, _height - 1);
			}
			if (_showSelectRect) {
				graphics.lineStyle(1, SELECT_COLOR);
				graphics.drawRect(0, 0, select.width - 1, select.height - 1);
			}
			graphics.lineStyle(2, 0xffdd00);
			graphics.drawRect(childX, childY, 30, 30);
			
//			var cropArea: Rectangle = new Rectangle(0, 0, _width, _height);
//			var croppedBitmap: Bitmap = new Bitmap(new BitmapData(_width, _height), PixelSnapping.ALWAYS, true);
//			croppedBitmap.bitmapData.draw(this, new Matrix() , null, null, cropArea, false);
//			croppedBitmap.x = x;
//			croppedBitmap.y = y;
//			bitmap = croppedBitmap;
			//todo попробовать this.addChild(croppedBitmap);
			
			//return croppedBitmap;
		}
	}
}