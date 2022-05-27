
    class Reviews extends HTMLElement{
    constructor(){
        super();
    }

    connectedCallback(){
        this.innerHTML = `
        <!--REVIEW SECTION-->

    <section class="reviews" id="reviews">
        <div class="heading">
            <span>Reviews</span>
            <h1>Our Customers Opinion</h1>
        </div>

        <div class="reviews-container">
            <div class="box">
                <div class="rev-img">
                    <img src="images/user.png" alt="">
                </div>
                <h2>SOMEONE</h2>
                <h4>Very good!</h4>
            </div>

        
            <div class="box">
                <div class="rev-img">
                    <img src="images/user.png" alt="">
                </div>
                <h2>SOMEONE</h2>
                <h4>Very good!</h4>
            </div>

            <div class="box">
                <div class="rev-img">
                    <img src="images/user.png" alt="">
                </div>
                <h2>SOMEONE</h2>
                <h4>Very good!</h4>
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
        
        .reviews-container{
            display: grid;
            grid-template-columns: repeat(auto-fit,minmax(250px,auto));
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .rev-img{
            width: 70px;
            height: 70px;
            color: #0b666b;
        }
        
        .rev-img img{
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            object-position: center;
        }
        
        .reviews-container .box{
            padding: 22px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            box-shadow: 1px 4px 51px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
        }
        
        .reviews-container .box h2{
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0.5rem 0 0.5rem;
        }
        
        .reviews-container .box h4{
            font-style: italic;
        }
        
        
        </style>
    `
    }
}


customElements.define('reviews-component',Reviews);