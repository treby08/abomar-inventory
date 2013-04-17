<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$fname = $_REQUEST['fname'];
		$mname = $_REQUEST['mname'];
		$lname = $_REQUEST['lname'];
		$address = $_REQUEST['address'];
		$phoneNum = $_REQUEST['phoneNum'];
		$mobileNum = $_REQUEST['mobileNum'];
		$tin = $_REQUEST['tin'];
		$businame = $_REQUEST['businame'];
		$baddress = $_REQUEST['baddress'];
		$bPhoneNum = $_REQUEST['bPhoneNum'];
		$bMobileNum = $_REQUEST['bMobileNum'];
		$email = $_REQUEST['email'];
		$gender = $_REQUEST['gender'];
		if ($type == "edit")
			$custID = $_REQUEST['custID'];
	}else if ($type == "delete")
		$custID = $_REQUEST['custID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT lname FROM customers WHERE lname='$lname' AND mname='$mname' AND  fname='$fname'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$fname $mname $lname Already Exist";
		}else{
			$query = mysql_query("INSERT INTO customers (fname, mname, lname, address, phoneNum, mobileNum, tin, businame, baddress, bPhoneNum, bMobileNum, email, gender) VALUES (\"$fname\", \"$mname\", \"$lname\", \"$address\", \"$phoneNum\", \"$mobileNum\", \"$tin\", \"$businame\", \"$baddress\", \"$bPhoneNum\", \"$bMobileNum\", \"$email\", \"$gender\" )",$conn);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE customers SET fname = '$fname' , mname = '$mname' , lname = '$lname' , address = '$address' , phoneNum = '$phoneNum' , mobileNum = '$mobileNum' , tin = '$tin' , businame = '$businame' , baddress = '$baddress' , bPhoneNum = '$bPhoneNum' , bMobileNum = '$bMobileNum' , email = '$email' , gender = '$gender' WHERE custID = $custID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM customers WHERE custID = '$custID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT * from customers WHERE fname LIKE '%$searchSTR%' OR lname LIKE '%$searchSTR%' OR mname LIKE '%$searchSTR%' OR businame LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item custID=\"".$row['custID']."\" fname=\"".$row['fname']."\" mname=\"".$row['mname']."\" lname=\"".$row['lname']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" businame=\"".$row['businame']."\" baddress=\"".$row['baddress']."\" bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\" email=\"".$row['email']."\" sex=\"".$row['gender']."\" />";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>