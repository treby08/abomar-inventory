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
		
	}
}