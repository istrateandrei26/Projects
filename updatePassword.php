<?php

// Include config file

include "backend/connect.php";

$data = $_POST['data'];

// $fp=fopen('test.txt', 'w');

// fwrite($fp, $message . "\n");

$delimiter  = ' ';
$details = explode($delimiter, $data);
// fwrite($fp, $details[0] . "*\n");
// fwrite($fp, $details[1] . "*\n");
// fwrite($fp, $details[2] . "*\n");

$username = $details[0];
$password = $details[1];

$desiredNumberOfBytes=12;
$salt = base64_encode(random_bytes($desiredNumberOfBytes));
$hashed = base64_encode(hash("sha512", $salt . $password, true));

$Q="UPDATE users 
SET password='$hashed',salt='$salt' 
WHERE username='$username'";

$result = mysqli_query($conn,$Q);



?>