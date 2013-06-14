<?php
	require("config.php");
	$type = $_REQUEST['type'];
	$xml = "<root type=\"".$type."\">";
	if ($type == "branches"){
		$query = mysql_query('SELECT * FROM branches',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item branchID=\"".$row['branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" bAddress=\"".$row['bAddress']."\" 
			bConPerson=\"".$row['bConPerson']."\" bDesig=\"".$row['bDesig']."\" bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\" 
			bEmailAdd=\"".$row['bEmailAdd']."\" bLocMap=\"".$row['bLocMap']."\"/>";
		}
	}else if($type=="remarks"){
		$query = mysql_query('SELECT * FROM whr_remarks',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item remID=\"".$row['remID']."\" remLabel=\"".$row['remLabel']."\" />";
		}
	}else if ($type=="userType"){
		$query = mysql_query('SELECT * FROM usertype',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item userTypeID=\"".$row['userTypeID']."\" userTypeName=\"".$row['name']."\" remark=\"".$row['remarks']."\" />";
		}
	}else if ($type=="invoice"){
		$custID = $_REQUEST['custID'];
		if ($custID)
			$add = " AND sq_custID=".$custID;
		$query = mysql_query('SELECT * FROM salesInvoice WHERE onProcess=0'.$add,$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item invID=\"".$row['sqID']."\" totalAmt=\"".$row['totalAmt']."\" invIDLabel=\"".$row['sq_quoteNo']."\" />";
		}
	}
	$xml .= "</root>";
	echo $xml;
	
?>