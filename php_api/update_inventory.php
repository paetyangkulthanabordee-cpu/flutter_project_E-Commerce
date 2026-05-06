<?php
header("Content-Type: application/json; charset=UTF-8");
include "condb.php";

try {
    // รับค่า id สินค้า และจำนวนที่สั่งซื้อ
    $room_id = isset($_POST['room_id']) ? $_POST['room_id'] : '';
    $order_qty = isset($_POST['qty']) ? (int)$_POST['qty'] : 0;

    if ($room_id != '' && $order_qty > 0) {
        // ตรวจสอบจำนวนคงเหลือปัจจุบันก่อนหัก
        $check_sql = "SELECT qty FROM rooms WHERE id = ?";
        $check_stmt = $conn->prepare($check_sql);
        $check_stmt->execute([$room_id]);
        $current_qty = $check_stmt->fetchColumn();

        if ($current_qty >= $order_qty) {
            // อัปเดตลดจำนวนสินค้าในตาราง rooms
            $sql = "UPDATE rooms SET qty = qty - ? WHERE id = ?";
            $stmt = $conn->prepare($sql);
            $success = $stmt->execute([$order_qty, $room_id]);

            if ($success) {
                echo json_encode(["status" => "success", "message" => "Inventory updated"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Update failed"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "สินค้าไม่พอ"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid data"]);
    }

} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>