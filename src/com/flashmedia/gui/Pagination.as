package com.flashmedia.gui
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	public class Pagination extends GameObject
	{
		private static const RIGHT_INDENT:uint = 8;
		
		protected var _currentPage:uint;
		
		private var _pagesCount:uint;
		private var _visiblePagesCount:uint;
		private var _currentX:int;
		private var _defaultTextFormat:TextFormat;
		private var _selectedTextFormat:TextFormat;
		
		private var layer:Sprite;
		
		public function Pagination(value:GameScene, x:uint=0, y:uint=0, pagesCount:uint=0, visiblePagesCount:uint=2)
		{
			super(value);
			this.x = x;
			this.y = y;
			this._pagesCount = pagesCount;
			this._visiblePagesCount = visiblePagesCount;
			
			_currentPage = 0;
			_currentX = 0;
			
			init();
		}
		
		public function set textFormatForDefaultButton(value:TextFormat):void {
			_defaultTextFormat = value;
			update();
		}
		
		public function set textFormatForSelectedButton(value:TextFormat):void {
			_selectedTextFormat = value;
			update();
		}
		
		public function set pagesCount(value:uint):void {
			_pagesCount = value;
			if (_currentPage > _pagesCount - 1) {
				_currentPage = _pagesCount - 1;
			}
			init();
		}
		
		public function get pagesCount():uint {
			return _pagesCount;
		}
		
		public function get currentPage():int {
			return _currentPage;
		}
		
		public function set currentPage(value: int): void {
			_currentPage = value;
			init();
		}
		
		public function clear():void {
			if (layer) {
				removeChild(layer);
				
				while (layer.numChildren != 0) {
					layer.removeChildAt(0);
				}
			}
			layer = new Sprite();
			
			while (numChildren != 0) {
				removeChildAt(0);
			}
		}
		
		public function init():void {
			clear();
			
			_currentX = 0;
			var start:uint = 0;
			var end:uint = 0;
			var i:int = 0;
			
			if (_pagesCount < _visiblePagesCount) {
				for (i = 0; i < _pagesCount; ++i) {
					addLinkButton(new String(i + 1), (i == _currentPage), i);
				}
			}
			else {
				var max:uint = Math.max(0, _currentPage - _visiblePagesCount);
				var min:uint = Math.min(_pagesCount - 1, _currentPage + _visiblePagesCount);
				
				if (max > 0) addButton(Util.multiLoader.get(Images.ARROW_LEFT), false, 0);
		
		        for (i = max; i <= min; ++i) {
					addLinkButton(new String(i + 1), (i == _currentPage), i);
		        }
		
		        if (min < _pagesCount - 1) addButton(Util.multiLoader.get(Images.ARROW_RIGHT), false, -1);
			}
			
			layer.x = width - layer.width;
			addChild(layer);
		}
		
		public function update():void {
			var o:Object;
			var b:LinkButton;
			for (var i:uint = 0; i < numChildren; ++i) {
				o = getChildAt(i);
				
				if (o is LinkButton) {
					b = o as LinkButton;
					b.enabled = (b.paginationIndex != _currentPage);
					
					if (b.paginationIndex == _currentPage) {
						b.setTextFormatForState(_selectedTextFormat, CONTROL_STATE_NORMAL);
					}
					else {
						b.setTextFormatForState(_defaultTextFormat, CONTROL_STATE_NORMAL);
					}
				}
			}
		}
		
		private function addLinkButton(label:String, isCurrent:Boolean, index:int):void {
			var b:LinkButton = new LinkButton(_scene, label, _currentX);
			b.textField.embedFonts = true;
			b.textField.antiAliasType = AntiAliasType.ADVANCED;
			b.paginationIndex = index;
			layer.addChild(b);
			
			b.enabled = !isCurrent;
			if (isCurrent && _selectedTextFormat) {
				b.setTextFormatForState(_selectedTextFormat, CONTROL_STATE_NORMAL);
			}
			if (!isCurrent && _defaultTextFormat) {
				b.setTextFormatForState(_defaultTextFormat, CONTROL_STATE_NORMAL);
			}
			//b.setTextFormatForState((isCurrent) ? _selectedTextFormat : _defaultTextFormat, CONTROL_STATE_NORMAL);

			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, buttonClickListener);
			_currentX += b.width + RIGHT_INDENT;
			layer.width = _currentX;
		}
		
		private function addButton(image:Bitmap, isCurrent:Boolean, index:int):void {
			var b:Button = new Button(_scene);
			b.y = 2;
			b.x = _currentX;
			if (image) {
				b.setBackgroundImageForState(new Bitmap(image.bitmapData), CONTROL_STATE_NORMAL);
			}
			b.paginationIndex = index;
			layer.addChild(b);
			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, buttonClickListener);
			_currentX += b.width + RIGHT_INDENT;
			layer.width = _currentX;
		}
		
		private function buttonClickListener(e:GameObjectEvent):void {
			var o:Object = e.gameObject;
			_currentPage = (o.paginationIndex < 0) ? _pagesCount - 1 : o.paginationIndex;
			init();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}