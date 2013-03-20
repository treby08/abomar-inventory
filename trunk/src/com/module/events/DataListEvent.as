package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class DataListEvent extends CairngormEvent
	{
		public static var GET_USERTYPE_LIST:String = "get_usertype_list";
		
		public var params:Object;
		
		public function DataListEvent(type:String, _params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new DataListEvent(this.type,params);
		}
	}
}