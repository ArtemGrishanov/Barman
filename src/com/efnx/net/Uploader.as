/* AS3
	Copyright 2008 efnx.com.
*/
package com.efnx.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Takes a filename, file, and variables object as input and return ByteArray post data suitable for an URLRequest as output.
	 *
	 * @see http://marstonstudio.com/?p=36
	 * @see http://www.w3.org/TR/html4/interact/forms.html
	 * @see http://www.jooce.com/blog/?p=143
	 * @see http://www.jooce.com/blog/wp%2Dcontent/uploads/2007/06/uploadFile.txt
	 * @see http://blog.je2050.de/2006/05/01/save-bytearray-to-file-with-php/
	 *
	 * @author Schell Scivally
	 * @since 05.04.2008
	 *
	 * This work is licensed under a Creative Commons Attribution NonCommercial ShareAlike 3.0 License.
	 * @see http://creativecommons.org/licenses/by-nc-sa/3.0/
	 *
	 */
	public class Uploader extends URLLoader 
{

	/*---------------------------------------------------------------------------------------------------*/
	/*  CLASS CONSTANTS						                                      		CLASS CONSTANTS */
	/*-------------------------------------------------------------------------------------------------*/
	
	/*---------------------------------------------------------------------------------------------------*/
	/*  PRIVATE VARIABLES			                                                 PRIVATE VARIABLES  */
	/*-------------------------------------------------------------------------------------------------*/
	/*Boundary used to break up different parts of the http POST body*/
	private var _boundary:String = "";
	private var urlRequest:URLRequest = new URLRequest();
	/*---------------------------------------------------------------------------------------------------*/
	/*  PUBLIC VARIABLES			                                                  PUBLIC VARIABLES  */
	/*-------------------------------------------------------------------------------------------------*/
	/**
 	 *	Filename to be sent to the server.
 	 */
	public var filename:String = "";
	/**
	 *	The file itself encoded in a ByteArray.
	 */
	public var file:ByteArray;
	/**
	 *	The destination url.
	 */
	public var url:String = "";
	/**
	 *	Variables to be sent to the server.
	 */
	public var variables:Object;
	
	public static var testing:Boolean = false;
	/*---------------------------------------------------------------------------------------------------*/
	/*  CONSTRUCTOR							                                         	   CONSTRUCTOR  */
	/*-------------------------------------------------------------------------------------------------*/
	
	/**
	 *	@Constructor
	 */
	public function Uploader()
	{
		super(); 
	}
	
	/*---------------------------------------------------------------------------------------------------*/
	/*  GETTER/SETTERS							                                      	GETTER/SETTERS  */
	/*-------------------------------------------------------------------------------------------------*/
	
	/*---------------------------------------------------------------------------------------------------*/
	/*  PUBLIC METHODS							                               	       	PUBLIC METHODS  */
	/*-------------------------------------------------------------------------------------------------*/
	/**
	 *	Uploads the file to the server.
	 */
	public function upload():void
	{
		if(filename == "") throw new Error("Uploader::upload: filename is undefined.");
		if(file == null) throw new Error("Uploader::upload: file is undefined.");
		if(url == "") throw new Error("Uploader::upload: url is undefined.");
		
		urlRequest.url = url;
		urlRequest.contentType = 'multipart/form-data; boundary=' + getBoundary();
		urlRequest.method = "POST";
		urlRequest.data = getPostData();
		urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
		
		dataFormat = "variables";
		load(urlRequest);
	}
	
	/*---------------------------------------------------------------------------------------------------*/
	/*  EVENT HANDLERS							                                       EVENT HANDLERS   */
	/*-------------------------------------------------------------------------------------------------*/
	
	/*---------------------------------------------------------------------------------------------------*/
	/*  PRIVATE/PROTECTED METHODS				                           	 PRIVATE/PROTECTED METHODS  */
	/*-------------------------------------------------------------------------------------------------*/
	/**
	 * Get the boundary for the post.
	 * Must be passed as part of the contentType of the UrlRequest
	 */
	private function getBoundary():String 
	{
		if(testing) trace("Uploader::getBoundary:");
		if(_boundary.length == 0) {
			for (var i:int = 0; i < 0x20; i++ ) {
				_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
			}
		}
		return _boundary;
	}
	/**
	 * Create post data to send in a UrlRequest
	 */
	public function getPostData():ByteArray
	{
		if(testing) trace("Uploader::getPostData:");
		var i: int;
		var bytes:String;

		var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

		/*add Filename to variables*/
		if(variables == null) 
		{
			variables = new Object();
		}
		variables.Filename = filename;

		/*add variables to postData*/
		for(var name:String in variables) 
		{
			postData = boundary(postData);
			postData = linebreak(postData);
			bytes = 'Content-Disposition: form-data; name="' + name + '"';
			for ( i = 0; i < bytes.length; i++ ) 
			{
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = linebreak(postData);
			postData = linebreak(postData);
			postData.writeUTFBytes(variables[name]);
			postData = linebreak(postData);
		}

		/*add Filedata to postData*/
		postData = boundary(postData);
		postData = linebreak(postData);
		bytes = 'Content-Disposition: form-data; name="Filedata"; filename="';
		for ( i = 0; i < bytes.length; i++ ) 
		{
			postData.writeByte( bytes.charCodeAt(i) );
		}
		postData.writeUTFBytes(filename);
		postData = quotationmark(postData);
		postData = linebreak(postData);
		bytes = 'Content-Type: application/octet-stream';
		for ( i = 0; i < bytes.length; i++ ) 
		{
			postData.writeByte( bytes.charCodeAt(i) );
		}
		postData = linebreak(postData);
		postData = linebreak(postData);
		postData.writeBytes(file, 0, file.length);
		postData = linebreak(postData);

		/*add upload filed to postData*/
		postData = linebreak(postData);
		postData = boundary(postData);
		postData = linebreak(postData);
		bytes = 'Content-Disposition: form-data; name="Upload"';
		for ( i = 0; i < bytes.length; i++ ) 
		{
			postData.writeByte( bytes.charCodeAt(i) );
		}
		postData = linebreak(postData);
		postData = linebreak(postData);
		bytes = 'Submit Query';
		for ( i = 0; i < bytes.length; i++ ) 
		{
			postData.writeByte( bytes.charCodeAt(i) );
		}
		postData = linebreak(postData);

		/*closing boundary*/
		postData = boundary(postData);
		postData = doubledash(postData);

		return postData;
	}
	/**
	 * Add a boundary to the PostData with leading doubledash
	 */
	private function boundary(p:ByteArray):ByteArray 
	{
		var l:int = getBoundary().length;

		p = doubledash(p);
		for (var i:int = 0; i < l; i++ ) 
		{
			p.writeByte( _boundary.charCodeAt( i ) );
		}
		return p;
	}
	/**
	 * Add one linebreak
	 */
	private function linebreak(p:ByteArray):ByteArray 
	{
		p.writeShort(0x0d0a);
		return p;
	}
	/**
	 * Add quotation mark
	 */
	private function quotationmark(p:ByteArray):ByteArray 
	{
		p.writeByte(0x22);
		return p;
	}
	/**
	 * Add Double Dash
	 */
	private function doubledash(p:ByteArray):ByteArray 
	{
		p.writeShort(0x2d2d);
		return p;
	}
}	
}
