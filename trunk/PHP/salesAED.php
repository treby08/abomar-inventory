<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$sales_custID = $_REQUEST['sales_custID'];
		$sales_branchID = $_REQUEST['sales_branchID'];
		$totalAmt = $_REQUEST['totalAmt'];
		$vat = $_REQUEST['vat'];
		$salesDetails = $_REQUEST['salesDetails'];
		$arr_salesDetails = explode("||",$salesDetails);
		if ($type == "edit")
			$salesID = $_REQUEST['salesID'];
	}else if ($type == "delete")
		$salesID = $_REQUEST['salesID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO sales (sales_custID, sales_branchID,  dateTrans, timeTrans,  totalAmt) VALUES ($sales_custID, $sales_branchID, NOW(), NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(salesID) as salesID FROM sales";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$row = mysql_fetch_assoc($query);
		$salesID = $row['salesID'];
		
		for ($i=0; $i < count($arr_salesDetails); $i++){
			$arrDetails = explode("|",$arr_salesDetails[$i]);
			
			$sql = "INSERT INTO salesdetails (`sd_salesID`, `sd_prodID`, `quantity`, `totalPurchase`, `sd_dateTrans`, `sd_timeTrans`) VALUES ($salesID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", NOW(), NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
		
	}else if ($type == "edit"){
		mysql_query("UPDATE sales SET sales_custID = '$sales_custID' , sales_branchID = '$sales_branchID' , totalAmt = '$totalAmt' WHERE salesID = $salesID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM sales WHERE salesID = '$salesID'",$conn);
	}else if ($type == "search"){
		//$query = mysql_query("SELECT * from sales WHERE prodCode LIKE '%$searchSTR%' OR prodName LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			/*while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prodID=\"".$row['prodID']."\" pCode=\"".$row['prodCode']."\" pName=\"".$row['prodName']."\" pDesc=\"".$row['prodDesc']."\" stockCnt=\"".$row['stockCount']."\" price=\"".$row['unitprice']."\" imgPath=\"".$row['imgPath']."\" />";
			}*/
		$xml .= "</root>";
		echo $xml;
	}
?>