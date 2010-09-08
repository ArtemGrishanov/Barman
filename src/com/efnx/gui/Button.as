/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.gui
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	/**
	 *	Button is a simple button with three images and four actions: over, down, up and out.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Schell Scivally
	 *	@since  2008-07-24
	 */
	public class Button extends Sprite 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var _bmds : Array = new Array();
		private var _bm:Bitmap = new Bitmap();
		private var _dwnBf:Boolean = false;
		private var _prs:Boolean = false;
		private var _center:String = "TL";
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	*	Reference to the function to be performed on roll over.
	 	*/
		public var overFunction:Function;
		/**
	 	*	Reference to the function to be performed on mouse down.
	 	*/
		public var downFunction:Function;
		/**
	 	*	Reference to the function to be performed on mouse up.
	 	*/
		public var upFunction:Function;
		/**
	 	*	Reference to the function to be performed on roll out.
	 	*/
		public var outFunction:Function;
		/**
	 	*	A <code>BitmapData</code> object specifying the bounds of the button.
	 	*	Two BitmapData given for each up/over/down state could be different
	 	*	sizes, so the guide will be the deciding bound.
	 	*/
		public var guide:BitmapData;
		/**
	 	*	Toggles verbose output.
	 	*/
		public static var testing:Boolean = false;
		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/**
		 *	@Constructor
		 */
		public function Button():void
		{
			super();
			if(testing) trace("Button::constructor() ");
			addChild(_bm);
			buttonMode = true;
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Returns whether or not the Button is initialized and
	 	 *	contains references to bitmapData.
	 	 */
		public function get initialized():Boolean
		{
			if(up == null) return false;
			if(over == null) return false;
			if(down == null) return false;
			return true;
		}
		/**
	 	*	The <code>BitmapData</code> object to represent the button in the normal or "up" position.
	 	*/
		public function set up( arg:BitmapData ) : void 
		{  
			if(testing) trace("Button::up() " );
			if(_bmds.length == 0)
			{
				if(testing) trace("	up() pushing _bm.bitmapData into all slots." );
				_bm.bitmapData = arg;
				addListeners();
				var len:int = 3;
				for (var i:int = 0; i<len; i++)
				{
					_bmds.push(arg);
				}
			}else
			{
				_bmds[0] = arg;
			}
			center();
		}
		/**
	 	*	The <code>BitmapData</code> object to represent the button in the normal or "up" position.
	 	*/
		public function get up() : BitmapData 
		{ 
			return _bmds[0]; 
		}
		/**
	 	*	The <code>BitmapData</code> object to represent the button in the over position.
	 	*/
		public function set over( arg:BitmapData ) : void 
		{ 
			if(testing) trace("Button::over() " );
			if(_bmds.length == 0)
			{
				if(testing) trace("	over() pushing _bm.bitmapData into all slots.");
				_bm.bitmapData = arg;
				addListeners();
				var len:int = 3;
				for (var i:int = 0; i<len; i++)
				{
					_bmds.push(arg);
				}
			}else
			{
				_bmds[1] = arg;
			}
			center();
		}	
		/**
		 *	The <code>BitmapData</code> object to represent the button in the over position.
		 */
		public function get over() : BitmapData 
		{ 
			return _bmds[1]; 
		}
		/**
	 	*	The <code>BitmapData</code> object to represent the button in the down position.
	 	*/
		public function set down( arg:BitmapData ) : void 
		{ 
			if(testing) trace("Button::down() " );
			if(_bmds.length == 0)
			{
				if(testing) trace("	down() pushing _bm.bitmapData into all slots.");
				_bm.bitmapData = arg;
				addListeners();
				var len:int = 3;
				for (var i:int = 0; i<len; i++)
				{
					_bmds.push(arg);
				}
			}else
			{
				_bmds[2] = arg;
			} 
			center();
		}
		/**
	 	*	The <code>BitmapData</code> object to represent the button in the down position.
	 	*/
		public function get down() : BitmapData 
		{ 
			return _bmds[2]; 
		}
		/**
		*	@inheritDoc
		*/
		public override function get width():Number
		{
			if(guide != null) return guide.width;
			if(_bmds.length == 0) return 0;
			var w:Number = up.width > over.width ? up.width : over.width;
				w = w > down.width ? w : down.width;
				
			return w;
		}
		/**
		*	@inheritDoc
		*/
		public override function set width(val:Number):void
		{
			var w:Number = width;
			var scale:Number = val/width;
			scaleX = scale;
		}
		/**
	 	*	@inheritDoc
		*/
		public override function get height():Number
		{
			if(guide != null) return guide.height;
			if(_bmds.length == 0) return 0;
			var h:Number = up.height > over.height ? up.height : over.height;
				h = h > down.height ? h : down.height;
				
			return h;
		}
		/**
	 	*	@inheritDoc
		*/
		public override function set height(val:Number):void
		{
			var h:Number = height;
			var scale:Number = val/height;
			scaleY = height;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	*	Destroys all internal references.
	 	*/
		public function destroy():void
		{
			if(_bmds.length > 0)
			{
				_bmds[0].dispose();
				_bmds[1].dispose();
				_bmds[2].dispose();
			}
			if(guide != null) guide.dispose();
			_bmds.splice(0, 3);
		}
		/**
		*	Returns a clone of the given Button instance.
		*	
		*	@return Button instance.
		*/
		public function clone():Button
		{
			var newb:Button = new Button();
				newb.guide = guide == null ? null : guide.clone();
				newb.up = up == null ? null : up.clone();
				newb.over = over == null ? null : over.clone();
				newb.down = down == null ? null : down.clone();
				newb.upFunction = upFunction;
				newb.overFunction = overFunction;
				newb.downFunction = downFunction;
				newb.outFunction = outFunction;
				return newb;
		}
		/**
	 	*	Inherits the skin [or bitmapdata and guide] as well as optionally the 
	 	*	action functions of the <code>parent</code> Button. This is much like
	 	*	the <code>clone</code> function, but instead of creating a new Button
	 	*	instance and returning it, it populates the calling Button instance
	 	*	with the bitmapdata and guide of the Button passed in the parameters.
	 	*	
	 	*	@param parent	The parent Button to inherit from.
	 	*	@parem inheritFunctions	Boolean value dictating whether or not to inherit the
	 	*	action functions of the <code>parent</code> Button.
	 	*/
		public function inheritSkin(parent:Button, inheritFunctions:Boolean = false):void
		{
			this.guide	= parent.guide;
			this.up   	= parent.up;   
			this.over 	= parent.over; 
			this.down 	= parent.down; 
			if(!inheritFunctions) return
			this.upFunction		= parent.upFunction;
			this.overFunction 	= parent.overFunction;
			this.downFunction 	= parent.downFunction;
			this.outFunction  	= parent.outFunction;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		private function mouseOverHandler(event:MouseEvent) : void 
		{
			var s:Boolean = _bm.smoothing;
			if(testing) trace("Button::mouseOverHandler() " );
			if(event.buttonDown && !_prs) _dwnBf = true;
			_bm.bitmapData = _bmds[1];
			_bm.smoothing = s;
			center();
			if(overFunction != null) overFunction(event);
		}
		private function mouseDownHandler(event:MouseEvent) : void 
		{
			var s:Boolean = _bm.smoothing;
			if(testing) trace("Button::mouseDownHandler() " );
			stage.addEventListener("mouseUp", mouseUpHandler, false, 0, true);
			_bm.bitmapData = _bmds[2];
			_bm.smoothing = s;
			_prs = true;
			_dwnBf = false;
			center();
			if(downFunction != null) downFunction(event);
		}
		private function mouseUpHandler(event:MouseEvent) : void 
		{
			var s:Boolean = _bm.smoothing;
			if(testing) trace("Button::mouseUpHandler() " );
			stage.removeEventListener("mouseUp", mouseUpHandler);
			_bm.bitmapData = event.target == this ? _bmds[1] : _bmds[0];
			_bm.smoothing = s;
			_prs = false;
			center();
			if(upFunction != null) upFunction(event);
		}
		private function mouseOutHandler(event:MouseEvent) : void 
		{
			var s:Boolean = _bm.smoothing;
			if(testing) trace("Button::mouseOutHandler() " );
			if(!event.buttonDown || _dwnBf) 
			{
				_bm.bitmapData = _bmds[0];
				_dwnBf = false;
			}
			_bm.smoothing = s;
			center();
			if(outFunction != null) outFunction(event);
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		private function addListeners():void
		{
			if(testing) trace("Button::addListeners() " );
			addEventListener("mouseOver", mouseOverHandler, false, 0, true);
			addEventListener("mouseDown", mouseDownHandler, false, 0, true);
			addEventListener("mouseOut", mouseOutHandler, false, 0, true);
		}
		/**
		*
		*/
		private function center():void
		{
			_bm.x = width/2 - _bm.width/2;
			_bm.y = height/2 - _bm.height/2;
		}
	}
	
}
