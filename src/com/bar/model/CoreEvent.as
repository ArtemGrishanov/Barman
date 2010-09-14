package com.bar.model
{
	import com.bar.model.essences.Client;
	import com.bar.model.essences.Decor;
	import com.bar.model.essences.Goods;
	import com.bar.model.essences.Production;
	import com.bar.model.essences.ProductionType;
	
	import flash.events.Event;

	public class CoreEvent extends Event
	{
		/**
		 * Сообщение с сервера, которое показывается Модальным Окном.
		 */
		public static const EVENT_MESSAGE_BOX: String = 'message_box';
		/**
		 * Загрузка состояния игры для текущего пользователя.
		 * Бар, параметры пользователя, обстановка, клиенты.
		 */
		public static const EVENT_BAR_LOADED: String = 'bar_loaded';
		public static const EVENT_DECOR_LOADED: String = 'decor_loaded';
		public static const EVENT_PRODUCTION_LOADED: String = 'production_loaded';
		public static const EVENT_GOODS_LOADED: String = 'goods_loaded';
		/**
		 * Загружены типы клиентов. Скины.
		 */
		public static const EVENT_CLIENTS_LOADED: String = 'clients_loaded';
		/**
		 * Статус клиента изменился. Клиент пришел, ожидает, ест,
		 */
		public static const EVENT_CLIENT_STATUS_CHANGED: String = 'client_status_changed';
		public static const EVENT_CLIENT_MOOD_CHANGED: String = 'client_mood_changed';
		/**
		 * Пришел новый клиент
		 */
		public static const EVENT_NEW_CLIENT: String = 'new_client';
		/**
		 * Клиента начали обслуживать. Готовить его товар
		 */
		public static const EVENT_CLIENT_START_SERVING: String = 'client_start_serving';
		/**
		 * Клиента прекратили обслуживать. Не до конца обслужили.
		 */
		public static const EVENT_CLIENT_STOP_SERVING: String = 'client_stop_serving';
		/**
		 * Клиента обслужили. Он получил свой товар.
		 */
		public static const EVENT_CLIENT_SERVED: String = 'client_served';
		/**
		 * Клиент оставил чаевые.
		 */
		public static const EVENT_CLIENT_PAY_TIP: String = 'client_pay_tip';
		/**
		 * Клиенту отказано в обслуживании
		 */
		public static const EVENT_CLIENT_DENIED: String = 'client_delnied';
		/**
		 * Клиент удален из бара
		 */
		public static const EVENT_CLIENT_DELETED: String = 'client_deleted';
		/**
		 * Чаевые изчезли. Бармен не успел забрать их.
		 */
		public static const EVENT_TIPS_DELETED: String = 'tips_deleted';
		/**
		 * Пользователь лицензировал продукцию.
		 */
		public static const EVENT_PRODUCTION_LICENSED: String = 'production_licensed';
		/**
		 * Пользователь купил и послтавил на стелаж продукцию.
		 */
		public static const EVENT_PRODUCTION_ADDED_TO_BAR: String = 'add_production';
		/**
		 * Порции продукции были добавлены в товар, который сейчас готовится
		 */
		public static const EVENT_PRODUCTION_ADDED_TO_CUR_GOODS: String = 'production_added_to_cur_goods';
		/**
		 * Вся продукция в баре обновлена.
		 * Это происходит, например, когда делается отмена заказа - продукция возвращается на полки
		 */
		public static const EVENT_PRODUCTION_UPDATED: String = 'production_updated';
		/**
		 * Какая то продукция закончилась у пользователя.
		 * Например, опустела бутылка водки.
		 * Но она еще стоит на полке
		 */
		public static const EVENT_PRODUCTION_EMPTY: String = 'production_empty';
		/**
		 * Продукция удалена со склада пользователя. Безвозвратно.
		 */
		public static const EVENT_PRODUCTION_DELETED: String = 'production_deleted';
		/**
		 * Количество денег у пользователя изменилось
		 */
		public static const EVENT_USER_MONEY_CENT_CHANGED: String = 'user_money_cent_changed';
		public static const EVENT_USER_MONEY_EURO_CHANGED: String = 'user_money_euro_changed';
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
		/**
		 * Бармен забрал чаевые. Деньги в кассе.
		 */
		public static const EVENT_BARMAN_TAKE_TIP: String = 'barman_take_tip';
		/**
		 * Декор добавлен в бар.
		 */
		public static const EVENT_DECOR_ADDED_TO_BAR: String = 'decor_added_to_bar';
		
		public var barPlace: BarPlace;
		public var user_id: String = '';
		public var message: String = '';
		public var client: Client;
		public var production: Production;
		public var typeProduction: ProductionType;
		public var goods: Goods;
		public var decor: Decor;
		
		public var oldMoneyCent: Number;
		public var newMoneyCent: Number;
		public var oldMoneyEuro: Number;
		public var newMoneyEuro: Number;
		public var oldExp: Number;
		public var newExp: Number;
		public var oldLevel: Number;
		public var newLevel: Number;
		public var oldLove: Number;
		public var newLove: Number;
		
		public var tipPosition: int;
		public var tipMoneyCent: Number;
		public var tipMoneyEuro: Number;
		public var clientId: Number;
		/**
		 * Признак того, что был обслужен первый клиент 
		 */
		public var firstClientServed: Boolean;
		
		public function CoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}