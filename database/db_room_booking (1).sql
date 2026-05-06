-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 06, 2026 at 09:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_room_booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `firstname`, `lastname`, `username`, `password`) VALUES
(1, 'jack', 'jp', 'admin', '1234'),
(2, 'kiw', 'jp', 'user', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `booking_date` varchar(100) DEFAULT NULL,
  `qty` int(100) DEFAULT NULL,
  `price` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `room_id`, `user_name`, `booking_date`, `qty`, `price`) VALUES
(21, 4, 'Q gh', '2026-05-06 08:16:36', 10, '9990.00');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `emp_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `first_name`, `last_name`, `phone`, `username`, `password`) VALUES
(1, 'Suda', 'Thongdee', '0823456789', 'user2', '1234'),
(2, 'Anan', 'Sukjai', '0834567890', 'user1', '1234'),
(3, 'Top', 'jp', '0654125632', 'user3', '1234'),
(4, 'Q', 'gh', '0587454162', 'user4', '1234'),
(5, 'jack', 'gh', '0654165262', 'user5', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `room_name` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `price` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `room_name`, `location`, `image`, `price`) VALUES
(1, 'Guczi', 'Guczi', '1777530447_OIP.jpg', '1000'),
(2, 'Adidas', 'Adidas', '1777531921_OIP (1).jpg', '1250'),
(4, 'Nike', 'Nike', '1777820753_download.jpg', '999'),
(6, 'Pumaa', 'Pumaa เสื้อยืดใส่สบาย', '1778050471_OIP (2).jpg', '590'),
(7, 'T-Shirt', 'เสื้อเรียบง่าย เหมาะสำหรับการทำงาน', '1778050541_OIP (3).jpg', '490'),
(8, 'เสื้อsummer', 'เสื้อเหมาะสำหรับใส่ไปชายหา ทะเล', '1778050642_OIP (4).jpg', '390'),
(9, 'New Balancee', 'เสื้อสำหรับการออกกำลังกาย', '1778050724_OIP (5).jpg', '550'),
(10, 'เสื้อกันหนาว', 'เสื้อสำหรับกันความหนาว', '1778050798_download (1).jpg', '450'),
(11, 'เสื้อลายดอก', 'เหมาะสำหรับใส่วันสงกรานต์', '1778050869_OIP (6).jpg', '199'),
(12, 'เสื้อคอปก', 'เหมาะสำหรับใส่ไปข้างนอก', '1778050916_OIP (7).jpg', '299'),
(13, 'เสื้อยืดคอกลม', 'ใส่สบาย เนื้อผ้านุ่ม', '1778050978_download (2).jpg', '149');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
