/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.time {
	
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.system.System;
	
	/**
	 *	FPSBox is a box with fps.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Schell Scivally
	 *	@since  14.04.2008
	 */
	public class FPSBox extends TextField 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var frame:uint = 0;
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/

		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/**
		 *	@Constructor
		 */
		public function FPSBox():void
		{
			super();
			textColor = 0xFF0000;
			autoSize = "left";
			addEventListener("enterFrame", everyFrame, false, 0, true);
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		public function deconstruct():void
		{
			removeEventListener("enterFrame", everyFrame);
			delete this;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		private function everyFrame(event:Event):void
		{
			frame++;
			var time:Number = getTimer()/1000;
			text = int(frame/time) + " FPS, " + Number(System.totalMemory/1000000).toPrecision(3) + " MB";
		}
	}
	
}
