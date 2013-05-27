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
		public static var SEARCH_SALES:String = "search_sales";
		
		public static var ADD_QUOTE:String = "add_quote";
		public static var EDIT_QUOTE:String = "edit_quote";
		public static var DELETE_QUOTE:String = "delete_quote";
		public static var SEARCH_QUOTE:String = "search_quote";
		public static var GET_QUOTE_DETAILS:String = "get_quote_details";
		
		public static var ADD_REQUISITION:String = "add_requisition";
		public static var EDIT_REQUISITION:String = "edit_requisition";
		public static var DELETE_REQUISITION:String = "delete_requisition";
		public static var SEARCH_REQUISITION:String = "search_requisition";
		public static var GET_REQUISITION_DETAILS:String = "get_requisition_details";
		public static var GET_REQUISITION_NUMBER:String = "get_requisition_number";
		
		public static var ADD_PURORD:String = "add_purord";
		public static var EDIT_PURORD:String = "edit_purord";
		public static var DELETE_PURORD:String = "delete_purord";
		public static var SEARCH_PURORD:String = "search_purord";
		public static var GET_PURORD_DETAILS:String = "get_purord_details";
		public static var GET_PURORD_NUMBER:String = "get_purord_number";
				
		public static var ADD_WH_RECEIPT:String = "add_wh_receipt";
		public static var EDIT_WH_RECEIPT:String = "edit_wh_receipt";
		public static var DELETE_WH_RECEIPT:String = "delete_wh_receipt";
		public static var SEARCH_WH_RECEIPT:String = "search_wh_receipt";
		public static var GET_WH_RECEIPT_DETAILS:String = "get_wh_receipt_details";
		public static var GET_WH_RECEIPT_NUMBER:String = "get_wh_receipt_number";
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