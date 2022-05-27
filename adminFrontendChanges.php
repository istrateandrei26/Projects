<!-- PHP FRONTEND FOR LOGIN -->
<?php
    if(!isset($_SESSION)) 
    { 
        session_start(); 
    } 
    if ($_SESSION['admin'] == true):?>
        <script type="text/javascript">
            window.addEventListener("load", function(event) {
                // alert("Session is set");
                // var loginButton = document.getElementById('loginbutton');
                // var registerButton = document.getElementById('registerbutton');
                // var parent = document.getElementById('buttonsDiv');

                // var removedLoginButton = parent.removeChild(loginButton);
                // var removedRegisterButton = parent.removeChild(registerButton);
                var welcomeMessage = document.getElementById('welcome-message');
                welcomeMessage.innerHTML = '<?php echo 'Welcome, '. $_SESSION['Username'] .'';?>';
                welcomeMessage.style.display = "block";

                var logoutButton = document.getElementById('logoutbutton');
                logoutButton.style.display = "block";

                
                var adminordersButton = document.getElementById('adminorders-button');
                adminordersButton.style.display = "block"; 

                var myordersButton = document.getElementById('myorders-button');
                myordersButton.style.display = "none"; 
                
                var servicesButton = document.getElementById('services-button');
                servicesButton.style.display = "none"; 

                var cartButton = document.getElementById('cart-button');
                cartButton.style.display = "none"; 
                
                // var profileButton = document.getElementById('profile-button');
                // profileButton.style.display = "block";

            });
            
        </script>
<?php else : ?>
    <script type="text/javascript">
            window.addEventListener("load", function(event) {

                var welcomeMessage = document.getElementById('welcome-message');
                welcomeMessage.style.display = "none";
                
                var logoutButton = document.getElementById('logoutbutton');
                logoutButton.style.display = "none";

                var cartButton = document.getElementById('cart-button');
                cartButton.style.display = "none"; 

                var adminordersButton = document.getElementById('adminorders-button');
                adminordersButton.style.display = "none"; 

                var myordersButton = document.getElementById('myorders-button');
                myordersButton.style.display = "none"; 
                
                // var profileButton = document.getElementById('profile-button');
                // profileButton.style.display = "none";  

                var registerButton = document.getElementById('registerbutton');
                registerButton.style.display = "block";

                var loginButton = document.getElementById('loginbutton');
                loginButton.style.display = "block";

            });
        </script>

    <?php endif ?>