package com.flashmedia.gui
{
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;

	public class MessageBox extends GameLayer
	{
		protected var _message:String;
		protected var _cancelButton:Button;
		protected var _otherButton:Button;
		
		public function MessageBox(value:GameScene, message:String, cancelButton:Button, otherButton:Button=null)
		{
			super(value);
			this.message = message;
			this.width = 200;
			this.height = 100;
			this.x = (_scene.stage.stageWidth - this.width) / 2;
			this.y = (_scene.stage.stageHeight - this.height) / 2;
			
			_cancelButton = cancelButton;
			_otherButton = otherButton;
			
			
			if (_cancelButton) {
				_cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelButtonClicked);
				addChild(_cancelButton);
			}
			
			if (_otherButton) {
				_otherButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onOtherButtonClicked);
				addChild(_otherButton);
			}
			
			fillBackground(0xff0000, 1.0);
		}
		
		public override function destroy(): void {
			if (_cancelButton) removeChild(_cancelButton);
			
			super.destroy();
		}
		
		public function set message(message:String):void {
			_message = message;
		}
		public function get message():String {
			return _message;
		}
		
		public function show():void {
			_scene.showModal(this);
		}
		
		private function onCancelButtonClicked(e:GameObjectEvent):void {
			_scene.resetModal(this);
			dispatchEvent(new MessageBoxEvent(MessageBoxEvent.CANCEL_BUTTON_CLICKED));
		}
		
		private function onOtherButtonClicked(e:GameObjectEvent):void {
			_scene.resetModal(this);
			dispatchEvent(new MessageBoxEvent(MessageBoxEvent.OTHER_BUTTON_CLICKED));
		}
	}
}