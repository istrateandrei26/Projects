function updateShoppingCart() {
    var cartContainer = document.getElementById('shopping-cart-container')
    var items = document.getElementsByClassName('box')

    var total = 0
    var count = 0;

    for(var i = 0; i< items.length;i++){
        count++
        var cartItem = items[i]
        var price = parseInt(cartItem.getElementsByClassName('price')[0].innerHTML)
        total += price
    }

    // console.log(total)
    document.getElementById('quantity-number').innerHTML = count
    document.getElementById('total-amount').innerHTML = total

    
}


window.onload = function(){
    updateShoppingCart();

    var deleteItemButtons = document.getElementsByClassName('trash')
    for(var i = 0; i < deleteItemButtons.length; i++){
        var button = deleteItemButtons[i]
        button.addEventListener('click', function(event){
    
            var buttonClicked = event.target

            buttonClicked.parentElement.remove()
            updateShoppingCart()
            
            var car_brand = buttonClicked.parentElement.getElementsByClassName('car-brand')[0].innerHTML
            var car_model = buttonClicked.parentElement.getElementsByClassName('car-model')[0].innerHTML
            
            var data = car_brand + '_' + car_model

            $.ajax({
                url: "deleteCartItem.php",
                type: "POST",
                data: {'data': data},
                // success: function(result){
                //     buttonClicked.innerHTML = "SENT";
                // }
            }).done(function(data) {
                // console.log(data);
                ;
            });


        })
    }


    var plusButtons = document.getElementsByClassName('plus-button')
    for(var i = 0; i < plusButtons.length; i++){
        var button = plusButtons[i]
        button.addEventListener('click', function(event){
            var buttonClicked = event.target
            var progress_bar = buttonClicked.parentElement.parentElement.children[6]
            var elements = buttonClicked.parentElement.children

            var price = parseInt(buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML);
            // console.log(price);

            var assurance_level = elements[1]
            if(progress_bar.value == 1)
            {
                assurance_level.innerHTML = "Assurance: Premium"
                price += 20;
                buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML = price;

            }
            if(progress_bar.value == 2)
            {
                assurance_level.innerHTML = "Assurance: VIP"
                price += 40;
                buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML = price;
            }

            if(progress_bar.value == 3)
                return
            progress_bar.value++;

            updateShoppingCart();
        
        })
    }


    var minusButtons = document.getElementsByClassName('minus-button')
    for(var i = 0; i < minusButtons.length; i++){
        var button = minusButtons[i]
        button.addEventListener('click', function(event){
            var buttonClicked = event.target
            var progress_bar = buttonClicked.parentElement.parentElement.children[6]
            var elements = buttonClicked.parentElement.children

            var price = parseInt(buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML);

            var assurance_level = elements[1]
            if(progress_bar.value == 3)
            {
                assurance_level.innerHTML = "Assurance: Premium"
                price -= 40;
                buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML = price;

            }
            if(progress_bar.value == 2)
            {
                assurance_level.innerHTML = "Assurance: Basic"
                price -= 20;
                buttonClicked.parentElement.parentElement.getElementsByClassName('price')[0].innerHTML = price;
            }

            

            if(progress_bar.value == 1)
                return
            progress_bar.value--;

            updateShoppingCart();
        })
    }
    

    var checkout_container = document.getElementsByClassName('cart-body')[0]
    var total_number = document.getElementById('total-amount').innerHTML
    var cart_message = document.getElementById('cart-message')

    if(total_number == 0)
    {
        checkout_container.style.display = "none"
        cart_message.innerHTML = "Your cart is empty"
    }
    else
    {
        checkout_container.style.display = "block"
        cart_message.innerHTML = "Explore Your Cart"
    }

    var checkoutButton = document.getElementsByClassName('checkout-button')[0];
    checkoutButton.onclick = function(){
        var checkout_var = parseInt(document.getElementById('total-amount').innerHTML);
        console.log(checkout_var);
        $.ajax({
            url: "checkout.php",
            type: "POST",
            data: {'data': checkout_var,},
            // success: function(result){
            //     buttonClicked.innerHTML = "SENT";
            // }
        }).done(function(data) {
            // console.log(data); aici sa setez un timer pentru a nu fi coliziune cand sterg din cosul din baza de date!
            window.location.href="index.php"
        });
    }

    



}