<?php
	require("config.php");
	//{prodID:obj.@prodID,pCode:obj.@pCode,pName:obj.@pName,pDesc:obj.@pDesc,stockCnt:obj.@stockCnt,price:obj.@price,imgPath:obj.@imgPath}
	//SELECT `prodID`, `prodCode`, `prodName`, `prodDesc`, `stockCount`, `unitprice` FROM `adomardb`.`products` LIMIT 0, 1000;
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$modelNo = $_REQUEST['modelNo'];
		$pCode = $_REQUEST['pCode'];
		$remarks = $_REQUEST['remarks'];
		$pDate = $_REQUEST['pDate'];
		$factor = $_REQUEST['factor'];
		$stockCnt = $_REQUEST['stockCnt'];
		$price = $_REQUEST['price'];
		$supplier = $_REQUEST['supplier'];
		$weight = $_REQUEST['weight'];
		$size = $_REQUEST['size'];
		$subNum = $_REQUEST['subNum'];
		$comModUse = $_REQUEST['comModUse'];
		$returnable = $_REQUEST['returnable']=="false"?0:1;
		$inactive = $_REQUEST['inactive']=="false"?0:1;		
		$imgPath = $_REQUEST['imgPath'];
		$listPrice = $_REQUEST['listPrice'];
		$dealPrice = $_REQUEST['dealPrice'];
		$srPrice = $_REQUEST['srPrice'];
		$priceCurr = $_REQUEST['priceCurr'];
		
		if ($type == "edit")
			$prodID = $_REQUEST['prodID'];
	}else if ($type == "delete")
		$prodID = $_REQUEST['prodID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr']==-1?"":$_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT prodModel FROM products WHERE prodModel='$modelNo'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$modelNo Already Exist";
		}else{
			$query = mysql_query("INSERT INTO products (prodModel, prodCode, prodSubNum, prodComModUse,	supplier, remarks, prodDate, factor, imgPath, 
	prodWeight, prodSize, stockCount, returnable, listPrice, dealPrice, srPrice, priceCurr, prod_branchID, isDeleted) VALUES (\"$modelNo\", \"$pCode\", \"$subNum\", \"$comModUse\", \"$supplier\", \"$remarks\", \"$pDate\", \"$factor\", \"$imgPath\", \"$weight\", \"$size\", \"$stockCnt\", $returnable, $listPrice, $dealPrice, $srPrice, \"$priceCurr\", 1,$inactive)",$conn);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE products SET prodModel = '$modelNo' , prodCode = '$pCode' , prodSubNum = '$subNum' , prodComModUse = '$comModUse' , supplier = '$supplier' , remarks = '$remarks' , prodDate = '$pDate' , factor = '$factor' , imgPath = '$imgPath' , prodWeight = '$weight' , prodSize = '$size' , stockCount = '$stockCnt', returnable = '$returnable' , listPrice = '$listPrice' , dealPrice = '$dealPrice' , srPrice = '$srPrice' , priceCurr = '$priceCurr' , isDeleted = '$inactive' WHERE prodID = $prodID",$conn);
	}else if ($type == "delete"){
		mysql_query("UPDATE products SET isDeleted=1 WHERE prodID = '$prodID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT p.*,b.bCode AS branchName FROM products p
							INNER JOIN branches b ON p.prod_branchID=b.branchID 
							WHERE (prodCode LIKE '%$searchSTR%' OR prodModel LIKE '%$searchSTR%') AND isDeleted=0",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prodID=\"".$row['prodID']."\" pCode=\"".$row['prodCode']."\" modelNo=\"".$row['prodModel']."\" remarks=\"".$row['remarks']."\" stockCnt=\"".$row['stockCount']."\" returnable=\"".$row['returnable']."\" imgPath=\"".$row['imgPath']."\" branchName=\"".$row['branchName']."\" supplier=\"".$row['supplier']."\" weight=\"".$row['prodWeight']."\" size=\"".$row['prodSize']."\" subNum=\"".$row['prodSubNum']."\" comModUse=\"".$row['prodComModUse']."\" pDate=\"".$row['prodDate']."\" factor=\"".$row['factor']."\" inactive=\"".$row['inactive']."\" listPrice=\"".$row['listPrice']."\" dealPrice=\"".$row['dealPrice']."\" srPrice=\"".$row['srPrice']."\" priceCurr=\"".$row['priceCurr']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>