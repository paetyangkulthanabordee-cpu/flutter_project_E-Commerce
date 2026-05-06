<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

include "condb.php"; // ตรวจสอบว่าชื่อไฟล์เชื่อมต่อฐานข้อมูลถูกต้อง

try {
    // รับค่าจาก Flutter ผ่าน $_POST
    $room_id   = $_POST['room_id'];
    $user_name = $_POST['user_name'];
    $qty       = $_POST['qty'];
    $price     = $_POST['price'];
    $date      = date('Y-m-d H:i:s'); // วันที่ปัจจุบัน

    // คำสั่ง SQL สำหรับบันทึกข้อมูล
    $sql = "INSERT INTO bookings (room_id, user_name, qty, price, booking_date) 
            VALUES (?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    $result = $stmt->execute([$room_id, $user_name, $qty, $price, $date]);

    if ($result) {
        echo json_encode(["status" => "success", "message" => "บันทึกข้อมูลสำเร็จ"]);
    } else {
        echo json_encode(["status" => "error", "message" => "ไม่สามารถบันทึกข้อมูลได้"]);
    }

} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database Error: " . $e->getMessage()
    ]);
}
?>