<?php
    // are you sure
    
    session_start();
    unset($_SESSION['Username']);
    unset($_SESSION['loggedIn']);
    unset($_SESSION['admin']);
    $_SESSION['Username'] = NULL;
    $_SESSION['loggedIn'] = NULL;
    $_SESSION['admin'] = NULL;
    header('Location: index.php');




?>