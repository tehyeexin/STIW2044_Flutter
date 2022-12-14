<?php

	if(!isset($_POST['register'])){
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	
	include_once("dbconnect.php");
	
	$name = $_POST['name'];
	$email = $_POST['email'];
	$phone = $_POST['phone'];
	$password = sha1($_POST['password']);
	$otp = rand(10000,99999);
	$encoded_string = $_POST['image'];
	
	$sqlregister = "INSERT INTO `tbl_users`
	(`user_name`, `user_email`, `user_phone`, `user_password`, `user_otp`) 
	VALUES ('$name','$email','$phone','$password','$otp')";

	
	if($conn->query($sqlregister) === TRUE){
		$response = array('status' => 'success', 'data' => null);
		$decoded_string = base64_decode($encoded_string);
		$filename = mysqli_insert_id($conn);
		$path = '../assets/images/profile/' . $filename . '.png';
		$is_written = file_put_contents($path, $decoded_string);
		sendEmail($email);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray){
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
	
	function sendEmail($email){
	}

?>