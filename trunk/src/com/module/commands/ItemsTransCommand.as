package com.module.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.module.business.ItemsTransDelegate;
	import com.module.events.ItemsTransEvent;
	
	public class ItemsTransCommand implements ICommand
	{
		public function ItemsTransCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			var obj:Object = (event as ItemsTransEvent).params
			switch(event.type){
				case ItemsTransEvent.ADD_PRODUCT:
					obj.type = "add";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.EDIT_PRODUCT:
					obj.type = "edit";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.DELETE_PRODUCT:
					obj.type = "delete";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.SEARCH_PRODUCT:
					obj.type = "search";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				/* PURCHASE ORDER*/
				case ItemsTransEvent.ADD_SALES:
					obj.type = "add";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.EDIT_SALES:
					obj.type = "edit";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.DELETE_SALES:
					obj.type = "delete";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				
				case ItemsTransEvent.SEARCH_SALES:
					obj.type = "search";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				/*QOUTATION*/
				case ItemsTransEvent.ADD_QUOTE:
					obj.type = "add";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.EDIT_QUOTE:
					obj.type = "edit";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.DELETE_QUOTE:
					obj.type = "delete";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_QUOTE:
					obj.type = "search";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.GET_QUOTE_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().quote_AED(obj);
				break;
				/*PURCHASE REQUISITION*/
				case ItemsTransEvent.ADD_REQUISITION:
					obj.type = "add";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.EDIT_REQUISITION:
					obj.type = "edit";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.DELETE_REQUISITION:
					obj.type = "delete";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_REQUISITION:
					obj.type = "search";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.GET_REQUISITION_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
				break;
				case ItemsTransEvent.GET_REQUISITION_NUMBER:
					obj.type = "get_req_no";
					ItemsTransDelegate.instance().purchaseReq_ReqNo(obj);
				break;
				
				/*PURCHASE Order*/
				case ItemsTransEvent.ADD_PURORD:
					obj.type = "add";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.EDIT_PURORD:
					obj.type = "edit";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.DELETE_PURORD:
					obj.type = "delete";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_PURORD:
					obj.type = "search";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.GET_PURORD_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.GET_PURORD_NUMBER:
					obj.type = "get_req_no";
					ItemsTransDelegate.instance().purchaseOrd_ReqNo(obj);
					break;
			}
		}
	}
}