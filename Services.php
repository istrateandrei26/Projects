<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services</title>
    <link rel="stylesheet" href="services.css">
    <script src="Product.js"></script>
    <script src="components/navbar.js" type="text/javascript" ></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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

    <!--CARS SECTION -->
    <section class="cars" id="cars">
        <div class="heading">
            <span>Our Stuff</span>
            <h1>Explore The Best Deals<br>Top Rated Dealers</h1>
        </div>


        <!-- spawn cars -->
        <div class="cars-container">
            <?php
                include "backend/connect.php";

                $sql = "SELECT * FROM cars";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    // output data of each row
                    while($row = $result->fetch_assoc()) {
                        $image = base64_encode($row['Imagine']);
                        $marca = $row['Marca'];
                        $model = $row['Model'];
                        $an = $row['An'];
                        $pret = $row['Pret'];

                        echo '<div class="box">
                                <div class="box-img">
                                    <img src="data:image/png;base64,' . $image . '"/>
                                </div>
                                <p>' . $an . '</p>
                                <h3>' . $marca . ' ' . $model . '</h3>
                                <h2>$' . $pret . ' /24h</h2>

                                <div class="form-container">
                                        <div style="display:none;" class="input-box">
                                            <span>Location</span>
                                            <input type="search" name="" id="" placeholder="Search places">
                                        </div>
                                        <div class="input-box">
                                            <span>Pick-up Date</span>
                                            <input type="date" name="" id="pickup-date">
                                        </div>
                                        <div class="input-box">
                                            <span>Return Date</span>
                                            <input type="date" name="" id="return-date">
                                        </div>
                                </div>

                                <a href="javascript:;" class="btn choice-btn">Choose</a>
                            </div>';
                    
                    }

                    
                } else {
                    echo "0 results";
                }
            ?>
        </div>

    </section>
    
</body>
</html>