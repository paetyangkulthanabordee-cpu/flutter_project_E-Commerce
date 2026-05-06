<?php
header("Content-Type: application/json; charset=UTF-8");
include "condb.php";

try {
    // ดึงข้อมูลการจองทั้งหมด พร้อมชื่อสินค้าจากตาราง rooms
    $sql = "SELECT b.*, r.room_name 
            FROM bookings b 
            INNER JOIN rooms r ON b.room_id = r.id 
            ORDER BY b.booking_date DESC";
            
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($result);
} catch (Exception $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
?>