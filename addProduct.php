<?php

$message = $_POST['carData'];
$days = $_POST['days'];

// $fp=fopen('test.txt', 'w');
// fwrite($fp, $days . "\n");
// fclose($fp);


$delimiter  = ' ';
$car_details = explode($delimiter, $message);

$car_brand = "";
$car_model = $car_details[0];
$car_br = $car_details[1];
$car_brand_copy = $car_br;



$word_to_find = "_";
if(strpos($car_brand_copy, $word) !== false){
    $list = explode("_", $car_brand_copy);
    $car_brand = $list[0] . ' ' . $list[1];
} 
else
{
    $car_brand = $car_brand_copy;
}
$car_brand = rtrim($car_brand);


session_start();
$username = $_SESSION['Username'];

include "backend/connect.php";
$sql = "SELECT id FROM users WHERE username = '$username'";
$result = $conn->query($sql);

$row = $result->fetch_assoc();
$user_id = intval($row['id']); 

// fwrite($fp, $user_id . "\n");

$sql = "SELECT id FROM cars WHERE Marca = '$car_brand' AND Model = '$car_model'";
$result = $conn->query($sql);

$row = $result->fetch_assoc();
$car_id = intval($row['id']); 

$sql = "INSERT INTO products (Client_ID, Car_ID, Days) VALUES ('$user_id', '$car_id', '$days')";
$result = mysqli_query($conn,$sql);

// fclose($fp);

// file_put_contents('test.txt', $message);


?>