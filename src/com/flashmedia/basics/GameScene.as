package com.flashmedia.basics
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * Базовый слой со специальными возможностями по управлению объектами.
	 */
	public class GameScene extends Sprite
	{
		public const FPS_DEF: uint = 30;
		public const TPS_DEF: uint = 30;
		public const DEBUG_TEXT_COLOR: uint = 0xff0000;
		
		private const MODAL_BLOCK_LAYER_Z_ORDER: int = GameObject.MAX_Z_ORDER + 1;
		private const MODAL_GAME_OBJECT_Z_ORDER: int = MODAL_BLOCK_LAYER_Z_ORDER + 1;
		private const FOREWARD_LAYER_Z_ORDER: int = MODAL_GAME_OBJECT_Z_ORDER + 1;
		
		protected var _fps: uint;
		protected var _tps: uint;
		protected var _realFps: uint;
		protected var _realTps: uint;
		protected var _realFpsCount: uint;
		protected var _realTpsCount: uint;
		protected var _isModalShow: Boolean;
		private var _framesTimeStamp: Number;
		private var _ticksTimeStamp: Number;
		private var _modalBlockLayer: GameLayer;
		/**
		 * Самый задний слой в иерархии отображения для отслеживания перемещения указателя мыши.
		 * Вообще он создан чтобы заменить объект stage, который при запуске в соц сети недоступен.
		 */
		private var _stageSprite: Sprite;
		/**
		 * Сохраненные свойства объектов, которые показываются модально
		 * ['zOrder'] - zOrder объекта до модального показа
		 * ['added'] - был ли объект специально добавлен на слой
		 */
		private var _savedModalGameObjectsAttrs: Array;
		
		protected var _debug: Boolean;
		protected var _debugText: TextField;

		protected var _selectedGameObject: GameObject;		
		protected var _timer: Timer;
		
		/**
		 * Объект доступа к параметрам сцены и настройкам приложения.
		 * По умолчанию роль этого объекта исполняет stage
		 * Но когда приложение запускается из ВКонтакте, то wrapper.application, так как объект stage недоступен.
		 */
		protected var _appObject: Object;
		
		public function GameScene() {
			super();
			mouseEnabled = true;
			doubleClickEnabled = true;
			tabEnabled = true;
			_stageSprite = new Sprite();
			_stageSprite.addEventListener(MouseEvent.MOUSE_MOVE, stageSpriteMouseMoveListener, false);
			_stageSprite.addEventListener(MouseEvent.MOUSE_MOVE, stageSpriteMouseMoveListener, true);
			_stageSprite.addEventListener(MouseEvent.CLICK, stageSpriteMouseClickListener, false);
			_stageSprite.addEventListener(MouseEvent.CLICK, stageSpriteMouseClickListener, true);
			_stageSprite.addEventListener(MouseEvent.MOUSE_DOWN, stageSpriteMouseDownListener, false);
			_stageSprite.addEventListener(MouseEvent.MOUSE_DOWN, stageSpriteMouseDownListener, true);
			_stageSprite.addEventListener(MouseEvent.MOUSE_UP, stageSpriteMouseUpListener, false);
			_stageSprite.addEventListener(MouseEvent.MOUSE_UP, stageSpriteMouseUpListener, true);
			super.addChild(_stageSprite);
			_fps = FPS_DEF;
			_tps = TPS_DEF;
			if (stage) {
				stage.frameRate = _fps;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.displayState = StageDisplayState.NORMAL;
				stage.stageFocusRect = false;
//				stage.addEventListener(MouseEvent.CLICK, mouseClickListener);
//				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
	  			_stageSprite.graphics.beginFill(0xffffff, 0.0);
	  			_stageSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
	  			_stageSprite.graphics.endFill();
				_appObject = stage;
			}
			_debug = false;
			_realFps = 0;
			_realTps = 0;
			_realFpsCount = 0;
			_realTpsCount = 0;
			_framesTimeStamp = 0;
			_ticksTimeStamp = 0;
			_isModalShow = false;
			_savedModalGameObjectsAttrs = new Array();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_timer = new Timer(1000 / _tps, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		/**
		 * Установка объекта для доступа к свойствам приложения
		 * Для ВКонтакте это wrapper.application
		 */
		public function set appObject(value: Object): void {
			_appObject = value;
			_appObject.scaleMode = StageScaleMode.NO_SCALE;
			_appObject.align = StageAlign.TOP_LEFT;
			_appObject.frameRate = _fps;
			if (!_appObject.hasOwnProperty('frameRate') ||
				!_appObject.hasOwnProperty('stageWidth') ||
				!_appObject.hasOwnProperty('stageHeight')) {
				throw new ArgumentError('appObject doesn\'t have some properties!');
			}
			_stageSprite.graphics.beginFill(0xffffff, 0.0);
	  		_stageSprite.graphics.drawRect(0, 0, _appObject['stageWidth'], _appObject['stageHeight']);
	  		_stageSprite.graphics.endFill();
//			try {
//				//todo если не сработает, то придумать что-то еще
//				_appObject.addEventListener(MouseEvent.CLICK, mouseClickListener);
//				_appObject.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
//			}
//			catch (e: Error) {}
		}
		
		public function get appObject():Object {
			return _appObject;
		}
		
		public function destroy(): void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
		}
		
		public function getChildById(id: Number): GameObject {
			for (var i: int = 0; i < _stageSprite.numChildren; i++) {
				var d: DisplayObject = _stageSprite.getChildAt(i);
				if (d is GameLayer) {
					var res: GameObject = (d as GameLayer).getChildById(id);
					if (res) {
						return res;
					}
				}
				if (d is GameObject && (d as GameObject).id == id) {
					return (d as GameObject);
				}
			}
			return null;
		}
		
		public function generateId(): Number {
			var result: Number = Math.round(Math.random() * 100000);
			while (getChildById(result) != null) {
				result = Math.round(Math.random() * 100000);
			}
			return result;
		}
		
		/**
		 * Получить любой игровой объект со сцены по имени.
		 */
		public function getGameObject(value: String): void {
			//TODO глобальный список всех объектов, которые только есть на сцене.
		}
		
		public override function addChild(value: DisplayObject): DisplayObject {
			_stageSprite.addChild(value);
			if (_isModalShow) {
				_stageSprite.addChild(_modalBlockLayer);
			}
			return value;
		}
		
		public override function removeChild(value: DisplayObject): DisplayObject {
			return _stageSprite.removeChild(value);
		}
		
		public function get fps(): uint {
			return _fps;
		}
		
		public function set fps(value: uint): void {
			_fps = value;
			if (_appObject) {
				_appObject['frameRate'] = _fps;
			}
		}
		
		public function get tps(): uint {
			return _tps;
		}
		
		public function set tps(value: uint): void {
			_tps = value;
		}
		
		public function get realTps(): uint {
			return _realTps;
		}
		
		public override function set width(value:Number):void {
			//throw new IllegalOperationError('Can not set \'width\' property for \'GameScene\' object');
		}
		
		public override function set height(value:Number):void {
			//throw new IllegalOperationError('Can not set \'height\' property for \'GameScene\' object');
		}
		
		public function get selectedGameObject(): GameObject {
			return _selectedGameObject;
		}

		/**
		 * Установить фокус на игровой объект
		 */		
		public function set selectedGameObject(value: GameObject): void {
			if (_selectedGameObject == value) {
				return;
			}
			var oldSelectedGameObject: GameObject = _selectedGameObject;
			_selectedGameObject = value;
			if (oldSelectedGameObject) {
				oldSelectedGameObject.focus = false;
			}
			if (_selectedGameObject) {
				_selectedGameObject.focus = true;
			}
		}
		
		/**
		 * Показать в модальном режиме игровой объект.
		 * Объект на время оказывается поверх всех. Выделение остальных объектов невозможно.
		 * Объект может быть уже добавлен в сцену, а может быть и совершенно новым.
		 */ 
		public function showModal(value: GameObject): void {
			_isModalShow = true;
			updateModalBlockLayer();
			value.isModal = true;
			var attrs: Object = new Object();
			attrs.zOrder = value.zOrder;
			value.internalZOrder = MODAL_GAME_OBJECT_Z_ORDER;
			if (!value.gameLayer) {
				_modalBlockLayer.addChild(value);
				attrs.added = true;
			}
			else {
				attrs.added = false;
			}
			_savedModalGameObjectsAttrs.push(attrs);
			selectedGameObject = null;
		}
		
		/**
		 * Отменить модальный показ объекта.
		 * Объекту возвращается его предыдущий zOrder.
		 * Если перед показом объект ыл добавлен на сцену, то удаляем его со сцены.
		 */
		public function resetModal(value: GameObject): void {
			var attrs: Object = _savedModalGameObjectsAttrs.pop();
			if (attrs) {
				value.internalZOrder = attrs.zOrder;
				if (attrs.added) {
					value.setGameLayer(null);
					_modalBlockLayer.removeChild(value);
				}
			}
			value.isModal = false;
			_isModalShow = (_savedModalGameObjectsAttrs.length > 0);
			updateModalBlockLayer();
		}
		
		public function get isModalShow(): Boolean {
			return _isModalShow;
		}
		
		protected function onTimer(event: TimerEvent): void {
			var now: Date = new Date();
			if (now.time - _ticksTimeStamp >= 1000) {
				_realTps = _realTpsCount;
				_realTpsCount = 0;
				_ticksTimeStamp = now.time;
				if (_debug) {
					drawDebugInfo();
				}
			}
			else {
				_realTpsCount++;
			}
			var gsEvent: GameSceneEvent = new GameSceneEvent(GameSceneEvent.TYPE_TICK);
			gsEvent.scene = this;
			dispatchEvent(gsEvent);
		}
		
		//TODO render
		protected function onEnterFrame(event: Event): void {
			if (_debug) {
				var now: Date = new Date();
				if (now.time - _framesTimeStamp >= 1000) {
					_realFps = _realFpsCount;
					_realFpsCount = 0;
					_framesTimeStamp = now.time;
					drawDebugInfo();
				}
				else {
					_realFpsCount++;
				}
			}
		}
		
		// TODO Modal objects does not work
		// клик не когда не попадает на модальный объект
		protected function stageSpriteMouseClickListener(event: MouseEvent): void {
			if (event.eventPhase == EventPhase.AT_TARGET) {
				var moveEvent: GameSceneEvent = new GameSceneEvent(GameSceneEvent.TYPE_MOUSE_CLICK);
				moveEvent.scene = this;
				moveEvent.stageMouseX = event.localX;
				moveEvent.stageMouseY = event.localY;
				dispatchEvent(moveEvent);
			}
		}
		
		protected function stageSpriteMouseMoveListener(event: MouseEvent): void {
			var moveEvent: GameSceneEvent = new GameSceneEvent(GameSceneEvent.TYPE_MOUSE_MOVE);
			moveEvent.scene = this;
			moveEvent.stageMouseX = event.localX;
			moveEvent.stageMouseY = event.localY;
			dispatchEvent(moveEvent);
		}
		
		protected function stageSpriteMouseDownListener(event: MouseEvent): void {
			if (event.eventPhase == EventPhase.BUBBLING_PHASE || event.eventPhase == EventPhase.AT_TARGET) {
				selectedGameObject = null;
			}
		}
		
		protected function stageSpriteMouseUpListener(event: MouseEvent): void {
			if (_selectedGameObject && _selectedGameObject.isDragging) {
				_selectedGameObject.stopDrag();
			}
		}
		
		private function updateModalBlockLayer(): void {
			if (!_modalBlockLayer) {
	    		_modalBlockLayer = new GameLayer(this);
	    		_modalBlockLayer.internalZOrder = MODAL_BLOCK_LAYER_Z_ORDER;
	  		}
	  		_modalBlockLayer.visible = _isModalShow;
	  		if (_isModalShow) {
	  			if (_appObject) {
		  			_modalBlockLayer.graphics.beginFill(0xffffff, 0.0);
		  			_modalBlockLayer.graphics.drawRect(0, 0, _appObject['stageWidth'], _appObject['stageHeight']);
		  			_modalBlockLayer.graphics.endFill();
		  		}
				_stageSprite.addChild(_modalBlockLayer); // делаем каждый раз, чтобы слой оказывался на верху
	  		}
		}
		
		protected function drawDebugInfo(): void {
			graphics.clear();
			if (_debug) {
				if (!_debugText) {
					_debugText = new TextField();
					_debugText.wordWrap = true;
					_debugText.selectable = false;
					_debugText.autoSize = TextFieldAutoSize.LEFT;
					_debugText.setTextFormat(new TextFormat('Arial', 10));
					_debugText.textColor = DEBUG_TEXT_COLOR;
					_debugText.x = 10;
					_debugText.y = 10;
				}
				_debugText.text = '';
				//TODO сделать статистику по объектам
				// System.totalMemory
				_debugText.appendText('FPS: ' + _realFps + '\n\r');
				_debugText.appendText('TPS: ' + _realTps + '\n\r');
				_debugText.appendText('Memory: \n\r');
				_debugText.appendText('GameObjects: \n\r');
				_debugText.appendText('GameLayers: \n\r');
				_debugText.appendText('Sprites: \n\r');
				_debugText.appendText('Bitmaps: \n\r');
				if (!contains(_debugText)) {
					_stageSprite.addChild(_debugText);
				}
				if (_appObject) {
					graphics.lineStyle(1, GameObject.BORDERS_COLOR);
					graphics.drawRect(0, 0, _appObject['stageWidth'], _appObject['stageHeight']);
				}
			}
			else {
				if (_debugText) {
					removeChild(_debugText);
				}
			}
		}
		
	}
}