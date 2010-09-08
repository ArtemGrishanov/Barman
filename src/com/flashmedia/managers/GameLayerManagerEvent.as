package com.flashmedia.managers
{
	import flash.events.Event;
	
	import com.flashmedia.basics.GameLayer;

	public class GameLayerManagerEvent extends Event
	{
		public static const TYPE_LAYER_SHOWED: String = 'type_layer_showed';
		public static const TYPE_LAYER_HIDED: String = 'type_layer_hided';
		public static const TYPE_LAYER_ADDED: String = 'type_layer_added';
		
		private var _gameLayer: GameLayer;
		
		public function GameLayerManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set gameLayer(value: GameLayer): void {
			_gameLayer = value;
		}
		
		public function get gameLayer(): GameLayer {
			return gameLayer;
		}
	}
}