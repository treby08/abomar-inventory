<?php
	require("config.php");
		
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$purReqID = $_REQUEST['purReqID'];
		$supID = $_REQUEST['supID'];
		$branchID = $_REQUEST['branchID'];
		$delID = $_REQUEST['delID'];
		$totalWeight = $_REQUEST['totalWeight'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = $_REQUEST['totalAmt'];
		
		$purOrdDetails = $_REQUEST['purOrdDetails'];
		$arr_purOrdDetails = explode("||",$purOrdDetails);
		if ($type == "edit")
			$purReqID = $_REQUEST['purReqID'];
	}else if ($type == "delete")
		$purReqID = $_REQUEST['purReqID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	else if ($type == "get_details")
		$purReqID = $_REQUEST['purReqID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO purchaseOrd (purOrd_purReqID, purOrd_supID, purOrd_branchID, purOrd_delID, totalWeight, dateTrans, timeTrans, totalAmt) VALUES ($purReqID,$supID, $branchID, $delID, $totalWeight,'$dateTrans', NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(purOrdID) as purOrdID FROM purchaseOrd";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$pur_purOrdID = $row['purOrdID'];
		
		for ($i=0; $i < count($arr_purOrdDetails); $i++){
			$arrDetails = explode("|",$arr_purOrdDetails[$i]);
			
			$sql = "INSERT INTO purchaseOrd_details (`pod_purOrdID`, `pod_prodID`, `quantity`, `totalPurchase`, `pod_dateTrans`, `pod_timeTrans`) VALUES ($pur_purOrdID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", '$dateTrans', NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			$sql = "UPDATE purchaseReq_details SET itemServed=".$arrDetails[1]." WHERE prdID=".$arrDetails[3];
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
		$sql = "SELECT SUM(quantity)=SUM(itemServed) AS total FROM `purchaseReq_details` WHERE prd_purReqID=$purReqID";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$row = mysql_fetch_assoc($query);
		if($row['total']=="1"){
			$sql = "UPDATE `purchaseReq` SET purReq_status=1,onProcess=1  WHERE purReqID=$purReqID";
			$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}else{
			$sql = "UPDATE `purchaseReq` SET onProcess=1  WHERE purReqID=$purReqID";
			$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE purchaseReq SET purReq_branchID = '$purReq_branchID' , preparedBy='$preparedBy' , approvedBy='$approvedBy' , dateTrans='$dateTrans' , totalAmt = '$totalAmt' WHERE purReqID = $purReqID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM purchaseReq WHERE purReqID = '$purReqID'",$conn);
	}else if ($type == "search"){
		$searchSTR = str_replace("0","",$searchSTR);
		$query = mysql_query("SELECT po.*, b.bCode, b.branchID, b.bLocation,s.supCompName FROM purchaseOrd po
							LEFT JOIN branches b ON b.branchID=po.purOrd_branchID
							LEFT JOIN supplier s ON s.supID=po.purOrd_supID
							WHERE (purOrdID LIKE '%$searchSTR%' OR supCompName LIKE '%$searchSTR%') AND onProcess=0",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item purOrdID=\"".$row['purOrdID']."\" purOrd_supID=\"".$row['purOrd_supID']."\" supCompName=\"".$row['supCompName']."\" purOrd_branchID=\"".$row['purOrd_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" purOrd_delID=\"".$row['purOrd_delID']."\" totalWeight=\"".$row['totalWeight']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$query = mysql_query("SELECT prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice 
							FROM purchaseReq_details pr 
							INNER JOIN products p ON pr.prd_prodID=p.prodID
							WHERE prd_purReqID = $purReqID",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prdID=\"".$row['prdID']."\" prd_purReqID=\"".$row['prd_purReqID']."\" prd_prodID=\"".$row['prd_prodID']."\" prodModel=\"".$row['prodModel']."\" quantity=\"".$row['quantity']."\" totalPurchase=\"".$row['totalPurchase']."\" prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" srPrice=\"".$row['srPrice']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_req_no"){
		$sql = "SELECT MAX(whrID)+1 as whrID FROM wh_receipt";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['whrID']?$row['whrID']:1;
		echo number_pad_req($reqNum);
	}
	
	function number_pad($number) {
		return str_pad($number,5,"0",STR_PAD_LEFT);
	}
	
	function number_pad_req($number) {
		return str_pad($number,3,"0",STR_PAD_LEFT);
	}
?>