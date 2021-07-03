-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 03, 2021 at 05:02 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_absensi`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidateLogin` (IN `str_email` VARCHAR(50))  BEGIN
select * from ms_user where str_email = str_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_absen` (IN `kd_perkuliahan` INT(10), IN `str_npm` VARCHAR(11), IN `str_tgl` DATE)  BEGIN
	INSERT into ms_absensi(
        kode_perkuliahan,
        id_dosen,
        str_npm,
        st_hadir,
        tanggal,
        pertemuan
     )VALUES
     (kd_perkuliahan, 'TTW', str_npm, 0, str_tgl, 7);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateMahasiswa` (IN `p_npm` VARCHAR(11), IN `p_nama` VARCHAR(100), IN `p_tgl` DATE, IN `p_tmp_lhr` VARCHAR(100), IN `p_telp` VARCHAR(50))  BEGIN
	IF (SELECT EXISTS (SELECT 1 from ms_mhs WHERE str_npm = p_npm) ) THEN
    	SELECT 'Npm sudah ada!!';
    ELSE
    INSERT INTO ms_mhs(
        str_npm,
        str_nm_mhs,
        dte_tgl_lhr,
        str_tmp_lhr,
        str_notelp_rmh)
    VALUES(
        p_npm,
        p_nama,
        p_tgl,
        p_tmp_lhr,
        p_telp
    );
ENd IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateMKTake` (IN `p_perwalian` INT(11), IN `p_kurikulum` INT(11), IN `p_sks` INT(1), IN `p_kls` INT(11), IN `p_st` INT(11))  BEGIN
INSERT INTO ms_mkuliah_take(
    id_perwalian,
    id_kurikulum,
    sks,
    id_kelas,
    status_keuangan)
VALUES(
    p_perwalian, p_kurikulum, p_sks, p_kls, p_st);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreatePerwalian` (IN `p_npm` VARCHAR(12), IN `p_semester` VARCHAR(8), IN `p_thn` INT(11), IN `p_konsen` INT(11))  BEGIN
INSERT INTO ms_perwalian(
    str_npm,
    str_semester,
    kd_thn_ajaran,
    int_id_konsentrasi,
    st_disetujui,
    st_aktif)
VALUES(
    p_npm, p_semester, p_thn, p_konse, 0, 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateUser` (IN `p_reff` VARCHAR(20), IN `p_key` VARCHAR(20), IN `p_email` VARCHAR(50), IN `p_username` VARCHAR(30), IN `p_pw` VARCHAR(256))  BEGIN
	IF (SELECT EXISTS (SELECT 1 from ms_user WHERE str_key = p_key) ) THEN
    	SELECT 'Npm sudah ada!!';
    ELSE
    INSERT INTO ms_user(
        str_reff,
        str_key,
        str_email,
        str_username,
        str_password,
        bol_status)
     VALUES(
         p_reff, p_key, p_email, p_username, p_pw, 1);
     END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpdateMahasiswa` (IN `p_npm` VARCHAR(11), IN `p_nama` VARCHAR(100), IN `p_tgl` DATE, IN `p_tmp` VARCHAR(100), IN `p_telp` VARCHAR(50), IN `p_id` INT(11))  NO SQL
BEGIN
UPDATE ms_mhs SET
	str_npm = p_npm,
    str_nm_mhs = p_nama,
    dte_tgl_lhr = p_tgl,
    str_tmp_lhr = p_tmp,
    str_notelp_rmh = p_telp
WHERE oid = p_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_perkuliahan`
--

CREATE TABLE `jadwal_perkuliahan` (
  `kode_perkuliahan` int(10) NOT NULL,
  `str_kd_mk` varchar(15) NOT NULL,
  `int_id_kurikulum` int(11) NOT NULL,
  `kode_tahun_ajaran` char(5) NOT NULL,
  `str_alias` varchar(6) NOT NULL,
  `kode_kelas` int(2) NOT NULL,
  `kode_kategori_kelas` char(2) NOT NULL,
  `semester` int(1) NOT NULL,
  `id_dosen` varchar(5) NOT NULL,
  `kode_ruangan` char(5) NOT NULL,
  `hari` char(1) NOT NULL,
  `jam_kuliah_mulai` varchar(5) NOT NULL,
  `jam_kuliah_selesai` varchar(5) NOT NULL,
  `tgl_uts` date NOT NULL,
  `kode_ruang_uts` char(5) NOT NULL,
  `jam_uts_mulai` varchar(5) NOT NULL,
  `jam_uts_selesai` varchar(5) NOT NULL,
  `id_pengawas_uts` int(11) NOT NULL,
  `tgl_uas` date NOT NULL,
  `kode_ruang_uas` char(5) NOT NULL,
  `jam_mulai_uas` varchar(5) NOT NULL,
  `jam_uas_selesai` varchar(5) NOT NULL,
  `id_pengawas_uas` int(11) NOT NULL,
  `stat_jadwal` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jadwal_perkuliahan`
--

INSERT INTO `jadwal_perkuliahan` (`kode_perkuliahan`, `str_kd_mk`, `int_id_kurikulum`, `kode_tahun_ajaran`, `str_alias`, `kode_kelas`, `kode_kategori_kelas`, `semester`, `id_dosen`, `kode_ruangan`, `hari`, `jam_kuliah_mulai`, `jam_kuliah_selesai`, `tgl_uts`, `kode_ruang_uts`, `jam_uts_mulai`, `jam_uts_selesai`, `id_pengawas_uts`, `tgl_uas`, `kode_ruang_uas`, `jam_mulai_uas`, `jam_uas_selesai`, `id_pengawas_uas`, `stat_jadwal`) VALUES
(1698, 'TIF-0001', 665, '22', 'TIF', 28, 'RM', 8, 'hsd', '19', '1', '18:20', '20:05', '0000-00-00', '', '', '', 0, '0000-00-00', '', '', '', 0, 1),
(1875, 'TIF-004', 743, '22', 'TIF', 28, 'RM', 8, 'mhw', '14', '2', '18:20', '20:05', '0000-00-00', '', '', '', 0, '0000-00-00', '', '', '', 0, 1),
(1876, 'TIF-005', 744, '22', 'TIF', 28, 'RM', 8, 'MRA', '4', '4', '18:20', '19:30', '0000-00-00', '', '', '', 0, '0000-00-00', '', '', '', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ms_absensi`
--

CREATE TABLE `ms_absensi` (
  `id` int(10) NOT NULL,
  `kode_perkuliahan` int(10) NOT NULL,
  `id_dosen` varchar(5) NOT NULL,
  `str_npm` varchar(11) NOT NULL,
  `st_hadir` int(1) NOT NULL,
  `pertemuan` int(2) NOT NULL,
  `tanggal` date NOT NULL,
  `id_pokok_bahasan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_absensi`
--

INSERT INTO `ms_absensi` (`id`, `kode_perkuliahan`, `id_dosen`, `str_npm`, `st_hadir`, `pertemuan`, `tanggal`, `id_pokok_bahasan`) VALUES
(422217, 1698, 'hsd', '15111253', 1, 7, '2019-11-04', 16948),
(427999, 1875, 'MHW', '15111253', 1, 7, '2019-11-05', 17175),
(433783, 1876, 'MRA', '15111253', 1, 7, '2019-11-07', 17390),
(439589, 1698, 'TTW', '15111253', 1, 7, '2021-03-02', 0),
(439590, 1698, 'TTW', '15111999', 1, 7, '2021-03-02', 0),
(439591, 1698, 'TTW', '15111253', 1, 7, '2021-03-02', 0),
(439592, 1698, 'TTW', '15111999', 0, 7, '2021-03-02', 0),
(439593, 1875, 'TTW', '15111253', 1, 7, '2021-03-02', 0),
(439594, 1875, 'TTW', '15111999', 0, 7, '2021-03-02', 0);

-- --------------------------------------------------------

--
-- Table structure for table `ms_dosen`
--

CREATE TABLE `ms_dosen` (
  `id` int(11) NOT NULL,
  `str_kd_dosen` varchar(5) NOT NULL,
  `str_alias` varchar(6) NOT NULL,
  `str_profil` varchar(250) NOT NULL,
  `str_nm_dosen` varchar(75) NOT NULL,
  `str_email` varchar(50) NOT NULL,
  `dte_tgl_lahir` date NOT NULL,
  `str_tmpt_lhr` varchar(50) NOT NULL,
  `str_prov_lhr` varchar(50) NOT NULL,
  `bol_jk` tinyint(1) NOT NULL,
  `str_jns_identitas` varchar(15) NOT NULL,
  `str_agama` varchar(15) NOT NULL,
  `str_almt` text NOT NULL,
  `str_rtrw` varchar(10) NOT NULL,
  `str_desa` varchar(50) NOT NULL,
  `str_kecam` varchar(50) NOT NULL,
  `num_kode_pos` int(10) NOT NULL,
  `str_prov` varchar(50) NOT NULL,
  `str_kokab` varchar(50) NOT NULL,
  `st_tmpt_tgl` varchar(25) NOT NULL,
  `num_tlp` varchar(50) NOT NULL,
  `str_thnmasuk` varchar(4) NOT NULL,
  `dte_tgl_pengangkatan` int(11) NOT NULL,
  `str_nomorsk` int(11) NOT NULL,
  `str_jbtn_aka` int(11) NOT NULL,
  `st_aktif` int(11) NOT NULL,
  `st_wali` int(11) NOT NULL,
  `st_dospem` tinyint(1) NOT NULL,
  `st_dosen` int(11) NOT NULL,
  `st_staff` char(5) NOT NULL,
  `str_loc_file` varchar(200) NOT NULL,
  `jabatan_array` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_dosen`
--

INSERT INTO `ms_dosen` (`id`, `str_kd_dosen`, `str_alias`, `str_profil`, `str_nm_dosen`, `str_email`, `dte_tgl_lahir`, `str_tmpt_lhr`, `str_prov_lhr`, `bol_jk`, `str_jns_identitas`, `str_agama`, `str_almt`, `str_rtrw`, `str_desa`, `str_kecam`, `num_kode_pos`, `str_prov`, `str_kokab`, `st_tmpt_tgl`, `num_tlp`, `str_thnmasuk`, `dte_tgl_pengangkatan`, `str_nomorsk`, `str_jbtn_aka`, `st_aktif`, `st_wali`, `st_dospem`, `st_dosen`, `st_staff`, `str_loc_file`, `jabatan_array`) VALUES
(85, 'TTW', 'TIF', '', 'Titi Widaretna, ST.', 'widaretnatiti@gmail.com', '1994-02-20', 'bandung', '', 1, '', 'Islam', 'Kp. Cilunjar', '01/06', 'Sukasari', 'Pameungpeuk', 40376, '', 'Bandung', '', '085721299931', '', 0, 0, 0, 1, 1, 0, 0, '', 'akun.jpg', 'dosen_pengampu');

-- --------------------------------------------------------

--
-- Table structure for table `ms_kelas`
--

CREATE TABLE `ms_kelas` (
  `kode_kelas` int(11) NOT NULL,
  `kuota` int(11) NOT NULL,
  `kapasitas` int(11) NOT NULL,
  `id_kampus` int(11) NOT NULL,
  `nama_kelas` varchar(20) NOT NULL,
  `semester` int(1) NOT NULL,
  `angkatan` smallint(4) NOT NULL,
  `tahun_angkatan` int(11) NOT NULL,
  `str_alias` varchar(6) NOT NULL,
  `stat_kelas` char(1) NOT NULL,
  `kode_kategori_kelas` char(2) NOT NULL,
  `id_kurikulum` int(11) NOT NULL,
  `int_id_konsentrasi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_kelas`
--

INSERT INTO `ms_kelas` (`kode_kelas`, `kuota`, `kapasitas`, `id_kampus`, `nama_kelas`, `semester`, `angkatan`, `tahun_angkatan`, `str_alias`, `stat_kelas`, `kode_kategori_kelas`, `id_kurikulum`, `int_id_konsentrasi`) VALUES
(8, 35, 35, 0, '14a', 8, 12, 13, 'TIF', '0', 'RP', 12, 1),
(22, 1, 0, 0, '12', 9, 22, 17, 'TIF', '0', 'RM', 16, 0),
(38, 0, 0, 0, '13', 9, 22, 15, 'TIF', '1', 'W', 14, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ms_kurikulum`
--

CREATE TABLE `ms_kurikulum` (
  `id` int(11) NOT NULL,
  `str_alias` varchar(3) NOT NULL,
  `str_kd_mk` varchar(15) NOT NULL,
  `str_thn_ajaran` varchar(4) NOT NULL,
  `str_kategori_mk` int(11) NOT NULL,
  `str_semester` int(2) NOT NULL,
  `int_id_mkuliah` int(11) NOT NULL,
  `str_extra` varchar(20) NOT NULL,
  `int_id_konsenterasi` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_kurikulum`
--

INSERT INTO `ms_kurikulum` (`id`, `str_alias`, `str_kd_mk`, `str_thn_ajaran`, `str_kategori_mk`, `str_semester`, `int_id_mkuliah`, `str_extra`, `int_id_konsenterasi`) VALUES
(1, 'TIF', 'KU-20121', '14', 1, 1, 1, '', 0),
(2, 'TIF', 'KU-20221', '14', 1, 1, 2, '', 0),
(3, 'TIF', 'KU-20421', '14', 1, 1, 3, '', 0),
(4, 'TIF', 'KU-20521', '14', 1, 1, 4, '', 0),
(5, 'TIF', 'DK-20131', '14', 1, 1, 5, '', 0),
(6, 'TIF', 'DK-20431', '14', 1, 1, 6, '', 0),
(7, 'TIF', 'DK-20621', '14', 1, 1, 7, '', 0),
(9, 'TIF', 'DK-20742', '14', 1, 1, 9, '', 0),
(10, 'TIF', 'KU-20321', '14', 2, 2, 10, '', 0),
(11, 'TIF', 'KU-20622', '14', 2, 2, 11, '', 0),
(12, 'TIF', 'DK-20232', '14', 2, 2, 12, '', 0),
(13, 'TIF', 'DK-20532', '14', 2, 2, 13, '', 0),
(14, 'TIF', 'DK-20743', '14', 2, 2, 14, '', 0),
(15, 'TIF', 'DK-20831', '14', 1, 2, 15, '', 0),
(16, 'TIF', 'DK-21121', '14', 1, 2, 16, '', 0),
(17, 'TIF', 'DK-21341', '14', 1, 2, 17, '', 0),
(18, 'TIF', 'DK-20333', '14', 1, 3, 18, '', 0),
(19, 'TIF', 'KK-20231', '14', 1, 3, 19, '', 0),
(20, 'TIF', 'KK-20431', '14', 1, 3, 20, '', 0),
(21, 'TIF', 'KK-21231', '14', 1, 3, 21, '', 0),
(22, 'TIF', 'KK-21531', '14', 1, 3, 22, '', 0),
(23, 'TIF', 'KP-21631', '14', 1, 3, 23, '', 0),
(24, 'TIF', 'KP-20531', '14', 1, 3, 24, '', 0),
(25, 'TIF', 'KK-20621', '14', 1, 4, 25, '', 0),
(26, 'TIF', 'KK-20731', '14', 1, 4, 26, '', 0),
(27, 'TIF', 'KK-20732', '14', 1, 4, 27, '', 0),
(28, 'TIF', 'KK-21031', '14', 2, 4, 28, '', 0),
(29, 'TIF', 'KK-21841', '14', 1, 4, 29, '', 0),
(30, 'TIF', 'KK-21931', '14', 1, 4, 30, '', 0),
(31, 'TIF', 'KK-21721', '14', 1, 5, 31, '', 0),
(32, 'TIF', 'KK-21933', '14', 1, 5, 32, '', 0),
(33, 'TIF', 'KK-22021', '14', 1, 5, 33, '', 0),
(34, 'TIF', 'KK-23131', '14', 1, 5, 34, '', 0),
(35, 'TIF', 'KP-20131', '14', 2, 5, 35, '', 0),
(36, 'TIF', 'KP-20431', '14', 1, 5, 36, '', 0),
(37, 'TIF', 'KP-20931', '14', 1, 5, 37, '', 0),
(38, 'TIF', 'KK-20121', '14', 1, 6, 38, '', 0),
(39, 'TIF', 'KK-20122', '14', 1, 6, 39, '', 0),
(40, 'TIF', 'KK-21932', '14', 1, 6, 40, '', 0),
(41, 'TIF', 'KK-21934', '14', 2, 6, 41, '', 0),
(42, 'TIF', 'KK-21935', '14', 2, 6, 42, '', 0),
(43, 'TIF', 'KP-20331', '14', 2, 6, 43, '', 0),
(44, 'TIF', 'KP-20631', '14', 2, 6, 44, '', 0),
(45, 'TIF', 'MP-24020', '14', 2, 7, 45, '', 0),
(46, 'TIF', 'KK-20123', '14', 1, 7, 46, '', 0),
(47, 'TIF', 'KK-21936', '14', 1, 7, 47, '', 0),
(48, 'TIF', 'KK-22121', '14', 1, 7, 48, '', 0),
(49, 'TIF', 'KK-22921', '14', 1, 7, 49, '', 0),
(50, 'TIF', 'KK-22922', '14', 1, 7, 50, '', 0),
(51, 'TIF', 'KP-20831', '14', 1, 7, 51, '', 0),
(59, 'TIF', 'KU-22531', '14', 1, 8, 52, '', 0),
(60, 'TIF', 'MP-24026', '14', 1, 8, 53, '', 0),
(61, 'TIF', 'MP-24028', '14', 1, 8, 54, '', 0),
(62, 'TIF', 'KK-22832', '14', 2, 8, 55, '', 0),
(63, 'TIF', 'KU-20121', '12', 1, 1, 1, '', 0),
(64, 'TIF', 'KU-20221', '12', 1, 1, 2, '', 0),
(65, 'TIF', 'KU-20421', '12', 1, 1, 3, '', 0),
(66, 'TIF', 'KU-20521', '12', 1, 1, 4, '', 0),
(67, 'TIF', 'DK-20131', '12', 1, 1, 5, '', 0),
(68, 'TIF', 'DK-20431', '12', 1, 1, 6, '', 0),
(69, 'TIF', 'DK-20621', '12', 1, 1, 7, '', 0),
(70, 'TIF', 'DK-20741', '12', 1, 1, 8, '', 0),
(71, 'TIF', 'DK-20742', '12', 2, 1, 9, '6@5@13', 0),
(72, 'TIF', 'KU-20321', '12', 2, 2, 10, '', 0),
(73, 'TIF', 'KU-20622', '12', 2, 2, 11, '', 0),
(74, 'TIF', 'DK-20232', '12', 2, 2, 12, '', 0),
(75, 'TIF', 'DK-20532', '12', 2, 2, 13, '', 0),
(76, 'TIF', 'DK-20743', '12', 1, 2, 14, '', 0),
(77, 'TIF', 'DK-20831', '12', 1, 2, 15, '', 0),
(78, 'TIF', 'KK-21121', '12', 1, 2, 71, '', 0),
(79, 'TIF', 'KK-20731', '12', 1, 2, 26, '', 0),
(80, 'TIF', 'DK-20333', '12', 1, 3, 18, '', 0),
(81, 'TIF', 'KK-20231', '12', 1, 3, 19, '', 0),
(82, 'TIF', 'KK-20431', '12', 1, 3, 20, '', 0),
(83, 'TIF', 'KK-21231', '12', 1, 3, 21, '', 0),
(84, 'TIF', 'KK-23531', '12', 1, 3, 77, '', 0),
(85, 'TIF', 'KK-21933', '12', 1, 3, 32, '', 0),
(86, 'TIF', 'KK-21932', '12', 1, 3, 40, '', 0),
(87, 'TIF', 'KK-20621', '12', 1, 4, 25, '', 0),
(88, 'TIF', 'KK-21341', '12', 1, 4, 81, '', 0),
(89, 'TIF', 'KK-21935', '12', 2, 4, 42, '', 0),
(90, 'TIF', 'KP-20531', '12', 1, 4, 24, '', 0),
(91, 'TIF', 'KK-21841', '12', 2, 4, 29, '', 0),
(92, 'TIF', 'KK-21931', '12', 1, 4, 30, '', 0),
(93, 'TIF', 'KK-21721', '12', 2, 5, 31, '', 0),
(94, 'TIF', 'KP-21631', '12', 1, 5, 23, '', 0),
(95, 'TIF', 'KK-22021', '12', 1, 5, 33, '', 0),
(96, 'TIF', 'KK-20121', '12', 1, 5, 38, '', 0),
(97, 'TIF', 'KP-20131', '12', 2, 5, 35, '', 0),
(98, 'TIF', 'KK-20732', '12', 1, 5, 27, '', 0),
(99, 'TIF', 'KK-21936', '12', 1, 5, 47, '', 0),
(100, 'TIF', 'KK-22921', '12', 1, 6, 49, '', 0),
(101, 'TIF', 'KK-20122', '12', 1, 6, 39, '', 0),
(102, 'TIF', 'KP-20931', '12', 1, 6, 37, '', 0),
(103, 'TIF', 'KK-21934', '12', 2, 6, 41, '', 0),
(104, 'TIF', 'KP-20431', '12', 1, 6, 36, '', 0),
(105, 'TIF', 'KP-20331', '12', 2, 6, 43, '', 0),
(106, 'TIF', 'KP-20631', '12', 1, 6, 44, '', 0),
(107, 'TIF', 'MP-24020', '12', 1, 7, 45, '', 0),
(108, 'TIF', 'KK-23131', '12', 1, 7, 34, '', 0),
(109, 'TIF', 'KK-22731', '12', 1, 7, 102, '', 0),
(110, 'TIF', 'KK-22121', '12', 1, 7, 48, '', 0),
(111, 'TIF', 'KK-20123', '12', 1, 7, 46, '', 0),
(112, 'TIF', 'KK-22922', '12', 1, 7, 50, '', 0),
(113, 'TIF', 'KP-20831', '12', 1, 7, 51, '', 0),
(121, 'TIF', 'KU-22531', '12', 1, 8, 52, '', 0),
(122, 'TIF', 'MP-24062', '12', 1, 8, 108, '', 0),
(123, 'TIF', 'MP-24028', '12', 1, 8, 54, '', 0),
(124, 'TIF', 'KK-22832', '12', 2, 8, 55, '', 0),
(125, 'TIF', 'KU-20121', '9', 1, 1, 1, '', 0),
(126, 'TIF', 'KU-20221', '9', 1, 1, 2, '', 0),
(127, 'TIF', 'KU-20421', '9', 1, 1, 3, '', 0),
(128, 'TIF', 'KU-20521', '9', 1, 1, 4, '', 0),
(129, 'TIF', 'DK-20131', '9', 1, 1, 5, '', 0),
(130, 'TIF', 'DK-20431', '9', 1, 1, 6, '', 0),
(131, 'TIF', 'DK-20621', '9', 1, 1, 7, '', 0),
(132, 'TIF', 'DK-20741', '9', 1, 1, 8, '', 0),
(133, 'TIF', 'DK-20742', '9', 1, 1, 9, '', 0),
(134, 'TIF', 'KU-20321', '9', 2, 2, 10, '', 0),
(135, 'TIF', 'KU-20622', '9', 2, 2, 11, '', 0),
(136, 'TIF', 'DK-20232', '9', 2, 2, 12, '', 0),
(137, 'TIF', 'DK-20532', '9', 2, 2, 13, '', 0),
(138, 'TIF', 'DK-20743', '9', 2, 2, 14, '', 0),
(139, 'TIF', 'DK-20831', '9', 1, 2, 15, '', 0),
(140, 'TIF', 'KK-21121', '9', 1, 2, 71, '', 0),
(141, 'TIF', 'KK-20731', '9', 1, 2, 26, '', 0),
(142, 'TIF', 'DK-20333', '9', 1, 3, 18, '', 0),
(143, 'TIF', 'KK-20231', '9', 1, 3, 19, '', 0),
(144, 'TIF', 'KK-20431', '9', 1, 3, 20, '', 0),
(145, 'TIF', 'KK-21231', '9', 1, 3, 21, '', 0),
(146, 'TIF', 'KK-21531', '9', 1, 3, 22, '', 0),
(147, 'TIF', 'KK-21933', '9', 1, 3, 32, '', 0),
(148, 'TIF', 'KK-21031', '9', 1, 3, 28, '', 0),
(149, 'TIF', 'KK-20621', '9', 1, 4, 25, '', 0),
(150, 'TIF', 'KK-21341', '9', 1, 4, 81, '', 0),
(151, 'TIF', 'KK-20622', '9', 2, 4, 137, '', 0),
(152, 'TIF', 'KP-20531', '9', 1, 4, 24, '', 0),
(153, 'TIF', 'KK-21841', '9', 2, 4, 29, '', 0),
(154, 'TIF', 'KK-21931', '9', 1, 4, 30, '', 0),
(155, 'TIF', 'KK-21721', '9', 2, 5, 31, '', 0),
(156, 'TIF', 'KP-21631', '9', 1, 5, 23, '', 0),
(157, 'TIF', 'KK-22021', '9', 1, 5, 33, '', 0),
(158, 'TIF', 'KK-20121', '9', 1, 5, 38, '', 0),
(159, 'TIF', 'KK-20131', '9', 2, 5, 145, '', 0),
(160, 'TIF', 'KK-20732', '9', 1, 5, 27, '', 0),
(161, 'TIF', 'KK-21932', '9', 1, 5, 40, '', 0),
(162, 'TIF', 'KK-22921', '9', 1, 6, 49, '', 0),
(163, 'TIF', 'KK-20122', '9', 1, 6, 39, '', 0),
(164, 'TIF', 'KP-20931', '9', 1, 6, 37, '', 0),
(165, 'TIF', 'KK-21934', '9', 1, 6, 41, '', 0),
(166, 'TIF', 'KP-20431', '9', 1, 6, 36, '', 0),
(167, 'TIF', 'KP-20331', '9', 2, 6, 43, '', 0),
(168, 'TIF', 'KP-20631', '9', 1, 6, 44, '', 0),
(169, 'TIF', 'MP-24020', '9', 1, 7, 45, '', 0),
(170, 'TIF', 'KK-23131', '9', 1, 7, 34, '', 0),
(171, 'TIF', 'KK-22731', '9', 1, 7, 102, '', 0),
(172, 'TIF', 'KK-22121', '9', 1, 7, 48, '', 0),
(173, 'TIF', 'KK-20123', '9', 1, 7, 46, '', 0),
(174, 'TIF', 'KK-22922', '9', 1, 7, 50, '', 0),
(175, 'TIF', 'KP-20831', '9', 1, 7, 51, '', 0),
(235, 'TIF', 'KU-22531', '9', 1, 8, 52, '', 0),
(236, 'TIF', 'MP-24026', '9', 1, 8, 53, '', 0),
(237, 'TIF', 'MP-24028', '9', 1, 8, 54, '', 0),
(238, 'TIF', 'KK-22832', '9', 2, 8, 55, '', 0),
(239, 'TIF', 'IFU01', '6', 1, 1, 166, '', 0),
(240, 'TIF', 'IF001', '6', 1, 1, 167, '', 0),
(241, 'TIF', 'IF002', '6', 1, 1, 168, '', 0),
(242, 'TIF', 'IFU02', '6', 1, 1, 169, '', 0),
(243, 'TIF', 'IF003', '6', 1, 1, 170, '', 0),
(244, 'TIF', 'IF004', '6', 1, 1, 171, '', 0),
(245, 'TIF', 'IF005', '6', 1, 1, 172, '', 0),
(246, 'TIF', 'IFU03', '6', 1, 1, 173, '', 0),
(247, 'TIF', 'IF006', '6', 1, 2, 174, '', 0),
(248, 'TIF', 'IF007', '6', 2, 2, 175, '', 0),
(249, 'TIF', 'IF008', '6', 2, 2, 176, '', 0),
(250, 'TIF', 'IFU04', '6', 2, 2, 177, '', 0),
(251, 'TIF', 'IF009', '6', 1, 2, 178, '', 0),
(252, 'TIF', 'IF010', '6', 1, 2, 179, '', 0),
(253, 'TIF', 'IF011', '6', 2, 2, 180, '', 0),
(254, 'TIF', 'IF012', '6', 1, 2, 181, '', 0),
(255, 'TIF', 'IFU05', '6', 1, 3, 182, '', 0),
(256, 'TIF', 'IF013', '6', 1, 3, 183, '', 0),
(257, 'TIF', 'IF014', '6', 1, 3, 184, '', 0),
(258, 'TIF', 'IF015', '6', 1, 3, 185, '', 0),
(259, 'TIF', 'IF016', '6', 2, 3, 186, '', 0),
(260, 'TIF', 'IF017', '6', 2, 3, 187, '', 0),
(261, 'TIF', 'IF018', '6', 1, 3, 188, '', 0),
(262, 'TIF', 'IF019', '6', 1, 4, 189, '', 0),
(263, 'TIF', 'IF020', '6', 1, 4, 190, '', 0),
(264, 'TIF', 'IF021', '6', 2, 4, 191, '', 0),
(265, 'TIF', 'IF022', '6', 1, 4, 192, '', 0),
(266, 'TIF', 'IFU06', '6', 2, 4, 193, '', 0),
(267, 'TIF', 'IF023', '6', 1, 4, 194, '', 0),
(268, 'TIF', 'IF024', '6', 1, 5, 196, '', 0),
(269, 'TIF', 'IF025', '6', 2, 5, 197, '', 0),
(270, 'TIF', 'IFU07', '6', 1, 5, 198, '', 0),
(271, 'TIF', 'IF026', '6', 1, 5, 199, '', 0),
(272, 'TIF', 'IF027', '6', 1, 5, 200, '', 0),
(273, 'TIF', 'IFU08', '6', 1, 6, 201, '', 0),
(274, 'TIF', 'IFU09', '6', 1, 6, 202, '', 0),
(275, 'TIF', 'IF028', '6', 1, 6, 203, '', 0),
(276, 'TIF', 'IF029', '6', 1, 6, 204, '', 0),
(277, 'TIF', 'IF030', '6', 2, 6, 205, '', 0),
(278, 'TIF', 'IF031', '6', 1, 6, 206, '', 0),
(279, 'TIF', 'IFU11', '6', 1, 7, 207, '', 0),
(280, 'TIF', 'IF032', '6', 1, 7, 208, '', 0),
(281, 'TIF', 'IF033', '6', 1, 7, 209, '', 0),
(282, 'TIF', 'IFU12', '6', 2, 8, 210, '', 0),
(283, 'TIF', 'IFU10', '6', 1, 8, 211, '', 0),
(284, 'TIF', 'IFP01', '6', 3, 7, 217, '', 0),
(285, 'TIF', 'IFP02', '6', 3, 7, 218, '', 0),
(286, 'TIF', 'IFP03', '6', 3, 7, 219, '', 0),
(287, 'TIF', 'IFP04', '6', 3, 7, 220, '', 0),
(288, 'TIF', 'IFP05', '6', 3, 7, 221, '', 0),
(289, 'TIF', 'IFP01', '6', 3, 8, 217, '', 0),
(290, 'TIF', 'IFP02', '6', 3, 8, 218, '', 0),
(291, 'TIF', 'IFP03', '6', 3, 8, 219, '', 0),
(292, 'TIF', 'IFP04', '6', 3, 8, 220, '', 0),
(293, 'TIF', 'IFP05', '6', 3, 8, 221, '', 0),
(294, 'TIF', 'IF101', '6', 4, 4, 212, '', 0),
(295, 'TIF', 'IF102', '6', 4, 4, 213, '', 0),
(296, 'TIF', 'IF103', '6', 4, 4, 214, '', 0),
(297, 'TIF', 'IF104', '6', 4, 4, 215, '', 0),
(298, 'TIF', 'IF105', '6', 4, 4, 216, '', 0),
(299, 'TIF', 'IF202', '6', 4, 4, 222, '', 0),
(300, 'TIF', 'IF203', '6', 4, 4, 223, '', 0),
(301, 'TIF', 'IF204', '6', 4, 4, 224, '', 0),
(302, 'TIF', 'IF205', '6', 4, 4, 225, '', 0),
(303, 'TIF', 'IF201', '6', 4, 4, 195, '', 0),
(304, 'TIF', 'IF101', '6', 4, 5, 212, '', 0),
(305, 'TIF', 'IF102', '6', 4, 5, 213, '', 0),
(306, 'TIF', 'IF103', '6', 4, 5, 214, '', 0),
(307, 'TIF', 'IF104', '6', 4, 5, 215, '', 0),
(308, 'TIF', 'IF105', '6', 4, 5, 216, '', 0),
(309, 'TIF', 'IF202', '6', 4, 5, 222, '', 0),
(310, 'TIF', 'IF203', '6', 4, 5, 223, '', 0),
(311, 'TIF', 'IF204', '6', 4, 5, 224, '', 0),
(312, 'TIF', 'IF205', '6', 4, 5, 225, '', 0),
(313, 'TIF', 'IF201', '6', 4, 5, 195, '', 0),
(314, 'TIF', 'IF101', '6', 4, 6, 212, '', 0),
(315, 'TIF', 'IF102', '6', 4, 6, 213, '', 0),
(316, 'TIF', 'IF103', '6', 4, 6, 214, '', 0),
(317, 'TIF', 'IF104', '6', 4, 6, 215, '', 0),
(318, 'TIF', 'IF105', '6', 4, 6, 216, '', 0),
(319, 'TIF', 'IF202', '6', 4, 6, 222, '', 0),
(320, 'TIF', 'IF203', '6', 4, 6, 223, '', 0),
(321, 'TIF', 'IF204', '6', 4, 6, 224, '', 0),
(322, 'TIF', 'IF205', '6', 4, 6, 225, '', 0),
(323, 'TIF', 'IF201', '6', 4, 6, 195, '', 0),
(324, 'TIF', 'IFU01', '8', 1, 1, 166, '', 0),
(325, 'TIF', 'IF001', '8', 1, 1, 167, '', 0),
(326, 'TIF', 'IF002', '8', 1, 1, 168, '', 0),
(327, 'TIF', 'IFU02', '8', 1, 1, 169, '', 0),
(328, 'TIF', 'IF003', '8', 1, 1, 170, '', 0),
(329, 'TIF', 'IF004', '8', 1, 1, 171, '', 0),
(330, 'TIF', 'IF005', '8', 1, 1, 172, '', 0),
(331, 'TIF', 'IFU03', '8', 1, 1, 173, '', 0),
(332, 'TIF', 'IF006', '8', 1, 2, 174, '', 0),
(333, 'TIF', 'IF007', '8', 2, 2, 175, '', 0),
(334, 'TIF', 'IF008', '8', 1, 2, 176, '', 0),
(335, 'TIF', 'IFU04', '8', 2, 2, 177, '', 0),
(336, 'TIF', 'IF009', '8', 1, 2, 178, '', 0),
(337, 'TIF', 'IF010', '8', 1, 2, 179, '', 0),
(338, 'TIF', 'IF011', '8', 2, 2, 180, '', 0),
(339, 'TIF', 'IF012', '8', 1, 2, 181, '', 0),
(340, 'TIF', 'IFU05', '8', 1, 3, 182, '', 0),
(341, 'TIF', 'IF013', '8', 1, 3, 183, '', 0),
(342, 'TIF', 'IF014', '8', 1, 3, 184, '', 0),
(343, 'TIF', 'IF015', '8', 1, 3, 185, '', 0),
(344, 'TIF', 'IF016', '8', 2, 3, 186, '', 0),
(345, 'TIF', 'IF017', '8', 2, 3, 187, '', 0),
(346, 'TIF', 'IF018', '8', 1, 3, 188, '', 0),
(347, 'TIF', 'IF019', '8', 1, 4, 189, '', 0),
(348, 'TIF', 'IF020', '8', 1, 4, 190, '', 0),
(349, 'TIF', 'IF021', '8', 2, 4, 191, '', 0),
(350, 'TIF', 'IF022', '8', 1, 4, 192, '', 0),
(351, 'TIF', 'IFU06', '8', 1, 4, 193, '', 0),
(352, 'TIF', 'IF023', '8', 1, 4, 194, '', 0),
(353, 'TIF', 'IF024', '8', 1, 5, 196, '', 0),
(354, 'TIF', 'IF025', '8', 2, 5, 197, '', 0),
(355, 'TIF', 'IFU07', '8', 1, 5, 198, '', 0),
(356, 'TIF', 'IF026', '8', 1, 5, 199, '', 0),
(357, 'TIF', 'IF027', '8', 2, 5, 200, '', 0),
(358, 'TIF', 'IFU08', '8', 1, 6, 201, '', 0),
(359, 'TIF', 'IFU09', '8', 1, 6, 202, '', 0),
(360, 'TIF', 'IF028', '8', 1, 6, 203, '', 0),
(361, 'TIF', 'IF029', '8', 1, 6, 204, '', 0),
(362, 'TIF', 'IF030', '8', 2, 6, 205, '', 0),
(363, 'TIF', 'IF031', '8', 1, 6, 206, '', 0),
(364, 'TIF', 'IFU11', '8', 1, 7, 207, '', 0),
(365, 'TIF', 'IF032', '8', 1, 7, 208, '', 0),
(366, 'TIF', 'IF033', '8', 1, 7, 209, '', 0),
(367, 'TIF', 'IFU12', '8', 2, 8, 210, '', 0),
(368, 'TIF', 'IFU10', '8', 1, 8, 211, '', 0),
(369, 'TIF', 'IFP01', '8', 3, 7, 217, '', 0),
(370, 'TIF', 'IFP02', '8', 3, 7, 218, '', 0),
(371, 'TIF', 'IFP03', '8', 3, 7, 219, '', 0),
(372, 'TIF', 'IFP04', '8', 3, 7, 220, '', 0),
(373, 'TIF', 'IFP05', '8', 3, 7, 221, '', 0),
(374, 'TIF', 'IFP01', '8', 3, 8, 217, '', 0),
(375, 'TIF', 'IFP02', '8', 3, 8, 218, '', 0),
(376, 'TIF', 'IFP03', '8', 3, 8, 219, '', 0),
(377, 'TIF', 'IFP04', '8', 3, 8, 220, '', 0),
(378, 'TIF', 'IFP05', '8', 3, 8, 221, '', 0),
(379, 'TIF', 'IF101', '8', 4, 4, 212, '', 0),
(380, 'TIF', 'IF102', '8', 4, 4, 213, '', 0),
(381, 'TIF', 'IF103', '8', 4, 4, 214, '', 0),
(382, 'TIF', 'IF104', '8', 4, 4, 215, '', 0),
(383, 'TIF', 'IF105', '8', 4, 4, 216, '', 0),
(384, 'TIF', 'IF201', '8', 4, 4, 195, '', 0),
(385, 'TIF', 'IF202', '8', 4, 4, 222, '', 0),
(386, 'TIF', 'IF203', '8', 4, 4, 223, '', 0),
(387, 'TIF', 'IF204', '8', 4, 4, 224, '', 0),
(388, 'TIF', 'IF205', '8', 4, 4, 225, '', 0),
(389, 'TIF', 'IF101', '8', 4, 5, 212, '', 0),
(390, 'TIF', 'IF102', '8', 4, 5, 213, '', 0),
(391, 'TIF', 'IF103', '8', 4, 5, 214, '', 0),
(392, 'TIF', 'IF104', '8', 4, 5, 215, '', 0),
(393, 'TIF', 'IF105', '8', 4, 5, 216, '', 0),
(394, 'TIF', 'IF201', '8', 4, 5, 195, '', 0),
(395, 'TIF', 'IF202', '8', 4, 5, 222, '', 0),
(396, 'TIF', 'IF203', '8', 4, 5, 223, '', 0),
(397, 'TIF', 'IF204', '8', 4, 5, 224, '', 0),
(398, 'TIF', 'IF205', '8', 4, 5, 225, '', 0),
(399, 'TIF', 'IF101', '8', 4, 6, 212, '', 0),
(400, 'TIF', 'IF102', '8', 4, 6, 213, '', 0),
(401, 'TIF', 'IF103', '8', 4, 6, 214, '', 0),
(402, 'TIF', 'IF104', '8', 4, 6, 215, '', 0),
(403, 'TIF', 'IF105', '8', 4, 6, 216, '', 0),
(404, 'TIF', 'IF201', '8', 4, 6, 195, '', 0),
(405, 'TIF', 'IF202', '8', 4, 6, 222, '', 0),
(406, 'TIF', 'IF203', '8', 4, 6, 223, '', 0),
(407, 'TIF', 'IF204', '8', 4, 6, 224, '', 0),
(408, 'TIF', 'IF205', '8', 4, 6, 225, '', 0),
(409, 'TIF', 'IF001', '11', 1, 1, 167, '', 0),
(410, 'TIF', 'IF003', '11', 1, 1, 170, '', 0),
(411, 'TIF', 'IF007', '11', 1, 1, 175, '', 0),
(412, 'TIF', 'IFU01', '11', 1, 1, 166, '', 0),
(413, 'TIF', 'IFU04', '11', 1, 1, 177, '', 0),
(414, 'TIF', 'IF011', '11', 1, 1, 180, '', 0),
(415, 'TIF', 'IF032', '11', 1, 1, 208, '', 0),
(416, 'TIF', 'IFU02', '11', 1, 1, 169, '', 0),
(417, 'TIF', 'IF002', '11', 2, 5, 168, '2', 0),
(418, 'TIF', 'IF004', '11', 1, 2, 171, '', 0),
(419, 'TIF', 'IF008', '11', 1, 2, 176, '', 0),
(420, 'TIF', 'IF009', '11', 1, 2, 178, '', 0),
(421, 'TIF', 'IFU05', '11', 2, 2, 182, '', 0),
(422, 'TIF', 'IF012', '11', 1, 2, 181, '', 0),
(423, 'TIF', 'IF013', '11', 1, 2, 183, '', 0),
(424, 'TIF', 'IFU03', '11', 1, 2, 173, '', 0),
(425, 'TIF', 'IF015', '11', 1, 3, 185, '', 0),
(426, 'TIF', 'IF005', '11', 1, 3, 172, '', 0),
(427, 'TIF', 'IF010', '11', 1, 3, 179, '', 0),
(428, 'TIF', 'IF017', '11', 1, 3, 187, '', 0),
(429, 'TIF', 'IF019', '11', 1, 3, 189, '', 0),
(430, 'TIF', 'IF014', '11', 1, 3, 184, '', 0),
(431, 'TIF', 'IF021', '11', 1, 3, 191, '', 0),
(432, 'TIF', 'IF016', '11', 2, 4, 186, '', 0),
(433, 'TIF', 'IF006', '11', 1, 4, 174, '', 0),
(434, 'TIF', 'IF023', '11', 1, 4, 194, '', 0),
(435, 'TIF', 'IF018', '11', 2, 4, 188, '', 0),
(436, 'TIF', 'IF020', '11', 1, 4, 190, '', 0),
(437, 'TIF', 'IF022', '11', 1, 4, 192, '', 0),
(438, 'TIF', 'IF025', '11', 1, 5, 197, '', 0),
(439, 'TIF', 'IF024', '11', 2, 5, 196, '', 0),
(440, 'TIF', 'IF027', '11', 1, 5, 200, '', 0),
(441, 'TIF', 'IFU06', '11', 1, 5, 193, '', 0),
(442, 'TIF', 'IF026', '11', 2, 6, 199, '', 0),
(443, 'TIF', 'IF029', '11', 1, 6, 204, '', 0),
(444, 'TIF', 'IF028', '11', 1, 6, 203, '', 0),
(445, 'TIF', 'IFU07', '11', 1, 6, 198, '', 0),
(446, 'TIF', 'IF030', '11', 1, 7, 205, '', 0),
(447, 'TIF', 'IFU10', '11', 1, 7, 211, '', 0),
(448, 'TIF', 'IFU08', '11', 1, 7, 201, '', 0),
(449, 'TIF', 'IF031', '11', 1, 8, 206, '', 0),
(450, 'TIF', 'IFU11', '11', 1, 8, 207, '', 0),
(451, 'TIF', 'IFU09', '11', 1, 8, 202, '', 0),
(452, 'TIF', 'IF101', '11', 4, 4, 212, '1@2', 0),
(453, 'TIF', 'IF102', '11', 4, 4, 213, '', 0),
(454, 'TIF', 'IF103', '11', 4, 4, 214, '', 0),
(455, 'TIF', 'IF104', '11', 4, 4, 215, '', 0),
(456, 'TIF', 'IF105', '11', 4, 4, 216, '', 0),
(457, 'TIF', 'IF201', '11', 4, 4, 195, '', 0),
(458, 'TIF', 'IF202', '11', 4, 4, 222, '', 0),
(459, 'TIF', 'IF203', '11', 4, 4, 223, '', 0),
(460, 'TIF', 'IF204', '11', 4, 4, 224, '', 0),
(461, 'TIF', 'IF205', '11', 4, 4, 225, '', 0),
(462, 'TIF', 'IF101', '11', 4, 5, 212, '', 0),
(463, 'TIF', 'IF102', '11', 4, 5, 213, '', 0),
(464, 'TIF', 'IF103', '11', 4, 5, 214, '', 0),
(465, 'TIF', 'IF104', '11', 4, 5, 215, '', 0),
(466, 'TIF', 'IF105', '11', 4, 5, 216, '', 0),
(467, 'TIF', 'IF201', '11', 4, 5, 195, '', 0),
(468, 'TIF', 'IF202', '11', 4, 5, 222, '', 0),
(469, 'TIF', 'IF203', '11', 4, 5, 223, '', 0),
(470, 'TIF', 'IF204', '11', 4, 5, 224, '', 0),
(471, 'TIF', 'IF205', '11', 4, 5, 225, '', 0),
(472, 'TIF', 'IF101', '11', 4, 6, 212, '', 0),
(473, 'TIF', 'IF102', '11', 4, 6, 213, '', 0),
(474, 'TIF', 'IF103', '11', 4, 6, 214, '', 0),
(475, 'TIF', 'IF104', '11', 4, 6, 215, '', 0),
(476, 'TIF', 'IF105', '11', 4, 6, 216, '', 0),
(477, 'TIF', 'IF201', '11', 4, 6, 195, '', 0),
(478, 'TIF', 'IF202', '11', 4, 6, 222, '', 0),
(479, 'TIF', 'IF203', '11', 4, 6, 223, '', 0),
(480, 'TIF', 'IF204', '11', 4, 6, 224, '', 0),
(481, 'TIF', 'IF205', '11', 4, 6, 225, '', 0),
(482, 'TIF', 'IFP01', '11', 3, 5, 217, '1', 0),
(483, 'TIF', 'IFP02', '11', 3, 5, 218, '1', 0),
(484, 'TIF', 'IFP03', '11', 3, 5, 219, '2', 0),
(485, 'TIF', 'IFP04', '11', 3, 5, 220, '1', 0),
(486, 'TIF', 'IFP05', '11', 3, 5, 221, '2', 0),
(487, 'TIF', 'IFP06', '11', 3, 5, 344, '2', 0),
(488, 'TIF', 'IFP07', '11', 3, 5, 345, '3', 0),
(489, 'TIF', 'IFP08', '11', 3, 5, 346, '3', 0),
(490, 'TIF', 'IFP01', '11', 3, 7, 217, '', 0),
(491, 'TIF', 'IFP02', '11', 3, 7, 218, '', 0),
(492, 'TIF', 'IFP03', '11', 3, 7, 219, '', 0),
(493, 'TIF', 'IFP04', '11', 3, 7, 220, '', 0),
(494, 'TIF', 'IFP05', '11', 3, 7, 221, '', 0),
(495, 'TIF', 'IFP06', '11', 3, 7, 344, '', 0),
(496, 'TIF', 'IFP07', '11', 3, 7, 345, '', 0),
(497, 'TIF', 'IFP08', '11', 3, 7, 346, '', 0),
(498, 'TIF', 'IFP01', '11', 3, 8, 217, '', 0),
(499, 'TIF', 'IFP02', '11', 3, 8, 218, '', 0),
(500, 'TIF', 'IFP03', '11', 3, 8, 219, '', 0),
(501, 'TIF', 'IFP04', '11', 3, 8, 220, '', 0),
(502, 'TIF', 'IFP05', '11', 3, 8, 221, '', 0),
(503, 'TIF', 'IFP06', '11', 3, 8, 344, '', 0),
(504, 'TIF', 'IFP07', '11', 3, 8, 345, '', 0),
(505, 'TIF', 'IFP08', '11', 3, 8, 346, '', 0),
(506, 'TIF', 'KU-20321', '14', 2, 1, 10, '', 0),
(507, 'TIF', 'KU-20622', '14', 2, 1, 11, '', 0),
(508, 'TIF', 'KU-20321', '14', 2, 1, 10, '', 0),
(509, 'TIF', 'KU-20622', '14', 2, 1, 11, '', 0),
(510, 'TIF', 'KU-20321', '14', 2, 1, 10, '', 0),
(511, 'TIF', 'KU-20622', '14', 2, 1, 11, '', 0),
(512, 'TIF', 'KU-20321', '14', 2, 1, 10, '', 0),
(513, 'TIF', 'DK-20232', '14', 2, 1, 12, '', 0),
(515, 'TIF', 'OPS002', '20', 1, 2, 362, '', 0),
(516, 'TIF', 'OPS002', '20', 1, 3, 362, '', 0),
(517, 'TIF', 'OPS002', '20', 1, 4, 362, '', 0),
(518, 'TIF', 'OPS002', '20', 1, 5, 362, '', 0),
(519, 'TIF', 'OPS002', '20', 1, 6, 362, '', 0),
(520, 'TIF', 'OPS002', '20', 1, 7, 362, '', 0),
(521, 'TIF', 'OPS002', '20', 1, 8, 362, '', 0),
(525, 'TIF', 'IF001', '22', 1, 1, 367, '', 0),
(526, 'TIF', 'IF003', '22', 1, 1, 368, '', 0),
(527, 'TIF', 'IF007', '22', 1, 1, 369, '', 0),
(528, 'TIF', 'IFU01', '22', 1, 1, 370, '', 0),
(529, 'TIF', 'IFU04', '22', 1, 1, 371, '', 0),
(530, 'TIF', 'IF011', '22', 1, 1, 372, '', 0),
(531, 'TIF', 'IF032', '22', 1, 1, 373, '', 0),
(532, 'TIF', 'IFU02', '22', 1, 1, 374, '', 0),
(533, 'TIF', ' IF006', '22', 1, 4, 391, '', 0),
(534, 'TIF', ' IFU06', '22', 1, 5, 401, '', 0),
(535, 'TIF', ' IF029', '22', 1, 6, 407, '', 0),
(538, 'TIF', 'IF002', '22', 2, 2, 375, '', 0),
(539, 'TIF', 'IF004', '22', 2, 2, 376, '', 0),
(540, 'TIF', 'IF008', '22', 2, 2, 377, '7', 0),
(541, 'TIF', 'IF009', '22', 2, 2, 378, '7', 0),
(542, 'TIF', 'IFU05', '22', 2, 2, 379, '', 0),
(543, 'TIF', 'IF012', '22', 2, 2, 380, '', 0),
(544, 'TIF', 'IF013', '22', 2, 2, 381, '', 0),
(545, 'TIF', 'IFU03', '22', 2, 2, 382, '', 0),
(546, 'TIF', 'IF015', '22', 2, 3, 383, '', 0),
(547, 'TIF', 'IF005', '22', 2, 3, 384, '', 0),
(548, 'TIF', 'IF010', '22', 2, 3, 385, '', 0),
(549, 'TIF', ' IF017', '22', 2, 3, 386, '', 0),
(550, 'TIF', 'IF019', '22', 2, 3, 387, '', 0),
(551, 'TIF', 'IF014', '22', 2, 3, 388, '', 0),
(552, 'TIF', ' IF021', '22', 2, 3, 389, '', 0),
(553, 'TIF', ' IF016', '22', 2, 4, 390, '', 0),
(554, 'TIF', ' IF023', '22', 2, 4, 392, '', 0),
(555, 'TIF', 'IF018', '22', 2, 4, 393, '', 0),
(556, 'TIF', ' IF020', '22', 2, 4, 394, '', 0),
(557, 'TIF', ' IF022', '22', 2, 4, 395, '', 0),
(558, 'TIF', ' IF025', '22', 2, 5, 398, '', 0),
(559, 'TIF', ' IF024', '22', 2, 5, 399, '', 0),
(560, 'TIF', ' IF027', '22', 2, 5, 400, '', 0),
(561, 'TIF', ' IF026', '22', 2, 6, 406, '', 0),
(562, 'TIF', ' IF028', '22', 2, 6, 408, '', 0),
(563, 'TIF', ' IFU07', '22', 2, 6, 409, '', 0),
(566, 'TIF', ' IF031', '22', 2, 8, 417, '', 0),
(567, 'TIF', ' IFU09', '22', 2, 8, 419, '', 0),
(570, 'TIF', 'IF101', '22', 4, 4, 396, '', 1),
(571, 'TIF', 'IF102', '22', 4, 5, 402, '', 1),
(572, 'TIF', 'IF103', '22', 4, 5, 404, '', 1),
(573, 'TIF', 'IF104', '22', 4, 5, 410, '', 1),
(574, 'TIF', 'IF105', '22', 4, 6, 412, '', 1),
(575, 'TIF', 'IF201', '22', 4, 4, 397, '', 2),
(576, 'TIF', 'IF202', '22', 4, 5, 403, '', 2),
(577, 'TIF', 'IF204', '22', 4, 5, 411, '', 2),
(578, 'TIF', 'IF203', '22', 4, 6, 405, '', 2),
(579, 'TIF', 'IF205', '22', 4, 6, 413, '', 2),
(580, 'TIF', 'IFP01', '22', 3, 5, 420, '1', 0),
(582, 'TIF', 'IFP03', '22', 3, 5, 422, '1', 0),
(583, 'TIF', 'IFP04', '22', 3, 6, 423, '', 0),
(584, 'TIF', ' IFP05', '22', 3, 6, 424, '', 0),
(585, 'TIF', ' IFP06', '22', 3, 6, 425, '1', 0),
(588, 'TIF', 'IFP09', '22', 3, 8, 428, '', 0),
(589, 'TIF', 'IFP10', '22', 3, 8, 429, '1', 0),
(647, 'TIF', 'IF-0001', '22', 1, 7, 487, '', 0),
(648, 'TIF', 'IF-00002', '22', 1, 7, 488, '', 0),
(650, 'TIF', 'IF-0004', '22', 1, 7, 490, '', 0),
(655, 'TIF', 'IF015', '22', 1, 3, 513, '', 0),
(656, 'TIF', 'IF023', '22', 1, 4, 512, '', 0),
(657, 'TIF', 'IF022', '22', 1, 4, 515, '', 0),
(658, 'TIF', 'IF104', '22', 1, 6, 518, '', 0),
(659, 'TIF', 'IF105', '22', 1, 5, 519, '', 0),
(660, 'TIF', 'IFU08', '22', 1, 5, 520, '', 0),
(661, 'TIF', 'IF-028', '22', 1, 6, 516, '', 0),
(662, 'TIF', 'IF204', '22', 1, 6, 517, '', 0),
(663, 'TIF', 'IF021', '22', 2, 4, 514, '', 0),
(664, 'TIF', 'IF205', '22', 1, 6, 522, '', 0),
(665, 'TIF', 'TIF-0001', '22', 1, 8, 523, '', 0),
(719, 'TIF', 'IF001', '22', 1, 1, 562, '', 0),
(720, 'TIF', 'IF002', '22', 1, 1, 563, '', 0),
(721, 'TIF', 'IF010', '22', 2, 2, 385, '', 0),
(722, 'TIF', ' IF022', '22', 2, 3, 395, '', 0),
(723, 'TIF', ' IF030', '22', 2, 3, 414, '', 0),
(724, 'TIF', 'IFU03', '22', 2, 4, 382, '', 0),
(725, 'TIF', ' IF025', '22', 2, 4, 398, '', 0),
(726, 'TIF', 'IF009', '22', 2, 5, 578, '', 0),
(727, 'TIF', 'IF015', '22', 2, 5, 383, '', 0),
(728, 'TIF', ' IF026', '22', 2, 5, 406, '', 0),
(729, 'TIF', ' IF016', '22', 2, 6, 390, '', 0),
(730, 'TIF', ' IF027', '22', 2, 6, 400, '', 0),
(732, 'TIF', 'IF007', '22', 1, 2, 564, '', 0),
(733, 'TIF', 'IF008', '22', 1, 2, 565, '', 0),
(734, 'TIF', 'IF010', '22', 1, 2, 566, '', 0),
(735, 'TIF', 'IF009', '22', 1, 2, 567, '', 0),
(736, 'TIF', 'IF024', '22', 1, 5, 569, '', 0),
(737, 'TIF', 'IF031', '22', 1, 6, 568, '', 0),
(738, 'TIF', ' IFU11', '22', 1, 7, 418, '', 0),
(739, 'TIF', 'IF-00002', '22', 1, 7, 488, '', 0),
(740, 'TIF', 'IFU01', '22', 1, 8, 370, '', 0),
(741, 'TIF', 'IFP10', '22', 3, 6, 429, '', 0),
(742, 'TIF', 'IFU08', '22', 1, 6, 520, '', 0),
(743, 'TIF', 'TIF-004', '22', 1, 8, 571, '', 0),
(744, 'TIF', 'TIF-005', '22', 1, 8, 572, '', 0),
(745, 'TIF', 'IF019', '22', 2, 4, 387, '', 0),
(746, 'TIF', 'IF203', '22', 4, 5, 405, '', 2),
(757, 'TIF', 'IF105', '22', 1, 6, 519, '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `ms_mhs`
--

CREATE TABLE `ms_mhs` (
  `oid` int(11) NOT NULL,
  `str_npm` varchar(11) NOT NULL,
  `str_nm_mhs` varchar(100) NOT NULL,
  `dte_tgl_lhr` date NOT NULL,
  `str_tmp_lhr` varchar(100) NOT NULL,
  `str_kd_kokab_lhr` int(11) NOT NULL,
  `bol_jk` varchar(1) NOT NULL,
  `bol_st_sipil` varchar(1) NOT NULL,
  `str_jns_identity` varchar(2) NOT NULL,
  `str_no_identity` varchar(50) NOT NULL,
  `str_kd_agama` int(11) NOT NULL,
  `str_almt_rmh` varchar(200) NOT NULL,
  `str_rtrw_rmh` varchar(50) NOT NULL,
  `str_dskel_rmh` varchar(200) NOT NULL,
  `str_kec_rmh` varchar(200) NOT NULL,
  `str_kdpos_rmh` varchar(10) NOT NULL,
  `str_kd_kokab_rmh` int(11) NOT NULL,
  `str_notelp_rmh` varchar(50) NOT NULL,
  `str_nohp_rmh` varchar(50) NOT NULL,
  `str_st_rmh` varchar(2) NOT NULL,
  `str_kd_prodi` varchar(6) NOT NULL,
  `num_thn_angkatan` year(4) NOT NULL,
  `str_smt_msk` varchar(2) NOT NULL,
  `str_st_kelas` varchar(2) NOT NULL,
  `str_kd_kelas` varchar(20) NOT NULL,
  `str_kd_dswali` varchar(6) NOT NULL,
  `str_nm_ayah` varchar(100) NOT NULL,
  `str_nm_ibu` varchar(100) NOT NULL,
  `dte_tgllhr_ayah` date NOT NULL,
  `dte_tgllhr_ibu` date NOT NULL,
  `str_pend_ayah` varchar(2) NOT NULL,
  `str_pend_ibu` varchar(2) NOT NULL,
  `str_pkrj_ayah` varchar(2) NOT NULL,
  `nm_dinas` varchar(50) NOT NULL,
  `pekerjaan_ortu_lainlain` varchar(50) NOT NULL,
  `str_pkrj_ibu` varchar(2) NOT NULL,
  `str_phsl_ayah` varchar(2) NOT NULL,
  `str_phsl_ibu` varchar(2) NOT NULL,
  `num_sdr_kdg` int(11) NOT NULL,
  `num_anak_ke` int(11) NOT NULL,
  `str_nm_wali` varchar(100) NOT NULL,
  `str_pkrj_wali` varchar(2) NOT NULL,
  `str_hub_wali` varchar(50) NOT NULL,
  `str_almt_ortu` varchar(200) NOT NULL,
  `str_rtrw_ortu` varchar(50) NOT NULL,
  `str_dskel_ortu` varchar(200) NOT NULL,
  `str_kec_ortu` varchar(200) NOT NULL,
  `str_kdpos_ortu` varchar(10) NOT NULL,
  `str_kd_kokab_ortu` int(11) NOT NULL,
  `str_notelp_ortu` varchar(50) NOT NULL,
  `str_nohp_ortu` varchar(50) NOT NULL,
  `str_jnj_asalskh` varchar(2) NOT NULL,
  `str_nm_asalskh` varchar(100) NOT NULL,
  `str_st_asalskh` varchar(2) NOT NULL,
  `str_almt_asalskh` varchar(200) NOT NULL,
  `str_kd_kokab_asalskh` int(11) NOT NULL,
  `str_notelp_asalskh` varchar(50) NOT NULL,
  `str_kdpos_asalskh` varchar(50) NOT NULL,
  `str_provinsi_sklh` varchar(10) NOT NULL,
  `str_negara_sklh` varchar(10) NOT NULL,
  `str_jur_asalskh` varchar(100) NOT NULL,
  `str_akred_asalskh` varchar(20) NOT NULL,
  `str_thmsk_asalskh` varchar(10) NOT NULL,
  `str_thlls_asalskh` varchar(10) NOT NULL,
  `str_noijz_asalskh` varchar(50) NOT NULL,
  `num_nilakh_asalskh` decimal(5,2) NOT NULL,
  `sts_kuliah` varchar(10) NOT NULL,
  `str_asl_univ` varchar(50) NOT NULL,
  `str_almt_univ` text NOT NULL,
  `str_kdpos_univ` char(5) NOT NULL,
  `str_negara_univ` varchar(10) NOT NULL,
  `str_provinsi_univ` varchar(10) NOT NULL,
  `str_kota_univ` varchar(10) NOT NULL,
  `str_sts_pend_terakhir` varchar(10) NOT NULL,
  `st_semester` int(11) NOT NULL,
  `str_lls_diploma` varchar(10) NOT NULL,
  `str_st_transfer` varchar(2) NOT NULL,
  `str_nm_ptpindah` varchar(100) NOT NULL,
  `str_st_ptpindah` varchar(2) NOT NULL,
  `str_almt_ptpindah` varchar(200) NOT NULL,
  `str_kd_kokab_ptpindah` int(11) NOT NULL,
  `str_notelp_ptpindah` varchar(50) NOT NULL,
  `str_kdpos_ptpindah` varchar(50) NOT NULL,
  `str_prodi_ptpindah` varchar(100) NOT NULL,
  `str_akred_ptpindah` varchar(20) NOT NULL,
  `str_nim_ptpindah` varchar(20) NOT NULL,
  `str_st_kerja` varchar(2) NOT NULL,
  `str_nm_usaha` varchar(100) NOT NULL,
  `str_jns_bdusaha` varchar(2) NOT NULL,
  `str_almt_usaha` varchar(200) NOT NULL,
  `str_kd_kokab_usaha` int(11) NOT NULL,
  `str_notelp_usaha` varchar(50) NOT NULL,
  `str_nohp_usaha` varchar(50) NOT NULL,
  `str_jbtn_usaha` varchar(100) NOT NULL,
  `str_bdg_usaha` varchar(100) NOT NULL,
  `str_loc_foto` varchar(200) NOT NULL,
  `str_loc_ijazah` varchar(200) NOT NULL,
  `str_loc_transkrip` varchar(200) NOT NULL,
  `str_loc_raport_skhun` varchar(200) NOT NULL,
  `str_loc_ijazah_diplm` varchar(200) NOT NULL,
  `str_loc_transkrip_diplm` varchar(200) NOT NULL,
  `bol_st_aktif` varchar(1) NOT NULL DEFAULT '1',
  `sks_skripsi` int(1) NOT NULL,
  `jumlah_seminar` int(10) NOT NULL,
  `int_st_wali` enum('0','1') NOT NULL,
  `str_kategori_kelas` varchar(2) NOT NULL,
  `uk_almamater` varchar(5) NOT NULL,
  `no_ijazah_sttb` varchar(255) NOT NULL,
  `str_jdl_skripsi` varchar(255) NOT NULL,
  `str_jdl_skripsi_en` varchar(255) NOT NULL,
  `tgl_lulus_ydsm` date NOT NULL,
  `tgl_wsd` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_mhs`
--

INSERT INTO `ms_mhs` (`oid`, `str_npm`, `str_nm_mhs`, `dte_tgl_lhr`, `str_tmp_lhr`, `str_kd_kokab_lhr`, `bol_jk`, `bol_st_sipil`, `str_jns_identity`, `str_no_identity`, `str_kd_agama`, `str_almt_rmh`, `str_rtrw_rmh`, `str_dskel_rmh`, `str_kec_rmh`, `str_kdpos_rmh`, `str_kd_kokab_rmh`, `str_notelp_rmh`, `str_nohp_rmh`, `str_st_rmh`, `str_kd_prodi`, `num_thn_angkatan`, `str_smt_msk`, `str_st_kelas`, `str_kd_kelas`, `str_kd_dswali`, `str_nm_ayah`, `str_nm_ibu`, `dte_tgllhr_ayah`, `dte_tgllhr_ibu`, `str_pend_ayah`, `str_pend_ibu`, `str_pkrj_ayah`, `nm_dinas`, `pekerjaan_ortu_lainlain`, `str_pkrj_ibu`, `str_phsl_ayah`, `str_phsl_ibu`, `num_sdr_kdg`, `num_anak_ke`, `str_nm_wali`, `str_pkrj_wali`, `str_hub_wali`, `str_almt_ortu`, `str_rtrw_ortu`, `str_dskel_ortu`, `str_kec_ortu`, `str_kdpos_ortu`, `str_kd_kokab_ortu`, `str_notelp_ortu`, `str_nohp_ortu`, `str_jnj_asalskh`, `str_nm_asalskh`, `str_st_asalskh`, `str_almt_asalskh`, `str_kd_kokab_asalskh`, `str_notelp_asalskh`, `str_kdpos_asalskh`, `str_provinsi_sklh`, `str_negara_sklh`, `str_jur_asalskh`, `str_akred_asalskh`, `str_thmsk_asalskh`, `str_thlls_asalskh`, `str_noijz_asalskh`, `num_nilakh_asalskh`, `sts_kuliah`, `str_asl_univ`, `str_almt_univ`, `str_kdpos_univ`, `str_negara_univ`, `str_provinsi_univ`, `str_kota_univ`, `str_sts_pend_terakhir`, `st_semester`, `str_lls_diploma`, `str_st_transfer`, `str_nm_ptpindah`, `str_st_ptpindah`, `str_almt_ptpindah`, `str_kd_kokab_ptpindah`, `str_notelp_ptpindah`, `str_kdpos_ptpindah`, `str_prodi_ptpindah`, `str_akred_ptpindah`, `str_nim_ptpindah`, `str_st_kerja`, `str_nm_usaha`, `str_jns_bdusaha`, `str_almt_usaha`, `str_kd_kokab_usaha`, `str_notelp_usaha`, `str_nohp_usaha`, `str_jbtn_usaha`, `str_bdg_usaha`, `str_loc_foto`, `str_loc_ijazah`, `str_loc_transkrip`, `str_loc_raport_skhun`, `str_loc_ijazah_diplm`, `str_loc_transkrip_diplm`, `bol_st_aktif`, `sks_skripsi`, `jumlah_seminar`, `int_st_wali`, `str_kategori_kelas`, `uk_almamater`, `no_ijazah_sttb`, `str_jdl_skripsi`, `str_jdl_skripsi_en`, `tgl_lulus_ydsm`, `tgl_wsd`) VALUES
(394, '15111253', 'Yoga Listianto', '1996-08-19', 'Bandung', 187, '0', '0', '0', '3277011908960002', 1, 'Babakan Cibaligo', '02/16', 'Cibeureum', 'Cimahi Selatan', '40535', 169, '-', '089694331588', '3', 'TIF', 2016, '1', '1', 'TIF-RM-15C', '23', 'Suwanta', 'Elis Mulyani', '1972-07-03', '1980-04-02', '8', '7', '7', '', '', '2', '3', '1', 2, 1, '', '', '', 'Babakan Cibaligo', '02/16', 'Cibeureum', 'Cimahi Selatan', '40535', 193, '-', '081220757048', '1', 'SMK TI GARUDA NUSANTARA CIMAHI', '1', 'Jl. Sangkuriang No.30, Cipageran, Cimahi Utara, Kota Cimahi, Jawa Barat', 193, '0226650810', '40535', '', '', 'RPL (Rekayasa Perangkat Lunak)', 'A', '04/2011', '05/2014', 'DN-02 Mk 0050819', '30.30', '', '', '', '', '', '', '', '', 0, '', '0', '', '0', '', 0, '', '', '', '', '', '1', 'Pt. Trimandiri Plasindo', '3', 'Jl. Industri IV No.1', 193, '0226006634', '40535', 'Staff Admin', 'Pabrik Plastik Merk Tristar', '1511125320181003102951.jpg', '1511125320160630222615.jpg', '1511125320160630224003.jpg', '', '', '', '1', 0, 0, '1', '1', '', '', '', '', '0000-00-00', '0000-00-00'),
(4835, '15111999', 'Agam Bakti Nugraha', '2021-03-16', 'Bandung', 0, '', '', '', '', 0, '', '', '', '', '', 0, '085223054961', '', '', '', 0000, '', '', '', '', '', '', '0000-00-00', '0000-00-00', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '', '0.00', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '', '', '1', 0, 0, '0', '', '', '', '', '', '0000-00-00', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `ms_mkuliah`
--

CREATE TABLE `ms_mkuliah` (
  `id` int(11) NOT NULL,
  `str_alias` varchar(3) NOT NULL,
  `str_kd_mk` varchar(15) NOT NULL,
  `str_nm_mk` varchar(100) NOT NULL,
  `str_nm_mk_en` varchar(255) NOT NULL,
  `str_jml_sks` int(1) NOT NULL,
  `thn_ajaran` varchar(20) NOT NULL,
  `str_kategori_mk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_mkuliah`
--

INSERT INTO `ms_mkuliah` (`id`, `str_alias`, `str_kd_mk`, `str_nm_mk`, `str_nm_mk_en`, `str_jml_sks`, `thn_ajaran`, `str_kategori_mk`) VALUES
(1, 'TIF', 'KU-20121', 'Agama', '', 2, '14', 1),
(2, 'TIF', 'KU-20221', 'Pancasila', '', 2, '14', 1),
(3, 'TIF', 'KU-20421', 'Bahasa Indonesia', '', 2, '14', 1),
(4, 'TIF', 'KU-20521', 'Bahasa Inggris I', '', 2, '14', 1),
(5, 'TIF', 'DK-20131', 'Kalkulus I', '', 3, '14', 1),
(6, 'TIF', 'DK-20431', 'Fisika I', '', 2, '14', 1),
(7, 'TIF', 'DK-20621', 'Pengantar Teknologi Informasi', '', 2, '14', 1),
(8, 'TIF', 'DK-20741', 'Algoritma dan Pemrograman I', '', 3, '14', 1),
(9, 'TIF', 'DK-20742', 'Dasar Komputer', '', 1, '14', 1),
(10, 'TIF', 'KU-20321', 'Kewarganegaraan', '', 2, '14', 2),
(11, 'TIF', 'KU-20622', 'Bahasa Inggris II', '', 2, '14', 2),
(12, 'TIF', 'DK-20232', 'Kalkulus II', '', 3, '14', 2),
(13, 'TIF', 'DK-20532', 'Fisika II', '', 2, '14', 2),
(14, 'TIF', 'DK-20743', 'Algoritma dan Pemrograman II', '', 3, '14', 2),
(15, 'TIF', 'DK-20831', 'Statistika', '', 3, '14', 1),
(16, 'TIF', 'DK-21121', 'Logika Boolean', '', 2, '14', 1),
(17, 'TIF', 'DK-21341', 'Sistem Operasi ', '', 3, '14', 1),
(18, 'TIF', 'DK-20333', 'Matriks dan Ruang Vektor', '', 3, '14', 1),
(19, 'TIF', 'KK-20231', 'Jaringan Komputer', '', 3, '14', 1),
(20, 'TIF', 'KK-20431', 'Struktur Data', '', 3, '14', 1),
(21, 'TIF', 'KK-21231', 'Teori Bahasa Otomata', '', 3, '14', 1),
(22, 'TIF', 'KK-21531', 'Pengantar Sistem Informasi', '', 3, '14', 1),
(23, 'TIF', 'KP-21631', 'Intelegensi Buatan ', '', 3, '14', 1),
(24, 'TIF', 'KP-20531', 'Sistem Informasi Enterprise', '', 3, '14', 1),
(25, 'TIF', 'KK-20621', 'Orkom dan Arkom', '', 3, '14', 1),
(26, 'TIF', 'KK-20731', 'Matematika Diskrit', '', 3, '14', 1),
(27, 'TIF', 'KK-20732', 'Teori Graph', '', 3, '14', 1),
(28, 'TIF', 'KK-21031', 'Rekayasa Perangkat Lunak', '', 3, '14', 2),
(29, 'TIF', 'KK-21841', 'Keamanan Sistem Jaringan ', '', 3, '14', 1),
(30, 'TIF', 'KK-21931', 'Sistem Basis Data', '', 3, '14', 1),
(31, 'TIF', 'KK-21721', 'Web Programming', '', 3, '14', 1),
(32, 'TIF', 'KK-21933', 'Visual Programming I', '', 3, '14', 1),
(33, 'TIF', 'KK-22021', 'Object Oriented Analisys and Design', '', 3, '14', 1),
(34, 'TIF', 'KK-23131', 'Teknik Penulisan Laporan Ilmiah', '', 2, '14', 1),
(35, 'TIF', 'KP-20131', 'Teknik Kompilasi', '', 3, '14', 2),
(36, 'TIF', 'KP-20431', 'Metode Numerik', '', 3, '14', 1),
(37, 'TIF', 'KP-20931', 'Pemodelan dan Simulasi', '', 3, '14', 1),
(38, 'TIF', 'KK-20121', 'Interaksi Manusia dan Komputer', '', 2, '14', 1),
(39, 'TIF', 'KK-20122', 'Etika Profesi', '', 2, '14', 1),
(40, 'TIF', 'KK-21932', 'Objeck Oriented Programming I', '', 3, '14', 1),
(41, 'TIF', 'KK-21934', 'Objeck Oriented Programming II', '', 3, '14', 2),
(42, 'TIF', 'KK-21935', 'Visual Programming II', '', 3, '14', 2),
(43, 'TIF', 'KP-20331', 'Basis Data Terdistribusi', '', 3, '14', 2),
(44, 'TIF', 'KP-20631', 'Multimedia dan Animasi', '', 3, '14', 2),
(45, 'TIF', 'MP-24020', 'Sistem Pakar', '', 2, '14', 2),
(46, 'TIF', 'KK-20123', 'Komputer Dalam Masyarakat', '', 2, '14', 1),
(47, 'TIF', 'KK-21936', 'Kerja Praktek', '', 2, '14', 1),
(48, 'TIF', 'KK-22121', 'Management Proyek Perangkat Lunak', '', 2, '14', 1),
(49, 'TIF', 'KK-22921', 'Internet dan E-Commerce', '', 3, '14', 1),
(50, 'TIF', 'KK-22922', 'Sistem Mikroprosessor', '', 3, '14', 1),
(51, 'TIF', 'KP-20831', 'Sistem Informasi Geografis', '', 3, '14', 1),
(52, 'TIF', 'KU-22531', 'Kewirausahaan', '', 2, '14', 1),
(53, 'TIF', 'MP-24026', 'Mobile Programming', '', 3, '14', 1),
(54, 'TIF', 'MP-24028', 'Uji Kualitas Perangkat Lunak', '', 2, '14', 1),
(55, 'TIF', 'KK-22832', 'Tugas Akhir', '', 5, '14', 2),
(56, 'TIF', 'KU-20121', 'Agama', '', 2, '12', 1),
(57, 'TIF', 'KU-20221', 'Pancasila', '', 2, '12', 1),
(58, 'TIF', 'KU-20421', 'Bahasa Indonesia', '', 2, '12', 1),
(59, 'TIF', 'KU-20521', 'Bahasa Inggris I', '', 2, '12', 1),
(60, 'TIF', 'DK-20131', 'Kalkulus I', '', 3, '12', 1),
(61, 'TIF', 'DK-20431', 'Fisika I', '', 2, '12', 1),
(62, 'TIF', 'DK-20621', 'Pengantar Teknologi Informasi', '', 2, '12', 1),
(63, 'TIF', 'DK-20741', 'Algoritma dan Pemrograman I', '', 3, '12', 1),
(64, 'TIF', 'DK-20742', 'Dasar Komputer', '', 1, '12', 2),
(65, 'TIF', 'KU-20321', 'Kewarganegaraan', '', 2, '12', 2),
(66, 'TIF', 'KU-20622', 'Bahasa Inggris II', '', 2, '12', 2),
(67, 'TIF', 'DK-20232', 'Kalkulus II', '', 3, '12', 2),
(68, 'TIF', 'DK-20532', 'Fisika II', '', 2, '12', 2),
(69, 'TIF', 'DK-20743', 'Algoritma dan Pemrograman II', '', 3, '12', 1),
(70, 'TIF', 'DK-20831', 'Statiska', '', 3, '12', 1),
(71, 'TIF', 'KK-21121', 'Logika Boolean', '', 2, '12', 1),
(72, 'TIF', 'KK-20731', 'Matematika Diskrit', '', 3, '12', 1),
(73, 'TIF', 'DK-20333', 'Matriks dan Ruang Vektor', '', 3, '12', 1),
(74, 'TIF', 'KK-20231', 'Jaringan Komputer', '', 3, '12', 1),
(75, 'TIF', 'KK-20431', 'Struktur Data', '', 3, '12', 1),
(76, 'TIF', 'KK-21231', 'Teori Bahasa Otomata', '', 3, '12', 1),
(77, 'TIF', 'KK-23531', 'Pengantar Sistem Informasi', '', 3, '12', 1),
(78, 'TIF', 'KK-21933', 'Visual Programming I', '', 3, '12', 1),
(79, 'TIF', 'KK-21932', 'Rekayasa Perangkat Lunak', '', 3, '12', 1),
(80, 'TIF', 'KK-20621', 'Orkom dan Arkom', '', 3, '12', 1),
(81, 'TIF', 'KK-21341', 'Sistem Operasi', '', 3, '12', 1),
(82, 'TIF', 'KK-21935', 'Visual Programming II', '', 3, '12', 2),
(83, 'TIF', 'KP-20531', 'Web Programming I', '', 3, '12', 1),
(84, 'TIF', 'KK-21841', 'Keamanan Sistem Jaringan', '', 3, '12', 2),
(85, 'TIF', 'KK-21931', 'Sistem Basis Data', '', 3, '12', 1),
(86, 'TIF', 'KK-21721', 'Web Programming II', '', 3, '12', 2),
(87, 'TIF', 'KP-21631', 'Intelegensi Buatan', '', 3, '12', 1),
(88, 'TIF', 'KK-22021', 'Object Oriented Analysis and Design', '', 3, '12', 1),
(89, 'TIF', 'KK-20121', 'Interaksi Manusia dan Komputer', '', 2, '12', 1),
(90, 'TIF', 'KP-20131', 'Teknik Kompilasi', '', 3, '12', 2),
(91, 'TIF', 'KK-20732', 'Teori Graph', '', 3, '12', 1),
(92, 'TIF', 'KK-21936', 'Object Oriented Programming I', '', 3, '12', 1),
(93, 'TIF', 'KK-22921', 'Internet dan E-Commerce', '', 3, '12', 1),
(94, 'TIF', 'KK-20122', 'Etika Profesi', '', 2, '12', 1),
(95, 'TIF', 'KP-20931', 'Sistem Informasi Enterprise', '', 3, '12', 1),
(96, 'TIF', 'KK-21934', 'Object Oriented Programming II', '', 3, '12', 2),
(97, 'TIF', 'KP-20431', 'Mobile Programming', '', 3, '12', 1),
(98, 'TIF', 'KP-20331', 'Basis Data Terdistribusi', '', 3, '12', 2),
(99, 'TIF', 'KP-20631', 'Multimedia dan Animasi', '', 3, '12', 1),
(100, 'TIF', 'MP-24020', 'Sistem Pakar', '', 2, '12', 1),
(101, 'TIF', 'KK-23131', 'Teknik Penulisan Laporan Ilmiah', '', 2, '12', 1),
(102, 'TIF', 'KK-22731', 'Kerja Praktek', '', 2, '12', 1),
(103, 'TIF', 'KK-22121', 'Manajemen Proyek Perangkat Lunak', '', 2, '12', 1),
(104, 'TIF', 'KK-20123', 'Komputer dalam Masyarakat', '', 2, '12', 1),
(105, 'TIF', 'KK-22922', 'Sistem Mikroprosessor', '', 3, '12', 1),
(106, 'TIF', 'KP-20831', 'Sistem Informasi Geografis', '', 3, '12', 1),
(107, 'TIF', 'KU-22531', 'Kewirausahaan', '', 2, '12', 1),
(108, 'TIF', 'MP-24062', 'Permodelan dan Simulasi', '', 2, '12', 1),
(109, 'TIF', 'MP-24028', 'Uji Kualitas Perangkat Lunak', '', 2, '12', 1),
(110, 'TIF', 'KK-22832', 'Tugas akhir', '', 5, '12', 2),
(111, 'TIF', 'KU-20121', 'Agama', '', 2, '9', 1),
(112, 'TIF', 'KU-20221', 'Pancasila ', '', 2, '9', 1),
(113, 'TIF', 'KU-20421', 'Bahasa Indonesia ', '', 2, '9', 1),
(114, 'TIF', 'KU-20521', 'Bahasa Inggris I', '', 2, '9', 1),
(115, 'TIF', 'DK-20131', 'Kalkulus I', '', 3, '9', 1),
(116, 'TIF', 'DK-20431', 'Fisika I', '', 2, '9', 1),
(117, 'TIF', 'DK-20621', 'Pengantar Teknologi Informasi', '', 2, '9', 1),
(118, 'TIF', 'DK-20741', 'Algoritma dan Pemograman I', '', 3, '9', 1),
(119, 'TIF', 'DK-20742', 'Dasar Komputer ', '', 1, '9', 1),
(120, 'TIF', 'KU-20321', 'Kewarganegaraan ', '', 2, '9', 2),
(121, 'TIF', 'KU-20622', 'Bahasa Inggris II', '', 2, '9', 2),
(122, 'TIF', 'DK-20232', 'Kalkulus II', '', 3, '9', 2),
(123, 'TIF', 'DK-20532', 'Fisika II', '', 2, '9', 2),
(124, 'TIF', 'DK-20743', 'Algoritma dan Pemograman II', '', 3, '9', 2),
(125, 'TIF', 'DK-20831', 'Statistika', '', 3, '9', 1),
(126, 'TIF', 'KK-21121', 'Logika Boolean', '', 2, '9', 1),
(127, 'TIF', 'KK-20731', 'Matematika Diskrit', '', 3, '9', 1),
(128, 'TIF', 'DK-20333', 'Matriks dan Ruang Vektor ', '', 3, '9', 1),
(129, 'TIF', 'KK-20231', 'Jaringan Komputer ', '', 3, '9', 1),
(130, 'TIF', 'KK-20431', 'Struktur Data ', '', 3, '9', 1),
(131, 'TIF', 'KK-21231', 'Teori Bahasa Otomata ', '', 3, '9', 1),
(132, 'TIF', 'KK-21531', 'Pengantar Sistem Informasi ', '', 3, '9', 1),
(133, 'TIF', 'KK-21933', 'Visual Programming I', '', 3, '9', 1),
(134, 'TIF', 'KK-21031', 'Rekayasa Perangkat Lunak', '', 3, '9', 1),
(135, 'TIF', 'KK-20621', 'Orkom dan Arkom', '', 3, '9', 1),
(136, 'TIF', 'KK-21341', 'Sistem Operasi', '', 3, '9', 1),
(137, 'TIF', 'KK-20622', 'Visual Programming II', '', 3, '9', 2),
(138, 'TIF', 'KP-20531', 'Web Programming I', '', 3, '9', 1),
(139, 'TIF', 'KK-21841', 'Keamanan Sistem Jaringan ', '', 3, '9', 2),
(140, 'TIF', 'KK-21931', 'Sistem Basis Data ', '', 3, '9', 1),
(141, 'TIF', 'KK-21721', 'Web Programming II', '', 3, '9', 2),
(142, 'TIF', 'KP-21631', 'Intelegensi Buatan ', '', 3, '9', 1),
(143, 'TIF', 'KK-22021', 'Object Oriented Analisys and Design', '', 3, '9', 1),
(144, 'TIF', 'KK-20121', 'Interaksi Manusia dan Komputer ', '', 2, '9', 1),
(145, 'TIF', 'KK-20131', 'Teknik Komplikasi ', '', 3, '9', 2),
(146, 'TIF', 'KK-20732', 'Teori Graph', '', 3, '9', 1),
(147, 'TIF', 'KK-21932', 'Object Oriented Programming I', '', 3, '9', 1),
(148, 'TIF', 'KK-22921', 'Internet dan E-Commerce', '', 3, '9', 1),
(149, 'TIF', 'KK-20122', 'Etika Profesi ', '', 2, '9', 1),
(150, 'TIF', 'KP-20931', 'Sistem Informasi Enterprise', '', 3, '9', 1),
(151, 'TIF', 'KK-21934', 'Object Oriented Programming II', '', 3, '9', 1),
(152, 'TIF', 'KP-20431', 'Mobile Programming ', '', 3, '9', 1),
(153, 'TIF', 'KP-20331', 'Basis Data Terdistribusi ', '', 3, '9', 2),
(154, 'TIF', 'KP-20631', 'Multimedia dan Animasi ', '', 3, '9', 1),
(155, 'TIF', 'MP-24020', 'Sistem Pakar ', '', 2, '9', 1),
(156, 'TIF', 'KK-23131', 'Teknik Penulisan Laporan Ilmiah ', '', 2, '9', 1),
(157, 'TIF', 'KK-22731', 'Kerja Praktek ', '', 2, '9', 1),
(158, 'TIF', 'KK-22121', 'Manajemen Proyek Perangkat Lunak ', '', 2, '9', 1),
(159, 'TIF', 'KK-20123', 'Komputer Dalam Masyarakat ', '', 2, '9', 1),
(160, 'TIF', 'KK-22922', 'Sistem Mikroprosessor', '', 3, '9', 1),
(161, 'TIF', 'KP-20831', 'Sistem Informasi Geografis', '', 3, '9', 1),
(162, 'TIF', 'KU-22531', 'Kewirausahaan', '', 2, '9', 1),
(163, 'TIF', 'MP-24026', 'Grafika Komputer', '', 2, '9', 1),
(164, 'TIF', 'MP-24028', 'Uji Kualitas Perangkat Lunak', '', 2, '9', 1),
(165, 'TIF', 'KK-22832', 'Tugas Akhir', '', 5, '9', 2),
(166, 'TIF', 'IFU01', 'Fisika Dasar', '', 3, '6', 1),
(167, 'TIF', 'IF001', 'Kalkulus I', '', 3, '6', 1),
(168, 'TIF', 'IF002', 'Matematika Diskret', '', 3, '6', 1),
(169, 'TIF', 'IFU02', 'Bahasa Inggris I', '', 2, '6', 1),
(170, 'TIF', 'IF003', 'Algoritma dan Pemrograman I', '', 3, '6', 1),
(171, 'TIF', 'IF004', 'Struktur Data ', '', 3, '6', 1),
(172, 'TIF', 'IF005', 'Pengantar Teknologi Informasi', '', 2, '6', 1),
(173, 'TIF', 'IFU03', 'Pancasila', '', 2, '6', 1),
(174, 'TIF', 'IF006', 'Sistem Operasi ', '', 3, '6', 1),
(175, 'TIF', 'IF007', 'Kalkulus II', '', 3, '6', 2),
(176, 'TIF', 'IF008', 'Logika Boolean', '', 2, '6', 2),
(177, 'TIF', 'IFU04', 'Bahasa Inggris II', '', 2, '6', 2),
(178, 'TIF', 'IF009', 'Dasar Komputer', '', 2, '6', 1),
(179, 'TIF', 'IF010', 'Matriks dan Ruang Vektor', '', 3, '6', 1),
(180, 'TIF', 'IF011', 'Algoritma dan Pemrograman II', '', 3, '6', 2),
(181, 'TIF', 'IF012', 'Sistem Basisi Data', '', 3, '6', 1),
(182, 'TIF', 'IFU05', 'Statistika', '', 3, '6', 1),
(183, 'TIF', 'IF013', 'Teori Bahasa Otomata', '', 3, '6', 1),
(184, 'TIF', 'IF014', 'Intelegensi Buatan ', '', 3, '6', 1),
(185, 'TIF', 'IF015', 'Visual Programming  I', '', 3, '6', 1),
(186, 'TIF', 'IF016', 'Teknik Kompilasi', '', 3, '6', 2),
(187, 'TIF', 'IF017', 'Basis Data Terdistribusi', '', 3, '6', 2),
(188, 'TIF', 'IF018', 'Jaringan Komputer', '', 3, '6', 1),
(189, 'TIF', 'IF019', 'Rekayasa Perangkat Lunak', '', 3, '6', 1),
(190, 'TIF', 'IF020', 'Web Programming I', '', 3, '6', 1),
(191, 'TIF', 'IF021', 'Visual Programming II', '', 3, '6', 2),
(192, 'TIF', 'IF022', 'Teori Graph', '', 3, '6', 1),
(193, 'TIF', 'IFU06', 'Kewarganegaraan', '', 2, '6', 2),
(194, 'TIF', 'IF023', 'Object Oriented Analisys and Design', '', 3, '6', 1),
(195, 'TIF', 'IF201', 'Multimedia App', '', 3, '6', 1),
(196, 'TIF', 'IF024', 'Mobile Programming ', '', 3, '6', 1),
(197, 'TIF', 'IF025', 'Web Programming II', '', 3, '6', 2),
(198, 'TIF', 'IFU07', 'Bahasa Indonesia', '', 2, '6', 1),
(199, 'TIF', 'IF026', 'Arkom dan Orkom', '', 3, '6', 1),
(200, 'TIF', 'IF027', 'Object Oriented Programming I', '', 3, '6', 1),
(201, 'TIF', 'IFU08', 'Teknik Penulisan Laporan Ilmiah', '', 2, '6', 1),
(202, 'TIF', 'IFU09', 'Etika Profesi', '', 2, '6', 1),
(203, 'TIF', 'IF028', 'Internet dan E-Commerce', '', 3, '6', 1),
(204, 'TIF', 'IF029', 'Sistem Mikroprosessor', '', 3, '6', 1),
(205, 'TIF', 'IF030', 'Object Oriented Programming II', '', 3, '6', 2),
(206, 'TIF', 'IF031', 'Sistem Informasi Geografis', '', 3, '6', 1),
(207, 'TIF', 'IFU11', 'Kerja Praktek', '', 2, '6', 1),
(208, 'TIF', 'IF032', 'Kewirausahaan', '', 2, '6', 1),
(209, 'TIF', 'IF033', 'Sistem Informasi Enterprise', '', 3, '6', 1),
(210, 'TIF', 'IFU12', 'Skripsi', '', 5, '6', 2),
(211, 'TIF', 'IFU10', 'Agama', '', 2, '6', 1),
(212, 'TIF', 'IF101', 'Computer Security', '', 3, '6', 4),
(213, 'TIF', 'IF102', 'Network Security', '', 3, '6', 4),
(214, 'TIF', 'IF103', 'Ethical Hacking', '', 3, '6', 4),
(215, 'TIF', 'IF104', 'Secure Programming', '', 3, '6', 4),
(216, 'TIF', 'IF105', 'Database Security', '', 3, '6', 4),
(217, 'TIF', 'IFP01', 'Manajemen Kinerja', '', 2, '6', 3),
(218, 'TIF', 'IFP02', 'Psikologi Industri', '', 2, '6', 3),
(219, 'TIF', 'IFP03', 'Mikrokontroler', '', 2, '6', 3),
(220, 'TIF', 'IFP04', 'Seni Budaya ', '', 2, '6', 3),
(221, 'TIF', 'IFP05', 'Sistem Pakar', '', 2, '6', 3),
(222, 'TIF', 'IF202', 'Software Development', '', 3, '6', 4),
(223, 'TIF', 'IF203', 'Computer Graphic', '', 3, '6', 4),
(224, 'TIF', 'IF204', 'Game Development', '', 3, '6', 4),
(225, 'TIF', 'IF205', 'IT Project Management', '', 3, '6', 4),
(226, 'TIF', 'IFU01', 'Fisika Dasar', '', 3, '8', 1),
(227, 'TIF', 'IF001', 'Kalkulus I', '', 3, '8', 1),
(228, 'TIF', 'IF002', 'Matematika Diskret ', '', 3, '8', 1),
(229, 'TIF', 'IFU02', 'Bahasa Inggris I', '', 2, '8', 1),
(230, 'TIF', 'IF003', 'Algoritma dan Pemrograman I', '', 3, '8', 1),
(231, 'TIF', 'IF004', 'Struktur Data', '', 3, '8', 1),
(232, 'TIF', 'IF005', 'Pengantar Teknologi Informasi', '', 2, '8', 1),
(233, 'TIF', 'IFU03', 'Pancasila', '', 2, '8', 1),
(234, 'TIF', 'IF006', 'Sistem Operasi', '', 3, '8', 1),
(235, 'TIF', 'IF007', 'Kalkulus II', '', 3, '8', 2),
(236, 'TIF', 'IF008', 'Logika Boolean', '', 2, '8', 1),
(237, 'TIF', 'IFU04', 'Bahasa Inggris II', '', 2, '8', 2),
(238, 'TIF', 'IF009', 'Dasar Komputer', '', 2, '8', 1),
(239, 'TIF', 'IF010', 'Matriks dan Ruang Vektor', '', 3, '8', 1),
(240, 'TIF', 'IF011', 'Algoritma dan Pemrograman II', '', 3, '8', 2),
(241, 'TIF', 'IF012', 'Sistem Basis Data', '', 3, '8', 1),
(242, 'TIF', 'IFU05', 'Stastistika', '', 3, '8', 1),
(243, 'TIF', 'IF013', 'Teori Bahasa Otomata', '', 3, '8', 1),
(244, 'TIF', 'IF014', 'Intelegensi Buatan', '', 3, '8', 1),
(245, 'TIF', 'IF015', 'Visual Programming I', '', 3, '8', 1),
(246, 'TIF', 'IF016', 'Teknik Kompilasi', '', 3, '8', 2),
(247, 'TIF', 'IF017', 'Basis Data Terdistribusi', '', 3, '8', 2),
(248, 'TIF', 'IF018', 'Jarigan Komputer', '', 3, '8', 1),
(249, 'TIF', 'IF019', 'Rekayasa Perangkat Lunak', '', 3, '8', 1),
(250, 'TIF', 'IF020', 'Web Programming I', '', 3, '8', 1),
(251, 'TIF', 'IF021', 'Visual Programming II', '', 3, '8', 2),
(252, 'TIF', 'IF022', 'Teori Graph', '', 3, '8', 1),
(253, 'TIF', 'IFU06', 'Kewarganegaraan', '', 2, '8', 1),
(254, 'TIF', 'IF023', 'Object Oriented Analisys and Design', '', 3, '8', 1),
(255, 'TIF', 'IF024', 'Mobile Programming', '', 3, '8', 1),
(256, 'TIF', 'IF025', 'Web Programmig II', '', 3, '8', 2),
(257, 'TIF', 'IFU07', 'Bahasa Indonesia', '', 2, '8', 1),
(258, 'TIF', 'IF026', 'Arkom dan Orkom', '', 3, '8', 1),
(259, 'TIF', 'IF027', 'Object Oriented Programming I', '', 3, '8', 2),
(260, 'TIF', 'IFU08', 'Teknik Pemulisan Laporan Ilmiah', '', 2, '8', 1),
(261, 'TIF', 'IFU09', 'Etika Profesi', '', 2, '8', 1),
(262, 'TIF', 'IF028', 'Internet dan E-Commerce', '', 3, '8', 1),
(263, 'TIF', 'IF029', 'Microprocessor', '', 3, '8', 1),
(264, 'TIF', 'IF030', 'Object Oriented Programming II', '', 3, '8', 2),
(265, 'TIF', 'IF031', 'Sistem Infomasi Geografis', '', 3, '8', 1),
(266, 'TIF', 'IFU11', 'Kerja Praktek', '', 2, '8', 1),
(267, 'TIF', 'IF032', 'Kewirausahaan', '', 2, '8', 1),
(268, 'TIF', 'IF033', 'Sistem Informasi Enterprise', '', 3, '8', 1),
(269, 'TIF', 'IFU12', 'Skripsi', '', 5, '8', 2),
(270, 'TIF', 'IFU10', 'Agama', '', 2, '8', 1),
(271, 'TIF', 'IF101', 'Computer Security', '', 3, '8', 4),
(272, 'TIF', 'IF102', 'Network Security', '', 3, '8', 4),
(273, 'TIF', 'IF103', 'Ethical Hacking', '', 3, '8', 4),
(274, 'TIF', 'IF104', 'Secure Programming', '', 3, '8', 4),
(275, 'TIF', 'IF105', 'Database Security', '', 3, '8', 4),
(276, 'TIF', 'IFP01', 'Manajemen Kinerja', '', 2, '8', 3),
(277, 'TIF', 'IFP02', 'Psikologi Industri', '', 2, '8', 3),
(278, 'TIF', 'IFP03', 'Mikrokontroler', '', 2, '8', 3),
(279, 'TIF', 'IFP04', 'Seni Budaya', '', 2, '8', 3),
(280, 'TIF', 'IFP05', 'Sistem Pakar', '', 2, '8', 3),
(281, 'TIF', 'IF201', 'Multimedia App.', '', 3, '8', 4),
(282, 'TIF', 'IF202', 'Softare Development', '', 3, '8', 4),
(283, 'TIF', 'IF203', 'Computer Graphic', '', 3, '8', 4),
(284, 'TIF', 'IF204', 'Game Development', '', 3, '8', 4),
(285, 'TIF', 'IF205', 'IT Project Management', '', 3, '8', 4),
(286, 'TIF', 'IF001', 'Algoritma dan Pemograman I', '', 3, '11', 1),
(287, 'TIF', 'IF003', 'Struktur Data', '', 3, '11', 1),
(288, 'TIF', 'IF007', 'Pengantar Teknologi Informasi', '', 2, '11', 1),
(289, 'TIF', 'IFU01', 'Agama', '', 2, '11', 1),
(290, 'TIF', 'IFU04', 'Bahasa Inggris I', '', 2, '11', 1),
(291, 'TIF', 'IF011', 'Matematika Dasar', '', 3, '11', 1),
(292, 'TIF', 'IF032', 'Fisika Dasar', '', 3, '11', 1),
(293, 'TIF', 'IFU02', 'Pancasila', '', 2, '11', 1),
(294, 'TIF', 'IF002', 'Algoritma dan Pemograman II', '', 3, '11', 2),
(295, 'TIF', 'IF004', 'Sistem Basis Data', '', 3, '11', 1),
(296, 'TIF', 'IF008', 'Interaksi Manusia Komputer', '', 2, '11', 1),
(297, 'TIF', 'IF009', 'Orkom dan Arkom', '', 2, '11', 1),
(298, 'TIF', 'IFU05', 'Bahasa Inggris II', '', 2, '11', 2),
(299, 'TIF', 'IF012', 'Metode Numerik', '', 3, '11', 1),
(300, 'TIF', 'IF013', 'Matematika Informatika', '', 3, '11', 1),
(301, 'TIF', 'IFU03', 'Kewarganegaraan', '', 2, '11', 1),
(302, 'TIF', 'IF015', 'Object Oriented Programming I', '', 3, '11', 1),
(303, 'TIF', 'IF005', 'Basis Data Terdistribusi', '', 3, '11', 1),
(304, 'TIF', 'IF010', 'Sistem Operasi', '', 3, '11', 1),
(305, 'TIF', 'IF017', 'Jaringan Komputer I', '', 3, '11', 1),
(306, 'TIF', 'IF019', 'Rekayasa Perangkat Lunak', '', 3, '11', 1),
(307, 'TIF', 'IF014', 'Statistika', '', 3, '11', 1),
(308, 'TIF', 'IF021', 'Teori Bahasa Otomata', '', 3, '11', 1),
(309, 'TIF', 'IF016', 'Object Oriented Programming II', '', 3, '11', 2),
(310, 'TIF', 'IF006', 'MTA : Database Adm. Fundamental', '', 3, '11', 1),
(311, 'TIF', 'IF023', 'Mobile Programming I', '', 3, '11', 1),
(312, 'TIF', 'IF018', 'Jaringan Komputer II', '', 3, '11', 2),
(313, 'TIF', 'IF020', 'Digital Preneurship', '', 3, '11', 1),
(314, 'TIF', 'IF022', 'Teknik Kompilasi', '', 3, '11', 1),
(315, 'TIF', 'IF025', 'Web Programming I', '', 3, '11', 1),
(316, 'TIF', 'IF024', 'Mobile Programming II', '', 3, '11', 2),
(317, 'TIF', 'IF027', 'Sistem Mikroprosessor', '', 3, '11', 1),
(318, 'TIF', 'IFU06', 'Bahasa Indonesia', '', 2, '11', 1),
(319, 'TIF', 'IF026', 'Web Programming II', '', 3, '11', 2),
(320, 'TIF', 'IF029', 'Metodologi Penelitian Informatika', '', 3, '11', 1),
(321, 'TIF', 'IF028', 'Sistem Mikrokontroler', '', 3, '11', 1),
(322, 'TIF', 'IFU07', 'Teknik Penulisan Literatur Ilmiah', '', 2, '11', 1),
(323, 'TIF', 'IF030', 'Intelegensi Buatan', '', 3, '11', 1),
(324, 'TIF', 'IFU10', 'CIPMA : Project Management', '', 3, '11', 1),
(325, 'TIF', 'IFU08', 'Pra Skripsi', '', 3, '11', 1),
(326, 'TIF', 'IF031', 'Sistem Pakar', '', 3, '11', 1),
(327, 'TIF', 'IFU11', 'Kerja Praktek', '', 2, '11', 1),
(328, 'TIF', 'IFU09', 'Skripsi', '', 5, '11', 1),
(329, 'TIF', 'IF101', 'Computer Security', '', 3, '11', 4),
(330, 'TIF', 'IF102', 'Network Security', '', 3, '11', 4),
(331, 'TIF', 'IF103', 'Information Security', '', 3, '11', 4),
(332, 'TIF', 'IF104', 'Ethical Hacking', '', 3, '11', 4),
(333, 'TIF', 'IF105', 'Forensic Security in Network Security', '', 3, '11', 4),
(334, 'TIF', 'IF201', 'Manajemen Proyek Perangkat Lunak', '', 3, '11', 4),
(335, 'TIF', 'IF202', 'Desain Kreatif Aplikasi dan Game', '', 3, '11', 4),
(336, 'TIF', 'IF203', 'Augmented and Virtual Reality', '', 3, '11', 4),
(337, 'TIF', 'IF204', 'Pengujian Perangkat Lunak', '', 3, '11', 4),
(338, 'TIF', 'IF205', 'Certificate in Computer Software Engineering', '', 3, '11', 4),
(339, 'TIF', 'IFP01', 'Sistem Informasi', '', 3, '11', 3),
(340, 'TIF', 'IFP02', 'Sistem Informasi Enterprise', '', 3, '11', 3),
(341, 'TIF', 'IFP03', 'Data Mining', '', 3, '11', 3),
(342, 'TIF', 'IFP04', 'Big Data', '', 3, '11', 3),
(343, 'TIF', 'IFP05', 'Info Grafis', '', 3, '11', 3),
(344, 'TIF', 'IFP06', 'Multimedia dan Animasi', '', 3, '11', 3),
(345, 'TIF', 'IFP07', 'Personal Development', '', 2, '11', 3),
(346, 'TIF', 'IFP08', 'Profesional Development', '', 2, '11', 3),
(367, 'TIF', 'IF001', 'Algoritma dan Pemograman 1', '', 3, '22', 1),
(368, 'TIF', 'IF003', 'Struktur Data', '', 3, '22', 1),
(369, 'TIF', 'IF007', 'Pengantar Teknologi Informasi', '', 2, '22', 1),
(370, 'TIF', 'IFU01', 'Agama', '', 2, '22', 1),
(371, 'TIF', 'IFU04', 'Bahasa Inggris 1', '', 2, '22', 1),
(372, 'TIF', 'IF011', 'Matematika Dasar', '', 3, '22', 1),
(373, 'TIF', 'IF032', 'Fisika Dasar', '', 3, '22', 1),
(374, 'TIF', 'IFU02', 'Pancasila', '', 2, '22', 1),
(375, 'TIF', 'IF002', 'Algoritma Dan Pemrograman 2', '', 3, '22', 2),
(376, 'TIF', 'IF004', 'Sistem Basis Data', '', 3, '22', 2),
(377, 'TIF', 'IF008', 'Interaksi Manusia Komputer', '', 2, '22', 2),
(378, 'TIF', 'IF009', 'Organisasi & Arsitektur Komputer', '', 2, '22', 2),
(379, 'TIF', 'IFU05', 'Bahasa Inggris 2', '', 2, '22', 2),
(380, 'TIF', 'IF012', 'Metode Numerik', '', 3, '22', 2),
(381, 'TIF', 'IF013', 'Matematika Informatika', '', 3, '22', 2),
(382, 'TIF', 'IFU03', 'Kewarganegaraan', '', 2, '22', 2),
(383, 'TIF', 'IF015', 'Pemrograman Berorientasi Objek 1', '', 3, '22', 2),
(384, 'TIF', 'IF005', 'Basis Data Terdistribusi', '', 3, '22', 2),
(385, 'TIF', 'IF010', 'Sistem Operasi ', '', 3, '22', 2),
(386, 'TIF', ' IF017', 'Jaringan Komputer 1 ', '', 3, '22', 2),
(387, 'TIF', 'IF019', 'Rekayasa Perangkat Lunak', '', 3, '22', 2),
(388, 'TIF', 'IF014', 'Statistika', '', 3, '22', 2),
(389, 'TIF', ' IF021', 'Teori Bahasa Otomata', '', 3, '22', 2),
(390, 'TIF', ' IF016', 'Pemograman Berorientasi Objek 2', '', 3, '22', 2),
(391, 'TIF', ' IF006', 'MTA : Database Adm. Fundamental', '', 3, '22', 1),
(392, 'TIF', ' IF023', 'Pemograman Mobile 1', '', 3, '22', 2),
(393, 'TIF', 'IF018', 'Jaringan Komputer 2', '', 3, '22', 2),
(394, 'TIF', ' IF020', 'Digital Preneurship', '', 3, '22', 2),
(395, 'TIF', ' IF022', 'Teknik Kompilasi ', '', 3, '22', 2),
(396, 'TIF', 'IF101', 'Computer Security', '', 3, '22', 4),
(397, 'TIF', 'IF201', 'Manajemen Proyek Perangkat Lunak', '', 3, '22', 4),
(398, 'TIF', ' IF025', 'Pemograman Web 1', '', 3, '22', 2),
(399, 'TIF', ' IF024', 'Pemograman Mobile 2', '', 3, '22', 2),
(400, 'TIF', ' IF027', 'Sistem Mikroprosessor', '', 3, '22', 2),
(401, 'TIF', ' IFU06', 'Bahasa Indonesia', '', 2, '22', 1),
(402, 'TIF', 'IF102', 'Network Security', '', 3, '22', 4),
(403, 'TIF', 'IF202', 'Desain Kreatif Aplikasi dan Game', '', 3, '22', 4),
(404, 'TIF', 'IF103', 'Information Security', '', 3, '22', 4),
(405, 'TIF', 'IF203', 'Augmented & Virtual Reality', '', 3, '22', 4),
(406, 'TIF', ' IF026', 'Pemograman Web 2', '', 3, '22', 2),
(407, 'TIF', ' IF029', 'Metodologi Penelitian Informatika', '', 3, '22', 1),
(408, 'TIF', ' IF028', 'Sistem Mikrokontroler', '', 3, '22', 2),
(409, 'TIF', ' IFU07', 'Teknik Penulisan Literatur Ilmiah', '', 2, '22', 2),
(410, 'TIF', 'IF104', 'Ethical Hacking', '', 3, '22', 4),
(411, 'TIF', 'IF204', 'Pengujian Perangkat Lunak', '', 3, '22', 4),
(412, 'TIF', 'IF105', 'FCNS (Forensic Security in Network Security)', '', 3, '22', 4),
(413, 'TIF', 'IF205', 'CCSE (Certificate in Computer Software Engineering)', '', 3, '22', 4),
(414, 'TIF', ' IF030', 'Artificial Intelegence', '', 3, '22', 2),
(415, 'TIF', ' IFU10', 'CIPMA : Project Management', '', 3, '22', 1),
(416, 'TIF', ' IFU08', 'Pra Skripsi', '', 3, '22', 2),
(417, 'TIF', ' IF031', 'Sistem Pakar', '', 3, '22', 2),
(418, 'TIF', ' IFU11', 'Kerja Praktek (Internship)', '', 2, '22', 1),
(419, 'TIF', ' IFU09', 'Skripsi', '', 5, '22', 2),
(420, 'TIF', 'IFP01', 'Sistem Informasi (OPSI 1)', '', 3, '22', 3),
(421, 'TIF', 'IFP02', 'Sistem Informasi Enterprise (OPSI 1)', '', 3, '22', 3),
(422, 'TIF', 'IFP03', 'Data Mining (OPSI 1)', '', 3, '22', 3),
(423, 'TIF', 'IFP04', 'Big Data (OPSI 2)', '', 3, '22', 3),
(424, 'TIF', ' IFP05', 'Info Grafis (OPSi 2)', '', 3, '22', 3),
(425, 'TIF', ' IFP06', 'Multimedia & Animasi (OPSi 2)', '', 3, '22', 3),
(426, 'TIF', ' IFP07', 'Personal Development (OPSI 3)', '', 2, '22', 3),
(427, 'TIF', 'IFP08', 'Profesional Development (OPSI 3)', '', 2, '22', 3),
(428, 'TIF', 'IFP09', 'Human Relationship (OPSi 4)', '', 2, '22', 3),
(429, 'TIF', 'IFP10', 'Etika Profesi (OPSi 4)', '', 2, '22', 3),
(487, 'TIF', 'IF-0001', 'Enterpreneurship', '', 2, '22', 1),
(488, 'TIF', 'IF-00002', 'Sistem Informasi Enterprise', '', 3, '22', 1),
(489, 'TIF', 'IF-00003', 'Kerja Praktek', '', 2, '22', 2),
(490, 'TIF', 'IF-0004', 'Pra Skripsi', '', 3, '22', 1),
(512, 'TIF', 'IF023', 'Object Oriented Analisys and Design (OOAD)', '', 3, '22', 1),
(513, 'TIF', 'IF015', 'Pemrograman Visual 1', '', 3, '22', 1),
(514, 'TIF', 'IF021', 'Pemrograman Visual 2', '', 3, '22', 2),
(515, 'TIF', 'IF022', 'Teori Graph', '', 3, '22', 1),
(516, 'TIF', 'IF-028', 'E-Commerce', '', 3, '22', 1),
(517, 'TIF', 'IF204', 'Game Development', '', 3, '22', 1),
(518, 'TIF', 'IF104', 'Secure Programming', '', 3, '22', 1),
(519, 'TIF', 'IF105', 'Database Security', '', 3, '22', 1),
(520, 'TIF', 'IFU08', 'Teknik Penulisan Laporan Ilmiah', '', 2, '22', 1),
(521, 'TIF', 'IF201', 'Manajemen Proyek Perangkat Lunak', '', 3, '22', 1),
(522, 'TIF', 'IF205', 'IT Project Manager', '', 3, '22', 1),
(523, 'TIF', 'TIF-0001', 'Pemodelan dan Simulasi', '', 2, '22', 1),
(562, 'TIF', 'IF001', 'Kalkulus 1', '', 3, '22', 1),
(563, 'TIF', 'IF002', 'Matematika Diskret', '', 3, '22', 1),
(564, 'TIF', 'IF007', 'Kalkulus II', '', 3, '22', 1),
(565, 'TIF', 'IF008', 'Logika Boolean', '', 2, '22', 1),
(566, 'TIF', 'IF010', 'Matriks & Vector', '', 3, '22', 1),
(567, 'TIF', 'IF009', 'Dasar Komputer', '', 2, '22', 1),
(568, 'TIF', 'IF031', 'Sistem Informasi Geografis', '', 3, '22', 1),
(569, 'TIF', 'IF024', 'Mobile Programming', '', 3, '22', 1),
(570, 'TIF', 'IF033', 'Sistem Informasi Enterprise', '', 3, '22', 1),
(571, 'TIF', 'TIF-004', 'Kewirausahaan', '', 2, '22', 1),
(572, 'TIF', 'TIF-005', 'Uji Kualitas Perangkat Lunak', '', 2, '22', 1),
(573, 'TIF', 'TIF-006', 'Pra Skripsi', '', 3, '22', 1),
(578, 'TIF', 'TIF-11111', 'Orkom & Arkom', '', 3, '22', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ms_mkuliah_take`
--

CREATE TABLE `ms_mkuliah_take` (
  `id` int(11) NOT NULL,
  `id_perwalian` int(11) NOT NULL,
  `id_kurikulum` int(11) NOT NULL,
  `sks` int(1) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `status_keuangan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ms_mkuliah_take`
--

INSERT INTO `ms_mkuliah_take` (`id`, `id_perwalian`, `id_kurikulum`, `sks`, `id_kelas`, `status_keuangan`) VALUES
(17408, 2112, 567, 5, 28, 1),
(17410, 2112, 744, 2, 28, 1),
(17411, 2112, 743, 2, 28, 1),
(17413, 2112, 665, 2, 28, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ms_perwalian`
--

CREATE TABLE `ms_perwalian` (
  `id` int(11) NOT NULL,
  `str_npm` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `str_semester` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kd_thn_ajaran` int(11) NOT NULL,
  `int_id_konsentrasi` int(11) NOT NULL,
  `st_disetujui` int(1) NOT NULL,
  `st_aktif` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ms_perwalian`
--

INSERT INTO `ms_perwalian` (`id`, `str_npm`, `str_semester`, `kd_thn_ajaran`, `int_id_konsentrasi`, `st_disetujui`, `st_aktif`) VALUES
(2112, '15111253', '8', 22, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ms_pokok_bahasan`
--

CREATE TABLE `ms_pokok_bahasan` (
  `id` int(10) NOT NULL,
  `kode_perkuliahan` int(10) NOT NULL,
  `npm_km` varchar(10) NOT NULL,
  `pertemuan` int(2) NOT NULL,
  `pokok_bahasan` text NOT NULL,
  `kesesuaian` int(1) NOT NULL,
  `keterangan` text NOT NULL,
  `id_koor` varchar(5) NOT NULL,
  `kesesuaian_koor` int(11) NOT NULL,
  `koor_tgl_assigment` date NOT NULL,
  `koor_img_assigment` text NOT NULL,
  `ket_koor` text NOT NULL,
  `id_kaprodi` varchar(5) NOT NULL,
  `kaprodi_tgl_assigment` date NOT NULL,
  `kaprodi_img_assigment` text NOT NULL,
  `ket_kaprodi` text NOT NULL,
  `id_pjm` varchar(5) NOT NULL,
  `pjm_tgl_assigment` date NOT NULL,
  `pjm_img_assigment` text NOT NULL,
  `ket_pjm` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_pokok_bahasan`
--

INSERT INTO `ms_pokok_bahasan` (`id`, `kode_perkuliahan`, `npm_km`, `pertemuan`, `pokok_bahasan`, `kesesuaian`, `keterangan`, `id_koor`, `kesesuaian_koor`, `koor_tgl_assigment`, `koor_img_assigment`, `ket_koor`, `id_kaprodi`, `kaprodi_tgl_assigment`, `kaprodi_img_assigment`, `ket_kaprodi`, `id_pjm`, `pjm_tgl_assigment`, `pjm_img_assigment`, `ket_pjm`) VALUES
(13899, 1875, '15111241', 2, 'Pertemuan 2', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(14031, 1875, '15111227', 1, 'Intro', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(14441, 1875, '15111227', 3, 'FL, SL', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(14982, 1875, '15111227', 4, 'Analisis fundamental', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(15667, 1875, '15111227', 5, 'Busines plan dsb', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(16393, 1875, '15111227', 6, 'Analisis Tugas', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', ''),
(17175, 1875, '15111227', 7, 'elearning', 0, '', '', 0, '0000-00-00', '', '', '', '0000-00-00', '', '', '', '0000-00-00', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `ms_user`
--

CREATE TABLE `ms_user` (
  `oid` int(11) NOT NULL,
  `str_reff` varchar(20) NOT NULL,
  `str_key` varchar(20) NOT NULL,
  `str_email` varchar(50) NOT NULL,
  `str_username` varchar(30) NOT NULL,
  `str_password` varchar(256) NOT NULL,
  `bol_status` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ms_user`
--

INSERT INTO `ms_user` (`oid`, `str_reff`, `str_key`, `str_email`, `str_username`, `str_password`, `bol_status`) VALUES
(4674, 'ms_mhs', '15111253', 'yogalistianto@gmail.com', 'yoga', 'pbkdf2:sha256:150000$zNo2sWY1$b559a6db50ec25e501b748f428c141fba5e0a648be56e63a07c3c5018f019575', '1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jadwal_perkuliahan`
--
ALTER TABLE `jadwal_perkuliahan`
  ADD PRIMARY KEY (`kode_perkuliahan`),
  ADD KEY `kode_matakuliah` (`str_kd_mk`),
  ADD KEY `kode_tahun_ajaran` (`kode_tahun_ajaran`),
  ADD KEY `kode_dosen` (`id_dosen`),
  ADD KEY `kode_ruangan` (`kode_ruangan`);

--
-- Indexes for table `ms_absensi`
--
ALTER TABLE `ms_absensi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_dosen`
--
ALTER TABLE `ms_dosen`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_kelas`
--
ALTER TABLE `ms_kelas`
  ADD PRIMARY KEY (`kode_kelas`);

--
-- Indexes for table `ms_kurikulum`
--
ALTER TABLE `ms_kurikulum`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_mhs`
--
ALTER TABLE `ms_mhs`
  ADD PRIMARY KEY (`oid`);

--
-- Indexes for table `ms_mkuliah`
--
ALTER TABLE `ms_mkuliah`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_mkuliah_take`
--
ALTER TABLE `ms_mkuliah_take`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_perwalian`
--
ALTER TABLE `ms_perwalian`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_pokok_bahasan`
--
ALTER TABLE `ms_pokok_bahasan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ms_user`
--
ALTER TABLE `ms_user`
  ADD PRIMARY KEY (`oid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal_perkuliahan`
--
ALTER TABLE `jadwal_perkuliahan`
  MODIFY `kode_perkuliahan` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2250;

--
-- AUTO_INCREMENT for table `ms_absensi`
--
ALTER TABLE `ms_absensi`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=439595;

--
-- AUTO_INCREMENT for table `ms_dosen`
--
ALTER TABLE `ms_dosen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=204;

--
-- AUTO_INCREMENT for table `ms_kelas`
--
ALTER TABLE `ms_kelas`
  MODIFY `kode_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=243;

--
-- AUTO_INCREMENT for table `ms_kurikulum`
--
ALTER TABLE `ms_kurikulum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=760;

--
-- AUTO_INCREMENT for table `ms_mhs`
--
ALTER TABLE `ms_mhs`
  MODIFY `oid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4836;

--
-- AUTO_INCREMENT for table `ms_mkuliah`
--
ALTER TABLE `ms_mkuliah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=584;

--
-- AUTO_INCREMENT for table `ms_mkuliah_take`
--
ALTER TABLE `ms_mkuliah_take`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23082;

--
-- AUTO_INCREMENT for table `ms_perwalian`
--
ALTER TABLE `ms_perwalian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2455;

--
-- AUTO_INCREMENT for table `ms_pokok_bahasan`
--
ALTER TABLE `ms_pokok_bahasan`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17627;

--
-- AUTO_INCREMENT for table `ms_user`
--
ALTER TABLE `ms_user`
  MODIFY `oid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4675;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
