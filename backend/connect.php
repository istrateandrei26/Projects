<?php

    //connect to database
    $conn = mysqli_connect('localhost', 'andrei', 'andrei', 'web');

    //check conn:
    if(!$conn)
    {
        echo 'Connection error: ' . mysqli_connect_error();
    }


?>