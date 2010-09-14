package com.bar.ui
{
	import com.bar.model.Balance;
	import com.bar.model.essences.Client;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class UIClient extends GameLayer
	{
		public static const MOOD_ICONS_BOTTOM_INDENT: Number = 170;
		public static const MOOD_ICONS_BETWEEN_INDENT: Number = 3;
		
		private var client: Client;
		private var mood: int;
		private var moodIcons: Array;
		
		public function UIClient(value: GameScene)
		{
			super(value);
			this.mood = 0;
			setSelect(true);
			setFocus(true, false);
			setHover(true, false);
			moodIcons = new Array(Balance.maxClientMood);
			for (var i: int = 0; i < Balance.maxClientMood; i++) {
				var moodIcon: GameObject = new GameObject(scene);
				moodIcon.bitmap = new Bitmap(new BitmapData(10, 10, false, 0xdd0a0f));
				moodIcons[i] = moodIcon;
				addChild(moodIcon);
			}
//			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onClientMouseClick);
//			go.addEventListener(GameObjectEvent.TYPE_LOST_FOCUS, onClientLostFocus);
//			go.addEventListener(GameObjectEvent.TYPE_SET_HOVER, onClientSetHover);
//			go.addEventListener(GameObjectEvent.TYPE_LOST_HOVER, onClientLostHover);
		}
		
		public function set clientUser(c: Client): void {
			client = c;
			x = UIBarPlace.CLIENT_SIT_CENTER_X[c.position] + client.typeClient.dx;
			y = UIBarPlace.CLIENT_SIT_Y + client.typeClient.dy;
			moodClient = client.mood;
			id = client.id;
			client.typeClient.bitmap.transform = 
			bitmap = BitmapUtil.cloneBitmap(client.typeClient.bitmap);
//			var t: TextField = new TextField();
//			t.text = c.typeClient.type;
//			t.autoSize = TextFieldAutoSize.LEFT;
//			setTextField(t);
			//todo fix 10
			var allIconsWidth: Number = Balance.maxClientMood * 10 + (Balance.maxClientMood - 1) * MOOD_ICONS_BETWEEN_INDENT;
			var xx: Number = (width - allIconsWidth) / 2;
			for each (var moodIcon: GameObject in moodIcons) {
				moodIcon.x = xx;
				moodIcon.y = -client.typeClient.dy - MOOD_ICONS_BOTTOM_INDENT - moodIcon.height;
				xx += MOOD_ICONS_BETWEEN_INDENT + moodIcon.width;
			}
		}
		
		public function set moodClient(value: int): void {
			var i: int = 0;
			for each (var moodIcon: GameObject in moodIcons) {
				moodIcon.visible = !(i >= value);
				i++;
			}
		}
	}
}