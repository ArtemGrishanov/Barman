package com.bar.ui.tooltips
{
	import com.flashmedia.basics.GameScene;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ProductionToolTip extends ToolTip
	{
		public static const NAME_TF_Y: Number = 8;
		public static const PARTS_TF_Y: Number = 20;
		
		private var nameTf: TextField;
		private var partsCountTf: TextField;
		
		public function ProductionToolTip(value:GameScene, w:Number, h:Number)
		{
			super(value, w, h);
			nameTf = new TextField();
			nameTf.y = NAME_TF_Y;
			nameTf.text = '';
			nameTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(nameTf);
			partsCountTf = new TextField();
			partsCountTf.y = PARTS_TF_Y;
			partsCountTf.text = '';
			partsCountTf.autoSize = TextFieldAutoSize.LEFT;
			addChild(partsCountTf);
		}
		
		public function setAttrs(name: String, partsCount: int): void {
			nameTf.text = name;
			partsCountTf.text = 'Порций: ' + partsCount.toString();
			nameTf.x = (width - nameTf.width) / 2;
			partsCountTf.x = (width - partsCountTf.width) / 2;
			super.update();
		}
	}
}