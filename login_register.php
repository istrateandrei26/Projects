<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register/LogIn</title>
    <link rel="stylesheet" type="text/css" href="login_register.css">
    <script src="components/navbar.js" type="text/javascript" defer></script>
</head>
<body>
    <navbar-component></navbar-component>
    <div class="main">
        <input type="checkbox" id="check" aria-hidden="true">

        <div class="register">
            <form method="post" action="backend/register.php">
                <label for="check" aria-hidden="true">Sign Up</label>

                <input type="text" name="username" placeholder="Username" required="">
                <input type="email" name="email" placeholder="Email" required="">
                <input type="password" name="password" placeholder="Password" required="">
                <button type="submit">Register</button>
            </form>
        </div>

        <div class="login">
            <form method="post" action="backend/login.php">
                <label for="check" aria-hidden="true">Login</label>
                <input type="text" name="username" placeholder="Username" required="">
                <input type="password" name="password" placeholder="Password" required="">
                <button type="submit">Login</button>

            </form>
        </div>

    </div>
</body>
</html>