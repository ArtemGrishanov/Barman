//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2008 efnx.com
// 
////////////////////////////////////////////////////////////////////////////////

package com.efnx.events {

import flash.events.ProgressEvent;
import flash.events.Event;

/**
 *	MultiLoaderEvent is an event that holds the ProgressEvent of
 *	many files being downloaded asynchronously.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0
 *
 *	@author Schell Scivally
 *	@since  13.11.2008
 */
public class MultiLoaderEvent extends ProgressEvent {
	
	//--------------------------------------
	// CLASS CONSTANTS
	//--------------------------------------
	/**
	 *	Defines the value of the type property of a MultiLoaderEvent event object.
	 */
	public static const PROGRESS:String = "progress";
	/**
	 *	Defines the value of the type property of a MultiLoaderEvent event object.
	 */
	public static const COMPLETE:String = "complete";
	/**
	 *	The name of the entry that the event pertains to.
	 */
	public var entry:String = "";
	//--------------------------------------
	//  CONSTRUCTOR
	//--------------------------------------
	
	/**
	 *	@constructor
	 */
	public function MultiLoaderEvent( type:String, bubbles:Boolean=true, cancelable:Boolean=false )
	{
		super(type, bubbles, cancelable);
	}
	
	//--------------------------------------
	//  GETTER/SETTERS
	//--------------------------------------
	
	//--------------------------------------
	//  PUBLIC METHODS
	//--------------------------------------

	public override function clone():Event
	{
		var event:MultiLoaderEvent = new MultiLoaderEvent(type, bubbles, cancelable);
			event.entry = entry;
		return event;
	}
	
	//--------------------------------------
	//  EVENT HANDLERS
	//--------------------------------------
	
	//--------------------------------------
	//  PRIVATE VARIABLES
	//--------------------------------------
	
	//--------------------------------------
	//  PRIVATE & PROTECTED INSTANCE METHODS
	//--------------------------------------
	
}

}

