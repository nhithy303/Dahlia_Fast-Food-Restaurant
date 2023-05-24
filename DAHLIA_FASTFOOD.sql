﻿CREATE DATABASE DAHLIA_FASTFOOD
GO
USE DAHLIA_FASTFOOD
GO
/***************************/
/****** CREATE TABLES ******/
/***************************/
CREATE TABLE PHANQUYEN
(
	MAPQ	VARCHAR(5)		NOT NULL,
	TENPQ	NVARCHAR(20)	NOT NULL,
	DAXOA	DATETIME		NULL,
	CONSTRAINT PK_PHANQUYEN PRIMARY KEY (MAPQ)
)
GO
CREATE TABLE TAIKHOAN
(
	MATK		INT IDENTITY(1,1)	NOT NULL,
	TENDANGNHAP	VARCHAR(20)			NOT NULL,
	MATKHAU		VARBINARY(MAX)		NOT NULL,
	SALT		UNIQUEIDENTIFIER	NOT NULL,
	PHANQUYEN	VARCHAR(5)			NOT NULL,
	DAXOA		DATETIME			NULL,
	CONSTRAINT PK_TAIKHOAN PRIMARY KEY (MATK),
	CONSTRAINT FK_TAIKHOAN_PHANQUYEN FOREIGN KEY (PHANQUYEN) REFERENCES PHANQUYEN(MAPQ)
)
GO
CREATE TABLE QUANLY
(
	MAQL		INT IDENTITY(1,1)	NOT NULL,
	MATK		INT					NULL,
	HOQL		NVARCHAR(50)		NOT NULL,
	TENQL		NVARCHAR(50)		NOT NULL,
	NGAYSINH	DATE				NOT NULL,
	GIOITINH	INT					NOT NULL,
	SDT			VARCHAR(15)			NOT NULL,
	DAXOA		DATETIME			NULL,
	CONSTRAINT PK_QUANLY PRIMARY KEY (MAQL),
	CONSTRAINT FK_QUANLY_TAIKHOAN FOREIGN KEY (MATK) REFERENCES TAIKHOAN(MATK),
	CONSTRAINT CK_QUANLY_NGAYSINH CHECK (YEAR(GETDATE()) - YEAR(NGAYSINH) >= 18),
	CONSTRAINT CK_QUANLY_GIOITINH CHECK (GIOITINH IN (1,2))
)
GO
CREATE TABLE PHANLOAINV
(
	MALOAI	INT IDENTITY(1,1)	NOT NULL,
	TENLOAI	NVARCHAR(20)		NOT NULL,
	DAXOA	DATETIME			NULL,
	CONSTRAINT PK_PHANLOAINV PRIMARY KEY (MALOAI),
)
GO
CREATE TABLE NHANVIEN
(
	MANV		INT IDENTITY(1,1)		NOT NULL,
	MATK		INT						NULL,
	HONV		NVARCHAR(50)			NOT NULL,
	TENNV		NVARCHAR(10)			NOT NULL,
	NGAYSINH	DATE					NOT NULL,
	GIOITINH	INT						NOT NULL,
	SDT			VARCHAR(15)				NOT NULL,
	DIACHI		NVARCHAR(200)			NOT NULL,
	MALOAI		INT						NOT NULL,
	NGAYVAOLAM	DATE DEFAULT GETDATE()	NOT NULL,
	DAXOA		DATETIME				NULL,
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV),
	CONSTRAINT FK_NHANVIEN_TAIKHOAN FOREIGN KEY (MATK) REFERENCES TAIKHOAN(MATK),
	CONSTRAINT FK_NHANVIEN_PHANLOAINV FOREIGN KEY (MALOAI) REFERENCES PHANLOAINV(MALOAI),
	CONSTRAINT CK_NHANVIEN_NGAYSINH CHECK (YEAR(GETDATE()) - YEAR(NGAYSINH) >= 18),
	CONSTRAINT CK_NHANVIEN_GIOITINH CHECK (GIOITINH IN (1,2))
)
GO
CREATE TABLE PHANLOAITD
(
	MALOAI	INT IDENTITY(1,1)	NOT NULL,
	TENLOAI	NVARCHAR(50)		NOT NULL,
	DAXOA	DATETIME			NULL,
	CONSTRAINT PK_PHANLOAITD PRIMARY KEY (MALOAI)
)
GO
CREATE TABLE THUCDON
(
	MAMON	INT IDENTITY(1,1)	NOT NULL,
	MALOAI	INT					NOT NULL,
	TENMON	NVARCHAR(100)		NOT NULL,
	ANHMON	VARCHAR(MAX)		NOT NULL,
	GIAGOC	INT DEFAULT 0		NOT NULL,
	GIABAN	INT DEFAULT 0		NOT NULL,
	DAXOA	DATETIME			NULL,
	CONSTRAINT PK_THUCDON PRIMARY KEY (MAMON),
	CONSTRAINT FK_THUCDON_PHANLOAITD FOREIGN KEY (MALOAI) REFERENCES PHANLOAITD(MALOAI)
)
GO
CREATE TABLE DONVITINH
(
	MADVT	INT IDENTITY(1,1)	NOT NULL,
	TENDVT	NVARCHAR(50)		NOT NULL,
	CONSTRAINT PK_DONVITINH PRIMARY KEY (MADVT)
)
GO
CREATE TABLE NGUYENLIEU
(
	MANL		INT IDENTITY(1,1)	NOT NULL,
	TENNL		NVARCHAR(50)		NOT NULL,
	TONKHO		INT DEFAULT 0		NOT NULL,
	DONVITINH	INT					NOT NULL,
	DONGIA		INT DEFAULT 0		NOT NULL,
	CONSTRAINT PK_NGUYENLIEU PRIMARY KEY (MANL),
	CONSTRAINT FK_NGUYENLIEU_DONVITINH FOREIGN KEY (DONVITINH) REFERENCES DONVITINH(MADVT)
)
GO
CREATE TABLE CONGTHUC
(
	MAMON		INT				NOT NULL,
	MANL		INT				NOT NULL,
	SOLUONG		INT DEFAULT 0	NOT NULL,
	DONVITINH	INT				NOT NULL,
	GIANL		INT DEFAULT 0	NOT NULL,
	CONSTRAINT PK_CONGTHUC PRIMARY KEY (MAMON, MANL),
	CONSTRAINT FK_CONGTHUC_THUCDON FOREIGN KEY (MAMON) REFERENCES THUCDON(MAMON),
	CONSTRAINT FK_CONGTHUC_NGUYENLIEU FOREIGN KEY (MANL) REFERENCES NGUYENLIEU(MANL),
	CONSTRAINT FK_CONGTHUC_DONVITINH FOREIGN KEY (DONVITINH) REFERENCES DONVITINH(MADVT),
	CONSTRAINT CK_CONGTHUC_SOLUONG CHECK (SOLUONG >= 0)
)
GO
CREATE TABLE HINHTHUCTHANHTOAN
(
	MAHTTT	INT IDENTITY(1,1)	NOT NULL,
	TENHTTT	NVARCHAR(50)		NOT NULL,
	DAXOA	DATETIME			NULL,
	CONSTRAINT PK_HINHTHUCTHANHTOAN PRIMARY KEY (MAHTTT)
)
GO
CREATE TABLE TRANGTHAIDONHANG
(
	MATT	INT IDENTITY(1,1)	NOT NULL,
	TENTT	NVARCHAR(50)		NOT NULL,
	DAXOA	DATETIME			NULL,
	CONSTRAINT PK_TRANGTHAIDONHANG PRIMARY KEY (MATT)
)
GO
CREATE TABLE HOADONBANHANG
(
	MAHD		INT IDENTITY(1,1)		NOT NULL,
	MANV		INT						NOT NULL,
	NGAYHD		DATE DEFAULT GETDATE()	NOT NULL,
	TONGTIEN	INT DEFAULT 0			NOT NULL,
	THANHTOAN	INT						NOT NULL,
	TRANGTHAI	INT						NOT NULL,
	CONSTRAINT PK_HOADONBANHANG PRIMARY KEY (MAHD),
	CONSTRAINT FK_HOADONBANHANG_NHANVIEN FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_HOADONBANHANG_HINHTHUCTHANHTOAN FOREIGN KEY (THANHTOAN) REFERENCES HINHTHUCTHANHTOAN(MAHTTT),
	CONSTRAINT FK_HOADONBANHANG_TRANGTHAIDONHANG FOREIGN KEY (TRANGTHAI) REFERENCES TRANGTHAIDONHANG(MATT)
)
GO
CREATE TABLE CHITIETHDBH
(
	MAHD		INT				NOT NULL,
	MAMON		INT				NOT NULL,
	SOLUONG		INT DEFAULT 0	NOT NULL,
	DONGIA		INT DEFAULT 0	NOT NULL,
	THANHTIEN	AS CONVERT(INT, SOLUONG * DONGIA) PERSISTED,
	CONSTRAINT PK_CHITIETHDBH PRIMARY KEY (MAHD, MAMON),
	CONSTRAINT FK_CHITIETHDBH_HOADONBANHANG FOREIGN KEY (MAHD) REFERENCES HOADONBANHANG(MAHD),
	CONSTRAINT FK_CHITIETHDBH_THUCDON FOREIGN KEY (MAMON) REFERENCES THUCDON(MAMON),
	CONSTRAINT CK_CHITIETHDBH_SOLUONG CHECK (SOLUONG >= 0)
)
GO
CREATE TABLE THAMSO
(
	TENTS	VARCHAR(50)		NOT NULL,
	GIATRI	INT				NOT NULL,
	MOTA	NVARCHAR(200)	NULL,
	CONSTRAINT PK_THAMSO PRIMARY KEY (TENTS)
)
GO
/**************************************/
/****** CREATE STORED PROCEDURES ******/
/**************************************/
--- spPHANQUYEN ---
CREATE PROCEDURE spPHANQUYEN
(
	@MaPQ		VARCHAR(5)		= NULL,
	@TenPQ		NVARCHAR(20)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAPQ, TENPQ FROM PHANQUYEN
			WHERE DAXOA IS NULL AND MAPQ = (CASE WHEN @MaPQ <> '' THEN @MaPQ ELSE MAPQ END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO PHANQUYEN(MAPQ, TENPQ) VALUES (@MaPQ, @TenPQ)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE PHANQUYEN SET TENPQ = @TenPQ WHERE MAPQ = @MaPQ
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE PHANQUYEN SET DAXOA = GETDATE() WHERE MAPQ = @MaPQ
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE PHANQUYEN SET DAXOA = NULL WHERE MAPQ = @MaPQ
		END
END
GO
--- spTAIKHOAN ----
CREATE PROCEDURE spTAIKHOAN
(
	@MaTK			INT			= NULL,
	@TenDangNhap	VARCHAR(20)	= NULL,
	@MatKhau		VARCHAR(20)	= NULL,
	@PhanQuyen		VARCHAR(5)	= NULL,
	@ActionType		VARCHAR(50)
)
AS
BEGIN
	DECLARE @Salt UNIQUEIDENTIFIER = NEWID()
	IF @ActionType = 'Select'
		BEGIN
			SELECT MATK, TENDANGNHAP, MATKHAU, PHANQUYEN FROM TAIKHOAN
			WHERE DAXOA IS NULL
				AND MATK = (CASE WHEN @MaTK <> 0 THEN @MaTK ELSE MATK END)
				AND TENDANGNHAP = (CASE WHEN @TenDangNhap <> '' THEN @TenDangNhap ELSE TENDANGNHAP END)
				AND MATKHAU = (CASE
					WHEN @MatKhau <> ''
					THEN HASHBYTES('SHA2_512', @MatKhau + CAST(SALT AS VARCHAR(36)))
					ELSE MATKHAU END)
				AND PHANQUYEN = (CASE WHEN @PhanQuyen <> '' THEN @PhanQuyen ELSE PHANQUYEN END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO TAIKHOAN(TENDANGNHAP, MATKHAU, PHANQUYEN, SALT) VALUES (
				CONVERT(VARCHAR(20), CONCAT(@PhanQuyen,
				(CASE WHEN @PhanQuyen = 'NV'
					THEN (SELECT MAX(MANV) FROM NHANVIEN)
					ELSE (SELECT MAX(MAQL) FROM QUANLY)
				END))),
				HASHBYTES('SHA2_512', 'dahliaffr47' + CAST(@Salt AS VARCHAR(36))), @PhanQuyen, @Salt)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE TAIKHOAN
			SET MATKHAU = HASHBYTES('SHA2_512', @MatKhau + CAST(SALT AS VARCHAR(36)))
			WHERE MATK = @MaTK
		END
	IF @ActionType = 'ResetPassword'
		BEGIN
			UPDATE TAIKHOAN
			SET MATKHAU = HASHBYTES('SHA2_512', 'dahliaffr47' + CAST(SALT AS VARCHAR(36)))
			WHERE MATK = @MaTK
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE TAIKHOAN SET DAXOA = GETDATE() WHERE MATK = @MaTK
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE TAIKHOAN SET DAXOA = NULL WHERE MATK = @MaTK
		END
END
GO
--- spQUANLY ---
CREATE PROCEDURE spQUANLY
(
	@MaQL		INT				= NULL,
	@MaTK		INT				= NULL,
	@HoQL		NVARCHAR(50)	= NULL,
	@TenQL		NVARCHAR(10)	= NULL,
	@NgaySinh	DATE			= NULL,
	@GioiTinh	INT				= NULL,
	@Sdt		VARCHAR(15)		= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAQL, MATK, HOQL, TENQL, NGAYSINH, GIOITINH, SDT FROM QUANLY
			WHERE DAXOA IS NULL
				AND MAQL = (CASE WHEN @MaQL <> 0 THEN @MaQL ELSE MAQL END)
				AND MATK = (CASE WHEN @MaTK <> 0 THEN @MaTK ELSE MATK END)
				AND GIOITINH = (CASE WHEN @GioiTinh <> 0 THEN @GioiTinh ELSE GIOITINH END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO QUANLY(HOQL, TENQL, NGAYSINH, GIOITINH, SDT) VALUES
				(@HoQL, @TenQL, @NgaySinh, @GioiTinh, @Sdt)
			EXEC spTAIKHOAN @ActionType = 'Create', @PhanQuyen = 'QL'
			---Add account---
			UPDATE QUANLY
			SET MATK = (SELECT MAX(MATK) FROM TAIKHOAN)
			WHERE MAQL = (SELECT MAX(MAQL) FROM QUANLY)
			-----------------
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE QUANLY
			SET HOQL = @HoQL, TENQL = @TenQL, NGAYSINH = @NgaySinh, GIOITINH = @GioiTinh, SDT = @Sdt
			WHERE MAQL = @MaQL
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE QUANLY SET DAXOA = GETDATE() WHERE MAQL = @MaQL
			EXEC spTAIKHOAN @ActionType = 'Delete', @MaTK = @MaTK
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE QUANLY SET DAXOA = NULL WHERE MAQL = @MaQL
			EXEC spTAIKHOAN @ActionType = 'Restore', @MaTK = @MaTK
		END
END
GO
--- spPHANLOAINV ---
CREATE PROCEDURE spPHANLOAINV
(
	@MaLoai		INT				= NULL,
	@TenLoai	NVARCHAR(20)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MALOAI, TENLOAI FROM PHANLOAINV
			WHERE DAXOA IS NULL AND MALOAI = (CASE WHEN @MaLoai <> 0 THEN @MaLoai ELSE MALOAI END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO PHANLOAINV(TENLOAI) VALUES (@TenLoai)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE PHANLOAINV SET TENLOAI = @TenLoai WHERE MALOAI = @MaLoai
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE PHANLOAINV SET DAXOA = GETDATE() WHERE MALOAI = @MaLoai
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE PHANLOAINV SET DAXOA = NULL WHERE MALOAI = @MaLoai
		END
END
GO
--- spNHANVIEN ---
CREATE PROCEDURE spNHANVIEN
(
	@MaNV		INT				= NULL,
	@MaTK		INT				= NULL,
	@HoNV		NVARCHAR(50)	= NULL,
	@TenNV		NVARCHAR(10)	= NULL,
	@NgaySinh	DATE			= NULL,
	@GioiTinh	INT				= NULL,
	@Sdt		VARCHAR(15)		= NULL,
	@DiaChi		NVARCHAR(200)	= NULL,
	@MaLoai		INT				= NULL,
	@NgayVaoLam	DATE			= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MANV, MATK, HONV, TENNV, NGAYSINH, GIOITINH, SDT, DIACHI, MALOAI, NGAYVAOLAM FROM NHANVIEN
			WHERE DAXOA IS NULL
				AND MANV = (CASE WHEN @MaNV <> 0 THEN @MaNV ELSE MANV END)
				AND MATK = (CASE WHEN @MaTK <> 0 THEN @MaTK ELSE MATK END)
				AND GIOITINH = (CASE WHEN @GioiTinh <> 0 THEN @GioiTinh ELSE GIOITINH END)
				AND MALOAI = (CASE WHEN @MaLoai <> 0 THEN @MaLoai ELSE MALOAI END)
				AND NGAYVAOLAM = (CASE WHEN @NgayVaoLam IS NOT NULL THEN @NgayVaoLam ELSE NGAYVAOLAM END)
		END
	IF @ActionType = 'GetFullName'
		BEGIN
			SELECT MANV, HONV + ' ' + TENNV AS HOTEN FROM NHANVIEN WHERE DAXOA IS NULL ORDER BY TENNV
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO NHANVIEN(HONV, TENNV, NGAYSINH, GIOITINH, SDT, DIACHI, MALOAI, NGAYVAOLAM) VALUES
				(@HoNV, @TenNV, @NgaySinh, @GioiTinh, @Sdt, @DiaChi, @MaLoai, @NgayVaoLam)
			EXEC spTAIKHOAN @ActionType = 'Create', @PhanQuyen = 'NV'
			---Add account---
			UPDATE NHANVIEN
			SET MATK = (SELECT MAX(MATK) FROM TAIKHOAN)
			WHERE MANV = (SELECT MAX(MANV) FROM NHANVIEN)
			-----------------
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE NHANVIEN
			SET HONV = @HoNV, TENNV = @TenNV, NGAYSINH = @NgaySinh, GIOITINH = @GioiTinh, SDT = @Sdt, DIACHI = @DiaChi, MALOAI = @MaLoai
			WHERE MANV = @MaNV
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE NHANVIEN SET DAXOA = GETDATE() WHERE MANV = @MaNV
			EXEC spTAIKHOAN @ActionType = 'Delete', @MaTK = @MaTK
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE NHANVIEN SET DAXOA = NULL WHERE MANV = @MaNV
			EXEC spTAIKHOAN @ActionType = 'Restore', @MaTK = @MaTK
		END
END
GO
--- spPHANLOAITD ---
CREATE PROCEDURE spPHANLOAITD
(
	@MaLoai		INT				= NULL,
	@TenLoai	NVARCHAR(50)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MALOAI, TENLOAI FROM PHANLOAITD
			WHERE DAXOA IS NULL
				AND MALOAI = (CASE WHEN @MaLoai <> 0 THEN @MaLoai ELSE MALOAI END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO PHANLOAITD(TENLOAI) VALUES (@TenLoai)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE PHANLOAITD SET TENLOAI = @TenLoai WHERE MALOAI = @MaLoai
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE PHANLOAITD SET DAXOA = GETDATE() WHERE MALOAI = @MaLoai
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE PHANLOAITD SET DAXOA = NULL WHERE MALOAI = @MaLoai
		END
END
GO
--- spTHUCDON ---
CREATE PROCEDURE spTHUCDON
(
	@MaMon		INT				= NULL,
	@MaLoai		INT				= NULL,
	@TenMon		NVARCHAR(100)	= NULL,
	@AnhMon		VARCHAR(MAX)	= NULL,
	@GiaGoc		INT				= NULL,
	@GiaBan		INT				= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAMON, MALOAI, TENMON, ANHMON, GIAGOC, GIABAN FROM THUCDON
			WHERE DAXOA IS NULL
				AND MAMON = (CASE WHEN @MaMon <> 0 THEN @MaMon ELSE MAMON END)
				AND MALOAI = (CASE WHEN @MaLoai <> 0 THEN @MaLoai ELSE MALOAI END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO THUCDON(MALOAI, TENMON, ANHMON, GIABAN) VALUES
				(@MaLoai, @TenMon, @AnhMon, @GiaBan)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE THUCDON
			SET MALOAI = @MaLoai, TENMON = @TenMon, ANHMON = @AnhMon, GIAGOC = @GiaGoc, GIABAN = @GiaBan
			WHERE MAMON = @MaMon
		END
	IF @ActionType = 'UpdateOriginalPrice'
		BEGIN
			UPDATE THUCDON
			SET GIAGOC = (SELECT SUM(GIANL) FROM CONGTHUC WHERE MAMON = @MaMon)
			WHERE MAMON = @MaMon
			EXEC spTHUCDON @ActionType = 'UpdateSellingPrice', @Mamon = @Mamon
		END
	IF @ActionType = 'UpdateSellingPrice'
		BEGIN
			UPDATE THUCDON
			SET GIABAN = ROUND(GIAGOC * (100 + (SELECT MAX(GIATRI) FROM THAMSO WHERE TENTS = 'ProfitMargin')) / 100, -3)
			WHERE MAMON = @MaMon
		END
	IF @ActionType = 'UpdateAllSellingPrice'
		BEGIN
			UPDATE THUCDON
			SET GIABAN = ROUND(GIAGOC * (100 + (SELECT MAX(GIATRI) FROM THAMSO WHERE TENTS = 'ProfitMargin')) / 100, -3)
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE THUCDON SET DAXOA = GETDATE() WHERE MAMON = @MaMon
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE THUCDON SET DAXOA = NULL WHERE MAMON = @MaMon
		END
END
GO
--- spDONVITINH ---
CREATE PROCEDURE spDONVITINH
(
	@MaDVT		INT				= NULL,
	@TenDVT		NVARCHAR(50)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MADVT, TENDVT FROM DONVITINH
			WHERE MADVT = (CASE WHEN @MaDVT <> 0 THEN @MaDVT ELSE MADVT END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO DONVITINH(TENDVT) VALUES (@TenDVT)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE DONVITINH SET TENDVT = @TenDVT WHERE MADVT = @MaDVT
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM DONVITINH WHERE MADVT = @MaDVT
		END
END
GO
--- spCONGTHUC ---
CREATE PROCEDURE spCONGTHUC
(
	@MaMon		INT	= NULL,
	@MaNL		INT	= NULL,
	@SoLuong	INT	= NULL,
	@DonViTinh	INT	= NULL,
	@GiaNL		INT	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAMON, MANL, SOLUONG, DONVITINH, GIANL FROM CONGTHUC
			WHERE MAMON = (CASE WHEN @MaMon <> 0 THEN @MaMon ELSE MAMON END)
				AND MANL = (CASE WHEN @MaNL <> 0 THEN @MaNL ELSE MANL END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO CONGTHUC(MAMON, MANL, SOLUONG, DONVITINH, GIANL) VALUES
				(@MaMon, @MaNL, @SoLuong, @DonViTinh, @GiaNL)
			EXEC spTHUCDON @ActionType = 'UpdateOriginalPrice', @MaMon = @MaMon
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE CONGTHUC
			SET SOLUONG = @SoLuong, DONVITINH = @DonViTinh, GIANL = @GiaNL
			WHERE MAMON = @MaMon AND MANL = @MaNL
			EXEC spTHUCDON @ActionType = 'UpdateOriginalPrice', @MaMon = @MaMon
		END
	IF @ActionType = 'UpdateIngredientPrice'
		BEGIN
			UPDATE CONGTHUC
			SET GIANL = @GiaNL * SOLUONG
			WHERE MANL = @MaNL
			EXEC spTHUCDON @ActionType = 'UpdateOriginalPrice', @MaMon = @MaMon
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM CONGTHUC
			WHERE MAMON = @MaMon AND MANL = @MaNL
			EXEC spTHUCDON @ActionType = 'UpdateOriginalPrice', @MaMon = @MaMon
		END
END
GO
--- spNGUYENLIEU ---
CREATE PROCEDURE spNGUYENLIEU
(
	@MaNL		INT				= NULL,
	@TenNL		NVARCHAR(50)	= NULL,
	@TonKho		INT				= NULL,
	@DonViTinh	INT				= NULL,
	@DonGia		INT				= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MANL, TENNL, TONKHO, DONVITINH, DONGIA FROM NGUYENLIEU
			WHERE MANL = (CASE WHEN @MaNL <> 0 THEN @MaNL ELSE MANL END)
			ORDER BY TENNL
		END
	IF @ActionType = 'GetUnitPrice'
		BEGIN
			SELECT TOP 1 DONGIA FROM NGUYENLIEU WHERE MANL = @MaNL
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO NGUYENLIEU(TENNL, DONVITINH, TONKHO, DONGIA) VALUES (@TenNL, @DonViTinh, @TonKho, @DonGia)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE NGUYENLIEU
			SET TENNL = @TenNL, TONKHO = @TonKho, DONVITINH = @DonViTinh, DONGIA = @DonGia WHERE MANL = @MaNL
			EXEC spCONGTHUC @ActionType = 'UpdateIngredientPrice', @MaNL = @MaNL, @GiaNL = @DonGia
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM NGUYENLIEU WHERE MANL = @MaNL
		END
END
GO
--- spHINHTHUCTHANHTOAN ---
CREATE PROCEDURE spHINHTHUCTHANHTOAN
(
	@MaHTTT		INT				= NULL,
	@TenHTTT	NVARCHAR(50)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAHTTT, TENHTTT FROM HINHTHUCTHANHTOAN
			WHERE DAXOA IS NULL AND MAHTTT = (CASE WHEN @MaHTTT <> 0 THEN @MaHTTT ELSE MAHTTT END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO HINHTHUCTHANHTOAN(TENHTTT) VALUES (@TenHTTT)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE HINHTHUCTHANHTOAN SET TENHTTT = @TenHTTT WHERE MAHTTT = @MaHTTT
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE HINHTHUCTHANHTOAN SET DAXOA = GETDATE() WHERE MAHTTT = @MaHTTT
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE HINHTHUCTHANHTOAN SET DAXOA = NULL WHERE MAHTTT = @MaHTTT
		END
END
GO
--- spTRANGTHAIDONHANG ---
CREATE PROCEDURE spTRANGTHAIDONHANG
(
	@MaTT		INT				= NULL,
	@TenTT		NVARCHAR(50)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MATT, TENTT FROM TRANGTHAIDONHANG
			WHERE DAXOA IS NULL
				AND MATT = (CASE WHEN @MaTT <> 0 THEN @MaTT ELSE MATT END)
				AND TENTT = (CASE WHEN @TenTT <> '' THEN @TenTT ELSE TENTT END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO TRANGTHAIDONHANG(TENTT) VALUES (@TenTT)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE TRANGTHAIDONHANG SET TENTT = @TenTT WHERE MATT = @MaTT
		END
	IF @ActionType = 'Delete'
		BEGIN
			UPDATE TRANGTHAIDONHANG SET DAXOA = GETDATE() WHERE MATT = @MaTT
		END
	IF @ActionType = 'Restore'
		BEGIN
			UPDATE TRANGTHAIDONHANG SET DAXOA = NULL WHERE MATT = @MaTT
		END
END
GO
--- spHOADONBANHANG ---
CREATE PROCEDURE spHOADONBANHANG
(
	@MaHD		INT			= NULL,
	@MaNV		INT			= NULL,
	@NgayHD		DATE		= NULL,
	@TongTien	INT			= NULL,
	@ThanhToan	VARCHAR(20)	= NULL,
	@TrangThai	VARCHAR(20)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAHD, MANV, NGAYHD, TONGTIEN, THANHTOAN, TRANGTHAI FROM HOADONBANHANG
			WHERE MAHD = (CASE WHEN @MaHD <> 0 THEN @MaHD ELSE MAHD END)
				AND MANV = (CASE WHEN @MaNV <> 0 THEN @MaNV ELSE MANV END)
				AND NGAYHD = (CASE WHEN @NgayHD <> '' THEN @NgayHD ELSE NGAYHD END)
				AND THANHTOAN = (CASE WHEN @ThanhToan <> 0 THEN @ThanhToan ELSE THANHTOAN END)
				AND TRANGTHAI = (CASE WHEN @TrangThai <> 0 THEN @TrangThai ELSE TRANGTHAI END)
		END
	IF @ActionType = 'GetLatest'
		BEGIN
			SELECT MAX(MAHD) FROM HOADONBANHANG
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO HOADONBANHANG(MANV, THANHTOAN, TRANGTHAI) VALUES
				(@MaNV, @ThanhToan, 1)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE HOADONBANHANG
			SET TONGTIEN = @TongTien, THANHTOAN = @ThanhToan, TRANGTHAI = @TrangThai
			WHERE MAHD = @MaHD
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM HOADONBANHANG WHERE MAHD = @MaHD
		END
END
GO
--- spCHITIETHDBH ---
CREATE PROCEDURE spCHITIETHDBH
(
	@MaHD		INT	= NULL,
	@MaMon		INT	= NULL,
	@SoLuong	INT	= NULL,
	@DonGia		INT	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT MAHD, MAMON, SOLUONG, DONGIA, THANHTIEN FROM CHITIETHDBH
			WHERE MAHD = (CASE WHEN @MaHD <> 0 THEN @MaHD ELSE MAHD END)
				AND MAMON = (CASE WHEN @MaMon <> 0 THEN @MaMon ELSE MAMON END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO CHITIETHDBH(MAHD, MAMON, SOLUONG, DONGIA) VALUES
				(@MaHD, @MaMon, @SoLuong, @DonGia)
			---Subtract amount of ingredient after selling dishes---
			--UPDATE NGUYENLIEU
			--SET TONKHO = TONKHO - (@SoLuong * (SELECT TOP 1 SOLUONG FROM CONGTHUC WHERE MAMON = @MaMon AND MANL = MANL))
			--WHERE MANL IN (SELECT MANL FROM CONGTHUC WHERE MAMON = @MaMon)
			--------------------------------------------------------
			---Update total price of this invoice---
			UPDATE HOADONBANHANG
			SET TONGTIEN = TONGTIEN + @SoLuong * @DonGia
			WHERE MAHD = @MaHD
			----------------------------------------
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE CHITIETHDBH
			SET SOLUONG = @SoLuong, DONGIA = @DonGia
			WHERE MAHD = @MaHD AND MAMON = @MaMon
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM CHITIETHDBH
			WHERE MAHD = @MaHD AND MAMON = @MaMon
		END
END
GO
--- spTHAMSO ---
CREATE PROCEDURE spTHAMSO
(
	@TenTS		VARCHAR(50)		= NULL,
	@GiaTri		INT				= NULL,
	@MoTa		NVARCHAR(200)	= NULL,
	@ActionType	VARCHAR(50)
)
AS
BEGIN
	IF @ActionType = 'Select'
		BEGIN
			SELECT * FROM THAMSO
			WHERE TENTS = (CASE WHEN @TenTS <> '' THEN @TenTS ELSE TENTS END)
		END
	IF @ActionType = 'Create'
		BEGIN
			INSERT INTO THAMSO(TENTS, GIATRI, MOTA) VALUES (@TenTS, @GiaTri, @MoTa)
		END
	IF @ActionType = 'Update'
		BEGIN
			UPDATE THAMSO
			SET	GIATRI = (CASE WHEN @GiaTri <> 0 THEN @GiaTri ELSE GIATRI END),
				MOTA = (CASE WHEN @MoTa <> '' THEN @MoTa ELSE MOTA END)
			WHERE TENTS = @TenTS
			IF @TenTS = 'ProfitMargin'
				BEGIN
					EXEC spTHUCDON @ActionType = 'UpdateAllSellingPrice'
				END
		END
	IF @ActionType = 'Delete'
		BEGIN
			DELETE FROM THAMSO WHERE TENTS = @TenTS
		END
END
GO
/*****************************/
/****** INITIALIZE DATA ******/
/*****************************/
--- PHANQUYEN ---
EXEC spPHANQUYEN @ActionType = 'Create', @MaPQ = 'QL', @TenPQ = N'Quản lý'
GO
EXEC spPHANQUYEN @ActionType = 'Create', @MaPQ = 'NV', @TenPQ = N'Nhân viên'
GO
--- PHANLOAINV ---
EXEC spPHANLOAINV @ActionType = 'Create', @TenLoai = N'Full-time'
GO
EXEC spPHANLOAINV @ActionType = 'Create', @TenLoai = N'Part-time'
GO
--- QUANLY ---
EXEC spQUANLY @ActionType = 'Create',
	@HoQL		= N'Trần Hoàng Yến',
	@TenQL		= N'Nhi',
	@NgaySinh	= '2001-03-30',
	@GioiTinh	= 1,
	@Sdt		= '0833336067'
GO
EXEC spQUANLY @ActionType = 'Create',
	@HoQL		= N'Hoàng Thụy Quỳnh',
	@TenQL		= N'Hương',
	@NgaySinh	= '2003-05-01',
	@GioiTinh	= 1,
	@Sdt		= '0897654321'
GO
EXEC spQUANLY @ActionType = 'Create',
	@HoQL		= N'Ngô Thị Yến',
	@TenQL		= N'Linh',
	@NgaySinh	= '2003-08-17',
	@GioiTinh	= 1,
	@Sdt		= '0812345679'
GO
--- HINHTHUCTHANHTOAN ---
EXEC spHINHTHUCTHANHTOAN @ActionType = 'Create', @TenHTTT = N'Tiền mặt'
GO
EXEC spHINHTHUCTHANHTOAN @ActionType = 'Create', @TenHTTT = N'Chuyển khoản'
GO
EXEC spHINHTHUCTHANHTOAN @ActionType = 'Create', @TenHTTT = N'MoMo'
GO
EXEC spHINHTHUCTHANHTOAN @ActionType = 'Create', @TenHTTT = N'ZaloPay'
GO
EXEC spHINHTHUCTHANHTOAN @ActionType = 'Create', @TenHTTT = N'Thẻ ATM'
GO
--- TRANGTHAIDONHANG ---
EXEC spTRANGTHAIDONHANG @ActionType = 'Create', @TenTT = N'Chờ phục vụ'
GO
EXEC spTRANGTHAIDONHANG @ActionType = 'Create', @TenTT = N'Hoàn thành'
GO
--- DONVITINH ---
EXEC spDONVITINH @ActionType = 'Create', @TenDVT = N'Gram'
GO
EXEC spDONVITINH @ActionType = 'Create', @TenDVT = N'Miếng'
GO
EXEC spDONVITINH @ActionType = 'Create', @TenDVT = N'Chai'
GO
EXEC spDONVITINH @ActionType = 'Create', @TenDVT = N'Quả'
GO
--- THAMSO ---
EXEC spTHAMSO @ActionType = 'Create', @TenTS = 'MenuColumns', @GiaTri = 3, @MoTa = N'Số cột hiển thị của thực đơn'
GO
EXEC spTHAMSO @ActionType = 'Create', @TenTS = 'ProfitMargin', @GiaTri = 20, @MoTa = N'Phần trăm lợi nhuận chỉ tiêu'
GO
