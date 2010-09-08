package com.bar.modeltests
{
	public class ModelStatistics
	{
		// сколько напитков-коктейлей продано за уровень
		// денег заработано за уровень
		// любви за уровень
		// декора куплено за уровень
		// времени затрачено на уровень
		// лицензирование - на каком уровне куплено, сколько времени прошло с начала игры
		// сколько времени прошло с начала игры до каждого уровня
		// сколько клиентов пришло на данном уровне (обслужено, отказано)
		// сколько реально приходило клиентов в минуту на уровне
		//
		
		
		/**
		 * [LevelStatistics]
		 */
		public var levels: Array;
		public var startTime: Number;
		
		public function ModelStatistics()
		{
			levels = new Array();
			startTime = new Date().getTime() / 1000; //sec
		}

		/**
		 * Открывает новый уровень в статистике
		 */
		public function startNewLevel(num: int): LevelStatistics {
			var l: LevelStatistics = new LevelStatistics(num);
			levels.push(l);
			return l;
		}

		/**
		 * Вернуть последний уровень в статистике
		 */
		public function get lastLevel(): LevelStatistics {
			if (levels.length > 0) {
				return levels[levels.length - 1];
			}
			return null;
		}
		
		public function toString(): String {
			var s: String = '';
			s += '======================== MODEL STATISTICS ================================';
			s += 'Length: ' + (new Date().getTime() / 1000 - startTime) + '\n';
			for each (var l: LevelStatistics in levels) {
				s += l.toString() + '\n';
			}
			s += '==========================================================================';
			return s;	
		}
}
}