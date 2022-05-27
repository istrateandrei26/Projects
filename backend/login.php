<?php

// Include config file

include "connect.php";

$username=$_POST['username'];
$password=$_POST['password'];


$Q="SELECT * FROM users WHERE username = '$username'";
$result=mysqli_query($conn,$Q);
if(mysqli_num_rows($result) > 0)
{
    $row=mysqli_fetch_array($result);
    $salt=$row['salt'];
    $database_pass=$row['password'];
    $hashed = base64_encode(hash("sha512", $salt . $password, true));
    $admin = intval($row['admin']);
    // $fp=fopen('test.txt', 'w');
    // fwrite($fp, $admin . "\n");
    // fclose($fp);
    session_start();
    

    if($hashed == $database_pass)
    {
        $_SESSION['Username'] = $username;
        $_SESSION['loggedIn'] = true;

        if($admin == 1)
        {
            $_SESSION['admin'] = true;
        }
        else
        {
            $_SESSION['admin'] = false;
        }

        header('Location: ../index.php');   
    }
    else
    {
        echo "<script>alert('Wrong username or password.')</script>";
        header('Location: ../index.php'); 
    }
}
else
{
    echo "<script>alert('Wrong username or password.')</script>";
    header('Location: ../index.php'); 
}



?>