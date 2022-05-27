<?php
	
	$redis = new Redis();
	$redis->connect("myredis");
    //$redis->auth('student');

    if(isset($_POST["from"]) && isset($_POST["message"]) && isset($_POST["time"]))
    {

        $from = $_POST["from"];
        $message = $_POST["message"];
        $time = $_POST["time"];

        $db_record_data = serialize(array($from,$message,$time));

        $redis->rpush("MESSAGES", $db_record_data);

    }

    
    // $redis->rpush("tutorial-list", "Mongodb"); 
    // $redis->rpush("tutorial-list", "Mysql");  
    
    // Get the stored data and print it 
    // $arList = $redis->lrange("tutorial-list", 0 ,-1); 
    // echo "Stored string in redis:: "; 
    // print_r($arList); 
    
?>