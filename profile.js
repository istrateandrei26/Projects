window.onload = function(){
    var submitButton = document.getElementById('submitButton');
    var password = document.getElementById("password");
    var confirm_password = document.getElementById("confirmPassword");

    

    submitButton.onclick = function(){
        console.log(password.value);
        console.log(confirm_password.value);
        if(password.value != confirm_password.value) {
            alert('Passwords don\'t match!');   
        }
        else{
            var username = document.getElementById('welcome-message').innerHTML.split(' ')[1];
            var data = username + ' ' + password.value + ' ' + confirm_password.value;
            //send username to php 
            $.ajax({
                url: "updatePassword.php",
                type: "POST",
                data: {'data': data},
                // success: function(result){
                //     buttonClicked.innerHTML = "SENT";
                // }
            }).done(function(data) {
                // console.log(data);
                document.getElementById("successChanged").style.display="block";
                setTimeout(function(){
                document.getElementById("successChanged").style.display="none";
                },3000);
            });
        }
    }
}