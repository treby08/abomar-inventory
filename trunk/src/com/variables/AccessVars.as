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
		public var remarks:ArrayCollection;
		
		public var headerBgColor:uint = 0x5e9940;
		public var headerFontColor:uint = 0xecf7ab;
		public var colBgColor:uint = 0xadde8c;
		public var colBgColorOver:uint = 0xecf7ab;
		public var colBgColorOut:uint = 0xadde8c;
		public var borderStrokeColor:uint = 0xadde8c;
		
		public var arrTerm:ArrayCollection = new ArrayCollection([
			{name:"PRE-PAID",termId:0},{name:"CASH",termId:1},{name:"COD",termId:2},
			{name:"7-DAYS",termId:3},{name:"15-DAYS",termId:4},{name:"30-DAYS",termId:5},
			{name:"45-DAYS",termId:6},{name:"60-DAYS",termId:7},{name:"Special",termId:8}]);
	}
}