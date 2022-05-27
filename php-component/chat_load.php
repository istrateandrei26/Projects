<?php
    $redis = new Redis();
	$redis->connect("myredis");
    //$redis->auth('student');


    if(isset($_POST["msg"]))
    {
        $response = array();

        $arList = $redis->lrange("MESSAGES", 0 ,-1); 
        foreach($arList as $item){
            // echo "<br/>" . $item ;

            $data_from_db = unserialize($item);
            $from = $data_from_db[0];
            $message = $data_from_db[1];
            $time = $data_from_db[2];

            // $fp=fopen('test.txt', 'w');
            // fwrite($fp, $from . "\n");
            // fwrite($fp, $message . "\n");
            // fwrite($fp, $time . "\n");
            // fclose($fp);


            array_push($response, array($from,$message,$time));

        }

        echo json_encode($response);

    }


?>