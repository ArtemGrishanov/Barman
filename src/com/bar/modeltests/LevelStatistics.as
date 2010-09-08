package com.bar.modeltests
{
	import com.bar.model.essences.Decor;
	
	public class LevelStatistics
	{
		public var num: int;
		public var goods: Array;
		public var loveCount: int;	
		public var decor: Array;
		public var levelStartTime: Number;
		public var levelLengthTime: Number;
		public var clientsServed: Array;
		public var clientsDenied: Array;
		/**
		 * Содержит имена типов продукции, которые лицензированы пользователем.
		 * ['ProductionType']
		 */
		public var licensedProdTypes: Array;
		public var moneyCent: Number;
		public var moneyEuro: Number;
		public var moneyCentUp: Number;
		public var moneyCentDown: Number;
		public var moneyEuroUp: Number;
		public var moneyEuroDown: Number;
		
		public function LevelStatistics(_num: int)
		{
			num = _num;
			goods = new Array();
			loveCount = 0;
			decor = new Array();
			levelStartTime = new Date().getTime() / 1000; //sec
			levelLengthTime = 0;
			clientsServed = new Array();
			clientsDenied = new Array();
			moneyCentUp = 0;
			moneyCentDown = 0;
			moneyEuroUp = 0;
			moneyEuroDown = 0;
			licensedProdTypes = new Array();
		}
		
		public function get clientsInMinute(): Number {
			return (clientsServed.length + clientsDenied.length) / levelLengthTime * 60;
		}

		public function endLevel(): void {
			levelLengthTime = new Date().getTime() / 1000 - levelStartTime;
		}
		
		public function toString(): String {
			var s: String = '-------------------- LEVEL STATISTICS -----------------------------\n';
			s += 'Level: ' + num + '. Start Time: ' + levelStartTime + 'sec. Length: ' + levelLengthTime + ' sec.\n';
			s += 'Cents: ' + moneyCent + '('+(moneyCentUp+moneyCentDown)+')' + ' [Up: '+moneyCentUp+'. Down: '+moneyCentDown+']\n';
			s += 'Euro: ' + moneyEuro + '('+(moneyEuroUp+moneyEuroDown)+')' + ' [Up: '+moneyEuroUp+'. Down: '+moneyEuroDown+']\n';
			s += 'Love during level: ' + loveCount + '\n';
			s += 'Goods sold: ' + goods.length + '\n';
			s += 'Clients in minute: ' + clientsInMinute + '\n';
			s += 'Clients served: ' + clientsServed.length + '\n';
			s += 'Clients denied: ' + clientsDenied.length + '\n';
			s += 'Decor buyed: ' + decor.length + ' [';
			for each (var d: Decor in decor) {
				s += d.typeDecor.name + ', ';
			}
			s += ']\n';
			s += 'Production Licensed: ' + licensedProdTypes.length + '\n';
//			for each (var p: ProductionType in licensedProdTypes) {
//				s += p + ', ';
//			}
//			s += ']\n';
			s += '-------------------------------------------------------------------';
			return s;
		}
	}
}