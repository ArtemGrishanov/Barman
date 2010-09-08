package com.util
{
	public class Selector
	{
		public function Selector()
		{
		}

		/**
		 * Сложение 2-x вероятностей
		 */
		public static function sum2Probs(p1: Number, p2: Number): Number {
			return p1 + p2 - p1*p2;
		}
		
		/**
		 * Сложение произвольного числа вероятностей
		 * probs - Array of Number
		 */
		public static function sumProbs(probs: Array): Number {
			var result: Number = 0;
			for each (var p: Number in probs) {
				result = sum2Probs(result, p)
			}
			return result;
		}

		/**
		 * Возвращает true или false в зависимости от того,
		 * произошло ли событие с заданной вероятнотью.
		 * 0.0 - 1.0
		 */
		public static function prob(p: Number): Boolean {
			return p >= Math.random();
		}

		/**
		 * Выбрать элемент из массива
		 * Элементы массива представляют собой весовые коэффициенты (по типу вероятности)
		 * Чем больше элемент массива, тем вероятнее он будет выбран
		 * @return - индекс элемента
		 */
		public static function chooseFromValues(arr: Array): Number {
			var choose: Number = -1;
			var range: Number = 0;
			for each (var v: Number in arr) {
				range += v;
			}
			var r: Number = Math.random();
			r = r * range;
			var sum: Number = 0;
			for each (v in arr) {
				choose++;
				sum += v;
				if (r <= sum && v != 0) {
					return choose; 
				}
			}
			return -1;
		}
		
		/**
		 * Выбрать целое число из диапазона чисел
		 */
		public static function chooseFromRange(min: int, max: int) : int {
			var r: Number = Math.random();
			var r2: Number = min + (r * (max - min));
			return Math.round(r2);
		}
	}
}