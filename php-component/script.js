function MyButtonClick(event) {
    event.preventDefault();

    var from=event.target.parentNode.children[2].value;
    var message=event.target.parentNode.children[3].value;
    console.log(from);
    console.log(message);

    var today = new Date();
    var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    console.log(time);

    $.ajax({
        type:"POST",
        url: "chat.php",
        data:{from:from,message:message,time:time},
        success: function(){
            console.log("Data sent to php into db.");
            //print all messages from db:
            $(document).ready(function() {
                LoadMessages();
            });
            
        }
    });

}


function LoadMessages(){
    $.ajax({
        type:"POST",
        url: "chat_load.php",
        data: {msg: "blank_payload"},
        dataType: "json",
        success : function(response){
            // var mydata = $.parseJSON(response);

            // var from = mydata["from"];
            console.log(response);
            $("#chat-content").empty(); // clear chat, then fill it
            for(var i = 0; i < response.length; i++)
            {
                $("#chat-content").append(`
                <div class="line"> 
                    <span class='message-time'>
                        ${response[i][2]}
                    </span>
                    <span class='from'>
                        ${response[i][0]}
                    : </span>
                    <span class='message-content'>
                        ${response[i][1]}
                    </span>
                    <br>
                </div>
                `);
            }
        },

    });
}

setInterval (LoadMessages, 2000);