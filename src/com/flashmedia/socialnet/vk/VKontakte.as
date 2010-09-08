package com.flashmedia.socialnet.vk
{
	import com.gsolo.encryption.MD5;
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class VKontakte extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://api.vkontakte.ru/api.php';
		private static const APP_KEY:String = 'EqKl8Wg2be';
		private static const APP_KEY_SAND_BOX:String = 'ZJEJl8y2Wl';
		private static const APP_ID:String = '1827403';
		private static const APP_ID_SAND_BOX:String = '1882789';
		
		public static var apiUrl:String = FC_API_SERVER;
//		public static var appId:String = APP_ID_SAND_BOX;
//		public static var appKey:String = APP_KEY_SAND_BOX;
		public static var appId:String = APP_ID;
		public static var appKey:String = APP_KEY;
		
		private const loader:URLLoader = new URLLoader();
		
		public var testMode:uint = 0;
		private var requestQueue: Array;
		private var timer: Timer;
		private var currentMethod: String;
		private var debug: Boolean;
		private var viewer_id: String;
		
		public function VKontakte(_viewer_id: String, _debug: Boolean = false)
		{
			viewer_id = _viewer_id;
			debug = _debug;
			currentMethod = null;
			requestQueue = new Array();
			timer = new Timer(500, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function onTimer(event: TimerEvent): void {
			if (requestQueue.length > 0 && !currentMethod) {
				var r: Object = requestQueue.pop();
				request(r['method'], r['vars']);
			}
		}

		private function request(method: String, vars:URLVariables):void
		{
			if (!currentMethod) {
				currentMethod = method;
				var request: URLRequest = new URLRequest();
				request.url = apiUrl;
				request.data = vars;
				loader.load(request);
			}
			else {
				var r: Object = {'method': method, 'vars': vars};
				requestQueue.push(r);	
			}
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, null, 255));
			currentMethod = null;
		}
		
		private function completeHandler(event:Event):void
		{
			if (debug) {
				trace('VKontakte: ' + currentMethod + ': ' + loader.data);
			}
			try {
				var response:Object = JSON.deserialize(loader.data);
				
				if (response.hasOwnProperty('error')) {
					response = response.error;
					var errorCode:int = response.error_code;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, errorCode, response.error_msg));
				}
				else if (response.hasOwnProperty('response')) {
					response = response.response;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.COMPLETED, currentMethod, response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, 254, e.message));
			}
			currentMethod = null;
		}
		
		public function getProfiles(uids:Array):void {
			var uidsString:String = uids.join(',');
			var vars: URLVariables = new URLVariables();
			var fields:String = 'nickname,sex,bdate,photo_big,city,country';
			var sig:String = viewer_id+'api_id='+appId+
				'fields='+fields+
				'format=json'+
				'method=getProfiles'+
				'test_mode='+testMode+
				'uids='+uidsString+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['v'] = '2.0';
			vars['method'] = 'getProfiles';
			vars['uids'] = uidsString;
			vars['fields'] = fields;
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getProfiles', vars);
		}
		
//		public function isAppUser():void {
//			var vars: URLVariables = new URLVariables();
//			var sig:String = Util.viewer_id+'api_id='+appId+
//				'format=json'+
//				'method=isAppUser'+
//				'test_mode='+testMode+
//				'v=2.0'+appKey;
//				
//			vars['api_id'] = appId;
//			vars['v'] = '2.0';
//			vars['method'] = 'isAppUser';
//			vars['format'] = 'json';
//			vars['test_mode'] = testMode;
//			vars['sig'] = MD5.encrypt(sig);
//			
//			request('isAppUser', vars);
//		}
		
//		public function getUserSettings():void {
//			var vars: URLVariables = new URLVariables();
//			var sig:String = Util.viewer_id+'api_id='+appId+
//				'format=json'+
//				'method=getUserSettings'+
//				'test_mode='+testMode+
//				'v=2.0'+appKey;
//				
//			vars['api_id'] = appId;
//			vars['v'] = '2.0';
//			vars['method'] = 'getUserSettings';
//			vars['format'] = 'json';
//			vars['test_mode'] = testMode;
//			vars['sig'] = MD5.encrypt(sig);
//			
//			request('getUserSettings', vars);
//		}
		
		public function getFriends():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = viewer_id+'api_id='+appId+
				'format=json'+
				'method=getFriends'+
				'test_mode='+testMode+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['v'] = '2.0';
			vars['method'] = 'getFriends';
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getFriends', vars);
		}
		
		public function getAppFriends():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = viewer_id+'api_id='+appId+
				'format=json'+
				'method=getAppFriends'+
				'test_mode='+testMode+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['v'] = '2.0';
			vars['method'] = 'getAppFriends';
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getAppFriends', vars);
		}
		
		public function getAlbums():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = viewer_id+
				'api_id='+appId+
				'format=json'+
				'method=photos.getAlbums'+
				'test_mode='+testMode+
				'uid='+viewer_id+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['v'] = '2.0';
			vars['uid'] = viewer_id;
			vars['method'] = 'photos.getAlbums';
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('photos.getAlbums', vars);
		}
		
		public function getPhotos(aid: String):void {
			var vars: URLVariables = new URLVariables();
			var sig:String = viewer_id+
				'aid='+aid+
				'api_id='+appId+
				'format=json'+
				'method=photos.get'+
				'test_mode='+testMode+
				'uid='+viewer_id+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['v'] = '2.0';
			vars['aid'] = aid;
			vars['uid'] = viewer_id;
			vars['method'] = 'photos.get';
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('photos.get', vars);
		}
		
		public function getAds():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = viewer_id+
				'api_id='+appId+
				'format=json'+
				'method=getAds'+
				'test_mode='+testMode+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['method'] = 'getAds';
			vars['v'] = '2.0';
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getAds', vars);
		}
		
		public function getCities(cids:Array):void {
			var vars: URLVariables = new URLVariables();
			var cidsString:String = cids.join(',');
			var sig:String = viewer_id+
				'api_id='+appId+
				'cids=' + cidsString + 
				'format=json'+
				'method=getCities'+
				'test_mode='+testMode+
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['method'] = 'getCities';
			vars['v'] = '2.0';
			vars['cids'] = cidsString;
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getCities', vars);
		}
		
		public function getCountries(cids:Array):void {
			var vars: URLVariables = new URLVariables();
			var cidsString:String = cids.join(',');
			var sig:String = viewer_id+
				'api_id='+appId+
				'cids=' + cidsString + 
				'format=json'+
				'method=getCountries'+
				'test_mode='+ testMode +
				'v=2.0'+appKey;
				
			vars['api_id'] = appId;
			vars['method'] = 'getCountries';
			vars['v'] = '2.0';
			vars['cids'] = cidsString;
			vars['format'] = 'json';
			vars['test_mode'] = testMode;
			vars['sig'] = MD5.encrypt(sig);
			
			request('getCountries', vars);
		}
	}
}