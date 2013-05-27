package com.module.business
{
	import com.module.views.CustomerBox;
	import com.module.views.CustomerListBox;
	import com.module.views.ProfilePanel;
	import com.module.views.SalesBox;
	import com.module.views.SupplierBox;
	import com.module.views.UserBox;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class UserDelegate
	{
		private static var _inst:UserDelegate
		public static function instance():UserDelegate
		{
			if (_inst == null)
				_inst = new UserDelegate();
			
			return _inst;
		}
		
		private var _params:Object
		
		public function User_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.USER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(User_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		public function Customer_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.CUSTOMER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Customer_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		public function supplier_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.SUPPLIER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(supplier_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function User_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("User_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
				break;
				case "edit":
					str="Edit";
				break;
				case "delete":
					str="Delete";
				break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("User "+str+" Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" User Complete.", str+" User",4,null,function():void{
					if (_params.pnl){
						_params.pnl.cancelClickHandler(null);
						_params.pnl = null;
					}else if (_params.upnl){
						_params.upnl.parent.removeElement(_params.upnl);
						_params.upnl = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				for each (var obj:XML in listXML.children()){
					arrCol.addItem({usersID:obj.@usersID,userTypeName:obj.@userTypeName,userTypeID:obj.@userTypeID,user:obj.@user,pass:obj.@pass,name:obj.@name,address:obj.@address,pnum:obj.@pNum,mnum:obj.@mNum,email:obj.@email,sex:obj.@sex})
				}
				(_params.uBox as UserBox).dataCollection = arrCol;
				(_params.uBox as UserBox).totCount.text = String(arrCol.length);
				//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
			}
			
		}
		private function Customer_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Customer_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
				break;
				case "edit":
					str="Edit";
				break;
				case "delete":
					str="Delete";
				break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("Customer "+str+" Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" Customer Complete.", str+" Customer",4,null,function():void{
					if (_params.cpnl){
						_params.cpnl.clearFields(null);
						_params.cpnl.hgControl.enabled = true;
						_params.cpnl = null;
					}else if (_params.upnl){
						_params.upnl.parent.removeElement(_params.upnl);
						_params.upnl = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				for each (var obj:XML in listXML.children()){
					arrCol.addItem({custID:obj.@custID,acctno:obj.@acctno,branchID:obj.@branchId,creditLine:obj.@creditLine,address:obj.@address,
						pNum:obj.@pNum,mNum:obj.@mNum,tin:obj.@tin, term:obj.@term,conPerson:obj.@conPerson,desig:obj.@desig,web:obj.@web,
						email:obj.@email,inactive:obj.@inactive})
				}
				if (_params.cBox){
					(_params.cBox as CustomerListBox).dataCollection = arrCol;
					(_params.cBox as CustomerListBox).totCount.text = String(arrCol.length);
					//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
				}else if (_params.csBox){ 
					_params.csBox.setDataProvider(arrCol,1);
					_params.csBox = null;
					_params = null;
				}
			}
			
		}
		private function supplier_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("supplier_AED_onResult",strResult);
			trace("_params.type:",_params.type)
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
					break;
				case "edit":
					str="Edit";
					break;
				case "delete":
					str="Delete";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("Supplier "+str+" Error: "+strResult,"Error");
				_params.qBox.hgControl.enabled = true;
				return;
			}
			var listXML:XML;
			var arrCol:ArrayCollection;
			var obj:XML;
			var arrObj:Object;
			if (str){
				Alert.show(str+" Supplier Complete.", str+" Supplier",4,null,function():void{
					if (_params.qBox){
						_params.qBox.clearFields(null);
						_params.qBox.hgControl.enabled = true;
						_params.qBox = null;
					}
					_params = null;
				});
			}else if (_params.type=="search"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection()
				
				for each (obj in listXML.children()){
					arrObj = new Object();
					arrObj.supID = obj.@supID;
					arrObj.supCode = obj.@supCode;
					arrObj.compName = obj.@compName;
					arrObj.creditLine = obj.@creditLine;
					arrObj.address = obj.@address;
					arrObj.pNum = obj.@pNum;
					arrObj.mNum = obj.@mNum;
					arrObj.tin = obj.@tin;
					arrObj.term = obj.@term;
					arrObj.conPerson = obj.@conPerson;
					arrObj.desig = obj.@desig;
					arrObj.web = obj.@web;
					arrObj.email = obj.@email;
					arrObj.isLocal = obj.@isLocal;
					arrCol.addItem(arrObj)
				}
				if (_params.qBox){
					(_params.qBox as SupplierBox).dataCollection = arrCol;
					(_params.qBox as SupplierBox).totCount.text = String(arrCol.length);
					//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
				}
			}else if (_params.type=="get_list"){
				listXML =  XML(evt.result);
				arrCol = new ArrayCollection()
				for each (obj in listXML.children()){
					arrObj = new Object();
					arrObj.supID = obj.@supID;
					arrObj.supCode = obj.@supCode;
					arrObj.compName = obj.@compName;
					arrObj.creditLine = obj.@creditLine;
					arrObj.address = obj.@address;
					arrObj.pNum = obj.@pNum;
					arrObj.mNum = obj.@mNum;
					arrObj.tin = obj.@tin;
					arrObj.term = obj.@term;
					arrObj.conPerson = obj.@conPerson;
					arrObj.desig = obj.@desig;
					arrObj.web = obj.@web;
					arrObj.email = obj.@email;
					arrObj.isLocal = obj.@isLocal;
					arrObj.label = obj.@supCode+" - "+obj.@compName;		
					arrCol.addItem(arrObj)
				}
				if (_params.qBox){ 
					_params.qBox.setDataProvider(arrCol,4);
					_params.qBox = null;
					_params = null;
				}
			}
			
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			trace(evt.message)
		}
	}
}