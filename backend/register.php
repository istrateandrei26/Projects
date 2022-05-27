<?php

// Include config file

include "connect.php";

$username = $_POST['username'];
$email = $_POST['email'];
$password = $_POST['password'];


$check_query = "SELECT username FROM users WHERE username = '$username'";
$check_user_exists = mysqli_query($conn,$check_query);
if(mysqli_num_rows($check_user_exists) > 0)
{
    echo "<script>alert('Username $username already exists.')</script>";
}
else
{
    $desiredNumberOfBytes=12;
    $salt = base64_encode(random_bytes($desiredNumberOfBytes));
    $hashed = base64_encode(hash("sha512", $salt . $password, true));

    $Q="INSERT INTO users (username,email, password, salt) VALUES ('$username','$email','$hashed','$salt')";

    $result = mysqli_query($conn,$Q);

    if(!$result)
    {
        echo "<script>alert('Failed to register.')</script>";
    }
    else
    {
        header('Location: ../index.php');
    }
}




?>