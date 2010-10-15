package com.bar.ui.tooltips
{
	import com.bar.util.Images;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ProductionToolTip extends ToolTip
	{
		public static const NAME_TF_Y: Number = 7;
		public static const PARTS_TF_Y: Number = 23;
		
		private var nameTf: TextField;
		private var partsCountTf: TextField;
		
		public function ProductionToolTip(value:GameScene)
		{
			super(value);
			bitmapPointerDown = BitmapUtil.cloneBitmap(Bar.multiLoader.get(Images.HINT_UP1));
			nameTf = new TextField();
			nameTf.y = NAME_TF_Y;
			nameTf.text = '';
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			nameTf.defaultTextFormat = new TextFormat("Arial", 14);
			contentArea.addChild(nameTf);
			partsCountTf = new TextField();
			partsCountTf.y = PARTS_TF_Y;
			partsCountTf.text = '';
			partsCountTf.autoSize = TextFieldAutoSize.LEFT;
			partsCountTf.defaultTextFormat = new TextFormat("Arial", 14);
			contentArea.addChild(partsCountTf);
		}
		
		public function setAttrs(name: String, partsCount: int): void {
			nameTf.text = name;
			partsCountTf.text = 'Порций: ' + partsCount.toString();
			nameTf.x = (contentArea.width - nameTf.width) / 2;
			partsCountTf.x = (contentArea.width - partsCountTf.width) / 2;
			super.update();
		}
	}
}