class About extends HTMLElement{
    constructor(){
        super();
    }

    connectedCallback(){
        this.innerHTML = `
        <!--ABOUT SECTION-->

        <section class="about" id="about">
            <div class="heading">
                <span>About Us</span>
                <h1>Best Experience</h1>
            </div>
    
            <div class="about-container">
                <div class="about-img">
                    <img src="images/about_image.png" alt="">
                </div>
                <div class="about-text">
                    <span>About Us</span>
                    <p>GetWheels company was established 37 years ago. Through the years the company gained a well-established reputation for its commitment to offer quality, timely and unparalleled customer service.</p>
                    <p>Since our clientele is diversified, we offer a wide selection of new models starting from small city cars, medium sized, automatic and luxury cars able to satisfy or give mobile solution at any of your professional or private needs. All car models we provide, are new and in excellent condition.</p>
                    <a href="#" class="btn">Learn More</a>
                </div>
            </div>
        </section>

        <style>
        .heading{
            margin-top:40px;
            text-align: center;
        }
        
        .heading span{
            font-weight: 500;
            text-transform: uppercase;
        }
    

        .heading h1{
            font-size: 2rem;
        }
        
        section .about-container{
            margin-top: 230px;
        }

        
        .about-container{
            display: grid;
            grid-template-columns: repeat(2,1fr);
            margin-top: 2rem;
            align-items: center;
            gap: 1rem;
        }
        
        .about-img img{
            width: 100%;
        }
        
        .about-text span{
            font-weight: 500;
            color: #0b666b;
            text-transform: uppercase;
        
        }
        
        .about-text p{
            margin: 0.5rem 0 1.4rem;
        }
        
        .about-text .btn{
            padding: 10px 20px;
            background: #0b666b;
            color: #e7e7e7;
            border-radius: 0.5rem;
        
        }
        
        
        .about-text .btn:hover{
            background: #00acb4;
        
        }
        </style>
    `
    }
}


customElements.define('about-component',About);