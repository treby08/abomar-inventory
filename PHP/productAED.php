<?php
	require("config.php");
	//{prodID:obj.@prodID,pCode:obj.@pCode,pName:obj.@pName,pDesc:obj.@pDesc,stockCnt:obj.@stockCnt,price:obj.@price,imgPath:obj.@imgPath}
	//SELECT `prodID`, `prodCode`, `prodName`, `prodDesc`, `stockCount`, `unitprice` FROM `adomardb`.`products` LIMIT 0, 1000;
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$pCode = $_REQUEST['pCode'];
		$pName = $_REQUEST['pName'];
		$pDesc = $_REQUEST['pDesc'];
		$stockCnt = $_REQUEST['stockCnt'];
		$price = $_REQUEST['price'];
		$imgPath = $_REQUEST['imgPath'];
		if ($type == "edit")
			$prodID = $_REQUEST['prodID'];
	}else if ($type == "delete")
		$prodID = $_REQUEST['prodID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr']==-1?"":$_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT prodCode FROM products WHERE prodCode='$pCode'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$pCode Already Exist";
		}else{
			$query = mysql_query("INSERT INTO products (prodCode, prodName, prodDesc, stockCount, unitprice, imgPath) VALUES (\"$pCode\", \"$pName\", \"$pDesc\", \"$stockCnt\", \"$price\", \"$imgPath\")",$conn);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE products SET prodCode = '$pCode' , prodName = '$pName' , prodDesc = '$pDesc' , stockCount = '$stockCnt' , unitprice = '$price' , imgPath = '$imgPath' WHERE prodID = $prodID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM products WHERE prodID = '$prodID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT p.*,branchName FROM products p
							INNER JOIN branches b ON p.prod_branchID=b.branchID 
							WHERE prodCode LIKE '%$searchSTR%' OR prodName LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prodID=\"".$row['prodID']."\" pCode=\"".$row['prodCode']."\" pName=\"".$row['prodName']."\" pDesc=\"".$row['prodDesc']."\" stockCnt=\"".$row['stockCount']."\" price=\"".$row['unitprice']."\" imgPath=\"".$row['imgPath']."\" branchName=\"".$row['branchName']."\" />";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>