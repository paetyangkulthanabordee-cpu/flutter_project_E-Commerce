<?php
header("Content-Type: application/json; charset=UTF-8");
include "condb.php";

// รับค่าที่ส่งมาจาก Flutter
$user_name = $_POST['user_name'];
$room_id = $_POST['room_id'];
$qty_to_buy = (int)$_POST['qty']; // จำนวนที่ผู้ใช้กรอกสั่งซื้อ
$price = $_POST['price'];
$booking_date = date("Y-m-d H:i:s");

try {
    $conn->beginTransaction();

    // 1. เช็คสต็อกปัจจุบันก่อนว่าพอขายไหม[cite: 1]
    $check_sql = "SELECT qty FROM rooms WHERE id = ?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->execute([$room_id]);
    $current_stock = $check_stmt->fetchColumn();

    if ($current_stock >= $qty_to_buy) {
        // 2. บันทึกข้อมูลการสั่งซื้อ
        $sql_insert = "INSERT INTO bookings (room_id, user_name, qty, price, booking_date) VALUES (?, ?, ?, ?, ?)";
        $stmt_insert = $conn->prepare($sql_insert);
        $stmt_insert->execute([$room_id, $user_name, $qty_to_buy, $price, $booking_date]);

        // 3. อัปเดตลดจำนวนสินค้าในตารางหลัก (สำคัญมาก)[cite: 1]
        $sql_update = "UPDATE rooms SET qty = qty - ? WHERE id = ?";
        $stmt_update = $conn->prepare($sql_update);
        $stmt_update->execute([$qty_to_buy, $room_id]);

        $conn->commit();
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => "สินค้าไม่พอ"]);
    }

} catch (Exception $e) {
    $conn->rollBack();
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>