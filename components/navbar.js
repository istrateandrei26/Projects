

class Navbar extends HTMLElement{
    constructor(){
        super();
    }

    connectedCallback(){
        this.innerHTML = `
    <header>
        <a href="index.php" class="logo"><img src="images/carLogo.png" alt=""></a>
        
        
        <div class="bx bx-menu" id="menu-icon"></div>

        <ul class="navbar">
            <li><a href="index.php#home">Home</a> </li>
            <li><a href="index.php#ride">Ride</a> </li>
            <li id="services-button"><a href="Services.php">Services</a> </li>
            <li id="about-button"><a href="about.php">About</a> </li>
            <li><a href="reviews.php">Reviews</a> </li>
            <li style="display:none;" id="cart-button"><a href="cart.php">Cart</a> </li>
            <li style="display:none;" id="myorders-button"><a href="MyOrders.php">Orders</a> </li>
            <li style="display:none;" id="adminorders-button"><a href="adminViewOrders.php">View Orders</a> </li>
        </ul>

        <div id="buttonsDiv" class="header-btn">
            
            <a href="login_register.php" style="display: none;" class="sign-up" id="registerbutton">Register</a>
            <a href="login_register.php" style="display: none;" class="sign-in" id="loginbutton">Login</a>
            <a href="Profile.php" style="display: none;" class="sign-in" id="welcome-message"></a>
            <a href="logout.php" style="display: none;" class="sign-in" id="logoutbutton">Logout</a>
        </div>
    </header>

    <style>
    *{
        margin:0;
        padding: 0;
        box-sizing: border-box;
        scroll-padding-top: 2rem;
        scroll-behavior: smooth;
        list-style: none;
        text-decoration: none;
    }
    
    :root{
        --main-color: #202731;
        --second-color: #00acb4;
        --text-color: #e7e7e7;
        --gradient: linear-gradient(#202731,#00acb4);
    }
    
    
    html::-webkit-scrollbar{
        width: 0.5rem;
    }
    
    html::-webkit-scrollbar-track{
        background-color: transparent;
    }
    
    html::-webkit-scrollbar-thumb{
        background-color: var(--main-color);
    }
    
    
    section{
        padding: 50px 100px;
    }
    
    header{
        position:fixed;
        width: 100%;
        top:0;
        right: 0;
        z-index: 1000;
        padding: 15px 100px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: #202731;
    }
    
    #menu-icon{
        color: #e7e7e7;
        font-size: 25px;
        cursor: pointer;
        z-index: 10001;
        display: none;
    }
    
    
    .logo img{
        width: 50px;
    }
    
    .navbar{
        display: flex;
    }
    
    .navbar li{
        position: relative;
    }
    
    .navbar a{
        font-size: 1rem;
        padding: 10px 20px;
        color: var(--text-color);
        font-weight: 500;
    }
    
    .navbar a::after
    {
        content: '';
        width: 0;
        height: 3px;
        background: var(--gradient);
        position: absolute;
        bottom: -4px;
        left: 0;
        transition: 0.5s;
    }
    
    
    
    
    
    .navbar a:hover::after
    {
        width: 100%;
    }
    
    
    .header-btn a{
        padding: 10px 20px;
        color: var(--text-color);
        font-weight: 500px;
    }
    
    .header-btn .sign-in{
        background: #0b666b;
        color: #e7e7e7;
        border-radius: 0.5rem;
        
    }
    
    .header-btn .sign-in:hover{
        background: #00acb4;
    }

    .header-btn{
        display: flex;
        flex-direction: row;
        gap: 1rem;
    }
    
    </style>
    `
    }
}


customElements.define('navbar-component',Navbar);