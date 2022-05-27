<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="adminOrders.css">
    <script src="components/navbar.js" type="text/javascript" defer></script>
    <title>View Orders</title>
</head>
<body>
    <navbar-component></navbar-component>
    <?php session_start();
        if($_SESSION['admin'] == false)
        {
            include "loginFrontend.php";
        }
        else
        {
            include "adminFrontendChanges.php";
        }
    ?>

<?php
    include "backend/connect.php";
    // $username = $_SESSION['Username'];
    // echo '<h3>' . $username . '</h3>';

    $sql = "SELECT DISTINCT u.username, c.Marca, c.Model
    FROM orders as o
    inner join users as u
    on o.ClientID=u.id
    inner join order_details as od
    on o.OrderID=od.OrderID
    inner join cars as c 
    on c.id=od.CarID  
    ORDER BY u.username ASC;";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // output data of each row

        echo '<table>
        <tr>
            <th>Username</th>
            <th>Car Brand</th>
            <th>Car Model</th>
        </tr>
        ';
        while($row = $result->fetch_assoc()) {
            $marca = $row['Marca'];
            $model = $row['Model'];
            $username = $row['username'];
            
            echo '
            <tr>
                <td>' . "$username" .'</td>
                <td>' . "$marca" .'</td>
                <td>' . "$model" .'</td>
            </tr>
            ';
            
        
        }

        echo '</table>';
    }
?>
    
</body>
</html>