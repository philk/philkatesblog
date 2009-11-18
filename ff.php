<?php 
header('Content-Type: application/json'); 
$ch = curl_init(); 
$timeout = 5; // set to zero for no timeout 
curl_setopt ($ch, CURLOPT_URL, 'http://friendfeed-api.com/v2/feed/thehawk?num=6');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); 
curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout); 
$file_contents = curl_exec($ch); 
curl_close($ch); 
// display file 
echo $file_contents; 
?>
