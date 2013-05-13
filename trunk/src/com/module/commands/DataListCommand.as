package com.module.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.module.business.DataListDelegate;
	import com.module.events.DataListEvent;
	
	public class DataListCommand implements ICommand
	{
		public function DataListCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			switch(event.type){
				case DataListEvent.GET_USERTYPE_LIST:
					DataListDelegate.instance().getUserlist((event as DataListEvent).params);
				break;
				
				case DataListEvent.GET_BRANCH_LIST:
					DataListDelegate.instance().getBranchlist((event as DataListEvent).params);
				break;
				
			}
		}
	}
}