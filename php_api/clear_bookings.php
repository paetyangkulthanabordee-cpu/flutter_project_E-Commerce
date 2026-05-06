<?php
include "condb.php";
$user_name = $_POST['user_name'];
$sql = "DELETE FROM bookings WHERE user_name = ?";
$stmt = $conn->prepare($sql);
if($stmt->execute([$user_name])) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>