<?php
include "condb.php";
$user_name = $_POST['user_name'];
// ดึงข้อมูลการจองพร้อมชื่อสินค้าจากตาราง rooms[cite: 1]
$sql = "SELECT b.*, r.room_name FROM bookings b 
        INNER JOIN rooms r ON b.room_id = r.id 
        WHERE b.user_name = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$user_name]);
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>