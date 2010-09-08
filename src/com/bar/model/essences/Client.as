package com.bar.model.essences
{
	import com.bar.model.Balance;
	
	public class Client
	{
		public static const STATUS_WAITING: String = 'status_waiting';
		public static const STATUS_ORDERING: String = 'status_ordering';
		public static const STATUS_EATING: String = 'status_eating';
		public static const STATUS_COMPLETED: String = 'status_ordered';
//		public static const STATUS_COMING: String = 'status_coming';
//		public static const STATUS_AWAYING: String = 'status_awaing';
		
		public var id: Number;
		/**
		 * Место клиента 0..4. На каком стуле он сидит.
		 */
		public var position: int;
		public var typeClient: ClientType;
		public var id_vk: String = '9028622';
		public var name: String = '';
		public var mood: Number = Balance.maxClientMood;
		public var status: String = STATUS_WAITING;
		public var isFriend: Boolean;
		/**
		 * Время, когда был создан клиент (когда он пришел в бар)
		 * СЕКУНДЫ !
		 */
		public var time: Number;
		public var orderGoodsType: GoodsType;
		
		public function Client(_typeClient: ClientType, _id_vk: String, _name: String, _isFriend: Boolean, _time: Number, _orderGoodsType: GoodsType, _position: int) {
			id = Balance.getUnicId();
			typeClient = _typeClient;
			id_vk = _id_vk;
			name = _name;
			isFriend = _isFriend;
			time = _time;
			orderGoodsType = _orderGoodsType;
			position = _position;
		}
		
	}
}