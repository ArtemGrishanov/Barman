package com.efnx {

	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.gui.Button;
	import com.efnx.net.MultiLoader;
	import com.efnx.time.FPSBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
/**
 *	Application entry point for UpdatedTools post.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Schell Scivally
 *	@since 18.08.2008
 */
public class UpdatedTools extends Sprite {
	
	public static const testing:Boolean = false;
	
	public var button:Button = new Button();
	public var multiLoader:MultiLoader = new MultiLoader();
	
	/**
	 *	@constructor
	 */
	public function UpdatedTools(stage: Stage)
	{
		super();

		stage.frameRate = 30;
		stage.scaleMode = "noScale";
		stage.align = "TL";
		stage.addEventListener("resize", resize, false, 0, true);
		
		// bitmapData of buttons "up" state
		var bmd_up:BitmapData = new BitmapData(50, 20, true, 0xFFBDE052);
		// bitmapData of buttons "over" state
		var bmd_over:BitmapData = new BitmapData(50, 20, true, 0xFF52C4E0);
		// bitmapData of buttons "down" state
		var bmd_down:BitmapData = new BitmapData(50, 20, true, 0xFFFFAF1A);
		
		button.x = 20;
		button.y = 20;
		// we pass our bitmapData to the button, one for each state. if only one bitmapData is supplied, it will be
		// copied to each state, after which each new bitmapData supplied will replace the first for the state 
		// specified. 
		button.up = bmd_up;
		button.over = bmd_over;
		button.down = bmd_down;
		
		// we supply functions to the buttons function references, if no functions are supplied, no functions will be called.
		button.overFunction = function():void{trace("UpdatedTools::UpdatedTools()", "button over");};
		button.downFunction = function():void{trace("UpdatedTools::UpdatedTools()", "button down");};
		button.upFunction = function():void{trace("UpdatedTools::UpdatedTools()", "button up");};
		button.outFunction = function():void{trace("UpdatedTools::UpdatedTools()", "button out");};
		
		addChild(button);
		
		// adding a label is as simple as creating a textfield and adding it to the button.
		var label:TextField = new TextField();
			label.textColor = 0xDDD4F7;
			label.mouseEnabled = false;
			label.text = "Button";
			label.autoSize = "left";
			label.x = button.width/2 - label.width/2;
			label.y = button.height/2 - label.height/2;
			
		button.addChild(label);
		
		var fps:FPSBox = new FPSBox();
		addChild(fps);
		
		MultiLoader.testing = true;
		MultiLoader.usingContext = true;
		
		multiLoader.load("http://www.efnx.com/images/experiment.gif", "efnx", "Bitmap");
		multiLoader.load("http://www.efnx.com/images/808.jpg", "808", "Sprite");
		multiLoader.addEventListener("progress", progress, false, 0, true);
		multiLoader.addEventListener("complete", complete, false, 0, true);
	}
	
	private function progress(event:MultiLoaderEvent):void
	{
		trace("UpdatedTools::progress()", event.entry, ": ", (event.bytesLoaded/event.bytesTotal*100));
	}
	private function complete(event:MultiLoaderEvent):void
	{
		trace("UpdatedTools::complete()");
		switch(event.entry)
		{
			case "efnx":
				var efnxBitmap:Bitmap = multiLoader.get("efnx");
					efnxBitmap.x = button.x + button.width + 10;
					efnxBitmap.y = button.y;
				addChild(efnxBitmap);
				break;
			case "808":
				var sprite808:Sprite = multiLoader.get("808");
					sprite808.x = button.x;
					sprite808.y = button.y + button.height + 20;
				addChild(sprite808);
				break;
			default:
		}
	}
	
	/**
	 *	Resize stub.
	 */
	private function resize(event:Event):void
	{
		if(testing) trace( "UpdatedTools::resize()" );
	}
	
}

}
