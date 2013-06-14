<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		
		$pay_ORNo = $_REQUEST['pay_ORNo'];
		$pay_custID = $_REQUEST['pay_custID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = $_REQUEST['totalAmt'];
		
		$payDetails = $_REQUEST['payDetails'];
		$arr_payDetails = explode("||",$payDetails);
		if ($type == "edit")
			$payID = $_REQUEST['payID'];
	}else if ($type == "delete")
		$payID = $_REQUEST['payID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		
	}else if ($type == "get_details")
		$payID = $_REQUEST['payID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO payment (pay_ORNo, pay_custID, preparedBy, dateTrans, timeTrans, totalAmt) VALUES ($pay_ORNo, $pay_custID, '$preparedBy', '$dateTrans', NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(payID) as payID FROM payment";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$prd_payID = $row['payID'];
		
		for ($i=0; $i < count($arr_payDetails); $i++){
			$arrDetails = explode("|",$arr_payDetails[$i]);
			//strItem.push(item.invID+"|"+item.amt+"|"+item.credit+"|"+item.totalAmt);
			$sql = "INSERT INTO payment_details (`pd_payID`, `pd_invID`, `pd_amt`, `pd_credit`, `pd_totalAmt`) VALUES ($prd_payID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].")";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE payment SET pay_custID = '$pay_custID' , preparedBy='$preparedBy' , pay_ORNo='$pay_ORNo' , dateTrans='$dateTrans' , totalAmt = '$totalAmt' WHERE payID = $payID",$conn);
		
		mysql_query("UPDATE payment_details SET isRemove=1 WHERE prd_payID=$payID",$conn);
		
		for ($i=0; $i < count($arr_payDetails); $i++){
			$arrDetails = explode("|",$arr_payDetails[$i]);
			if ($arrDetails[4]=="undefined"){
				$sql = "INSERT INTO payment_details (`pd_payID`, `pd_invID`, `pd_amt`, `pd_credit`, `pd_totalAmt`) VALUES ($payID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].")";
			}else{
				$sql = "UPDATE payment_details SET pd_amt=".$arrDetails[1].", pd_credit=".$arrDetails[2].", pd_totalAmt=".$arrDetails[2]." WHERE pdID=".$arrDetails[4];
			}
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
	}else if ($type == "delete"){
		mysql_query("DELETE FROM payment WHERE payID = '$payID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT p.*,c.acctno FROM payment p
							INNER JOIN customers c ON p.pay_custID=c.custID
							WHERE (p.pay_ORNo LIKE '%$searchSTR%' OR acctno LIKE '%$searchSTR%')",$conn); 
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item payID=\"".$row['payID']."\" reqNo=\"".number_pad($row['payID'])."\" preparedBy=\"".$row['preparedBy']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" branchID=\"".$row['branchID']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$query = mysql_query("SELECT prdID,prd_payID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,listPrice,prodWeight 
							FROM payment_details pr 
							INNER JOIN products p ON pr.prd_prodID=p.prodID
							WHERE prd_payID = $payID AND (quantity-itemServed) <> 0 AND isRemove=0",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prdID=\"".$row['prdID']."\" prd_payID=\"".$row['prd_payID']."\" prd_prodID=\"".$row['prd_prodID']."\" prodModel=\"".$row['prodModel']."\" desc=\"".$row['prodDescrip']."\" quantity=\"".$row['quantity']."\" totalPurchase=\"".$row['totalPurchase']."\" prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" srPrice=\"".$row['listPrice']."\" weight=\"".$row['prodWeight']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>