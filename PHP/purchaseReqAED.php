<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$purReq_branchID = $_REQUEST['purReq_branchID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$approvedBy = $_REQUEST['approvedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = $_REQUEST['totalAmt'];
		
		$purReqDetails = $_REQUEST['purReqDetails'];
		$arr_purReqDetails = explode("||",$purReqDetails);
		if ($type == "edit")
			$purReqID = $_REQUEST['purReqID'];
	}else if ($type == "delete")
		$purReqID = $_REQUEST['purReqID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	else if ($type == "get_details")
		$purReqID = $_REQUEST['purReqID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO purchaseReq (purReq_branchID, preparedBy, approvedBy, dateTrans, timeTrans, totalAmt) VALUES ($purReq_branchID, '$preparedBy', '$approvedBy', '$dateTrans', NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(purReqID) as purReqID FROM purchaseReq";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$prd_purReqID = $row['purReqID'];
		
		for ($i=0; $i < count($arr_purReqDetails); $i++){
			$arrDetails = explode("|",$arr_purReqDetails[$i]);
			
			$sql = "INSERT INTO purchaseReq_details (`prd_purReqID`, `prd_prodID`, `quantity`, `totalPurchase`, `prd_dateTrans`, `prd_timeTrans`) VALUES ($prd_purReqID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", NOW(), NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
		
	}else if ($type == "edit"){
		mysql_query("UPDATE purchaseReq SET purReq_branchID = '$purReq_branchID' , preparedBy='$preparedBy' , approvedBy='$approvedBy' , dateTrans='$dateTrans' , totalAmt = '$totalAmt' WHERE purReqID = $purReqID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM purchaseReq WHERE purReqID = '$purReqID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT pr.*, b.bCode, b.branchID FROM purchaseReq pr
							INNER JOIN branches b ON b.branchID=pr.purReq_branchID
							WHERE bCode LIKE '%$searchSTR%' OR purReqID LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item purReqID=\"".$row['purReqID']."\" reqNo=\"REQ - ".number_pad($row['purReqID'])."\" preparedBy=\"".$row['preparedBy']."\" bCode=\"".$row['bCode']."\" branchID=\"".$row['branchID']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\"/>";
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
		$sql = "SELECT MAX(purReqID)+1 as purReqID FROM purchaseReq";
		//$sql = "SELECT MAX(prdID)+1 AS prdID FROM purchaseReq_details";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['purReqID']?$row['purReqID']:1;
		echo "REQ - ".number_pad($reqNum);
	}
	
	function number_pad($number) {
		return str_pad($number,4,"0",STR_PAD_LEFT);
	}
?>