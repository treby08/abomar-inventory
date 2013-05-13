package com.module.business
{
	import com.module.views.ProfilePanel;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class DataListDelegate
	{
		private static var _inst:DataListDelegate
		public static function instance():DataListDelegate
		{
			if (_inst == null)
				_inst = new DataListDelegate();
			
			return _inst;
		}
		
		private var _profPanel:Object;
		
		public function getUserlist(params:Object):void{
			_profPanel = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.USER_TYPE_LIST);
			var token:AsyncToken = service.send();
			var responder:mx.rpc.Responder = new mx.rpc.Responder(getUserlist_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function getUserlist_onResult(evt:ResultEvent):void{
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			for each (var obj:XML in listXML.children()){
				arrCol.addItem({label:obj.@userTypeName,id:obj.@userTypeID})
			}
			_profPanel.cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
			if (_profPanel is ProfilePanel)
				_profPanel.showDefault();
		}
		
		public function getBranchlist(params:Object):void{
			_profPanel = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.BRANCH_LIST);
			var token:AsyncToken = service.send();
			var responder:mx.rpc.Responder = new mx.rpc.Responder(getBranchlist_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function getBranchlist_onResult(evt:ResultEvent):void{
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			for each (var obj:XML in listXML.children()){
				arrCol.addItem({bCode:obj.@bCode,branchID:obj.@branchID,bLocation:obj.@bLocation,bAddress:obj.@bAddress,bConPerson:obj.@bConPerson,
					bDesig:obj.@bDesig,bPhoneNum:obj.@bPhoneNum,bMobileNum:obj.@bMobileNum,bEmailAdd:obj.@bEmailAdd,bLocMap:obj.@bLocMap})
			}
			_profPanel.pBox.setDataProvider(arrCol,1);
			_profPanel.pBox = null;
			_profPanel = null;
		}
		private function Main_onFault(evt:FaultEvent):void{
			trace(evt.message)
		}
	}
}