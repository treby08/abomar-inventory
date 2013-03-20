package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class UserEvent extends CairngormEvent
	{
		public static var ADD_USER:String = "add_user";
		public static var EDIT_USER:String = "edit_user";
		public static var DELETE_USER:String = "delete_user";
		public static var SEARCH_USER:String = "search_user";
		
		public static var ADD_CUSTOMER:String = "add_customer";
		public static var EDIT_CUSTOMER:String = "edit_customer";
		public static var DELETE_CUSTOMER:String = "delete_customer";
		public static var SEARCH_CUSTOMER:String = "search_customer";
		
		public var params:Object;
		
		public function UserEvent(type:String, _params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new UserEvent(this.type,params);
		}
	}
}