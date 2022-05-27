window.onload = function(){

    var chooseCarButtons = document.getElementsByClassName('choice-btn')
    // console.log(chooseCarButtons);
    for(var i = 0; i < chooseCarButtons.length; i++){
        var button = chooseCarButtons[i]
        button.addEventListener('click', function(event){
            var buttonClicked = event.target
            var car_specs =  buttonClicked.parentElement.children
            
            var marca_model = car_specs[2]  // pot trimite catre php
            

            var location = car_specs[4].children[0].children[1].value
            var pickupDate = car_specs[4].children[1].children[1].value
            var returnDate = car_specs[4].children[2].children[1].value

            if(/*location.length == 0 ||*/ pickupDate.length == 0 || returnDate.length == 0){
                alert('Please fill all fields for the selected car!');
                return;
            }

            //verify is user is loggedIn
            var user = document.getElementById('welcome-message')
            if(user.style.display == "none")
            {
                alert('You have to be logged in to place an order!');
                window.location.replace("login_register.php");
                return;
            }

            var an = car_specs[1].innerHTML
            var pret = car_specs[3].innerHTML
            const car = marca_model.innerHTML.toString().split(' ');
            
            var model = car[car.length - 1]
            car.pop();
            var marca = car.join('_');


            var val = model + ' ' + marca + ' ' + an + ' ' + pret + ' ' + location + ' ' + pickupDate + ' ' + returnDate;

            var date1 = new Date(pickupDate);
            var date2 = new Date(returnDate);

            // console.log('date1: ' + date1);
            // console.log('date2: ', date2);
            //get days
            var diffTime = Math.abs(date2 - date1);
            var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
            
            // console.log(diffDays + 'days');
            $.ajax({
                url: "addProduct.php",
                type: "POST",
                data: {'carData': val, 'days': diffDays},
                // success: function(result){
                //     buttonClicked.innerHTML = "SENT";
                // }
            }).done(function(data) {
                // console.log(data);
                buttonClicked.innerHTML = "ADDED TO CART";
            });

            // console.log(an)
            // console.log(pret)
            // console.log(marca)
            // console.log(model)

        })
    }

}

