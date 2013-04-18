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
		
		private var _params:Object;
		private var _paramsItems:Object;
		private var _paramsQuote:Object;
				
		public function Items_AED(params:Object):void{
			_paramsItems = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PRODUCT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Items_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function Items_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Items_AED_onResult",strResult);
			
			var str:String;
			switch(_paramsItems.type){
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
					if (_paramsItems.pBox){
						_paramsItems.pBox.clearFields(null);
						_paramsItems.pBox = null;
					}else if (_paramsItems.ppnl){
						_paramsItems.ppnl.parent.removeElement(_paramsItems.ppnl);
						_paramsItems.ppnl = null;
					}
					_paramsItems = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection();
				trace("search",XML(evt.result).toXMLString())
				for each (var obj:XML in listXML.children()){
					arrCol.addItem({prodID:obj.@prodID,pCode:obj.@pCode,pName:obj.@pName,pDesc:obj.@pDesc,stockCnt:obj.@stockCnt,price:obj.@price,imgPath:obj.@imgPath,branchName:obj.@branchName})
				}
				if (_paramsItems.pBox){
					(_paramsItems.pBox as ProductBox).dataCollection = arrCol;
					(_paramsItems.pBox as ProductBox).totCount.text = String(arrCol.length);
					_paramsItems.pBox = null;
					_paramsItems = null;
				}else if (_paramsItems.sBox){
					_paramsItems.sBox.setDataProvider(arrCol,0);
					_paramsItems.sBox = null;
					_paramsItems = null;
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
				Alert.show(str+" Sales Complete.", str+" Sales",4,null,function():void{
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
		
		public function quote_AED(params:Object):void{
			_paramsQuote = params;
			trace("quote_AED",_paramsQuote.type,_paramsQuote.quoteID);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.QOUTE_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(quote_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function quote_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("quote_AED_onResult",strResult);
			
			var str:String;
			switch(_paramsQuote.type){
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
				Alert.show(str+" Quote Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
			if (str){
				Alert.show(str+" Quote Complete.", str+" Quote",4,null,function():void{
					if (_paramsQuote.pBox){
						_paramsQuote.pBox.clearFields(null);
						_paramsQuote.pBox = null;
					}else if (_paramsQuote.ppnl){
						_paramsQuote.ppnl.parent.removeElement(_paramsQuote.ppnl);
						_paramsQuote.ppnl = null;
					}
					_paramsQuote = null;
				});
			}else if (_paramsQuote.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
					
				trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = {}
					//qdID,qd_quoteID,qd_prodID,quantity,totalPurchase,prodCode,prodName,prodDesc,stockCount,unitprice,branchName
					arrObj.qdID = obj.@qdID;
					arrObj.qd_quoteID = obj.@qd_quoteID;
					arrObj.branchName = obj.@branchName;
					arrObj.qd_prodID = obj.@qd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.prodName = obj.@prodName;
					arrObj.prodDesc = obj.@prodDesc;
					arrObj.stockCount = obj.@stockCount;
					arrObj.price = obj.@unitprice;
					arrCol.addItem(arrObj);
				}
				if (_paramsQuote.qBox){
					_paramsQuote.qBox.setDataProvider(arrCol,3);
					_paramsQuote.qBox = null;
					_paramsQuote = null;
				}
			}else{
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
				for each (obj in listXML.children()){
					arrObj = {}
					arrObj.quoteID = obj.@quoteID;
					arrObj.quoteLabel = obj.@quoteLabel;
					arrObj.branchName = obj.@branchName;
					arrObj.customer = obj.@customer;
					arrObj.businame = obj.@businame;
					arrObj.baddress = obj.@baddress;
					arrObj.bPhoneNum = obj.@bPhoneNum;
					arrObj.bMobileNum = obj.@bMobileNum;
					arrCol.addItem(arrObj);
				}
				if (_paramsQuote.qBox){
					_paramsQuote.qBox.setDataProvider(arrCol,1);
					_paramsQuote.qBox = null;
					_paramsQuote = null;
				}else if (_params.sBox){
					_paramsQuote.sBox.setDataProvider(arrCol,0);
					_paramsQuote.sBox = null;
					_paramsQuote = null;
				}
			}
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			Alert.show("Query Fault:"+evt.message);
		}
	}
}