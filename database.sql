-- ============================================================
-- LaundryPOS - Struktur & Data Database (MySQL / MariaDB)
-- Untuk hosting cPanel: buat database di cPanel -> MySQL Databases,
-- lalu import file ini lewat phpMyAdmin (tab Import).
-- Charset : utf8mb4 (mendukung semua karakter)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------------
-- Tabel: store_settings (info toko, tampil di struk & laporan)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `store_settings`;
CREATE TABLE `store_settings` (
  `id` VARCHAR(10) NOT NULL,
  `name` VARCHAR(150) NOT NULL DEFAULT '',
  `phone` VARCHAR(50) NOT NULL DEFAULT '',
  `address` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `store_settings` (`id`,`name`,`phone`,`address`) VALUES
('main', 'Laundry Kinanti', '0812-3456-7890', 'Jl. Merdeka No. 10, Yogyakarta');

-- -------------------------------------------------------------
-- Tabel: packages (paket layanan & harga normal/express)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price_per_kg` INT NOT NULL DEFAULT 0,
  `price_per_pcs` INT NOT NULL DEFAULT 0,
  `express_per_kg` INT NOT NULL DEFAULT 0,
  `express_per_pcs` INT NOT NULL DEFAULT 0,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `packages` (`id`,`name`,`price_per_kg`,`price_per_pcs`,`express_per_kg`,`express_per_pcs`,`active`,`sort_order`) VALUES
(1, 'Cuci kering', 7000, 5000, 10000, 7000, 1, 1),
(2, 'Cuci setrika', 9000, 7000, 13000, 10000, 1, 2),
(3, 'Setrika saja', 5000, 4000, 8000, 6000, 1, 3);

-- -------------------------------------------------------------
-- Tabel: transactions (riwayat transaksi, status langsung DONE)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `invoice_no` VARCHAR(30) NOT NULL,
  `customer_name` VARCHAR(100) NOT NULL,
  `package_name` VARCHAR(150) NOT NULL,
  `unit` ENUM('KG','PCS') NOT NULL DEFAULT 'KG',
  `qty` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `express` TINYINT(1) NOT NULL DEFAULT 0,
  `unit_price` INT NOT NULL DEFAULT 0,
  `total` INT NOT NULL DEFAULT 0,
  `paid` INT NOT NULL DEFAULT 0,
  `change_amount` INT NOT NULL DEFAULT 0,
  `status` VARCHAR(20) NOT NULL DEFAULT 'DONE',
  `cashier` VARCHAR(100) NOT NULL DEFAULT '',
  `created_at` DATETIME NOT NULL,
  `completed_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_invoice_no` (`invoice_no`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `transactions` (`id`,`invoice_no`,`customer_name`,`package_name`,`unit`,`qty`,`express`,`unit_price`,`total`,`paid`,`change_amount`,`status`,`cashier`,`created_at`,`completed_at`) VALUES
(1, 'A-909', 'Budi Santoso', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-10-31 08:00:00', '2026-10-31 11:00:00'),
(2, 'A-921', 'Rina Wulandari', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-10-31 08:24:00', '2026-10-31 11:24:00'),
(3, 'A-920', 'Citra Ayu', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-10-31 09:07:00', '2026-10-31 12:07:00'),
(4, 'A-919', 'Lina Marlina', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-10-31 10:50:00', '2026-10-31 13:50:00'),
(5, 'A-918', 'Dewi Lestari', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-10-31 11:33:00', '2026-10-31 14:33:00'),
(6, 'A-917', 'Toko Bangunan Jaya', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-10-31 12:16:00', '2026-10-31 15:16:00'),
(7, 'A-916', 'Joko Susilo', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-10-31 13:59:00', '2026-10-31 16:59:00'),
(8, 'A-915', 'Toko Melati', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-10-31 14:42:00', '2026-10-31 17:42:00'),
(9, 'A-914', 'Nadia Safira', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-10-31 15:25:00', '2026-10-31 18:25:00'),
(10, 'A-913', 'Warung Bu Tini', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-10-31 16:08:00', '2026-10-31 19:08:00'),
(11, 'A-925', 'Fajar Nugroho', 'Cuci setrika', 'KG', 2.00, 0, 9000, 18000, 50000, 32000, 'DONE', 'Andi', '2026-10-31 16:32:00', '2026-10-31 19:32:00'),
(12, 'A-924', 'Agus Pratama', 'Cuci kering', 'KG', 7.00, 0, 7000, 49000, 49000, 0, 'DONE', 'Andi', '2026-10-31 17:15:00', '2026-10-31 20:15:00'),
(13, 'A-912', 'Siti Rahma', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-10-31 17:51:00', '2026-10-31 20:51:00'),
(14, 'A-911', 'Pak Slamet', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-10-31 18:34:00', '2026-10-31 21:34:00'),
(15, 'A-923', 'Rizky Ramadhan', 'Setrika saja', 'KG', 4.00, 0, 5000, 20000, 20000, 0, 'DONE', 'Andi', '2026-10-31 18:58:00', '2026-10-31 21:58:00'),
(16, 'A-910', 'Hendra Wijaya', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-10-31 19:17:00', '2026-10-31 22:17:00'),
(17, 'A-922', 'Ibu Ratna', 'Cuci setrika', 'KG', 9.00, 0, 9000, 81000, 81000, 0, 'DONE', 'Andi', '2026-10-31 19:41:00', '2026-10-31 22:41:00'),
(18, 'A-926', 'Siti Rahma', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-01 08:00:00', '2026-11-01 11:00:00'),
(19, 'A-938', 'Agus Pratama', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-11-01 08:24:00', '2026-11-01 11:24:00'),
(20, 'A-937', 'Rizky Ramadhan', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-01 09:07:00', '2026-11-01 12:07:00'),
(21, 'A-949', 'Toko Melati', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-01 09:31:00', '2026-11-01 12:31:00'),
(22, 'A-948', 'Nadia Safira', 'Cuci setrika', 'KG', 4.00, 0, 9000, 36000, 36000, 0, 'DONE', 'Andi', '2026-11-01 10:14:00', '2026-11-01 13:14:00'),
(23, 'A-936', 'Ibu Ratna', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-11-01 10:50:00', '2026-11-01 13:50:00'),
(24, 'A-935', 'Rina Wulandari', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-11-01 11:33:00', '2026-11-01 14:33:00'),
(25, 'A-947', 'Warung Bu Tini', 'Cuci kering', 'KG', 9.00, 0, 7000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-01 11:57:00', '2026-11-01 14:57:00'),
(26, 'A-934', 'Citra Ayu', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-11-01 12:16:00', '2026-11-01 15:16:00'),
(27, 'A-946', 'Siti Rahma', 'Setrika saja', 'KG', 6.00, 0, 5000, 30000, 50000, 20000, 'DONE', 'Andi', '2026-11-01 12:40:00', '2026-11-01 15:40:00'),
(28, 'A-945', 'Pak Slamet', 'Cuci setrika', 'KG', 3.00, 0, 9000, 27000, 27000, 0, 'DONE', 'Andi', '2026-11-01 13:23:00', '2026-11-01 16:23:00'),
(29, 'A-933', 'Lina Marlina', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-01 13:59:00', '2026-11-01 16:59:00'),
(30, 'A-944', 'Hendra Wijaya', 'Cuci kering', 'KG', 8.00, 1, 10000, 80000, 80000, 0, 'DONE', 'Andi', '2026-11-01 14:06:00', '2026-11-01 17:06:00'),
(31, 'A-932', 'Dewi Lestari', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-01 14:42:00', '2026-11-01 17:42:00'),
(32, 'A-931', 'Toko Bangunan Jaya', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-01 15:25:00', '2026-11-01 18:25:00'),
(33, 'A-943', 'Budi Santoso', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-01 15:49:00', '2026-11-01 18:49:00'),
(34, 'A-930', 'Joko Susilo', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-11-01 16:08:00', '2026-11-01 19:08:00'),
(35, 'A-942', 'Ayu Kartika', 'Cuci setrika', 'KG', 2.00, 0, 9000, 18000, 50000, 32000, 'DONE', 'Andi', '2026-11-01 16:32:00', '2026-11-01 19:32:00'),
(36, 'A-941', 'Maya Putri', 'Cuci kering', 'KG', 7.00, 0, 7000, 49000, 49000, 0, 'DONE', 'Andi', '2026-11-01 17:15:00', '2026-11-01 20:15:00'),
(37, 'A-929', 'Toko Melati', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-11-01 17:51:00', '2026-11-01 20:51:00'),
(38, 'A-928', 'Nadia Safira', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-01 18:34:00', '2026-11-01 21:34:00'),
(39, 'A-940', 'Ibu Wati', 'Setrika saja', 'KG', 4.00, 0, 5000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-01 18:58:00', '2026-11-01 21:58:00'),
(40, 'A-927', 'Warung Bu Tini', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-01 19:17:00', '2026-11-01 22:17:00');
INSERT INTO `transactions` (`id`,`invoice_no`,`customer_name`,`package_name`,`unit`,`qty`,`express`,`unit_price`,`total`,`paid`,`change_amount`,`status`,`cashier`,`created_at`,`completed_at`) VALUES
(41, 'A-939', 'Fajar Nugroho', 'Cuci setrika', 'KG', 9.00, 0, 9000, 81000, 81000, 0, 'DONE', 'Andi', '2026-11-01 19:41:00', '2026-11-01 22:41:00'),
(42, 'A-950', 'Toko Melati', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-02 08:00:00', '2026-11-02 11:00:00'),
(43, 'A-962', 'Maya Putri', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-11-02 08:24:00', '2026-11-02 11:24:00'),
(44, 'A-961', 'Ibu Wati', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-02 09:07:00', '2026-11-02 12:07:00'),
(45, 'A-960', 'Fajar Nugroho', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-11-02 10:50:00', '2026-11-02 13:50:00'),
(46, 'A-959', 'Agus Pratama', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-11-02 11:33:00', '2026-11-02 14:33:00'),
(47, 'A-958', 'Rizky Ramadhan', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-11-02 12:16:00', '2026-11-02 15:16:00'),
(48, 'A-957', 'Ibu Ratna', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-02 13:59:00', '2026-11-02 16:59:00'),
(49, 'A-956', 'Rina Wulandari', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-02 14:42:00', '2026-11-02 17:42:00'),
(50, 'A-955', 'Citra Ayu', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-02 15:25:00', '2026-11-02 18:25:00'),
(51, 'A-954', 'Lina Marlina', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-11-02 16:08:00', '2026-11-02 19:08:00'),
(52, 'A-953', 'Dewi Lestari', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-11-02 17:51:00', '2026-11-02 20:51:00'),
(53, 'A-952', 'Toko Bangunan Jaya', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-02 18:34:00', '2026-11-02 21:34:00'),
(54, 'A-951', 'Joko Susilo', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-02 19:17:00', '2026-11-02 22:17:00'),
(55, 'A-963', 'Dewi Lestari', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-03 08:00:00', '2026-11-03 11:00:00'),
(56, 'A-975', 'Hendra Wijaya', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-11-03 08:24:00', '2026-11-03 11:24:00'),
(57, 'A-987', 'Ibu Ratna', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-03 08:48:00', '2026-11-03 11:48:00'),
(58, 'A-974', 'Budi Santoso', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-03 09:07:00', '2026-11-03 12:07:00'),
(59, 'A-986', 'Rina Wulandari', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-03 09:31:00', '2026-11-03 12:31:00'),
(60, 'A-985', 'Citra Ayu', 'Cuci setrika', 'KG', 4.00, 0, 9000, 36000, 36000, 0, 'DONE', 'Andi', '2026-11-03 10:14:00', '2026-11-03 13:14:00'),
(61, 'A-973', 'Ayu Kartika', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-11-03 10:50:00', '2026-11-03 13:50:00'),
(62, 'A-972', 'Maya Putri', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-11-03 11:33:00', '2026-11-03 14:33:00'),
(63, 'A-984', 'Lina Marlina', 'Cuci kering', 'KG', 9.00, 0, 7000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-03 11:57:00', '2026-11-03 14:57:00'),
(64, 'A-971', 'Ibu Wati', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-11-03 12:16:00', '2026-11-03 15:16:00'),
(65, 'A-983', 'Dewi Lestari', 'Setrika saja', 'KG', 6.00, 0, 5000, 30000, 50000, 20000, 'DONE', 'Andi', '2026-11-03 12:40:00', '2026-11-03 15:40:00'),
(66, 'A-982', 'Toko Bangunan Jaya', 'Cuci setrika', 'KG', 3.00, 0, 9000, 27000, 27000, 0, 'DONE', 'Andi', '2026-11-03 13:23:00', '2026-11-03 16:23:00'),
(67, 'A-970', 'Fajar Nugroho', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-03 13:59:00', '2026-11-03 16:59:00'),
(68, 'A-981', 'Joko Susilo', 'Cuci kering', 'KG', 8.00, 1, 10000, 80000, 80000, 0, 'DONE', 'Andi', '2026-11-03 14:06:00', '2026-11-03 17:06:00'),
(69, 'A-969', 'Agus Pratama', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-03 14:42:00', '2026-11-03 17:42:00'),
(70, 'A-968', 'Rizky Ramadhan', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-03 15:25:00', '2026-11-03 18:25:00'),
(71, 'A-980', 'Toko Melati', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-03 15:49:00', '2026-11-03 18:49:00'),
(72, 'A-967', 'Ibu Ratna', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-11-03 16:08:00', '2026-11-03 19:08:00'),
(73, 'A-979', 'Nadia Safira', 'Cuci setrika', 'KG', 2.00, 0, 9000, 18000, 50000, 32000, 'DONE', 'Andi', '2026-11-03 16:32:00', '2026-11-03 19:32:00'),
(74, 'A-978', 'Warung Bu Tini', 'Cuci kering', 'KG', 7.00, 0, 7000, 49000, 49000, 0, 'DONE', 'Andi', '2026-11-03 17:15:00', '2026-11-03 20:15:00'),
(75, 'A-966', 'Rina Wulandari', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-11-03 17:51:00', '2026-11-03 20:51:00'),
(76, 'A-965', 'Citra Ayu', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-03 18:34:00', '2026-11-03 21:34:00'),
(77, 'A-977', 'Siti Rahma', 'Setrika saja', 'KG', 4.00, 0, 5000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-03 18:58:00', '2026-11-03 21:58:00'),
(78, 'A-988', 'Rizky Ramadhan', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-03 19:05:00', '2026-11-03 22:05:00'),
(79, 'A-964', 'Lina Marlina', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-03 19:17:00', '2026-11-03 22:17:00'),
(80, 'A-976', 'Pak Slamet', 'Cuci setrika', 'KG', 9.00, 0, 9000, 81000, 81000, 0, 'DONE', 'Andi', '2026-11-03 19:41:00', '2026-11-03 22:41:00');
INSERT INTO `transactions` (`id`,`invoice_no`,`customer_name`,`package_name`,`unit`,`qty`,`express`,`unit_price`,`total`,`paid`,`change_amount`,`status`,`cashier`,`created_at`,`completed_at`) VALUES
(81, 'A-989', 'Rina Wulandari', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-04 08:00:00', '2026-11-04 11:00:00'),
(82, 'A-1001', 'Warung Bu Tini', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-11-04 08:24:00', '2026-11-04 11:24:00'),
(83, 'A-1000', 'Siti Rahma', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-04 09:07:00', '2026-11-04 12:07:00'),
(84, 'A-999', 'Pak Slamet', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-11-04 10:50:00', '2026-11-04 13:50:00'),
(85, 'A-998', 'Hendra Wijaya', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-11-04 11:33:00', '2026-11-04 14:33:00'),
(86, 'A-997', 'Budi Santoso', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-11-04 12:16:00', '2026-11-04 15:16:00'),
(87, 'A-1008', 'Citra Ayu', 'Cuci setrika', 'KG', 3.00, 0, 9000, 27000, 27000, 0, 'DONE', 'Andi', '2026-11-04 13:23:00', '2026-11-04 16:23:00'),
(88, 'A-996', 'Ayu Kartika', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-04 13:59:00', '2026-11-04 16:59:00'),
(89, 'A-1007', 'Lina Marlina', 'Cuci kering', 'KG', 8.00, 1, 10000, 80000, 80000, 0, 'DONE', 'Andi', '2026-11-04 14:06:00', '2026-11-04 17:06:00'),
(90, 'A-995', 'Maya Putri', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-04 14:42:00', '2026-11-04 17:42:00'),
(91, 'A-994', 'Ibu Wati', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-04 15:25:00', '2026-11-04 18:25:00'),
(92, 'A-1006', 'Dewi Lestari', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-04 15:49:00', '2026-11-04 18:49:00'),
(93, 'A-993', 'Fajar Nugroho', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-11-04 16:08:00', '2026-11-04 19:08:00'),
(94, 'A-1005', 'Toko Bangunan Jaya', 'Cuci setrika', 'KG', 2.00, 0, 9000, 18000, 50000, 32000, 'DONE', 'Andi', '2026-11-04 16:32:00', '2026-11-04 19:32:00'),
(95, 'A-1004', 'Joko Susilo', 'Cuci kering', 'KG', 7.00, 0, 7000, 49000, 49000, 0, 'DONE', 'Andi', '2026-11-04 17:15:00', '2026-11-04 20:15:00'),
(96, 'A-992', 'Agus Pratama', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-11-04 17:51:00', '2026-11-04 20:51:00'),
(97, 'A-991', 'Rizky Ramadhan', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-04 18:34:00', '2026-11-04 21:34:00'),
(98, 'A-1003', 'Toko Melati', 'Setrika saja', 'KG', 4.00, 0, 5000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-04 18:58:00', '2026-11-04 21:58:00'),
(99, 'A-990', 'Ibu Ratna', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-04 19:17:00', '2026-11-04 22:17:00'),
(100, 'A-1002', 'Nadia Safira', 'Cuci setrika', 'KG', 9.00, 0, 9000, 81000, 81000, 0, 'DONE', 'Andi', '2026-11-04 19:41:00', '2026-11-04 22:41:00'),
(101, 'A-1009', 'Agus Pratama', 'Cuci kering', 'KG', 2.00, 1, 10000, 20000, 50000, 30000, 'DONE', 'Andi', '2026-11-05 08:00:00', '2026-11-05 11:00:00'),
(102, 'A-1021', 'Joko Susilo', 'Cuci kering', 'KG', 6.00, 1, 10000, 60000, 100000, 40000, 'DONE', 'Andi', '2026-11-05 08:24:00', '2026-11-05 11:24:00'),
(103, 'A-1020', 'Toko Melati', 'Setrika saja', 'PCS', 11.00, 0, 4000, 44000, 44000, 0, 'DONE', 'Andi', '2026-11-05 09:07:00', '2026-11-05 12:07:00'),
(104, 'A-1019', 'Nadia Safira', 'Cuci setrika', 'KG', 8.00, 0, 9000, 72000, 72000, 0, 'DONE', 'Andi', '2026-11-05 10:50:00', '2026-11-05 13:50:00'),
(105, 'A-1018', 'Warung Bu Tini', 'Cuci kering', 'KG', 5.00, 0, 7000, 35000, 35000, 0, 'DONE', 'Andi', '2026-11-05 11:33:00', '2026-11-05 14:33:00'),
(106, 'A-1017', 'Siti Rahma', 'Setrika saja', 'KG', 2.00, 0, 5000, 10000, 50000, 40000, 'DONE', 'Andi', '2026-11-05 12:16:00', '2026-11-05 15:16:00'),
(107, 'A-1016', 'Pak Slamet', 'Cuci setrika', 'KG', 7.00, 0, 9000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-05 13:59:00', '2026-11-05 16:59:00'),
(108, 'A-1015', 'Hendra Wijaya', 'Cuci kering', 'KG', 4.00, 1, 10000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-05 14:42:00', '2026-11-05 17:42:00'),
(109, 'A-1014', 'Budi Santoso', 'Setrika saja', 'PCS', 5.00, 0, 4000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-05 15:25:00', '2026-11-05 18:25:00'),
(110, 'A-1013', 'Ayu Kartika', 'Cuci setrika', 'KG', 6.00, 0, 9000, 54000, 100000, 46000, 'DONE', 'Andi', '2026-11-05 16:08:00', '2026-11-05 19:08:00'),
(111, 'A-1012', 'Maya Putri', 'Cuci kering', 'KG', 3.00, 0, 7000, 21000, 21000, 0, 'DONE', 'Andi', '2026-11-05 17:51:00', '2026-11-05 20:51:00'),
(112, 'A-1011', 'Ibu Wati', 'Setrika saja', 'KG', 8.00, 0, 5000, 40000, 40000, 0, 'DONE', 'Andi', '2026-11-05 18:34:00', '2026-11-05 21:34:00'),
(113, 'A-1023', 'Dewi Lestari', 'Setrika saja', 'KG', 4.00, 0, 5000, 20000, 20000, 0, 'DONE', 'Andi', '2026-11-05 18:58:00', '2026-11-05 21:58:00'),
(114, 'A-1010', 'Fajar Nugroho', 'Cuci setrika', 'KG', 5.00, 0, 9000, 45000, 45000, 0, 'DONE', 'Andi', '2026-11-05 19:17:00', '2026-11-05 22:17:00'),
(115, 'A-1022', 'Toko Bangunan Jaya', 'Cuci setrika', 'KG', 9.00, 0, 9000, 81000, 81000, 0, 'DONE', 'Andi', '2026-11-05 19:41:00', '2026-11-05 22:41:00'),
(116, 'A-1024', 'Budi Santoso', 'Cuci setrika', 'KG', 4.00, 1, 13000, 52000, 52000, 0, 'DONE', 'Andi', '2026-11-06 09:15:00', '2026-11-06 11:15:00'),
(117, 'A-1025', 'Siti Rahma', 'Setrika saja', 'KG', 3.00, 1, 8000, 24000, 24000, 0, 'DONE', 'Andi', '2026-11-06 10:40:00', '2026-11-06 12:40:00'),
(118, 'A-1029', 'Siti Rahma', 'Setrika saja', 'KG', 3.00, 1, 8000, 24000, 24000, 0, 'DONE', 'Andi', '2026-11-06 11:17:06', '2026-11-06 14:03:44'),
(119, 'A-1026', 'Toko Melati', 'Cuci kering', 'KG', 9.00, 0, 7000, 63000, 63000, 0, 'DONE', 'Andi', '2026-11-06 11:25:00', '2026-11-06 14:03:44'),
(120, 'A-1030', 'sds', 'Cuci kering', 'KG', 1.30, 0, 7000, 9100, 20000, 10900, 'DONE', 'Andi', '2026-11-06 12:30:39', '2026-11-06 14:03:44');
INSERT INTO `transactions` (`id`,`invoice_no`,`customer_name`,`package_name`,`unit`,`qty`,`express`,`unit_price`,`total`,`paid`,`change_amount`,`status`,`cashier`,`created_at`,`completed_at`) VALUES
(121, 'A-1031', 'Budi Santoso', 'Setrika saja', 'KG', 3.00, 0, 5000, 15000, 15000, 0, 'DONE', 'Andi', '2026-11-06 12:37:41', '2026-11-06 14:03:44'),
(122, 'A-1032', 'budi doang', 'Cuci kering', 'KG', 1.60, 0, 7000, 11200, 20000, 8800, 'DONE', 'Andi', '2026-11-06 12:41:40', '2026-11-06 14:03:44'),
(123, 'A-1027', 'Dewi Lestari', 'Cuci setrika', 'KG', 3.00, 0, 9000, 27000, 27000, 0, 'DONE', 'Andi', '2026-11-06 13:10:00', '2026-11-06 15:10:00'),
(124, 'A-1033', 'Hasa', 'Setrika saja', 'KG', 5.00, 1, 8000, 40000, 50000, 10000, 'DONE', 'Andi', '2026-11-06 13:46:27', '2026-11-06 14:03:44'),
(125, 'A-1034', 'aaa', 'Cuci setrika', 'KG', 1.50, 1, 13000, 19500, 20000, 500, 'DONE', 'Andi', '2026-11-06 13:52:39', '2026-11-06 14:03:44'),
(126, 'A-1035', 'bbb', 'Cuci kering', 'KG', 2.50, 1, 10000, 25000, 50000, 25000, 'DONE', 'Andi', '2026-11-06 13:53:33', '2026-11-06 14:03:44'),
(127, 'A-1028', 'Rina Wulandari', 'Setrika saja', 'KG', 5.00, 0, 5000, 25000, 25000, 0, 'DONE', 'Andi', '2026-11-06 14:05:00', '2026-11-06 11:17:46'),
(128, 'A-1036', 'sss', 'Cuci kering', 'PCS', 2.00, 0, 5000, 10000, 20000, 10000, 'DONE', 'Andi', '2026-11-06 14:10:38', '2026-11-06 14:10:38');

SET FOREIGN_KEY_CHECKS = 1;
-- Selesai. Login aplikasi tidak perlu: buka index.php langsung.
