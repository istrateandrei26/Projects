<?php
    include "backend/connect.php";


    session_start();
    // $fp=fopen('test.txt', 'w');
    // fwrite($fp, $_SESSION['Username'] . "\n");
    // fwrite($fp, $_POST['data'] . "*\n");

    $username = $_SESSION['Username'];
    $data = $_POST['data'];
    $delimiter  = '_';
    $car_details = explode($delimiter, $data);

    $car_brand = $car_details[0];
    $car_model = $car_details[1];

    // fwrite($fp, $car_brand . "*\n");
    // fwrite($fp, $car_model . "*\n");

    $sql = "SELECT id FROM users WHERE username = '$username'";
    $result = $conn->query($sql);

    $row = $result->fetch_assoc();
    $user_id = intval($row['id']); 

    // fwrite($fp, $user_id . "\n");

    $sql = "SELECT id FROM cars WHERE Marca = '$car_brand' AND Model = '$car_model'";
    $result = $conn->query($sql);

    $row = $result->fetch_assoc();
    $car_id = intval($row['id']); 

    $sql = "DELETE FROM products WHERE Client_ID = '$user_id' AND Car_ID = '$car_id' LIMIT 1";
    $result = $conn->query($sql);


?>