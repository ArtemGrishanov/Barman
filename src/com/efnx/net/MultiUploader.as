/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.net 
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 *	When uploads are finished an event will be dispatched which event type is the name
	 *	of the file that has completed it's upload. For example, if one uploads a file and
	 *	designates it's <code>entryName</code> as "FileOne" then the event type of it's complete
	 *	event will be "FileOne."
	 *	@eventType flash.events.Event
	 */
	[Event(name="filename", type="flash.events.Event")]
	
	/**
	 * 	MultiUploader allows the user to upload multiple files as ByteArrays asyncronously. 
	 *	
	 *	Use of this class requires efnx.net.Uploader.
	 *
	 * 	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@see http://blog.efnx.com
	 *	
	 *	@author Schell Scivally
	 * 	@since  08.06.2008
	 */	
	
	public class MultiUploader extends EventDispatcher 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/

		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var list:Object = new Object();
		private var loaded:Object = new Object();
		private var unloader:Object = new Object();
		private var count:int = 0;
		private var testing:Boolean;
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/

		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
		 *	@constructor
		 *	@param _testing Sets verbose output.
		 */
		public function MultiUploader(_testing:Boolean = false):void
		{
			super();
			testing = _testing;
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Tells whether all uploads have completed.
	 	 */
		public function get isLoaded():Boolean 
		{	
			//if there are no objects, return false
			if(count < 1) return false;
			//if any object are not loaded return false
			for(var key:Object in list)
			{
				if(!loaded[list[key]]) return false;
			}
			
			return true;
			
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
		*	Uploads a ByteArray to a given location and stores the data retrieved from that location.
		*	Data can be retrieved from the uploader using the <code>get</code> function.
		*	
		*	@param byteArray A ByteArray containing the encoded file to upload.
		*	@param location A String URL denoting the save path.
		*	@param entryName The name under which to store retrieved data.
		*	@param variables The post variables object to send with the file.
		*	
		*	@see #get() 
		*	@see flash.net.URLLoader#dataFormat
		*		
		*/
		public function upload(byteArray:ByteArray, location:String, entryName:String = "", variables:Object = null):void
		{
			if(entryName == "") entryName = "file_"+count;
			count++;
			
			var uploader:Uploader = new Uploader();
				uploader.file = byteArray;
				uploader.url = location;
				uploader.filename = entryName;
				uploader.variables = variables;
				uploader.addEventListener("ioError", onError, false, 0, true);
				uploader.addEventListener("complete", onComplete, false, 0, true);
		
			list[entryName]	= uploader;	
			loaded[entryName] = false;
			
			uploader.upload();
		}
		/**
		*	Unloads a given resource.
		*	@param entryName Name of resource to unload.
		*/
		public function unload(entryName:String):void
		{
			delete list[entryName];
			delete loaded[entryName];
			list[entryName] = null;
			loaded[entryName] = null;
			
			count--;
		}
		/**
		*	Unloads all resources.	
		*/
		public function unloadAll():void
		{
			for(var key:Object in list)
			{	
				unload(key.toString());
			}
		}
		/**
		*	Retrieves the data collected from an upload operation.
		*	@param entryName The name of the upload to retrieve data from.
		*/
		public function get(entryName:String):*
		{
			if(!loaded[entryName]) throw new Error("MultiUploader::ERROR get() " + entryName + " has not fully loaded.");
			return list[entryName];
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		private function onError(event:IOErrorEvent):void
		{
			trace("MultiUploader::onError() " + event);
		}
		/**
		*	
		*/
		private function onComplete(event:Event):void
		{
			if(testing)	trace("MultiUploader::onComplete() " + event.target, event.target.data);
			list[event.target.filename] = event.target.data;
			loaded[event.target.filename] = true;
			dispatchEvent(new Event(event.target.filename));
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		
	}
	
}
