/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.net 
{
	
	import flash.utils.Dictionary;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	
	import efnx.events.MultiURLEvent;
	
	/**
	 *	MultiURLLoader is a loader that loads multiple binary things or variables.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Schell Scivally
	 *	@since  06.04.2008
	 */
	public class MultiURLLoader extends EventDispatcher 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var list:Dictionary = new Dictionary(true);
		private var loaded:Dictionary = new Dictionary(true);
		private var count:int = 0;
		private var format:String = "text";
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/

		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/**
		 *	@Constructor
		 */
		public function MultiURLLoader()
		{
			super();
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
		 *	Returns the number of resources listed.
		 */
		public function get length():int
		{
			return count;
		}
		/**
		 *	Returns whether or not all resources are loaded.
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
		/**
	 	 *	The format of the return data.
		 *	@see flash.net.URLLoader#dataFormat
		 */
		public function get dataFormat():String
		{
			return format;
		}
		public function set dataFormat(str:String):void
		{
			format = str;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Starts the loading of a resource.
	 	 *	@param path The path to the resource to load.
	 	 *	@param entryName Then name of the resource to use in retrieval.
	     */ 
		public function load(path:String, entryName:String = ""):void
		{			
			/*just in case no name is included*/
			if(entryName == "") entryName = "Data";
			/*just in case the included name is taken, so we don't replace the resource*/
			if(list[entryName] != undefined) entryName += length.toString();
			
			loadFromPath(String(path), entryName);
			count++;
		}
		/**
		 *	Unloads a given resource.
		 *	@param entryName The name of the resource to unload.
		 */
		public function unload(entryName:String):void
		{
			if(entryName == "")
			{
				throw new Error("MultiURLLoader:ERROR #3: must specify a resource to unload.");
			}
			
			count--;
			list[entryName] = null;
			delete list[entryName];
			delete loaded[entryName];
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
	 	 *	Retrieves a resource.
	 	 *	@param entryName Then name of the resource to retrieve.
		 */
		public function get(entryName:String):*
		{
			if(list[entryName] == null) throw new Error("MultiURLLoader::ERROR #6 resource \"" + entryName + "\" does not exist.\n\n" + this);
			if(loaded[list[entryName]])
			{
				return list[entryName];
			}else
			{
				throw new Error("MultiURLLoader::ERROR #7 resource " + entryName + " not loaded.");
			}
		}
		/**
	 	 *	@inheritDoc
	 	 */
		public override function toString():String
		{
			var string:String = "MultiURLLoader: \n";
			for(var key:Object in list)
			{
				string += "	" + key + " => (" + list[key] + ")\n		loaded[" + key + "] => (" + loaded[list[key]] + ")\n";
				
			}
			
			return string;
		}
		/**
	 	 *	Returns whether or not a given resource has loaded.
	 	 *	@param entryName Then name of the resource.
		 */
		public function hasLoaded(entryName:String = ""):Boolean
		{
			if(list[entryName] == null) throw new Error("MultiURLLoader::ERROR #5 resource \"" + entryName + "\" does not exist.\n\n" + this);
			if(entryName == "") return isLoaded;
			return loaded[list[entryName]];
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		private function loadFromPath(path:String, entryName:String):void
		{	
			/*create loader and url to get bitmapData*/
			var loader:URLLoader = new URLLoader();
				loader.dataFormat = format;
			var url:URLRequest = new URLRequest(path);
			
			/*set world usable values temporarily while loading*/
			list[entryName] = loader;
			
			/*store entryName in retrievable key*/
			list[loader] = new Array();
			list[loader].push(entryName, loader);
			loaded[list[entryName]] = false;
			
			loader.addEventListener(Event.COMPLETE, completeLoad, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorLoad, false, 0, true);
			loader.load(url);
			url = null;
		}
		private function completeLoad(event:Event):void
		{	
			var entryName:String = list[event.target][0].toString();
			
			list[entryName] = list[event.target][1].data;
			list[event.target][1].removeEventListener(Event.COMPLETE, completeLoad);
			list[event.target][1].removeEventListener(IOErrorEvent.IO_ERROR, errorLoad);
			loaded[list[entryName]] = true;
			
			list[event.target] = null;
			loaded[event.target] = null;
			delete list[event.target];
			delete loaded[event.target];
			
			//if(isLoaded) dispatchEvent(new Event(Event.COMPLETE));
			/*dispatchEvent(new Event(entryName));*/				//this is the old way, before MultiURLEvent
			var mEvent:MultiURLEvent = new MultiURLEvent();
				mEvent.name = entryName;
				mEvent.data = get(entryName);
			dispatchEvent(mEvent);
		}
		private function errorLoad(event:IOErrorEvent):void
		{
			throw new Error("MultiURLLoader::ERROR #4: loading error: " + event);
		}
		/**********************************************************************/
	}
}