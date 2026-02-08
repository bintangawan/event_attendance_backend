-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 08, 2026 at 12:09 PM
-- Server version: 8.0.30
-- PHP Version: 8.3.30

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
  `nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `event_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_event` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tanggal_event` date NOT NULL,
  `jam_masuk_mulai` time NOT NULL,
  `jam_masuk_selesai` time NOT NULL,
  `checkin_end_time` datetime DEFAULT NULL,
  `status_event` enum('draft','aktif','selesai') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'draft',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`event_id`, `event_code`, `nama_event`, `tanggal_event`, `jam_masuk_mulai`, `jam_masuk_selesai`, `checkin_end_time`, `status_event`, `description`, `created_at`) VALUES
(1, 'EVT-5782DA6A', 'Seminar Teknologi 2026', '2026-01-19', '08:00:00', '10:00:00', '2026-01-19 15:48:59', 'selesai', NULL, '2026-01-19 03:37:24'),
(2, 'EVT-B67F7886', 'Seminar Informasi Magang', '2026-01-19', '08:00:00', '15:00:00', '2026-01-19 12:35:00', 'selesai', NULL, '2026-01-19 04:35:42'),
(3, 'EVT-D74B8A47', 'Seminar Admin', '2026-01-19', '08:00:00', '23:50:00', '2026-01-19 23:36:00', 'selesai', NULL, '2026-01-19 15:36:33'),
(4, 'EVT-6AE8C988', 'Seminar Magang Internasional', '2026-01-20', '08:00:00', '10:30:00', '2026-01-20 17:30:00', 'selesai', NULL, '2026-01-20 02:27:18'),
(5, 'EVT-2E74F537', 'Seminar Jauh', '2026-01-20', '08:00:00', '10:00:00', '2026-01-21 11:56:00', 'selesai', NULL, '2026-01-20 03:56:24'),
(6, 'EVT-119C6406', 'Seminar Pembangunan', '2026-01-20', '08:00:00', '10:00:00', '2026-01-20 14:23:00', 'selesai', NULL, '2026-01-20 06:24:07'),
(7, 'EVT-42B9EE3E', 'Seminar Ilmu Komputer', '2026-02-01', '08:00:00', '10:00:00', '2026-02-01 22:32:00', 'selesai', NULL, '2026-02-01 14:33:22'),
(8, 'EVT-B16F5DE2', 'Seminar Ilmu Komputer 23', '2026-02-01', '08:00:00', '10:00:00', '2026-02-01 23:43:00', 'selesai', NULL, '2026-02-01 15:47:36'),
(9, 'EVT-F6D85E86', 'Seminar Ilmu Komputer 29', '2026-02-01', '08:00:00', '15:00:00', '2026-02-01 23:51:00', 'selesai', 'Seminar Acara ini merupakan Seminar Ilmu Komputer yang ke 29', '2026-02-01 15:51:21'),
(10, 'EVT-246D92D4', 'Seminar Ilmu Komputer 30', '2026-02-01', '08:00:00', '17:00:00', '2026-02-02 02:36:00', 'selesai', 'Selamat Datang di Seminar Ilmu Komputer 30, Kalian semua yang mempunyai tiket silahkan masuk yaa!', '2026-02-01 17:37:05'),
(11, 'EVT-407E6A8B', 'Diah Putri Kartikasari', '2026-02-02', '08:00:00', '23:00:00', '2026-02-07 03:00:00', 'selesai', NULL, '2026-02-01 19:00:30'),
(12, 'EVT-DAA4EFF7', 'Undangan Seminar Proposal Skripsi – Diah Putri Kartikasari', '2026-02-01', '08:00:00', '16:00:00', '2026-02-09 03:00:00', 'aktif', 'Seminar Proposal ini diselenggarakan sebagai bagian dari tahapan akademik mahasiswa dalam menyusun skripsi. Kegiatan ini bertujuan untuk memaparkan rencana penelitian yang akan dilakukan oleh Diah Putri, sekaligus memperoleh masukan, saran, dan evaluasi dari dosen pembimbing serta penguji guna penyempurnaan proposal penelitian sebelum pelaksanaan penelitian secara penuh.', '2026-02-01 19:17:48'),
(13, 'EVT-0603585E', 'Seminar Ilmu Komputer 99', '2026-02-06', '08:00:00', '10:00:00', '2026-02-06 13:42:00', 'selesai', NULL, '2026-02-06 05:42:27'),
(14, 'EVT-C8E22B2B', 'Seminar Ilmu Komputer 6666', '2026-02-06', '08:00:00', '10:00:00', '2026-02-06 20:41:00', 'selesai', NULL, '2026-02-06 12:41:56');

-- --------------------------------------------------------

--
-- Table structure for table `event_attendances`
--

CREATE TABLE `event_attendances` (
  `attendance_id` int NOT NULL,
  `event_id` int NOT NULL,
  `participant_id` int NOT NULL,
  `ticket_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `jam_masuk` datetime NOT NULL,
  `status_hadir` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status_konsumsi` tinyint(1) DEFAULT '0' COMMENT '0=Belum, 1=Sudah',
  `jam_ambil_konsumsi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `event_attendances`
--

INSERT INTO `event_attendances` (`attendance_id`, `event_id`, `participant_id`, `ticket_token`, `jam_masuk`, `status_hadir`, `created_at`, `status_konsumsi`, `jam_ambil_konsumsi`) VALUES
(7, 4, 1, 'TCK-EVT4-001', '2026-01-20 08:01:00', 1, '2026-01-20 02:32:01', 0, NULL),
(8, 4, 2, 'TCK-EVT4-002', '2026-01-20 08:03:00', 1, '2026-01-20 02:32:01', 0, NULL),
(9, 4, 3, 'TCK-EVT4-003', '2026-01-20 08:05:00', 1, '2026-01-20 02:32:01', 0, NULL),
(10, 4, 4, 'TCK-EVT4-004', '2026-01-20 08:07:00', 1, '2026-01-20 02:32:01', 0, NULL),
(11, 4, 5, 'TCK-EVT4-005', '2026-01-20 08:09:00', 1, '2026-01-20 02:32:01', 0, NULL),
(12, 4, 6, 'TCK-EVT4-006', '2026-01-20 08:11:00', 1, '2026-01-20 02:32:01', 0, NULL),
(13, 4, 7, 'TCK-EVT4-007', '2026-01-20 08:13:00', 1, '2026-01-20 02:32:01', 0, NULL),
(14, 4, 8, 'TCK-EVT4-008', '2026-01-20 08:15:00', 1, '2026-01-20 02:32:01', 0, NULL),
(15, 4, 9, 'TCK-EVT4-009', '2026-01-20 08:17:00', 1, '2026-01-20 02:32:01', 0, NULL),
(16, 4, 10, 'TCK-EVT4-010', '2026-01-20 08:19:00', 1, '2026-01-20 02:32:01', 0, NULL),
(17, 4, 11, 'TCK-EVT4-011', '2026-01-20 08:21:00', 1, '2026-01-20 02:32:01', 0, NULL),
(18, 4, 12, 'TCK-EVT4-012', '2026-01-20 08:23:00', 1, '2026-01-20 02:32:01', 0, NULL),
(19, 4, 13, 'TCK-EVT4-013', '2026-01-20 08:25:00', 1, '2026-01-20 02:32:01', 0, NULL),
(20, 4, 14, 'TCK-EVT4-014', '2026-01-20 08:27:00', 1, '2026-01-20 02:32:01', 0, NULL),
(21, 4, 15, 'TCK-EVT4-015', '2026-01-20 08:29:00', 1, '2026-01-20 02:32:01', 0, NULL),
(22, 4, 16, 'TCK-EVT4-016', '2026-01-20 08:31:00', 1, '2026-01-20 02:32:01', 0, NULL),
(23, 4, 17, 'TCK-EVT4-017', '2026-01-20 08:33:00', 1, '2026-01-20 02:32:01', 0, NULL),
(24, 4, 18, 'TCK-EVT4-018', '2026-01-20 08:35:00', 1, '2026-01-20 02:32:01', 0, NULL),
(25, 4, 19, 'TCK-EVT4-019', '2026-01-20 08:37:00', 1, '2026-01-20 02:32:01', 0, NULL),
(26, 4, 20, 'TCK-EVT4-020', '2026-01-20 08:39:00', 1, '2026-01-20 02:32:01', 0, NULL),
(27, 4, 21, 'TCK-EVT4-021', '2026-01-20 08:41:00', 1, '2026-01-20 02:32:01', 0, NULL),
(28, 4, 22, 'TCK-EVT4-022', '2026-01-20 08:43:00', 1, '2026-01-20 02:32:01', 0, NULL),
(29, 4, 23, 'TCK-EVT4-023', '2026-01-20 08:45:00', 1, '2026-01-20 02:32:01', 0, NULL),
(30, 4, 24, 'TCK-EVT4-024', '2026-01-20 08:47:00', 1, '2026-01-20 02:32:01', 0, NULL),
(31, 4, 25, 'TCK-EVT4-025', '2026-01-20 08:49:00', 1, '2026-01-20 02:32:01', 0, NULL),
(32, 4, 26, 'TCK-EVT4-026', '2026-01-20 08:51:00', 1, '2026-01-20 02:32:01', 0, NULL),
(33, 4, 27, 'TCK-EVT4-027', '2026-01-20 08:53:00', 1, '2026-01-20 02:32:01', 0, NULL),
(34, 4, 28, 'TCK-EVT4-028', '2026-01-20 08:55:00', 1, '2026-01-20 02:32:01', 0, NULL),
(35, 4, 29, 'TCK-EVT4-029', '2026-01-20 08:57:00', 1, '2026-01-20 02:32:01', 0, NULL),
(36, 4, 30, 'TCK-EVT4-030', '2026-01-20 08:59:00', 1, '2026-01-20 02:32:01', 0, NULL),
(37, 4, 31, 'TCK-EVT4-031', '2026-01-20 09:01:00', 1, '2026-01-20 02:32:01', 0, NULL),
(38, 4, 32, 'TCK-EVT4-032', '2026-01-20 09:03:00', 1, '2026-01-20 02:32:01', 0, NULL),
(39, 4, 33, 'TCK-EVT4-033', '2026-01-20 09:05:00', 1, '2026-01-20 02:32:01', 0, NULL),
(40, 4, 34, 'TCK-EVT4-034', '2026-01-20 09:07:00', 1, '2026-01-20 02:32:01', 0, NULL),
(41, 4, 35, 'TCK-EVT4-035', '2026-01-20 09:09:00', 1, '2026-01-20 02:32:01', 0, NULL),
(42, 4, 36, 'TCK-EVT4-036', '2026-01-20 09:11:00', 1, '2026-01-20 02:32:01', 0, NULL),
(43, 4, 37, 'TCK-EVT4-037', '2026-01-20 09:13:00', 1, '2026-01-20 02:32:01', 0, NULL),
(44, 4, 38, 'TCK-EVT4-038', '2026-01-20 09:15:00', 1, '2026-01-20 02:32:01', 0, NULL),
(45, 4, 39, 'TCK-EVT4-039', '2026-01-20 09:17:00', 1, '2026-01-20 02:32:01', 0, NULL),
(46, 4, 40, 'TCK-EVT4-040', '2026-01-20 09:19:00', 1, '2026-01-20 02:32:01', 0, NULL),
(47, 4, 41, 'TCK-EVT4-041', '2026-01-20 09:21:00', 1, '2026-01-20 02:32:01', 0, NULL),
(48, 4, 42, 'TCK-EVT4-042', '2026-01-20 09:23:00', 1, '2026-01-20 02:32:01', 0, NULL),
(49, 4, 43, 'TCK-EVT4-043', '2026-01-20 09:25:00', 1, '2026-01-20 02:32:01', 0, NULL),
(50, 4, 44, 'TCK-EVT4-044', '2026-01-20 09:27:00', 1, '2026-01-20 02:32:01', 0, NULL),
(51, 4, 45, 'TCK-EVT4-045', '2026-01-20 09:29:00', 1, '2026-01-20 02:32:01', 0, NULL),
(52, 4, 46, 'TCK-EVT4-046', '2026-01-20 09:31:00', 1, '2026-01-20 02:32:01', 0, NULL),
(53, 4, 47, 'TCK-EVT4-047', '2026-01-20 09:33:00', 1, '2026-01-20 02:32:01', 0, NULL),
(54, 4, 48, 'TCK-EVT4-048', '2026-01-20 09:35:00', 1, '2026-01-20 02:32:01', 0, NULL),
(55, 4, 49, 'TCK-EVT4-049', '2026-01-20 09:37:00', 1, '2026-01-20 02:32:01', 0, NULL),
(56, 4, 50, 'TCK-EVT4-050', '2026-01-20 09:39:00', 1, '2026-01-20 02:32:01', 0, NULL),
(57, 4, 51, 'TCK-27FA9ADADB29', '2026-01-20 10:47:19', 1, '2026-01-20 03:47:19', 0, NULL),
(58, 4, 52, 'TCK-B753B5EA8AAC', '2026-01-20 10:48:39', 1, '2026-01-20 03:48:39', 0, NULL),
(59, 4, 53, 'TCK-2B14268D0527', '2026-01-20 10:50:37', 1, '2026-01-20 03:50:37', 0, NULL),
(60, 4, 54, 'TCK-C3FAA5CF37E3', '2026-01-20 10:53:14', 1, '2026-01-20 03:53:14', 0, NULL),
(61, 5, 55, 'TCK-353B463A4084', '2026-01-20 10:56:55', 1, '2026-01-20 03:56:55', 0, NULL),
(62, 5, 56, 'TCK-E15A161E317B', '2026-01-20 11:08:07', 1, '2026-01-20 04:08:07', 0, NULL),
(63, 5, 57, 'TCK-8096DFF2D9F8', '2026-01-20 11:12:29', 1, '2026-01-20 04:12:29', 0, NULL),
(64, 5, 58, 'TCK-5FC1290903CA', '2026-01-20 11:15:08', 1, '2026-01-20 04:15:08', 0, NULL),
(65, 5, 59, 'TCK-DA557D4B75AE', '2026-01-20 11:28:07', 1, '2026-01-20 04:28:07', 0, NULL),
(66, 5, 60, 'TCK-78D0EA53A3AC', '2026-01-20 11:32:14', 1, '2026-01-20 04:32:14', 0, NULL),
(67, 5, 61, 'TCK-475AB2FA80FE', '2026-01-20 11:33:34', 1, '2026-01-20 04:33:34', 0, NULL),
(68, 5, 62, 'TCK-5102EAD38403', '2026-01-20 11:37:37', 1, '2026-01-20 04:37:37', 0, NULL),
(69, 5, 63, 'TCK-CBADAAF6AB29', '2026-01-20 11:38:48', 1, '2026-01-20 04:38:48', 0, NULL),
(70, 5, 64, 'TCK-670E1977A2B8', '2026-01-20 13:22:54', 1, '2026-01-20 06:22:54', 0, NULL),
(71, 6, 64, 'TCK-7F76BE24F112', '2026-01-20 13:24:45', 1, '2026-01-20 06:24:45', 0, NULL),
(72, 7, 1, 'TCK-EVT7-001', '2026-02-10 08:05:00', 1, '2026-02-01 14:35:45', 0, NULL),
(73, 7, 2, 'TCK-EVT7-002', '2026-02-10 08:07:00', 1, '2026-02-01 14:35:45', 0, NULL),
(74, 7, 3, 'TCK-EVT7-003', '2026-02-10 08:09:00', 1, '2026-02-01 14:35:45', 0, NULL),
(75, 7, 4, 'TCK-EVT7-004', '2026-02-10 08:11:00', 1, '2026-02-01 14:35:45', 0, NULL),
(76, 7, 5, 'TCK-EVT7-005', '2026-02-10 08:14:00', 1, '2026-02-01 14:35:45', 0, NULL),
(77, 7, 6, 'TCK-EVT7-006', '2026-02-10 08:16:00', 1, '2026-02-01 14:35:45', 0, NULL),
(78, 7, 7, 'TCK-EVT7-007', '2026-02-10 08:18:00', 1, '2026-02-01 14:35:45', 0, NULL),
(79, 7, 8, 'TCK-EVT7-008', '2026-02-10 08:21:00', 1, '2026-02-01 14:35:45', 0, NULL),
(80, 7, 9, 'TCK-EVT7-009', '2026-02-10 08:23:00', 1, '2026-02-01 14:35:45', 0, NULL),
(81, 7, 10, 'TCK-EVT7-010', '2026-02-10 08:25:00', 1, '2026-02-01 14:35:45', 0, NULL),
(82, 7, 11, 'TCK-EVT7-011', '2026-02-10 08:28:00', 1, '2026-02-01 14:35:45', 0, NULL),
(83, 7, 12, 'TCK-EVT7-012', '2026-02-10 08:30:00', 1, '2026-02-01 14:35:45', 0, NULL),
(84, 7, 13, 'TCK-EVT7-013', '2026-02-10 08:33:00', 1, '2026-02-01 14:35:45', 0, NULL),
(85, 7, 14, 'TCK-EVT7-014', '2026-02-10 08:35:00', 1, '2026-02-01 14:35:45', 0, NULL),
(86, 7, 15, 'TCK-EVT7-015', '2026-02-10 08:37:00', 1, '2026-02-01 14:35:45', 0, NULL),
(87, 7, 16, 'TCK-EVT7-016', '2026-02-10 08:40:00', 1, '2026-02-01 14:35:45', 0, NULL),
(88, 7, 17, 'TCK-EVT7-017', '2026-02-10 08:42:00', 1, '2026-02-01 14:35:45', 0, NULL),
(89, 7, 18, 'TCK-EVT7-018', '2026-02-10 08:44:00', 1, '2026-02-01 14:35:45', 0, NULL),
(90, 7, 19, 'TCK-EVT7-019', '2026-02-10 08:47:00', 1, '2026-02-01 14:35:45', 0, NULL),
(91, 7, 20, 'TCK-EVT7-020', '2026-02-10 08:49:00', 1, '2026-02-01 14:35:45', 0, NULL),
(92, 7, 21, 'TCK-EVT7-021', '2026-02-10 08:51:00', 1, '2026-02-01 14:35:45', 0, NULL),
(93, 7, 22, 'TCK-EVT7-022', '2026-02-10 08:54:00', 1, '2026-02-01 14:35:45', 0, NULL),
(94, 7, 23, 'TCK-EVT7-023', '2026-02-10 08:56:00', 1, '2026-02-01 14:35:45', 0, NULL),
(95, 7, 24, 'TCK-EVT7-024', '2026-02-10 08:58:00', 1, '2026-02-01 14:35:45', 0, NULL),
(96, 7, 25, 'TCK-EVT7-025', '2026-02-10 09:01:00', 1, '2026-02-01 14:35:45', 0, NULL),
(97, 7, 26, 'TCK-EVT7-026', '2026-02-10 09:03:00', 1, '2026-02-01 14:35:45', 0, NULL),
(98, 7, 27, 'TCK-EVT7-027', '2026-02-10 09:05:00', 1, '2026-02-01 14:35:45', 0, NULL),
(99, 7, 28, 'TCK-EVT7-028', '2026-02-10 09:08:00', 1, '2026-02-01 14:35:45', 0, NULL),
(100, 7, 29, 'TCK-EVT7-029', '2026-02-10 09:10:00', 1, '2026-02-01 14:35:45', 0, NULL),
(101, 7, 30, 'TCK-EVT7-030', '2026-02-10 09:12:00', 1, '2026-02-01 14:35:45', 0, NULL),
(102, 7, 31, 'TCK-EVT7-031', '2026-02-10 09:15:00', 1, '2026-02-01 14:35:45', 0, NULL),
(103, 7, 32, 'TCK-EVT7-032', '2026-02-10 09:17:00', 1, '2026-02-01 14:35:45', 0, NULL),
(104, 7, 33, 'TCK-EVT7-033', '2026-02-10 09:19:00', 1, '2026-02-01 14:35:45', 0, NULL),
(105, 7, 34, 'TCK-EVT7-034', '2026-02-10 09:22:00', 1, '2026-02-01 14:35:45', 0, NULL),
(106, 7, 35, 'TCK-EVT7-035', '2026-02-10 09:24:00', 1, '2026-02-01 14:35:45', 0, NULL),
(107, 7, 36, 'TCK-EVT7-036', '2026-02-10 09:26:00', 1, '2026-02-01 14:35:45', 0, NULL),
(108, 7, 37, 'TCK-EVT7-037', '2026-02-10 09:29:00', 1, '2026-02-01 14:35:45', 0, NULL),
(109, 7, 38, 'TCK-EVT7-038', '2026-02-10 09:31:00', 1, '2026-02-01 14:35:45', 0, NULL),
(110, 7, 39, 'TCK-EVT7-039', '2026-02-10 09:33:00', 1, '2026-02-01 14:35:45', 0, NULL),
(111, 7, 40, 'TCK-EVT7-040', '2026-02-10 09:36:00', 1, '2026-02-01 14:35:45', 0, NULL),
(112, 7, 41, 'TCK-EVT7-041', '2026-02-10 09:38:00', 1, '2026-02-01 14:35:45', 0, NULL),
(113, 7, 42, 'TCK-EVT7-042', '2026-02-10 09:40:00', 1, '2026-02-01 14:35:45', 0, NULL),
(114, 7, 43, 'TCK-EVT7-043', '2026-02-10 09:42:00', 1, '2026-02-01 14:35:45', 0, NULL),
(115, 7, 44, 'TCK-EVT7-044', '2026-02-10 09:44:00', 1, '2026-02-01 14:35:45', 0, NULL),
(116, 7, 45, 'TCK-EVT7-045', '2026-02-10 09:46:00', 1, '2026-02-01 14:35:45', 0, NULL),
(117, 7, 46, 'TCK-EVT7-046', '2026-02-10 09:48:00', 1, '2026-02-01 14:35:45', 0, NULL),
(118, 7, 47, 'TCK-EVT7-047', '2026-02-10 09:50:00', 1, '2026-02-01 14:35:45', 0, NULL),
(119, 7, 48, 'TCK-EVT7-048', '2026-02-10 09:52:00', 1, '2026-02-01 14:35:45', 0, NULL),
(120, 7, 49, 'TCK-EVT7-049', '2026-02-10 09:54:00', 1, '2026-02-01 14:35:45', 0, NULL),
(121, 7, 50, 'TCK-EVT7-050', '2026-02-10 09:56:00', 1, '2026-02-01 14:35:45', 0, NULL),
(122, 10, 64, 'TCK-AEFE9059BAAB', '2026-02-02 00:47:30', 1, '2026-02-01 17:47:30', 0, NULL),
(123, 10, 65, 'TCK-FF6604834E47', '2026-02-02 00:51:20', 1, '2026-02-01 17:51:20', 0, NULL),
(124, 10, 66, 'TCK-6367BD81A4DD', '2026-02-02 01:08:10', 1, '2026-02-01 18:08:10', 0, NULL),
(125, 12, 67, 'TCK-D4B2FB80C3D7', '2026-02-06 00:29:25', 1, '2026-02-05 17:29:25', 0, NULL),
(128, 12, 70, 'TCK-35FB64080A3B', '2026-02-06 00:49:22', 1, '2026-02-05 17:48:58', 0, NULL),
(129, 12, 71, 'TCK-B6BF7B5B9593', '2026-02-06 00:52:47', 0, '2026-02-05 17:52:47', 1, '2026-02-06 02:33:16'),
(130, 12, 72, 'TCK-3C41B9C983A4', '2026-02-06 01:01:20', 0, '2026-02-05 18:01:20', 0, NULL),
(131, 12, 73, 'TCK-79EC00980A6E', '2026-02-06 02:44:43', 1, '2026-02-05 18:03:57', 1, '2026-02-06 02:44:57'),
(132, 12, 74, 'TCK-A20632E5D1C3', '2026-02-06 01:08:50', 0, '2026-02-05 18:08:50', 0, NULL),
(133, 12, 75, 'TCK-C2025FA980BB', '2026-02-06 02:31:44', 1, '2026-02-05 18:24:38', 1, '2026-02-06 02:33:09'),
(134, 12, 76, 'TCK-8CAB3CF04ABF', '2026-02-06 12:05:27', 1, '2026-02-05 18:27:34', 1, '2026-02-06 02:15:23'),
(135, 12, 77, 'TCK-D726BC194586', '2026-02-06 01:27:56', 0, '2026-02-05 18:27:56', 0, NULL),
(136, 12, 78, 'TCK-FC5E8A7001E4', '2026-02-06 01:45:02', 0, '2026-02-05 18:45:02', 0, NULL),
(137, 12, 79, 'TCK-CE2E27B84A6D', '2026-02-06 01:46:29', 0, '2026-02-05 18:46:29', 0, NULL),
(138, 12, 80, 'TCK-AAEF702E68CE', '2026-02-06 12:06:27', 1, '2026-02-06 05:06:13', 1, '2026-02-06 12:12:49'),
(139, 12, 81, 'TCK-99D8FC1A307A', '2026-02-06 12:18:47', 1, '2026-02-06 05:17:15', 1, '2026-02-06 12:18:59'),
(140, 10, 82, 'TCK-01DDD91C30A3', '2026-02-06 12:25:40', 1, '2026-02-06 05:25:21', 1, '2026-02-06 12:26:33');

-- --------------------------------------------------------

--
-- Table structure for table `event_gallery`
--

CREATE TABLE `event_gallery` (
  `gallery_id` int NOT NULL,
  `event_id` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `event_gallery`
--

INSERT INTO `event_gallery` (`gallery_id`, `event_id`, `image_url`, `caption`, `created_at`) VALUES
(2, 7, '/uploads/1769959875188-477592600.jpg', 'Anak Bermain', '2026-02-01 15:31:15'),
(3, 9, '/uploads/1769967367189-19529337.jpg', 'Foto Teman', '2026-02-01 17:36:07'),
(4, 10, '/uploads/1769967439305-449087372.jpg', 'Foto Teman', '2026-02-01 17:37:19'),
(5, 10, '/uploads/1769967497992-759772742.jpg', 'Foto Keluarga', '2026-02-01 17:38:17'),
(6, 10, '/uploads/1769967504535-449524851.jpg', 'Foto Saudara', '2026-02-01 17:38:24'),
(7, 10, '/uploads/1769967510903-793100176.jpg', 'Foto Team', '2026-02-01 17:38:30'),
(8, 10, '/uploads/1769971707006-998035901.png', 'Ticket Keren', '2026-02-01 18:48:27'),
(9, 12, '/uploads/1769973725932-147624211.jpeg', 'Uti lagi bengong', '2026-02-01 19:22:05'),
(10, 12, '/uploads/1769973733747-107273710.jpeg', 'Uti lagi gatau', '2026-02-01 19:22:13'),
(11, 12, '/uploads/1769973744819-927097896.jpeg', 'Uti di Jalan Bintang', '2026-02-01 19:22:24'),
(12, 12, '/uploads/1769973809559-168396814.jpeg', 'Uti lagi cakeup', '2026-02-01 19:23:29'),
(13, 12, '/uploads/1769973916882-553763425.jpeg', 'Uti lagi manyun', '2026-02-01 19:25:16'),
(14, 12, '/uploads/1769974064312-990329427.jpeg', 'Uti lagi manyun pt. 2', '2026-02-01 19:27:44'),
(15, 12, '/uploads/1769974084321-950114788.jpeg', 'Uti lagi foto', '2026-02-01 19:28:04'),
(16, 12, '/uploads/1769974207450-348647635.jpeg', 'Uti graduated with distinction from Coding Camp 2025', '2026-02-01 19:30:07');

-- --------------------------------------------------------

--
-- Table structure for table `participants`
--

CREATE TABLE `participants` (
  `participant_id` int NOT NULL,
  `nama` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
(64, 'Bintang', '6287841185404', 'Jl.Gambir', '2026-01-20 06:22:54'),
(65, 'BUDI JAUH 2', '6287841185422', 'Medan', '2026-02-01 17:51:20'),
(66, 'BUDI JAUH', '6287841185404we', 'sd', '2026-02-01 18:08:10'),
(67, 'Bakwan', '62888', 'Jl. Sidodadi', '2026-02-05 17:29:25'),
(68, 'Diah', '088788', 'jajan', '2026-02-05 17:43:45'),
(69, 'Diah', '08784118', 'Jajan', '2026-02-05 17:44:22'),
(70, 'Diah', '62878411854046666', 'Jl. Jauh', '2026-02-05 17:48:58'),
(71, 'BUDI JAUH', '628784118540499', 'hjh', '2026-02-05 17:52:47'),
(72, 'BUDI JAUH 22', '6287841185404222', 'er', '2026-02-05 18:01:20'),
(73, 'BUDI JAUH 33', '6287841185404333', 'fefef', '2026-02-05 18:03:57'),
(74, 'Diah', '6287841185404334535', 'dfdf', '2026-02-05 18:08:50'),
(75, 'Diah rdfr', '62878411854044454545', 'rgrgrg', '2026-02-05 18:24:38'),
(76, 'Bakwanwwew', '6287841185404232', 'sdsdsd', '2026-02-05 18:27:34'),
(77, 'BUDI JAUHdwd', '628784118540433322', 'sdsd', '2026-02-05 18:27:56'),
(78, 'BUDI JAUH 33fefe', '62878411854043353555', 'dfdf', '2026-02-05 18:45:02'),
(79, 'Diah', '62878411854043333', 'dfdfdf', '2026-02-05 18:46:29'),
(80, 'Jajan Jajan', '0878999', 'Jalan Jauh', '2026-02-06 05:06:13'),
(81, 'Sharing Bangs', '90902222', 'fgfg', '2026-02-06 05:17:15'),
(82, 'Sharing Bang66', '343434', 'dfdfdf', '2026-02-06 05:25:21');

-- --------------------------------------------------------

--
-- Table structure for table `winners`
--

CREATE TABLE `winners` (
  `winner_id` int NOT NULL,
  `event_id` int NOT NULL,
  `attendance_id` int NOT NULL,
  `hadiah` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
(25, 4, 51, 'Voucher XL 100K', '2026-01-20 03:00:06'),
(26, 7, 120, 'Kulkas', '2026-02-01 14:45:14'),
(27, 7, 93, 'Vouche Data 50 Gb', '2026-02-01 14:48:47'),
(28, 7, 96, 'TV', '2026-02-01 14:54:34');

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
-- Indexes for table `event_gallery`
--
ALTER TABLE `event_gallery`
  ADD PRIMARY KEY (`gallery_id`),
  ADD KEY `fk_event_gallery` (`event_id`);

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
  MODIFY `event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `event_attendances`
--
ALTER TABLE `event_attendances`
  MODIFY `attendance_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT for table `event_gallery`
--
ALTER TABLE `event_gallery`
  MODIFY `gallery_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `participants`
--
ALTER TABLE `participants`
  MODIFY `participant_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `winners`
--
ALTER TABLE `winners`
  MODIFY `winner_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

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
-- Constraints for table `event_gallery`
--
ALTER TABLE `event_gallery`
  ADD CONSTRAINT `fk_event_gallery` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE;

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
