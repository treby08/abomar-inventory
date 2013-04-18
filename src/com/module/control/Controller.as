package com.module.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.module.commands.*;
	import com.module.events.DataListEvent;
	import com.module.events.ItemsTransEvent;
	import com.module.events.LoginEvent;
	import com.module.events.UserEvent;
	
	public class Controller extends FrontController
	{
		public function Controller()
		{
			initialiseCommands();
		}
		
		public function initialiseCommands() : void
		{
			addCommand( LoginEvent.SIGN_IN, LoginCommand );
			
			addCommand( DataListEvent.GET_USERTYPE_LIST, DataListCommand );
			
			addCommand( UserEvent.ADD_USER, UserCommand );
			addCommand( UserEvent.EDIT_USER, UserCommand );
			addCommand( UserEvent.DELETE_USER, UserCommand );
			addCommand( UserEvent.SEARCH_USER, UserCommand );
			
			addCommand( UserEvent.ADD_CUSTOMER, UserCommand );
			addCommand( UserEvent.EDIT_CUSTOMER, UserCommand );
			addCommand( UserEvent.DELETE_CUSTOMER, UserCommand );
			addCommand( UserEvent.SEARCH_CUSTOMER, UserCommand );
			
			addCommand( ItemsTransEvent.ADD_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_PRODUCT, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_SALES, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_QUOTE_DETAILS, ItemsTransCommand );
		}
	}
}