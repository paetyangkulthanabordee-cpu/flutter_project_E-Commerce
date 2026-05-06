<?php
header("Content-Type: application/json");
include "condb.php"; // ตรวจสอบว่าไฟล์เชื่อมต่อ DB ถูกต้อง[cite: 5]

// รับค่าจาก Flutter ให้ตรงกับชื่อคอลัมน์ในตาราง employees[cite: 3]
$first_name = $_POST['first_name'] ?? '';
$last_name  = $_POST['last_name'] ?? '';
$phone      = $_POST['phone'] ?? '';
$username   = $_POST['username'] ?? '';
$password   = $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบ"]);
    exit;
}

try {
    // เพิ่มข้อมูลลงตาราง employees[cite: 3]
    $sql = "INSERT INTO employees (first_name, last_name, phone, username, password)
            VALUES (:first_name, :last_name, :phone, :username, :password)";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":first_name", $first_name);
    $stmt->bindParam(":last_name", $last_name);
    $stmt->bindParam(":phone", $phone);
    $stmt->bindParam(":username", $username);
    $stmt->bindParam(":password", $password);

    if($stmt->execute()){
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => "ไม่สามารถสมัครสมาชิกได้"]);
    }
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>