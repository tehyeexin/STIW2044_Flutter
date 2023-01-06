<?php

	error_reporting(0);
	if(!isset($_GET)){
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	
	$userid = $_GET['userid'];
	include_once("dbconnect.php");
	
	$sqlloadhomestay = "SELECT * FROM `tbl_homestay` WHERE user_id = '$userid' ORDER BY homestay_date DESC";
	$result = $conn->query($sqlloadhomestay);
	
	if ($result->num_rows > 0){
		$homestayarray["homestay"] = array();
		while($row = $result->fetch_assoc()){
			$hslist = array();
			$hslist['homestay_id'] = $row['homestay_id'];
			$hslist['homestay_name'] = $row['homestay_name'];
			$hslist['homestay_desc'] = $row['homestay_desc'];
			$hslist['homestay_price'] = $row['homestay_price'];
			$hslist['homestay_room'] = $row['homestay_room'];
			$hslist['homestay_state'] = $row['homestay_state'];
			$hslist['homestay_locality'] = $row['homestay_locality'];
			$hslist['homestay_lat'] = $row['homestay_lat'];
			$hslist['homestay_lng'] = $row['homestay_lng'];
			$hslist['homestay_contact'] = $row['homestay_contact'];
			$hslist['homestay_date'] = $row['homestay_date'];
			array_push($homestayarray["homestay"],$hslist);
		}
		$response = array('status' => 'success', 'data' => $homestayarray);
			sendJsonResponse($response);
	}
	else{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray){
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>