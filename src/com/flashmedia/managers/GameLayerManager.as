package com.flashmedia.managers
{
	import flash.events.EventDispatcher;
	
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	
	//TODO впоследствии следует добавить функционал для управления заргузкой
	// Грузить или нет каждый раз слой при его показе
	// События onLoad, onProgress
	// loadPolicy: String = LOAD_POLICY_CACHE
	// public static const LOAD_POLICY_CACHE: String = 'load_policy_cache';
	// public static const LOAD_POLICY_NO_CACHE: String = 'load_policy_no_cache';
	public class GameLayerManager extends EventDispatcher
	{
		public static const HISTORY_MAX_SIZE: uint = 50;
		
		private var _scene: GameScene;
		// список данных слоев
		private var _layersData: Array;
		// очередь переходов
		private var _navigationHistory: Array;
		private var _currentNavigIndex: int;
		
		public function GameLayerManager(value: GameScene) {
			_scene = value;
			_layersData = new Array();
			_navigationHistory = new Array();
			_currentNavigIndex = -1;
		}

		public function addGameLayer(gameLayer: GameLayer): void {
			var o: Object = {'gameLayer': gameLayer, 'loadPolicy': null};
			_layersData.push(o);
			var event: GameLayerManagerEvent = new GameLayerManagerEvent(GameLayerManagerEvent.TYPE_LAYER_ADDED);
			event.gameLayer = gameLayer;
			dispatchEvent(event);
		}
		
		public function deleteGameLayer(value: String): GameLayer {
			for (var i: uint; i < _layersData.length; i++) {
				var gameLayer: GameLayer = _layersData[i] as GameLayer;
				if (gameLayer.name == value) {
					_layersData.splice(i, 1);
					return gameLayer;
				}
			}
			return null;
		}
		
		public function getGameLayer(value: String): GameLayer {
			for each (var o: Object in _layersData) {
				var gameLayer: GameLayer = o.gameLayer as GameLayer;
				if (gameLayer.name == value) {
					return gameLayer;
				}
			}
			return null;
		}
		
		/**
		 * Отобразить слой по его имени.
		 * @return объект, который был реально отображен после вызва функции
		 * null - никакой слой не был отображен 
		 */
		public function showLayer(value: String): GameLayer {
			var result: GameLayer = null;
			for each (var o: Object in _layersData) {
				var gameLayer: GameLayer = o.gameLayer as GameLayer;
				if (gameLayer.name == value) {
					if (!_scene.contains(gameLayer)) {
						_scene.addChild(gameLayer);
					}
					gameLayer.visible = true;
					var event: GameLayerManagerEvent = new GameLayerManagerEvent(GameLayerManagerEvent.TYPE_LAYER_SHOWED);
					event.gameLayer = gameLayer;
					dispatchEvent(event);
					addHistoryState(gameLayer.name);
					result = gameLayer;
				}
				else {
					if (gameLayer.visible) {
						gameLayer.visible = false;
						event = new GameLayerManagerEvent(GameLayerManagerEvent.TYPE_LAYER_HIDED);
						event.gameLayer = gameLayer;
						dispatchEvent(event);
					}
				}
			}
			return gameLayer;
		}
		
		public function goBack(): GameLayer {
			if (_currentNavigIndex > 0) {
				--_currentNavigIndex
				if (_navigationHistory.length > 0) {
					return showLayer(_navigationHistory[_currentNavigIndex]);
				}
			}
			return null;
		}
		
		
		public function goNext(): GameLayer {
			if (_currentNavigIndex < _navigationHistory.length - 1) {
				++_currentNavigIndex
				return showLayer(_navigationHistory[_currentNavigIndex]);
			}
			return null;
		}
		
		public function clearNavigationHistory(): void {
			_navigationHistory = new Array();
			_currentNavigIndex = -1;
		}
		
		private function addHistoryState(value: String): void {
			_currentNavigIndex++;
//			удалить хвост
			_navigationHistory.splice(_currentNavigIndex, _navigationHistory.length - _currentNavigIndex);
//			добавить элемент
			_navigationHistory.push(value);
//			удалить излишек вначале
			if (_navigationHistory.length > HISTORY_MAX_SIZE) {
				_navigationHistory.splice(0, 1);
			}
		}
	}
}