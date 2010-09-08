/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.net 
{
	
	import com.bar.util.Images;
	import com.efnx.events.MultiLoaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 *	MultiLoader is a loader that loads multiple jpgs, pngs, gifs or swfs and 
	 *	holds them as BitmapData, Sprites or MovieClips based on fileType. 
	 *	Returns a BitmapData or Sprite.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Schell Scivally
	 *	@since  06.04.2008
	 */
	public class MultiLoader extends EventDispatcher 
	{
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
		/*-------------------------------------------------------------------------------------------------*/

		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		private var list:Object = new Object();
		private var type:Object = new Object();
		private var loaded:Object = new Object();
		private var resolver:Dictionary = new Dictionary(true);
		private var unloader:Object = new Object();
		private var count:int = 0;
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
		/*-------------------------------------------------------------------------------------------------*/
		public static var testing:Boolean = false;
		public static var usingContext:Boolean = false;
		/*---------------------------------------------------------------------------------------------------*/
		/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
		/*-------------------------------------------------------------------------------------------------*/
		
		/**
		 *	@Constructor
		 */
		public function MultiLoader():void
		{
			super();
			if(testing) trace("MultiLoader::constructor() ");
		}
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Returns the number of resources loaded.
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
			if(testing) trace("MultiLoader::get isLoaded()");
			//if there are no objects, return false
			if(count < 1) return false;
			//if any object are not loaded return false
			for(var key:Object in loaded)
			{
				if(!loaded[key]) return false;
			}
			
			return true;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		/**
	 	 *	Begins the load process of a new resource.
	 	 *	@param path The path to the resource.
	 	 *	@param entryName The name of the resource [used in retrieval].
	 	 *	@param returnType The expected return type. Valid types are "MovieClip", "Sprite", "Bitmap" or "BitmapData"
		 */
		public function load(path:String, entryName:String = "", returnType:String = ""):void
		{
			if (path == 'http://vkontakte.ru/images/question_a.gif') {
				path = Images.QUESTION_A;
			}
			
			if(testing) trace("MultiLoader::load() " + path,entryName,returnType);
			/*just in case no name is included*/
			if(entryName == "") entryName = "Data_";
			/*just in case the included name is taken, so we don't replace the resource*/
			if(list[entryName] != undefined) entryName += length.toString();
			
			loadFromPath(String(path), entryName, returnType);
			count++;
		}
		/**
		 *	Unloads a given resource specified by <code>entryName</code>.
		 *	@param entryName The name of the resource to unload.
		 */
		public function unload(entryName:String):void
		{
			if(testing) trace("MultiLoader::unload()", entryName);
			if(entryName == "")
			{
				throw new Error("MultiLoader:ERROR #3: must specify a resource to unload.");
			}
			if(loaded[entryName])
			{
				switch(type[entryName])
				{
					case ".swf":
						if(testing) trace("MultiLoader::unload() deleting swf.");                                             
						break;                                        
					case ".jpg":                                      
						if(testing) trace("MultiLoader::unload() deleting jpg. ");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;                                        
					case "jpeg":                                      
						if(testing) trace("MultiLoader::unload() deleting jpg.");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;                                        
					case ".gif":                                      
						if(testing) trace("MultiLoader::unload() deleting gif.");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;                                        
					case ".png":                                      
						if(testing) trace("MultiLoader::unload() deleting jpg.");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;    
					case "MovieClip":
						if(testing) trace("MultiLoader::unload() deleting swf.");                                             
						break;                               
					case "Sprite":                               
						if(testing) trace("MultiLoader::unload() deleting Sprite.");
						break;                                    
					case "Bitmap":                                
						if(testing) trace("MultiLoader::unload() deleting Bitmap");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;                                    
					case "BitmapData":                            
						if(testing) trace("MultiLoader::unload() deleting BitmapData.");
						Bitmap(list[entryName]).bitmapData.dispose();
						break;
					default:
						if(testing) trace("MultiLoader::unload() could not determine type, will delete content.");
						break;
				}
			}else
			{
				throw new Error("MultiLoader::ERROR #7 resource " + entryName + " not loaded.");
			}
			if(unloader[entryName].numChildren > 0) unloader[entryName].unload();
			
			count--;
			loaded[entryName] = false;
			delete unloader[entryName];
			delete resolver[entryName];
			delete list[entryName];
			delete loaded[entryName];
			delete type[entryName];
		}
		/**
		 *	Unloads all resources.
		 */
		public function unloadAll():void
		{
			if(testing) trace("MultiLoader::unloadAll() ");
			for(var key:String in list)
			{	
				unload(key);
			}
		}
		/**
		 *	Returns the given resource specified by <code>entryName</code> in the format designated
		 *	by <code>returnType</code> in <code>load()</code>.
		 *	@param entryName The name of the resource to retrieve.
		 *	@see #load()
		 */
		public function get(entryName:String):*
		{
			if(testing) trace("MultiLoader::get()");
			if(list[entryName] == null) return;//throw new Error("MultiLoader::ERROR #6 resource \"" + entryName + "\" does not exist.\n\n" + this);
			if(loaded[entryName])
			{
				switch(type[entryName])
				{
					case ".swf":
						if(testing) trace("MultiLoader::get() returning swf as MovieClip. " + list[entryName]);
						return list[entryName] as MovieClip;
					case ".jpg":
						if(testing) trace("MultiLoader::get() returning jpg as BitmapData. " + list[entryName]);
						return Bitmap(list[entryName]).bitmapData;
					case "jpeg":
						if(testing) trace("MultiLoader::get() returning jpg as BitmapData. " + list[entryName]);
						return Bitmap(list[entryName]).bitmapData;
					case ".gif":
						if(testing) trace("MultiLoader::get() returning gif as BitmapData. " + list[entryName]);
						return Bitmap(list[entryName]).bitmapData;
					case ".png":
						if(testing) trace("MultiLoader::get() returning png as BitmapData. " + list[entryName]);
						return Bitmap(list[entryName]).bitmapData;
					case "MovieClip":
						if(testing) trace("MultiLoader::get() returning content as MovieClip. " + list[entryName]);
						return list[entryName] as MovieClip;
					case "Sprite":
						if(testing) trace("MultiLoader::get() returning content as Sprite. " + list[entryName]);
						var sprite:Sprite = new Sprite();
							sprite.addChild(list[entryName] as Bitmap);
						return sprite;
					case "Bitmap":
						if(testing) trace("MultiLoader::get() returning content as Bitmap. " + list[entryName]);
						return list[entryName] as Bitmap;
					case "BitmapData":
						if(testing) trace("MultiLoader::get() returning content as BitmapData. " + list[entryName]);
						return Bitmap(list[entryName]).bitmapData;
					default:
						if(testing) trace("MultiLoader::get() could not determine type, will return content. " + list[entryName]);
						return list[entryName];
				}
			}else
			{
				throw new Error("MultiLoader::ERROR #7 resource " + entryName + " not loaded.");
			}
		}
		/**
		 *	@inheritDoc
		 */
		public override function toString():String
		{
			var string:String = "MultiLoader: \n";
			for(var key:Object in list)
			{
				string += "	" + key + " => (" + list[key] + ")\n		loaded[" + key + "] => (" + loaded[list[key]] + ")\n";
				
			}
			
			return string;
		}
		/**
		 *	Returns whether or not a given resource has loaded.
		 *	@param entryName The name of the resource to check load status of.
		 */
		public function hasLoaded(entryName:String = ""):Boolean
		{
			if(testing) trace("MultiLoader::hasLoaded() ");
			if(list[entryName] == null) return false;
			if(entryName == "") return isLoaded;
			return loaded[entryName];
		}
		/**
		*	Lists all resources.
		*/
		public function listEntries():void
		{
			for (var p:String in list)
			{
				trace("MultiLoader::listEntries()", p, "loaded ? ", loaded[p]);
			}
		}
		/**
		*	Tells whether a certain resource exists.
		*	@param	entryName The name of the resource to check.
		*/
		public function hasEntry(entryName:String):Boolean
		{
			for (var p:String in list)
			{
				if(p == entryName) return true;
			}
			return false;
		}
		/*---------------------------------------------------------------------------------------------------*/
		/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
		/*-------------------------------------------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------------------------------------*/
		/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
		/*-------------------------------------------------------------------------------------------------*/
		private function loadFromPath(path:String, entryName:String, returnType:String = ""):void
		{	
			if(testing) trace("MultiLoader::loadFromPath() " + path,entryName,returnType);
			/*create loader and url to get bitmapData*/
			var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			var url:URLRequest = new URLRequest(path);
			
			/*set world usable values temporarily while loading*/
			resolver[loader.contentLoaderInfo] = entryName;
			list[entryName] = loader;
			loaded[entryName] = false;
			
			/*determine type and add to type list*/
			if(returnType != "")
			{
				type[entryName] = returnType;
			}else
			{
				var suffix:String = path.substr(-4);
				type[entryName] = suffix.toLowerCase();
			}
			
			/*store entryName in retrievable key*/
			loader.contentLoaderInfo.addEventListener("complete", completeLoad, false, 0, true);
			loader.contentLoaderInfo.addEventListener("progress", progressLoad, false, 0, true);
			loader.contentLoaderInfo.addEventListener("ioError", errorLoad, false, 0, true);
			loader.load(url, usingContext ? loaderContext : null);
			url = null;
		}
		/**
		*	
		*/
		private function progressLoad(event:ProgressEvent):void
		{	
			var entryName:String = resolver[event.target];
			if(testing) trace("MultiLoader::progressLoad() " + event.target,entryName,(event.bytesLoaded/event.bytesTotal).toPrecision(3));
			var progEvent:ProgressEvent = new ProgressEvent(entryName+"_Progress");
				progEvent.bytesLoaded = event.bytesLoaded;
				progEvent.bytesTotal = event.bytesTotal;
				
			dispatchEvent(progEvent);
			
			var m_event:MultiLoaderEvent = new MultiLoaderEvent("progress");
				m_event.bytesLoaded = event.bytesLoaded;
				m_event.bytesTotal = event.bytesTotal;
				m_event.entry = entryName;
			
			dispatchEvent(m_event);
		}
		/**
		*	LoaderInfo
		*/
		private function completeLoad(event:Event):void
		{
			var entryName:String = resolver[event.target];
			if(testing) trace("MultiLoader::completeLoad() " + entryName);
			event.target.removeEventListener(Event.COMPLETE, completeLoad);
			event.target.removeEventListener("progress", progressLoad);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, errorLoad);
			
			list[entryName] = event.target.content;
			loaded[entryName] = true;
			delete resolver[event.target];
			unloader[entryName] = event.target.loader;
			
			dispatchEvent(new Event(entryName+"_Complete"));
			
			var m_event:MultiLoaderEvent = new MultiLoaderEvent("complete");
				m_event.entry = entryName;
				
			dispatchEvent(m_event);
		}
		private function errorLoad(event:IOErrorEvent):void
		{
			throw new Error("MultiLoader::ERROR #4: loading error: " + event);
		}
	}
}