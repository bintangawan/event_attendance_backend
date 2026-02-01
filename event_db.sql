-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 01, 2026 at 02:14 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `event_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`admin_id`, `nama`, `email`, `password_hash`, `created_at`) VALUES
(1, 'Bintangin', 'bintangin@gmail.com', '$2a$12$PDRUBkoYt890yqX1Fgf5xulpp4xwF72k06qepcXJ88rSNDYBgek6i', '2026-01-19 03:27:31');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `event_id` int NOT NULL,
  `event_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_event` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tanggal_event` date NOT NULL,
  `jam_masuk_mulai` time NOT NULL,
  `jam_masuk_selesai` time NOT NULL,
  `checkin_end_time` datetime DEFAULT NULL,
  `status_event` enum('draft','aktif','selesai') COLLATE utf8mb4_unicode_ci DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`event_id`, `event_code`, `nama_event`, `tanggal_event`, `jam_masuk_mulai`, `jam_masuk_selesai`, `checkin_end_time`, `status_event`, `created_at`) VALUES
(1, 'EVT-5782DA6A', 'Seminar Teknologi 2026', '2026-01-19', '08:00:00', '10:00:00', '2026-01-19 15:48:59', 'aktif', '2026-01-19 03:37:24'),
(2, 'EVT-B67F7886', 'Seminar Informasi Magang', '2026-01-19', '08:00:00', '15:00:00', '2026-01-19 12:35:00', 'selesai', '2026-01-19 04:35:42'),
(3, 'EVT-D74B8A47', 'Seminar Admin', '2026-01-19', '08:00:00', '23:50:00', '2026-01-19 23:36:00', 'aktif', '2026-01-19 15:36:33'),
(4, 'EVT-6AE8C988', 'Seminar Magang Internasional', '2026-01-20', '08:00:00', '10:30:00', '2026-01-20 17:30:00', 'aktif', '2026-01-20 02:27:18'),
(5, 'EVT-2E74F537', 'Seminar Jauh', '2026-01-20', '08:00:00', '10:00:00', '2026-01-21 11:56:00', 'aktif', '2026-01-20 03:56:24'),
(6, 'EVT-119C6406', 'Seminar Pembangunan', '2026-01-20', '08:00:00', '10:00:00', '2026-01-20 14:23:00', 'aktif', '2026-01-20 06:24:07');

-- --------------------------------------------------------

--
-- Table structure for table `event_attendances`
--

CREATE TABLE `event_attendances` (
  `attendance_id` int NOT NULL,
  `event_id` int NOT NULL,
  `participant_id` int NOT NULL,
  `ticket_token` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jam_masuk` datetime NOT NULL,
  `status_hadir` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `event_attendances`
--

INSERT INTO `event_attendances` (`attendance_id`, `event_id`, `participant_id`, `ticket_token`, `jam_masuk`, `status_hadir`, `created_at`) VALUES
(7, 4, 1, 'TCK-EVT4-001', '2026-01-20 08:01:00', 1, '2026-01-20 02:32:01'),
(8, 4, 2, 'TCK-EVT4-002', '2026-01-20 08:03:00', 1, '2026-01-20 02:32:01'),
(9, 4, 3, 'TCK-EVT4-003', '2026-01-20 08:05:00', 1, '2026-01-20 02:32:01'),
(10, 4, 4, 'TCK-EVT4-004', '2026-01-20 08:07:00', 1, '2026-01-20 02:32:01'),
(11, 4, 5, 'TCK-EVT4-005', '2026-01-20 08:09:00', 1, '2026-01-20 02:32:01'),
(12, 4, 6, 'TCK-EVT4-006', '2026-01-20 08:11:00', 1, '2026-01-20 02:32:01'),
(13, 4, 7, 'TCK-EVT4-007', '2026-01-20 08:13:00', 1, '2026-01-20 02:32:01'),
(14, 4, 8, 'TCK-EVT4-008', '2026-01-20 08:15:00', 1, '2026-01-20 02:32:01'),
(15, 4, 9, 'TCK-EVT4-009', '2026-01-20 08:17:00', 1, '2026-01-20 02:32:01'),
(16, 4, 10, 'TCK-EVT4-010', '2026-01-20 08:19:00', 1, '2026-01-20 02:32:01'),
(17, 4, 11, 'TCK-EVT4-011', '2026-01-20 08:21:00', 1, '2026-01-20 02:32:01'),
(18, 4, 12, 'TCK-EVT4-012', '2026-01-20 08:23:00', 1, '2026-01-20 02:32:01'),
(19, 4, 13, 'TCK-EVT4-013', '2026-01-20 08:25:00', 1, '2026-01-20 02:32:01'),
(20, 4, 14, 'TCK-EVT4-014', '2026-01-20 08:27:00', 1, '2026-01-20 02:32:01'),
(21, 4, 15, 'TCK-EVT4-015', '2026-01-20 08:29:00', 1, '2026-01-20 02:32:01'),
(22, 4, 16, 'TCK-EVT4-016', '2026-01-20 08:31:00', 1, '2026-01-20 02:32:01'),
(23, 4, 17, 'TCK-EVT4-017', '2026-01-20 08:33:00', 1, '2026-01-20 02:32:01'),
(24, 4, 18, 'TCK-EVT4-018', '2026-01-20 08:35:00', 1, '2026-01-20 02:32:01'),
(25, 4, 19, 'TCK-EVT4-019', '2026-01-20 08:37:00', 1, '2026-01-20 02:32:01'),
(26, 4, 20, 'TCK-EVT4-020', '2026-01-20 08:39:00', 1, '2026-01-20 02:32:01'),
(27, 4, 21, 'TCK-EVT4-021', '2026-01-20 08:41:00', 1, '2026-01-20 02:32:01'),
(28, 4, 22, 'TCK-EVT4-022', '2026-01-20 08:43:00', 1, '2026-01-20 02:32:01'),
(29, 4, 23, 'TCK-EVT4-023', '2026-01-20 08:45:00', 1, '2026-01-20 02:32:01'),
(30, 4, 24, 'TCK-EVT4-024', '2026-01-20 08:47:00', 1, '2026-01-20 02:32:01'),
(31, 4, 25, 'TCK-EVT4-025', '2026-01-20 08:49:00', 1, '2026-01-20 02:32:01'),
(32, 4, 26, 'TCK-EVT4-026', '2026-01-20 08:51:00', 1, '2026-01-20 02:32:01'),
(33, 4, 27, 'TCK-EVT4-027', '2026-01-20 08:53:00', 1, '2026-01-20 02:32:01'),
(34, 4, 28, 'TCK-EVT4-028', '2026-01-20 08:55:00', 1, '2026-01-20 02:32:01'),
(35, 4, 29, 'TCK-EVT4-029', '2026-01-20 08:57:00', 1, '2026-01-20 02:32:01'),
(36, 4, 30, 'TCK-EVT4-030', '2026-01-20 08:59:00', 1, '2026-01-20 02:32:01'),
(37, 4, 31, 'TCK-EVT4-031', '2026-01-20 09:01:00', 1, '2026-01-20 02:32:01'),
(38, 4, 32, 'TCK-EVT4-032', '2026-01-20 09:03:00', 1, '2026-01-20 02:32:01'),
(39, 4, 33, 'TCK-EVT4-033', '2026-01-20 09:05:00', 1, '2026-01-20 02:32:01'),
(40, 4, 34, 'TCK-EVT4-034', '2026-01-20 09:07:00', 1, '2026-01-20 02:32:01'),
(41, 4, 35, 'TCK-EVT4-035', '2026-01-20 09:09:00', 1, '2026-01-20 02:32:01'),
(42, 4, 36, 'TCK-EVT4-036', '2026-01-20 09:11:00', 1, '2026-01-20 02:32:01'),
(43, 4, 37, 'TCK-EVT4-037', '2026-01-20 09:13:00', 1, '2026-01-20 02:32:01'),
(44, 4, 38, 'TCK-EVT4-038', '2026-01-20 09:15:00', 1, '2026-01-20 02:32:01'),
(45, 4, 39, 'TCK-EVT4-039', '2026-01-20 09:17:00', 1, '2026-01-20 02:32:01'),
(46, 4, 40, 'TCK-EVT4-040', '2026-01-20 09:19:00', 1, '2026-01-20 02:32:01'),
(47, 4, 41, 'TCK-EVT4-041', '2026-01-20 09:21:00', 1, '2026-01-20 02:32:01'),
(48, 4, 42, 'TCK-EVT4-042', '2026-01-20 09:23:00', 1, '2026-01-20 02:32:01'),
(49, 4, 43, 'TCK-EVT4-043', '2026-01-20 09:25:00', 1, '2026-01-20 02:32:01'),
(50, 4, 44, 'TCK-EVT4-044', '2026-01-20 09:27:00', 1, '2026-01-20 02:32:01'),
(51, 4, 45, 'TCK-EVT4-045', '2026-01-20 09:29:00', 1, '2026-01-20 02:32:01'),
(52, 4, 46, 'TCK-EVT4-046', '2026-01-20 09:31:00', 1, '2026-01-20 02:32:01'),
(53, 4, 47, 'TCK-EVT4-047', '2026-01-20 09:33:00', 1, '2026-01-20 02:32:01'),
(54, 4, 48, 'TCK-EVT4-048', '2026-01-20 09:35:00', 1, '2026-01-20 02:32:01'),
(55, 4, 49, 'TCK-EVT4-049', '2026-01-20 09:37:00', 1, '2026-01-20 02:32:01'),
(56, 4, 50, 'TCK-EVT4-050', '2026-01-20 09:39:00', 1, '2026-01-20 02:32:01'),
(57, 4, 51, 'TCK-27FA9ADADB29', '2026-01-20 10:47:19', 1, '2026-01-20 03:47:19'),
(58, 4, 52, 'TCK-B753B5EA8AAC', '2026-01-20 10:48:39', 1, '2026-01-20 03:48:39'),
(59, 4, 53, 'TCK-2B14268D0527', '2026-01-20 10:50:37', 1, '2026-01-20 03:50:37'),
(60, 4, 54, 'TCK-C3FAA5CF37E3', '2026-01-20 10:53:14', 1, '2026-01-20 03:53:14'),
(61, 5, 55, 'TCK-353B463A4084', '2026-01-20 10:56:55', 1, '2026-01-20 03:56:55'),
(62, 5, 56, 'TCK-E15A161E317B', '2026-01-20 11:08:07', 1, '2026-01-20 04:08:07'),
(63, 5, 57, 'TCK-8096DFF2D9F8', '2026-01-20 11:12:29', 1, '2026-01-20 04:12:29'),
(64, 5, 58, 'TCK-5FC1290903CA', '2026-01-20 11:15:08', 1, '2026-01-20 04:15:08'),
(65, 5, 59, 'TCK-DA557D4B75AE', '2026-01-20 11:28:07', 1, '2026-01-20 04:28:07'),
(66, 5, 60, 'TCK-78D0EA53A3AC', '2026-01-20 11:32:14', 1, '2026-01-20 04:32:14'),
(67, 5, 61, 'TCK-475AB2FA80FE', '2026-01-20 11:33:34', 1, '2026-01-20 04:33:34'),
(68, 5, 62, 'TCK-5102EAD38403', '2026-01-20 11:37:37', 1, '2026-01-20 04:37:37'),
(69, 5, 63, 'TCK-CBADAAF6AB29', '2026-01-20 11:38:48', 1, '2026-01-20 04:38:48'),
(70, 5, 64, 'TCK-670E1977A2B8', '2026-01-20 13:22:54', 1, '2026-01-20 06:22:54'),
(71, 6, 64, 'TCK-7F76BE24F112', '2026-01-20 13:24:45', 1, '2026-01-20 06:24:45');

-- --------------------------------------------------------

--
-- Table structure for table `participants`
--

CREATE TABLE `participants` (
  `participant_id` int NOT NULL,
  `nama` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `participants`
--

INSERT INTO `participants` (`participant_id`, `nama`, `no_hp`, `alamat`, `created_at`) VALUES
(1, 'Ahmad Fauzi', '628111001001', 'Medan', '2026-01-20 02:30:29'),
(2, 'Siti Nurhaliza', '628111001002', 'Medan', '2026-01-20 02:30:29'),
(3, 'Muhammad Rizki', '628111001003', 'Binjai', '2026-01-20 02:30:29'),
(4, 'Aisyah Ramadhani', '628111001004', 'Binjai', '2026-01-20 02:30:29'),
(5, 'Andi Pratama', '628111001005', 'Deli Serdang', '2026-01-20 02:30:29'),
(6, 'Nur Aulia', '628111001006', 'Deli Serdang', '2026-01-20 02:30:29'),
(7, 'Fajar Maulana', '628111001007', 'Medan', '2026-01-20 02:30:29'),
(8, 'Putri Annisa', '628111001008', 'Medan', '2026-01-20 02:30:29'),
(9, 'Rizky Hidayat', '628111001009', 'Langkat', '2026-01-20 02:30:29'),
(10, 'Dewi Lestari', '628111001010', 'Langkat', '2026-01-20 02:30:29'),
(11, 'Bagus Saputra', '628111001011', 'Medan', '2026-01-20 02:30:29'),
(12, 'Nabila Khairunnisa', '628111001012', 'Binjai', '2026-01-20 02:30:29'),
(13, 'Arif Rahman', '628111001013', 'Deli Serdang', '2026-01-20 02:30:29'),
(14, 'Lina Marlina', '628111001014', 'Medan', '2026-01-20 02:30:29'),
(15, 'Yoga Prasetyo', '628111001015', 'Medan', '2026-01-20 02:30:29'),
(16, 'Fitri Handayani', '628111001016', 'Langkat', '2026-01-20 02:30:29'),
(17, 'Ilham Akbar', '628111001017', 'Binjai', '2026-01-20 02:30:29'),
(18, 'Rina Puspita', '628111001018', 'Medan', '2026-01-20 02:30:29'),
(19, 'Dimas Saputro', '628111001019', 'Deli Serdang', '2026-01-20 02:30:29'),
(20, 'Salsa Bilqis', '628111001020', 'Medan', '2026-01-20 02:30:29'),
(21, 'Reza Firmansyah', '628111001021', 'Binjai', '2026-01-20 02:30:29'),
(22, 'Aulia Rahmi', '628111001022', 'Medan', '2026-01-20 02:30:29'),
(23, 'Hendra Wijaya', '628111001023', 'Langkat', '2026-01-20 02:30:29'),
(24, 'Maya Sari', '628111001024', 'Medan', '2026-01-20 02:30:29'),
(25, 'Agus Setiawan', '628111001025', 'Deli Serdang', '2026-01-20 02:30:29'),
(26, 'Intan Permata', '628111001026', 'Medan', '2026-01-20 02:30:29'),
(27, 'Bayu Nugroho', '628111001027', 'Binjai', '2026-01-20 02:30:29'),
(28, 'Citra Lestari', '628111001028', 'Medan', '2026-01-20 02:30:29'),
(29, 'Eko Prabowo', '628111001029', 'Langkat', '2026-01-20 02:30:29'),
(30, 'Lukman Hakim', '628111001030', 'Medan', '2026-01-20 02:30:29'),
(31, 'Rani Oktaviani', '628111001031', 'Binjai', '2026-01-20 02:30:29'),
(32, 'Syahrul Ramadhan', '628111001032', 'Deli Serdang', '2026-01-20 02:30:29'),
(33, 'Miftahul Jannah', '628111001033', 'Medan', '2026-01-20 02:30:29'),
(34, 'Fikri Alamsyah', '628111001034', 'Langkat', '2026-01-20 02:30:29'),
(35, 'Nanda Putra', '628111001035', 'Medan', '2026-01-20 02:30:29'),
(36, 'Yuni Kartika', '628111001036', 'Binjai', '2026-01-20 02:30:29'),
(37, 'Taufik Hidayat', '628111001037', 'Medan', '2026-01-20 02:30:29'),
(38, 'Salsabila Zahra', '628111001038', 'Deli Serdang', '2026-01-20 02:30:29'),
(39, 'Rifqi Maulana', '628111001039', 'Medan', '2026-01-20 02:30:29'),
(40, 'Hani Fauziah', '628111001040', 'Langkat', '2026-01-20 02:30:29'),
(41, 'Aditya Prakoso', '628111001041', 'Medan', '2026-01-20 02:30:29'),
(42, 'Rahmawati', '628111001042', 'Binjai', '2026-01-20 02:30:29'),
(43, 'Farhan Aziz', '628111001043', 'Deli Serdang', '2026-01-20 02:30:29'),
(44, 'Nisa Azzahra', '628111001044', 'Medan', '2026-01-20 02:30:29'),
(45, 'Iqbal Kurniawan', '628111001045', 'Langkat', '2026-01-20 02:30:29'),
(46, 'Amelia Putri', '628111001046', 'Medan', '2026-01-20 02:30:29'),
(47, 'Robby Kurnia', '628111001047', 'Binjai', '2026-01-20 02:30:29'),
(48, 'Khairul Anwar', '628111001048', 'Medan', '2026-01-20 02:30:29'),
(49, 'Vina Melati', '628111001049', 'Deli Serdang', '2026-01-20 02:30:29'),
(50, 'Yusuf Alfarizi', '628111001050', 'Medan', '2026-01-20 02:30:29'),
(51, 'Budi Megawati', '628788', 'Jl, Gambir', '2026-01-20 03:47:19'),
(52, 'Diah Putri', '62878', 'Jl. Mana', '2026-01-20 03:48:39'),
(53, 'Jajanan Basi', '62899', 'Jjaasdfsd', '2026-01-20 03:50:37'),
(54, 'sdsd', 'ss', 'sdsd', '2026-01-20 03:53:14'),
(55, 'sdsd', 'sdsd', 'sd', '2026-01-20 03:56:55'),
(56, 'wdsd2323', 'sdsd2323', 'sdsd', '2026-01-20 04:08:07'),
(57, 'sdsd', '23343', 'sdsd', '2026-01-20 04:12:29'),
(58, 'jang', 'ujang', '122e23', '2026-01-20 04:15:08'),
(59, 'dwdwdw', '2222', 'sdfdf', '2026-01-20 04:28:07'),
(60, 'jajan', '6287', '224234', '2026-01-20 04:32:14'),
(61, '242424', '35465456', '465656', '2026-01-20 04:33:34'),
(62, 'sds', 'sd2434', 'dfd', '2026-01-20 04:37:37'),
(63, '0908', '7878899', 'efdfd', '2026-01-20 04:38:48'),
(64, 'Bintang', '6287841185404', 'Jl.Gambir', '2026-01-20 06:22:54');

-- --------------------------------------------------------

--
-- Table structure for table `winners`
--

CREATE TABLE `winners` (
  `winner_id` int NOT NULL,
  `event_id` int NOT NULL,
  `attendance_id` int NOT NULL,
  `hadiah` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `winners`
--

INSERT INTO `winners` (`winner_id`, `event_id`, `attendance_id`, `hadiah`, `created_at`) VALUES
(20, 4, 34, 'Doorprize Utama', '2026-01-20 02:36:44'),
(21, 4, 12, 'Doorprize Utama', '2026-01-20 02:40:08'),
(22, 4, 22, 'Doorprize Utama', '2026-01-20 02:42:38'),
(23, 4, 14, 'Doorprize Utama', '2026-01-20 02:44:12'),
(24, 4, 10, 'Mesin Cuci', '2026-01-20 02:46:44'),
(25, 4, 51, 'Voucher XL 100K', '2026-01-20 03:00:06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`event_id`),
  ADD UNIQUE KEY `event_code` (`event_code`);

--
-- Indexes for table `event_attendances`
--
ALTER TABLE `event_attendances`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `ticket_token` (`ticket_token`),
  ADD UNIQUE KEY `uq_event_participant` (`event_id`,`participant_id`),
  ADD KEY `fk_participant` (`participant_id`);

--
-- Indexes for table `participants`
--
ALTER TABLE `participants`
  ADD PRIMARY KEY (`participant_id`);

--
-- Indexes for table `winners`
--
ALTER TABLE `winners`
  ADD PRIMARY KEY (`winner_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `attendance_id` (`attendance_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `event_attendances`
--
ALTER TABLE `event_attendances`
  MODIFY `attendance_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `participants`
--
ALTER TABLE `participants`
  MODIFY `participant_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `winners`
--
ALTER TABLE `winners`
  MODIFY `winner_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `event_attendances`
--
ALTER TABLE `event_attendances`
  ADD CONSTRAINT `fk_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_participant` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`participant_id`) ON DELETE CASCADE;

--
-- Constraints for table `winners`
--
ALTER TABLE `winners`
  ADD CONSTRAINT `winners_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`),
  ADD CONSTRAINT `winners_ibfk_2` FOREIGN KEY (`attendance_id`) REFERENCES `event_attendances` (`attendance_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
