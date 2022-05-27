<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews</title>
    <script src="components/navbar.js" type="text/javascript" defer></script>
    <script src="components/reviews.js" type="text/javascript" defer></script>
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
    <reviews-component></reviews-component>
    
</body>
</html>