package com.variables
{
	import mx.collections.ArrayCollection;
	
	public class AccessVars
	{
		private static var _this:AccessVars;
		public static function instance():AccessVars
		{
			if (_this == null){
				_this = new AccessVars();
			}
			
			return _this;
		}
		
		public var mainApp:Abomar;
		public var userType:ArrayCollection;
		
		public var headerBgColor:uint = 0x5e9940;
		public var headerFontColor:uint = 0xecf7ab;
		public var colBgColor:uint = 0xadde8c;
		public var colBgColorOver:uint = 0xecf7ab;
		public var colBgColorOut:uint = 0xadde8c;
		public var borderStrokeColor:uint = 0xadde8c;
	}
}