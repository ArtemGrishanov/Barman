package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class RatingBar extends GameObject
	{
		public static const POINTS_COUNT_DEF: uint = 5;
		public static const COLOR_ON_DEF: uint = 0xffffff;
		public static const COLOR_OFF_DEF: uint = 0x222222;
		
		private var _iconsOn: Array;
		private var _iconsOff: Array;
		private var _rating: uint;
		private var _hoverRating: uint;
		private var _pointsCount: uint;
		private var _rateIconOn: Bitmap;
		private var _rateIconOff: Bitmap;
		private var _tX: int;
		private var _tY: int;
		private var _rateCellWidth: uint;
		private var _rateCellHeight: uint;
		
		public function RatingBar(value: GameScene, pointsCount: uint = POINTS_COUNT_DEF)
		{
			super(value);
			
			width = 100;
			height = 20;
			setSelect(true);
			_rating = 0;
			_hoverRating = 0;
			_pointsCount = pointsCount;
			_tX = 0;
			_tY = 0;
			_rateCellWidth = 0;
			_rateCellHeight = 0;
			_iconsOn = new Array();
			_iconsOff = new Array();
		}
		
		public function set enabled(value:Boolean):void {
			setSelect(value);
			buttonMode = selectable;
			useHandCursor = selectable;
			
			if (!selectable) _hoverRating = 0;
			update(false);
		}
		
		public override function set bitmap(value:Bitmap):void {
			super.bitmap = value;
			width = value.width;
			height = value.height;
		}
		
		public function get rating(): uint {
			return _rating;
		}
		
		public function set rating(value: uint): void {
			_rating = value;
			update();
		}
		
		public function set rateIconOn(value: Bitmap): void {
			_rateIconOn = value;
			while (_iconsOn.length != 0) {
				removeChild(_iconsOn.pop() as Bitmap);
			}
			for (var i: uint = 0; i < _pointsCount; i++) {
				var b: Bitmap = new Bitmap(value.bitmapData);
				_iconsOn.push(b);
				addChild(b);
			}
			update();
		}
		
		public function set rateIconOff(value: Bitmap): void {
			_rateIconOff = value;
			while (_iconsOff.length != 0) {
				removeChild(_iconsOff.pop() as Bitmap);
			}
			for (var i: uint = 0; i < _pointsCount; i++) {
				var b: Bitmap = new Bitmap(value.bitmapData);
				_iconsOff.push(b);
				addChild(b);
			}
			update();
		}
		
		public function setLayout(tX: int, tY: int = 0, rateCellWidth: uint = 0, rateCellHeight: uint = 0): void {
			_tX = tX;
			_tY = tY;
			_rateCellWidth = rateCellWidth;
			_rateCellHeight = rateCellHeight;
			update();
		}
		
		private function update(updateLayout: Boolean = true): void {
			for (var i: uint = 0; i < _iconsOn.length; i++) {
				if (_hoverRating > 0) {
					(_iconsOn[i] as Bitmap).visible = i < _hoverRating;
				}
				else {
					(_iconsOn[i] as Bitmap).visible = i < _rating;
				}
			}
			for (i = 0; i < _iconsOff.length; i++) {
				if (_hoverRating > 0) {
					(_iconsOff[i] as Bitmap).visible = !(i < _hoverRating);
				}
				else {
					(_iconsOff[i] as Bitmap).visible = !(i < _rating);
				}
			}
			if (updateLayout) {
				var xx: int = _tX;
				for (i = 0; i < _iconsOn.length; i++) {
					(_iconsOn[i] as Bitmap).x = xx + (_rateCellWidth - (_iconsOn[i] as Bitmap).width) / 2;
					(_iconsOn[i] as Bitmap).y = _tY + (_rateCellHeight - (_iconsOn[i] as Bitmap).height) / 2;
					xx += _rateCellWidth;
				}
				xx = _tX;
				for (i = 0; i < _iconsOff.length; i++) {
					(_iconsOff[i] as Bitmap).x = xx + (_rateCellWidth - (_iconsOff[i] as Bitmap).width) / 2;
					(_iconsOff[i] as Bitmap).y = _tY + (_rateCellHeight - (_iconsOff[i] as Bitmap).height) / 2;
					xx += _rateCellWidth;
				}
			}
		}
		
		protected override function mouseMoveListener(event: MouseEvent): void {
			if (selectable) {
				super.mouseMoveListener(event);
				if (event.localX > _tX && event.localY > _tY &&
					event.localX < (_tX + _pointsCount * _rateCellWidth) &&
					event.localY < (_tY + _rateCellHeight)) {
					_hoverRating = (event.localX - _tX) / _rateCellWidth + 1;
				}
				else {
					_hoverRating = 0;
				}
				update(false);
			}
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			if (selectable) {
				super.mouseOutListener(event);
				_hoverRating = 0;
				update(false);
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			if (selectable) {
				if (event.localX > _tX && event.localY > _tY &&
					event.localX < (_tX + _pointsCount * _rateCellWidth) &&
					event.localY < (_tY + _rateCellHeight)) {
					rating = (event.localX - _tX) / _rateCellWidth + 1;
				}
				
				super.mouseClickListener(event);
			}
		}
	}
}