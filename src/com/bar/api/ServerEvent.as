package com.bar.api
{
	import com.bar.model.BarPlace;
	
	import flash.events.Event;

	/**
	 * События, которые приходят с сервера
	 */
	public class ServerEvent extends Event
	{
//		public static const EVENT_FIRST_LAUNCH: String = 'first_launch';
		/**
		 * Ошибка сервера, соединения и т.п.
		 */
		public static const EVENT_ERROR: String = 'event_error';
		/**
		 * Сообщение с сервера, которое показывается Модальным Окном.
		 */
		public static const EVENT_MESSAGE_BOX: String = 'message_box';
		/**
		 * Загрузка состояния игры для текущего пользователя.
		 * Бар, параметры пользователя, обстановка, клиенты.
		 */
		public static const EVENT_BAR_LOADED: String = 'bar_loaded';
		/**
		 * Количество денег у пользователя изменилось
		 */
		public static const EVENT_USER_MONEY_CENT_CHANGED: String = 'user_money_cent_changed';
		public static const EVENT_USER_MONEY_EURO_CHANGED: String = 'user_money_euro_changed';
		/**
		 * Загружены друзья пользователя, которые зарегистрированы в игре.
		 * Возвращается список ид друзей, которые есть в игре.
		 */
		public static const EVENT_FRIENDS_LOADED: String = 'friends_loaded';
		/**
		 * ТОП загружен
		 */
		public static const EVENT_TOP_LOADED: String = 'top_loaded';
		/**
		 * Каталог баров с платным размещением
		 */
		public static const EVENT_BAR_CATALOG_LOADED: String = 'bar_catalog_loaded';
		/**
		 * Получены новости
		 */
		public static const EVENT_NEWS_LOADED: String = 'news_loaded';
		
		/**
		 * Изменение опыта пользователя.
		 */
		public static const EVENT_USER_EXP_CHANGED: String = 'user_exp_changed';
		/**
		 * Изменение уровня пользователя
		 */
		public static const EVENT_USER_LEVEL_CHANGED: String = 'user_level_changed';
		/**
		 * Изменение любви пользователя
		 */
		public static const EVENT_USER_LOVE_CHANGED: String = 'user_love_changed';

		public var barPlace: BarPlace;
		public var message: String = '';
		public var moneyCent: Number;
		public var moneyEuro: Number;
		public var exp: Number;
		public var level: Number;
		public var love: Number;
		/**
		 * Идишники друзей, которые в игре
		 */
		public var friendsIds: Array;
		/**
		 * Уровни друзей, которые в игре. Параллельный с friendsIds.
		 */
		public var friendsLevels: Array;
		/**
		 * Опыт друзей, которые в игре. Параллельный с friendsIds.
		 */
		public var friendsExp: Array;
		/**
		 * Признак первого запуска.
		 */
		public var firstLaunch: Boolean;
		
		public function ServerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}