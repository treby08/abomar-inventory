package com.module.business
{
	
	import com.module.views.ProductBox;
	import com.module.views.PurchaseOrderBox;
	import com.module.views.SalesBox;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ItemsTransDelegate
	{
		private static var _inst:ItemsTransDelegate
		public static function instance():ItemsTransDelegate
		{
			if (_inst == null)
				_inst = new ItemsTransDelegate();
			
			return _inst;
		}
		
		private var _params:Object
				
		public function Items_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PRODUCT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Items_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function Items_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Items_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "Adding":
					str="Add";
					break;
				case "Updating":
					str="Edit";
					break;
				case "delete":
					str="Deleting";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Product Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" Product Complete.", str+" Product",4,null,function():void{
					if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				for each (var obj:XML in listXML.children()){
					arrCol.addItem({prodID:obj.@prodID,pCode:obj.@pCode,pName:obj.@pName,pDesc:obj.@pDesc,stockCnt:obj.@stockCnt,price:obj.@price,imgPath:obj.@imgPath})
				}
				if (_params.pBox){
					(_params.pBox as ProductBox).dataCollection = arrCol;
					(_params.pBox as ProductBox).totCount.text = String(arrCol.length);
					_params.pBox = null;
					_params = null;
				}else if (_params.sBox){
					_params.sBox.setDataProvider(arrCol,0);
					_params.sBox = null;
					_params = null;
				}
			}
			
		}
		
		public function sales_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.SALES_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Sales_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function Sales_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Sales_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Sales Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" Sales Complete.", str+" Product",4,null,function():void{
					if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				var arrObj:Object = {}
				for each (var obj:XML in listXML.children()){
					arrObj = {}
					arrObj.qouteID = obj.@qouteID;
					arrObj.fname = obj.@fname;
					arrObj.mname = obj.@mname;
					arrObj.lname = obj.@lname;
					arrObj.businame = obj.@businame;
					arrObj.baddress = obj.@baddress;
					arrObj.bPhoneNum = obj.@bPhoneNum;
					arrObj.bMobileNum = obj.@bMobileNum;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){
					_params.qBox.setDataProvider(arrCol,1);
					_params.qBox = null;
					_params = null;
				}else if (_params.sBox){
					_params.sBox.setDataProvider(arrCol,0);
					_params.sBox = null;
					_params = null;
				}
			}
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			Alert.show("Query Fault:"+evt.message);
		}
	}
}