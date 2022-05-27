<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="cart.css">
    <!-- <script src="AssuranceButtons.js"></script> -->
    <script src="components/navbar.js" type="text/javascript" ></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="Cart.js"></script>
    <title>Your Cart</title>
</head>
<body>
    <navbar-component></navbar-component>
    <?php include "loginFrontend.php"; ?>

    <section class="cars" id="cars">
        <div class="heading">
            <span>Your Choices</span>
            <h1 id="cart-message">Explore Your Cart</h1>
        </div>


        <!-- spawn cars -->
        <div id="shopping-cart-container" class="cars-container">
            <?php
                include "backend/connect.php";


                $username = $_SESSION['Username'];
                // echo '<h3>' . $username . '</h3>';



                $sql = "SELECT c.* , p.Days
                from cars as c
                inner join products as p
                on c.id = p.Car_ID
                inner join users as u
                on u.id = p.Client_ID
                where u.username = '$username'";
                
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        $image = base64_encode($row['Imagine']);
                        $marca = $row['Marca'];
                        $model = $row['Model'];
                        $an = $row['An'];
                        $days = $row['Days'];
                        $pret = $row['Pret'];
                        $total = $pret * $days;

                        echo '<div class="box">
                                <img class="trash" src="images/trash-icon.png">
                                <div class="box-img">
                                    <img src="data:image/png;base64,' . $image . '"/>
                                </div>
                                <p class="car-year">' . $an . '</p>
                                <h3>' . '<span class="car-brand">' . $marca . '</span>' . ' ' . '<span class="car-model">' . $model . '</span>' . '</h3>
                                <h2>$' . '<span class="price">'. $total . '</span>' . '</h2>
                                
                                <div class="quantity-container">
                                    <button class="quantity-button minus-button">-</button>
                                    <h4>Assurance: Basic</h4>
                                    <button class="quantity-button plus-button">+</button>
                                </div>
                                <meter class="assurance-level" min="0" max="3" value="1"> at 50/100 </meter>

                            </div>';
                    
                    }
                    
                }
            ?>
        </div>

        <div class="cart-body">
            <hr> 
            <div class="checkout">
                <div class="total">
                    <div>
                        <div class="total-quantity">Total items: <span id="quantity-number"></span></div>
                    </div>
                    <div class="amount">$<span id="total-amount"></span></div>
                </div>
                <div class="button-container">
                    <button class="checkout-button">Checkout</button>
                </div>
            </div>
        </div>
    </section>
</body>
</html>