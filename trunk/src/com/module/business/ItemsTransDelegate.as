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
		private var _paramsUniqueID:Object;
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
				Alert.show(str+" Product Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" Product Complete.", str+" Product",4,null,function():void{
					if (_paramsItems.pBox){
						_paramsItems.pBox.clearFields(null);
						_paramsItems.pBox.hgControl.enabled = true;
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
				var arrObj:Object;
				for each (var obj:XML in listXML.children()){
					arrObj = new Object();
					arrObj.prodID = obj.@prodID;
					arrObj.pCode = obj.@pCode;
					arrObj.modelNo = obj.@modelNo;
					arrObj.remarks = obj.@remarks;
					arrObj.stockCnt = obj.@stockCnt;
					arrObj.returnable = obj.@returnable;
					arrObj.imgPath = obj.@imgPath;
					arrObj.supplier = obj.@supplier;
					arrObj.weight = obj.@weight;
					arrObj.size = obj.@size;
					arrObj.subNum = obj.@subNum;
					arrObj.desc = obj.@desc;
					arrObj.comModUse = obj.@comModUse;
					arrObj.pDate = obj.@pDate;
					arrObj.factor = obj.@factor;
					arrObj.inactive = obj.@inactive;
					arrObj.listPrice = obj.@listPrice,
					arrObj.dealPrice = obj.@dealPrice;
					arrObj.srPrice = obj.@srPrice;
					arrObj.priceCurr = obj.@priceCurr;
					arrCol.addItem(arrObj);
					
				}
				if (_paramsItems.pBox){
					(_paramsItems.pBox).dataCollection = arrCol;
					(_paramsItems.pBox).totCount.text = String(arrCol.length);
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
			if(_paramsQuote == null)
				return;
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
					_paramsQuote.itemRen.isDispatch = false;
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
					_paramsQuote.qBox.dataCollection = arrCol;
					_paramsQuote.qBox = null;
					_paramsQuote = null;
				}else if (_params.sBox){
					_paramsQuote.sBox.setDataProvider(arrCol,0);
					_paramsQuote.sBox = null;
					_paramsQuote = null;
				}
			}
		}
		public function purchaseReq_ReqNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseReq_ReqNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_REQ_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseReq_ReqNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function purchaseReq_ReqNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseReq_ReqNo_onResult",strResult);
			
			if (_paramsUniqueID.type=="get_req_no"){
				if (_paramsUniqueID.qBox){
					_paramsUniqueID.qBox.txtReqNo.text = String(evt.result);
					_paramsUniqueID.qBox = null;
					_paramsUniqueID = null;
				}	
			}
		}
		public function purchaseReq_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseReq_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_REQ_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseReq_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function purchaseReq_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseReq_AED_onResult",strResult);
			if(_params == null)
				return;
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
				Alert.show(str+" Purchase Requisition Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
			if (str){
				Alert.show(str+" Purchase Requisition Complete.", str+" Purchase Requisition",4,null,function():void{
					if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
				var num:int = 1;
				trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = {}
					//prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice					
					arrObj.prdID = obj.@prdID;
					arrObj.prd_purReqID = obj.@prd_purReqID;
					arrObj.prd_prodID = obj.@prd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodDesc = obj.@desc;
					arrObj.weight = obj.@weight;
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.price = obj.@srPrice;
					arrObj.num = num;
					arrObj.isSelected = "1";
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
				for each (obj in listXML.children()){
					arrObj = {}
						/*<item purReqID=\"".$row['purReqID']."\" reqNo=\"REQ - ".number_pad($row['purReqID'])."\" preparedBy=\"".$row['preparedBy'].
					"\" bCode=\"".$row['bCode']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans'].
					"\" totalAmt=\"".$row['totalAmt']."\"/>*/
					arrObj.purReqID = obj.@purReqID;
					arrObj.reqNo = obj.@reqNo;
					arrObj.bCode = obj.@bCode;					
					arrObj.branchID = obj.@branchID;
					arrObj.preparedBy = obj.@preparedBy;
					arrObj.approvedBy = obj.@approvedBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.totalAmt = obj.@totalAmt;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function purchaseOrd_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseOrd_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_ORD_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseOrd_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function purchaseOrd_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseOrd_AED_onResult",strResult);
			if(_params == null)
				return;
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
				Alert.show(str+" Purchase Order Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
			if (str){
				Alert.show(str+" Purchase Order Complete.", str+" Purchase Order",4,null,function():void{
					if (_params.pBox){
						if (str == "Adding")
							_params.pBox.updateCurrentPO();
						else
							_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
				var num:int = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = {}
					//prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice					
					arrObj.prdID = obj.@prdID;
					arrObj.prd_purReqID = obj.@prd_purReqID;
					arrObj.prd_prodID = obj.@prd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.weight = obj.@weight;
					arrObj.srPrice = obj.@srPrice;
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else if (_params.type=="get_req_no"){
				if (_params.qBox){
					_params.qBox.txtReqNo.text = String(evt.result);
					_params.qBox = null;
					_params = null;
				}	
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				arrObj = {};
				for each (obj in listXML.children()){
					arrObj = {}
					/*<item purReqID=\"".$row['purReqID']."\" reqNo=\"REQ - ".number_pad($row['purReqID'])."\" preparedBy=\"".$row['preparedBy'].
					"\" bCode=\"".$row['bCode']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans'].
					"\" totalAmt=\"".$row['totalAmt']."\"/>*/
					arrObj.purReqID = obj.@purReqID;
					arrObj.reqNo = obj.@reqNo;
					arrObj.bCode = obj.@bCode;					
					arrObj.branchID = obj.@branchID;
					arrObj.preparedBy = obj.@preparedBy;
					arrObj.approvedBy = obj.@approvedBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.totalAmt = obj.@totalAmt;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function purchaseOrd_ReqNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseOrd_ReqNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_ORD_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseOrd_ReqNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function purchaseOrd_ReqNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseOrd_ReqNo_onResult",strResult);
			if (_paramsUniqueID.qBox){
				_paramsUniqueID.qBox.txtReqNo.text = String(evt.result);
				_paramsUniqueID.qBox = null;
				_paramsUniqueID = null;
			}	
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			Alert.show("Query Fault:"+evt.message);
		}
	}
}