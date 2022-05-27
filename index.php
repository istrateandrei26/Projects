<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GetWheels</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">  <!--icons -->
    <script src="script.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" type="text/javascript"></script>
    <script src="components/navbar.js" type="text/javascript" defer></script>
    <!-- https://stackoverflow.com/questions/20390949/edit-the-contents-of-another-page-with-php/20391053 -->

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


    <!--HOME SECTION-->

    <section class="home" id="home">
        <div class="text">
            <h1><span>Rent</span> The Best Quality <br>Cars With Us</h1>
            <p>You can everytime choose the best car from our local stores or order it remotely at the <br>best price for you and get the best quality cars as long as you expect</p>
        </div>

        <!-- <div class="form-container">
            <form action="">
                <div class="input-box">
                    <span>Location</span>
                    <input type="search" name="" id="" placeholder="Search places">
                </div>
                <div class="input-box">
                    <span>Pick-up Date</span>
                    <input type="date" name="" id="">
                </div>
                <div class="input-box">
                    <span>Return Date</span>
                    <input type="date" name="" id="">
                </div>
                <input type="submit" value="Submit" id="" class="btn">
            </form>
        </div> -->
    </section>



    <!--STEPS SECTION-->

    <section class="ride" id="ride">
        <div class="heading">
            <span>Let's see how it's done</span>
            <h1>Rent A Car With 3 Easy Steps</h1>
        </div>

        <div class="ride-container">
            <div class="box">
                <img class="bx" src="images/icon1.png">
                <h2>Choose a pick-up place</h2>
            </div>

            <div class="box">
                <img class="bx" src="images/calendar.png">
                <h2>Choose a date</h2>
            </div>

            <div class="box">
                <img class="bx" src="images/finish_sign.png">
                <h2>Book a car</h2>
            </div>
        </div>
    </section>

</body>
</html>