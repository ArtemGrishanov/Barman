package com.flashmedia.temp
{
	import com.flashmedia.basics.GameObject;
	
	public class Test
	{
		public function Test()
		{
			var go: GameObject = new GameObject(null);
			// zOrder
			
			// координаты или layout
			// layout="vertical|horizontal|absolute"
			// объект, относительно которого выполняется позиционирование
			// setLayout(obj, subj = null) может быть любой объект
			// Задание отступов между компонентами
			layout : String
			Specifies the layout mechanism used for this container.

			includeInLayout : Boolean
			Specifies whether this component is included in the layout of the parent container.
			
			explicitMinWidth : Number
			The minimum recommended width of the component to be considered by the parent during layout.
			
			explicitMaxWidth : Number
			The maximum recommended width of the component to be considered by the parent during layout.

			// определение width и height исходя из визуального состояния
			// В общем случае width и height ставится "руками", не завися от визуального представления
			//
			//
			
			
			go.addChild(backImage);
			go.addChild(textField);
			go.addChild(icon);
		}

	}
}