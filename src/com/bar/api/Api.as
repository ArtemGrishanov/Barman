package com.facecontrol.api
{
	import com.facecontrol.util.Util;
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class Api extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://www.fcapi.ru/';
//		private static const FC_API_SERVER:String = 'http://facecontrol/';
		
		private const loader:URLLoader = new URLLoader();
		private var requestQueue: Array;
		private var timer: Timer;
		private var currentMethod: String;
		
		public function Api()
		{
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
				request.url = FC_API_SERVER;
				request.data = vars;
				loader.load(request);
			}
			else {
				requestQueue.push({'method': method, 'vars': vars});	
			}
		}

		private function errorHandler(e:IOErrorEvent):void {
			trace("errorHandler: "+e.text);
			dispatchEvent(new ApiEvent(ApiEvent.ERROR, e.text, 255));
			currentMethod = null;
		}
		
		private function completeHandler(event:Event):void
		{
			trace("Api:completeHandler: "+loader.data);
			try {
				var json:Object = JSON.deserialize(loader.data);
				
				if (json.hasOwnProperty('error')) {
					json = json.error;
					var errorCode:int = json.err_code;
					var errorMessage:String = null;
					
					if (json.hasOwnProperty('err_msg')) {
						errorMessage = json.err_msg;
					}
					dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, errorCode, errorMessage));
				}
				else if (json.hasOwnProperty('response')) {
					dispatchEvent(new ApiEvent(ApiEvent.COMPLETED, json.response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, 254, e.message));
			}
			currentMethod = null;
		}
		
		public function registerUser(uid:int, fname:String, lname:String, nickname:String, sex:int, bdate:String, city:int, country:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'reg_user';
			vars['uid'] = uid;
			vars['fname'] = fname;
			vars['lname'] = lname;
			
			if (nickname != null) vars['nickname'] = nickname;
			vars['sex'] = sex;
			
			if (bdate != null) vars['bdate'] = bdate;
			vars['city'] = city;
			vars['country'] = country;
			
			request('reg_user', vars);
		}
		
		public function saveSettings(uid:int, sex:int=0, minAge:int=8, maxAge:int=99, city:String=null, country:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'save_settings';
			vars['uid'] = uid;
			vars['sex'] = sex;
			vars['age_min'] = minAge;
			vars['age_max'] = maxAge;
			if (city) vars['city'] = city;
			if (country) vars['country'] = country;
			
			request('save_settings', vars);
		}
		
		public function loadSettings(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'load_settings';
			vars['uid'] = uid;
			
			request('load_settings', vars);
		}
		
		public function addPhoto(uid:int, src:String, src_small:String, src_big:String, comment:String=null, vkPid:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_photo';
			vars['uid'] = uid;
			vars['src'] = src;
			vars['src_small'] = src_small;
			vars['src_big'] = src_big;
			if (comment) vars['comment'] = comment;
			if (vkPid) vars['vk_pid'] = vkPid;
			
			request('add_photo', vars);
		}
		
		public function getPhotos(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'get_photos';
			vars['uid'] = uid;
			
			request('get_photos', vars);
		}
		
		public function deletePhoto(pid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_photo';
			vars['pid'] = pid;
			
			request('del_photo', vars);
		}
		
		public function setComment(pid:int, comment:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_comment';
			vars['pid'] = pid;
			
			vars['comment'] = comment;
			
			request('set_comment', vars);
		}
		
		public function vote(uid:int, pid:String, rating:int=1):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'vote';
			vars['uid'] = uid;
			vars['pid'] = pid;
			vars['rating'] = rating;
			
			request('vote', vars);
		}
		
		public function setMain(pid:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_main';
			vars['pid'] = pid;
			
			request('set_main', vars);
		}
		
		public function nextPhoto(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'next_photo';
			vars['uid'] = uid;
			
			request('next_photo', vars);
		}
		
		public function friends(uids:Array):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'friends';
			var uidsString:String = '';
			var uid:String;
			for each (uid in uids) {
				uidsString += uid + ',';
			}
			vars['viewer_id'] = Util.userId;
			vars['uids'] = uidsString;
			
			request('friends', vars);
		}
		
		public function favorites(uid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'favorites';
			vars['uid'] = uid;
			
			request('favorites', vars);
		}
		
		public function addFavorite(uid:int, favoriteUid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_favorite';
			vars['uid'] = uid;
			vars['favorite_uid'] = favoriteUid;
			
			request('add_favorite', vars);
		}
		
		public function deleteFavorite(uid:int, favoriteUid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_favorite';
			vars['uid'] = uid;
			vars['favorite_uid'] = favoriteUid;
			
			request('del_favorite', vars);
		}
		
		public function getTop(uid:uint):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			vars['uid'] = uid;
			request('top100', vars);
		}
	}
}