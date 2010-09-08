/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *	TileBar is a bar that tiles in x or y.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Schell Scivally
	 *	@since  24.07.2008
	 */
	public class TileBar extends Bitmap 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var bmdArray:Array = new Array();
		private var _direction:String = "horizontal";
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Sets verbose output.
	 	 */
		public static var testing:Boolean = false;
		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/**
		 *	@Constructor
		 *	Creates a new instance of TileBar.
		 */
		public function TileBar(_left:BitmapData = null, _middle:BitmapData = null, _right:BitmapData = null):void
		{
			super();
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Returns whether or not the TileBar is initialized and
	 	 *	contains references to bitmapData.
	 	 */
		public function get initialized():Boolean
		{
			if(left == null) return false;
			if(middle == null) return false;
			if(right == null) return false;
			return true;
		}
		/**
	 	 *	Sets the middle <code>BitmapData</code> object. This is the <code>BitmapData</code> that
	 	 *	will be tiled.
	 	 */
		public function set middle(bmd:BitmapData):void
		{
			var len:int = bmdArray.length;
			switch(len)
			{
				case 0:
					var len2:int = 3;
					for (var i:int = 0; i<len2; i++)
					{
						bmdArray.push(bmd);
					}
					break;
				default:
					bmdArray[1] = bmd;
					break;
			}
			direction = _direction;
		}
		public function get middle():BitmapData
		{
			return bmdArray[1];
		}
		/**
		*	Sets the left <code>BitmapData</code> object, this will appear to the left
		*	of the tiling.
		*/
		public function set left(bmd:BitmapData):void
		{
			var len:int = bmdArray.length;
			switch(len)
			{
				case 0:
					var len2:int = 3;
					for (var i:int = 0; i<len2; i++)
					{
						bmdArray.push(bmd);
					}
					break;
				default:
					bmdArray[0] = bmd;
					break;
			}
			direction = "horizontal";
		}
		public function get left():BitmapData
		{
			return bmdArray[0];
		}
		/**
		*	Sets the right <code>BitmapData</code> object, this will appear to the right
		*	of the tiling.	
		*/
		public function set right(bmd:BitmapData):void
		{
			var len:int = bmdArray.length;
			switch(len)
			{
				case 0:
					var len2:int = 3;
					for (var i:int = 0; i<len2; i++)
					{
						bmdArray.push(bmd);
					}
					break;
				default:
					bmdArray[2] = bmd;
					break;
			}
			direction = "horizontal";
		}
		public function get right():BitmapData
		{
			return bmdArray[2];
		}
		/**
		*	Sets the top <code>BitmapData</code> object, this will appear above
		*	the tiling. The <code>direction</code> will automatically be converted.
		*	
		*	@see #direction
		*/
		public function set top(bmd:BitmapData):void
		{
			left = bmd;
			direction = "vertical";
		}
		public function get top():BitmapData
		{
			return bmdArray[0];
		}
		/**
		*	Sets the bottom <code>BitmapData</code> object, this will appear below
		*	the tiling. The <code>direction</code> will automatically be converted.
		*	
		*	@see #direction
		*/
		public function set bottom(bmd:BitmapData):void
		{
			right = bmd;
			direction = "vertical";
		}
		public function get bottom():BitmapData
		{
			return bmdArray[2];
		}
		/**
		*	
		*/
		public function get direction():String
		{
			return _direction;
		}
		/**
		 *	Sets the direction of tiling. Either "horizontal" or "vertical" are valid values.
		 */
		public function set direction(string:String):void
		{
			if(string != "horizontal" && string != "vertical") throw new Error("TileBar::set direction() Not a valid direction.");
			_direction = string;
			renderBitmapData();
		}
		/**
		*	@inheritDoc
		*/
		public override function set width(val:Number):void
		{
			if(direction == "vertical") 
			{
				super.width = val;
				return;
			}
			visible = !(isNaN(val) || val < 1);
			val = visible ? val : 1;
			var w:int = val;
			var lrw:int = left.width + right.width;
			var lw:int = w < lrw ? left.width/lrw * w : left.width;
			var rw:int = w < lrw ? right.width/lrw * w : right.width;
			var endPoint:int = w - rw;
			var startPoint:int = lw;
			var len:int = Math.ceil((endPoint - startPoint)/middle.width);
			bitmapData = new BitmapData(w, left.height, true, 0x00FFFFFF);
			bitmapData.lock();
			bitmapData.copyPixels(left, new Rectangle(0, 0, lw, left.height), new Point(0, 0));
			for (var i:int = 0; i<len && w > lrw; i++)
			{
				bitmapData.copyPixels(middle, new Rectangle(0, 0, middle.width, middle.height), new Point(startPoint+i*middle.width, 0));
			}
			bitmapData.copyPixels(right, new Rectangle(right.width-rw, 0, rw, right.height), new Point(endPoint, 0));
			if(w < lrw && lw + rw + 1 == w)
				bitmapData.copyPixels(right, new Rectangle(right.width-rw, 0, 1, right.height), new Point(rw, 0));
			bitmapData.unlock();
		}
		/**
		*	@inheritDoc
		*/
		public override function set height(val:Number):void
		{
			if(direction == "horizontal") 
			{
				super.height = val;
				return;
			}	
			visible = !(isNaN(val) || val < 1);
			val = visible ? val : 1;
			var h:int = val;
			var tbh:int = top.height + bottom.height;
			var th:int = h < tbh ? top.height/tbh * h : top.height;
			var bh:int = h < tbh ? bottom.height/tbh * h : bottom.height;
			var endPoint:int = h - bh;
			var startPoint:int = th;
			var len:int = Math.ceil((endPoint - startPoint)/middle.height);
			bitmapData = new BitmapData(top.width, h, true, 0x00FFFFFF);
			bitmapData.lock();
			bitmapData.copyPixels(top, new Rectangle(0, 0, top.width, th), new Point(0, 0));
			for (var i:int = 0; i<len && h > tbh; i++)
			{
				bitmapData.copyPixels(middle, new Rectangle(0, 0, middle.width, middle.height), new Point(0, startPoint+i*middle.height));
			}
			bitmapData.copyPixels(bottom, new Rectangle(0, bottom.height-bh, bottom.width, bh), new Point(0, endPoint));
			if(h < tbh && th + bh + 1 == h)
				bitmapData.copyPixels(bottom, new Rectangle(0, bottom.height-bh, bottom.width, 1), new Point(0, bh));
			bitmapData.unlock();
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Chops one <code>BitmapData</code> object into three chunks and uses each as left, middle and right 
	 	 *	or top, middle and bottom.
	 	 *	@param bmd The <code>BitmapData</code> object to use.
	 	 *	@param _left The width of the left chunk. AKA - The amount to chop off <code>bmd</code> to 
	 	 *		   make the left or top <code>BitmapData</code> object.
	 	 *	@param _middle The width of the middle chunk. AKA - The amount to chop off <code>bmd</code> to 
	 	 *		   make the middle <code>BitmapData</code> object.
	 	 *	@param _right The width of the right chunk. AKA - The amount to chop off <code>bmd</code> to 
	 	 *		   make the right or bottom <code>BitmapData</code> object.
	 	 *	
	 	 *	If <code>_middle</code> and <code>_right</code> are omitted, <code>bmd</code> will be chopped according
	 	 *	to <code>_left</code>.
	 	 */
		public function chopAndUse(bmd:BitmapData, _left:int, _middle:int = 0, _right:int = 0):void
		{
			_middle = _middle == 0 ? _left : _middle;
			_right = _right == 0 ? _left : _right;
			
			var w1:int; var w2:int; var w3:int;
			var h1:int; var h2:int; var h3:int;
			
			var px1:int = 0; var px2:int = 0; var px3:int = 0;
			var py1:int = 0; var py2:int = 0; var py3:int = 0;
			
			if(direction == "horizontal")
			{
				w1 = _left; 	h1 = bmd.height;
				w2 = _middle; 	h2 = bmd.height;
				w3 = _right; 	h3 = bmd.height;
				
				px1 = 0; 
				px2 = w1;
				px3 = w1+w2;
				py1 = 0;
				py2 = 0;
				py3 = 0;
			}else
			{
				h1 = _left; 	w1 = bmd.height;
				h2 = _middle; 	w2 = bmd.height;
				h3 = _right; 	w3 = bmd.height;
				
				px1 = 0;
				px2 = 0;
				px3 = 0;
				py1 = 0;
				py2 = h1;
				py3 = h1+h2;
			}
			
			var l:BitmapData = new BitmapData(w1, h1, true, 0x00FFFFFF);
			var m:BitmapData = new BitmapData(w2, h2, true, 0x00FFFFFF);
			var r:BitmapData = new BitmapData(w3, h3, true, 0x00FFFFFF);
			
			var rect1:Rectangle = new Rectangle(px1, py1, w1, h1);
			var rect2:Rectangle = new Rectangle(px2, py2, w2, h2); 
			var rect3:Rectangle = new Rectangle(px3, py3, w3, h3);
			
			if(testing) trace("TileBar::chopAndUse() " + rect1, rect2, rect3); 
			                                                      
			l.copyPixels(bmd, rect1, new Point(0, 0));
			m.copyPixels(bmd, rect2, new Point(0, 0));
			r.copyPixels(bmd, rect3, new Point(0, 0));
			
			left = l;
			middle = m;
			right = r;
		}
		/**
	 	 *	Clones the TileBar.
	 	 */
		public function clone():TileBar
		{
			var tb:TileBar = new TileBar();
				tb.left = left.clone();
				tb.middle = middle.clone();
				tb.right = right.clone();
				tb.direction = direction;
				tb.width = width;
				tb.height = height;
				
			return tb;
		}
		/**
	 	*	Inherits the skin [or bitmapdata] of the <code>parent</code> TileBar. 
	 	*	This is much like the <code>clone</code> function, but instead of 
	 	*	creating a new TileBar instance and returning it, it populates the 
	 	*	calling TileBar instance with the bitmapdata of the TileBar 
	 	*	passed in the parameters.
	 	*	
	 	*	@param parent	The parent TileBar to inherit from.
	 	*/
		public function inheritSkin(parent:TileBar):void
		{
			this.left 		= parent.left;
			this.middle 	= parent.middle;
			this.right 		= parent.right;
			this.direction 	= parent.direction;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		private function renderBitmapData():void
		{
			if(testing) trace("TileBar::renderBitmapData() " + super.width, super.height);
			width = super.width;
			height = super.height;
		}
	}
	
}
