<?php

    session_start();
    $username = $_SESSION['Username'];

    include "backend/connect.php";

    $sql = "SELECT SUM(c.Pret * p.Days) as Total
    FROM users AS u
    INNER JOIN products as p
    on u.id=p.Client_ID
    INNER JOIN cars as c
    on c.id=p.Car_ID
    GROUP BY u.id;";

    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $total = intval($row['Total']);
    $total = intval($_POST['data']);

    $sql = "SELECT id FROM users WHERE username = '$username'";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $user_id = intval($row['id']); 


    $sql = "INSERT INTO orders (ClientID, Total) VALUES ('$user_id', '$total')";
    $result = mysqli_query($conn,$sql);

    $sql = "SELECT o.OrderID as LastOrderId
            FROM orders as o
            ORDER BY o.OrderID DESC LIMIT 1" ;
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $last_order_id = intval($row['LastOrderId']); 


    $sql = "SELECT c.*
            from cars as c
            inner join products as p
            on c.id = p.Car_ID
            inner join users as u
            on u.id = p.Client_ID
            where u.username = '$username'";

    $result = $conn->query($sql);
    
    // $fp=fopen('test.txt', 'w');
    
    
    if ($result->num_rows > 0) {
        // output data of each row
        while($row = $result->fetch_assoc()) {

            $current_car_id = intval($row['id']);
            $sql = "INSERT INTO order_details (OrderID, CarID) VALUES ('$last_order_id', '$current_car_id')";
            $myresult = mysqli_query($conn,$sql);
            
            // fwrite($fp, $current_car_id . "\n");
        }
    }

    $sql = "DELETE FROM products WHERE Client_ID = '$user_id'";
    $result = $conn->query($sql);

    // $message = $_POST['data']; it works







?>