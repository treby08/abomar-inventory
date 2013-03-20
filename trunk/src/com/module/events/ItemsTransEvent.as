package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	public class ItemsTransEvent extends CairngormEvent
	{
		public static var ADD_PRODUCT:String = "add_product";
		public static var EDIT_PRODUCT:String = "edit_product";
		public static var DELETE_PRODUCT:String = "delete_product";
		public static var SEARCH_PRODUCT:String = "search_product";
		public static var ADD_SALES:String = "add_sales";
		public static var EDIT_SALES:String = "edit_sales";
		public static var DELETE_SALES:String = "delete_sales";
		
		public var params:Object;
		
		public function ItemsTransEvent(type:String, _params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new ItemsTransEvent(this.type,params);
		}
	}
	
}