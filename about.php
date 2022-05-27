<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
    <link rel="stylesheet" href="about.css">
    <script src="script.js"></script>
    <script src="components/navbar.js" type="text/javascript" defer></script>
    <script src="components/about.js" type="text/javascript" defer></script>
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
    <about-component></about-component>
    
    
</body>
</html>