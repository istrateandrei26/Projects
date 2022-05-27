<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="MyOrders.css">
    <script src="components/navbar.js" type="text/javascript" ></script>
    <title>Orders</title>
</head>
<body>
    <navbar-component></navbar-component>
    <?php include "loginFrontend.php"; ?>
    <section class="cars" id="cars">
        <div class="heading">
            <span>Your Ordered Cars</span>
            <h1 id="order-message">Explore Your Preferences</h1>
        </div>


    <!-- spawn cars -->
    <div id="shopping-cart-container" class="cars-container">
            <?php
                include "backend/connect.php";

                $username = $_SESSION['Username'];
                // echo '<h3>' . $username . '</h3>';



                $sql = "SELECT DISTINCT c.Marca,c.Model,c.Imagine,c.An
                FROM orders as o
                inner join users as u 
                on o.ClientID=u.id
                inner join order_details as od
                on od.OrderID=o.OrderID
                inner join cars as c
                on c.id=od.CarID
                where u.username='$username'";
                
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        $image = base64_encode($row['Imagine']);
                        $marca = $row['Marca'];
                        $model = $row['Model'];
                        $an = $row['An'];

                        echo '
                                <div class="box">
                                    <div class="box-img">
                                        <img src="data:image/png;base64,' . $image . '"/>
                                    </div>
                                    <p class="car-year">' . $an . '</p>
                                    <h3>' . '<span class="car-brand">' . $marca . '</span>' . ' ' . '<span class="car-model">' . $model . '</span>' . '</h3>
                                </div>
                            ';
                    
                    }
                    
                } else {
                    echo "<script type='text/javascript'>
                            var message = document.getElementById('order-message')
                            message.innerHTML = 'You didn\'t order anything yet.'
                        </script>";
                }
            ?>
        </div>
    </section>
</body>
</html>