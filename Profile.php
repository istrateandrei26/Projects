<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="components/navbar.js" type="text/javascript" ></script>
    <script src="profile.js" type="text/javascript" ></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="profile.css">
    <link rel="stylesheet" href="style.css">
    <title>My Profile</title>
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
    <div class="container">
        <div class="mainDiv">
            <div class="cardStyle">
                <div>
                    <img src="" id="signupLogo"/>
                    <h2 class="formTitle">
                        My Profile
                    </h2>

                    <div class="inputDiv">
                        <label class="inputLabel" for="password">New Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="inputDiv">
                        <label class="inputLabel" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword">
                    </div>
                
                    <div class="buttonWrapper">
                        <button type="submit" id="submitButton" onclick="validateSignupForm()" class="submitButton pure-button pure-button-primary">
                            <span>Change Password</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <h3 id="successChanged">Successfully changed password!</h3>
    </div>
</body>
</html>