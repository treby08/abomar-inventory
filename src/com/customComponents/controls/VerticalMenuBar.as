package com.customComponents.controls
{
	import com.customComponents.controls.menuClasses.VerticalMenuItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.ApplicationControlBar;
	import mx.controls.Menu;
	import mx.controls.MenuBar;
	import mx.controls.menuClasses.IMenuBarItemRenderer;
	import mx.controls.menuClasses.MenuItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IFlexDisplayObject;
	import mx.events.MenuEvent;
	import mx.managers.ISystemManager;
	import mx.styles.ISimpleStyleClient;

	public class VerticalMenuBar extends MenuBar
	{
		
   		private static const MARGIN_HEIGHT:int = 0;		
	    
	    /**
	    * There are two possiblities for direction: left or right. Here we define
	    * these two constants that you should use in your AS code to change the
	    * direction of the VerticalMenuBar. So to change the direction the code would
	    * be something like: 
	    * menubar.direction = VerticalMenuBar.LEFT;
	    */
	    public static const LEFT:String = "left";
	    public static const RIGHT:String = "right";
	    
	    /**
	    * We're storing a variable to specify direction. This can be set via MXML
	    * or Actionscript. The direction will take effect the next time a menu item
	    * is clicked.
	    */
	    private var _direction:String = VerticalMenuBar.RIGHT;
		
		public function get direction():String {
			return this._direction;
		}
		
		public function set direction(value:String):void {
			if(this._direction != value) {
				this._direction = value;
			}		
		}
		
		
		public function VerticalMenuBar() {
			super();
			setStyle("baseColor",0x7ebd5e);
			setStyle("themeColor",0x7ebd5e);
		}
		
		/**
	     *  Changed to calculate based on vertical layout. Pretty much
	     *  the same code as in MenuBar, but instad of using the X and width
	     *  properties, now we're using Y and height.
	     */
		override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	
			var lastY:Number = 0;
			var lastH:Number = 0;
			
	        var len: int = menuBarItems.length;
	
	        var clipContent:Boolean = false;
	        var hideItems:Boolean = (unscaledWidth == 0 || unscaledHeight == 0);
	
	        for (var i:int = 0; i < len; i++)
	        {
	            var item:IMenuBarItemRenderer = menuBarItems[i];
	
	            item.setActualSize(unscaledWidth, item.getExplicitOrMeasuredHeight());
	            item.visible = !hideItems;
	
				item.move(0, lastY + lastH);
				
	            lastY = item.y = lastY+lastH;
	            lastH = item.height;
	            
	            if (!hideItems &&
	                (item.getExplicitOrMeasuredWidth() > unscaledWidth ||
	                 (lastY + lastH) > unscaledHeight))
	            {
	                clipContent = true;
	            }
	            
	        }
	        
	        /* Here we are omitting setting the size of the background.
	         * I'm not sure when the background comes into play, since without
	         * this part of the code everything seems to look OK to me.
	         * So I'm just leaving it out. Otherwise we would have to duplicate
	         * a local reference to background and reproduce a lot of code
	         * that is private in MenuBar. So screw that.
	         */
			/*
	        if (background)
	        {
	            background.setActualSize(unscaledWidth, unscaledHeight);
	            background.visible = !hideItems;
	        }
			*/
			
	        // Set a scroll rect to handle clipping.
	        scrollRect = clipContent ? new Rectangle(0, 0,
	                unscaledWidth, unscaledHeight) : null;
	    }
	    
	    
	    
	    /**
	     *  Changed to calculate based on vertical layout. Pretty much
	     *  the same code as in MenuBar, but instad of using the X and width
	     *  properties, now we're using Y and height.
	     */
	    override protected function measure():void
	    {
	        super.measure();
	
	        var len:int = menuBarItems.length;
	
	        measuredHeight = 0;
	
	        measuredWidth = DEFAULT_MEASURED_MIN_WIDTH; 
	        for (var i:int = 0; i < len; i++)
	        {
	            measuredHeight += menuBarItems[i].getExplicitOrMeasuredHeight();
	            measuredWidth = Math.max(
	                    measuredWidth, menuBarItems[i].getExplicitOrMeasuredWidth());
	        }
	
	        if (len > 0)
	            measuredHeight += 2 * MARGIN_HEIGHT;
	        else 
	            measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT; 
	
	        measuredMinWidth = measuredWidth;
	        measuredMinHeight = measuredHeight;
	    }
	    
	    
	   
    	/**
    	 * We're overriding getMenuAt for two reasons. First, we set a custom itemRenderer for 
    	 * the menu if we're supposed to be facing left. Second, we add a listener that gets 
    	 * executed when the menu is shown. The secret to what we're doing is we're repositiong
    	 * the menu only after it has been positioned originally by the mx.controls.MenuBar class.
    	 * This allows us to not have to override a ton of private methods of the MenuBar class.
    	 * The fundamental problem with extending MenuBar for our purposes is that the showMenu 
    	 * method is private. If showMenu was protected we might be able to just override that
    	 * and specify our own coordinates for where to place the menu. But instead, we do it
    	 * a sneaky way and try to move the Menu the instant it gets shown.
    	 */
	    override public function getMenuAt(index:int):Menu
	    {
	    	var menu:Menu = menus[index];
	    	
	    	var wasNull:Boolean = (menu == null);
	    	
	    	menu = super.getMenuAt(index);
	       
	       	if(this.direction == VerticalMenuBar.LEFT) {
	        	menu.itemRenderer = new ClassFactory(VerticalMenuItemRenderer);
	        }
	        else {
				var mir:MenuItemRenderer = new MenuItemRenderer();
				mir.height = 45;
			
	        	menu.itemRenderer = new ClassFactory(VerticalMenuItemRenderer);
	        }
	        /* Now here's a sneaky part. First, we elminate the openDuration
	         * because that screws the whole thing up. If openDuration is not 1, then
	         * menu shows the opening tween prior to shifting the menu to the
	         * left or right, so we see the menu visibly jump. That's no good.
	         * And if we set the openDuration to 0 I've noticed unexplained behavior
	         * that messes up showing an Alert box. I have no idea why.
	         */
	        if(wasNull) {
	        	menu.setStyle("openDuration", 1);
	       		
	       		/* This is the listener that gets executed when the menu is shown.
	       		 * Basically we're going to wait until the menu is shown, and then
	       		 * quickly move it over to the right or left.
	       		 */
	       		menu.addEventListener("menuShow", moveMenuOnShow);
	        }
	        
	        return menu;
	    }
    
    	
	    private function moveMenuOnShow(event:MenuEvent):void {
	    	var menu:Menu = event.menu;
	    	var menuBar:MenuBar = event.menuBar;
	    	var parentMenu:Menu = menu.parentMenu;

	    	/* OK, cool, we're going to shift the Menu. But we need to use callLater
	    	 * because we need to first update the Menu's x and y position so we can
	    	 * use that to shift the menu over 
	    	 */
	    	if(parentMenu == null) {
	    		var item:IMenuBarItemRenderer = menuBar.menuBarItems[menuBar.selectedIndex];
	
	    		callLater(shiftRootMenu, [menu, menuBar, item]);
	    	}
	    	else {
	    		callLater(shiftSubMenu, [menu, parentMenu]);
	    	}
	    }
	    
	    /** 
	     * If we're showing the menu to the left, then we need to shift the submenus
	     * to the left as well. Normal functionality is to show the submenu
	     * to the right of the parent menu. So if we're facing right then
	     * we don't need to shift the submenu at all.
	     */
	    private function shiftSubMenu(menu:Menu, parentMenu:Menu):void {    	
	    	if(this._direction == VerticalMenuBar.LEFT) {
	    		menu.move(parentMenu.x - menu.width, menu.y);
	    	}
	    }
	    
	    /** 
	     * The root menus always need to be shifted, either to the right or to the left.
	     * The default Menu functionality is to show the menu directly below the MenuItem.
	     * So we just shift the Menu from where the default places it, and move it to the
	     * right or the left. We also move it up higher, to be at the same y position as 
	     * the MenuItem.
	     */
	    private function shiftRootMenu(menu:Menu, menuBar:MenuBar, item:IMenuBarItemRenderer):void {    	
	    	
	    	/* Here's some code taken from the MenuBar class from the showMenu method
	    	 * that's used to calculcate the position that we need to place the menu.
	    	 * It's only been modified to adjust the menu to the right or the left of 
	    	 * the current item.
	    	 */
	    	var pt:Point = new Point(0, 0);
	        pt = DisplayObject(item).localToGlobal(pt);
	        
	        if(this._direction == VerticalMenuBar.LEFT) {
	        	pt.x -= menu.width;
	        }
	        else {
	        	pt.x += item.width;
	        }
	        
	        pt.y -= item.height;
	        
	        var sm:ISystemManager = systemManager;
	        
	        // check to see if we'll go offscreen
	        if (pt.y + item.height + 1 + menu.getExplicitOrMeasuredHeight() > screen.height + screen.y)
	            pt.y -= menu.getExplicitOrMeasuredHeight();
	        else
	            pt.y += item.height + 1;
	        if (pt.x + menu.getExplicitOrMeasuredWidth() > screen.width + screen.x)
	            pt.x = screen.x + screen.width - menu.getExplicitOrMeasuredWidth();
	        pt = DisplayObject(sm.topLevelSystemManager).globalToLocal(pt);
	    	
	    	menu.move(pt.x, pt.y);
	    }
	    
	}
}