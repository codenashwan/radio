<?php include 'includes/config.php';


header('Content-Type: application/json');
$query = mysqli_query($db  , "SELECT * FROM `radio` ORDER BY `id` ASC");

$json = [];
while($row = mysqli_fetch_assoc($query)){
    $json[] = $row;
}

echo json_encode($json,JSON_NUMERIC_CHECK);
?>