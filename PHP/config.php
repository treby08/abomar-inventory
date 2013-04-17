<?php
	$host = "localhost";
	$user = "philnigc_adomar";
	$pass = "!@adomar$%";
	$dbName = "philnigc_adomar_db";
	
	$conn = mysql_connect($host,$user,$pass) or die(mysql_error());
	mysql_select_db($dbName,$conn) or die(mysql_error());
?>