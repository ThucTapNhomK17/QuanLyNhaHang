USE [master]
GO
/****** Object:  Database [QUANLYNHAHANG]    Script Date: 29/06/2021 11:24:19 SA ******/
CREATE DATABASE [QUANLYNHAHANG]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QUANLYNHAHANG', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\QUANLYNHAHANG.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QUANLYNHAHANG_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\QUANLYNHAHANG_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [QUANLYNHAHANG] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QUANLYNHAHANG].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QUANLYNHAHANG] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ARITHABORT OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QUANLYNHAHANG] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYNHAHANG] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QUANLYNHAHANG] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QUANLYNHAHANG] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QUANLYNHAHANG] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QUANLYNHAHANG] SET  MULTI_USER 
GO
ALTER DATABASE [QUANLYNHAHANG] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QUANLYNHAHANG] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QUANLYNHAHANG] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QUANLYNHAHANG] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QUANLYNHAHANG] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QUANLYNHAHANG] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [QUANLYNHAHANG] SET QUERY_STORE = OFF
GO
USE [QUANLYNHAHANG]
GO
/****** Object:  UserDefinedFunction [dbo].[Ngay]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Ngay](@index int)
returns @ngay table(ngay date)
as
begin
	declare @ngaydau date
	declare @ngaycuoi date

	if(@index = 0)
	begin
		set @ngaydau = DATEADD(day, -7, CAST(GETDATE() AS date))
		set @ngaycuoi = CAST(GETDATE()-1 AS date)
	end

	else if (@index = 1)
	begin
		set @ngaydau = DATEADD(day, -1, CONVERT(date, getdate()))
		set @ngaycuoi = DATEADD(day, -1, CONVERT(date, getdate()))
	end

	else if (@index = 2)
	begin
		set @ngaydau = CONVERT(date, getdate())
		set @ngaycuoi = CONVERT(date, getdate())
	end

	else if (@index = 3)
	begin
		set @ngaydau = CONVERT(date, dateadd(d, -(day(getdate() - 1)), getdate()))
		set @ngaycuoi = convert(date, getdate())
	end

	else if (@index = 4)
	begin
		set @ngaydau = CONVERT(date, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0))
		set @ngaycuoi = CONVERT(date, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) - 1, -1))
	end

	while (@ngaydau <= @ngaycuoi)
		begin
			insert into @ngay values (@ngaydau)
			set @ngaydau = DATEADD(day, 1, @ngaydau)
		end
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMAHOADON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[TAOMAHOADON]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAHD VARCHAR(10)
DECLARE @MAXMAHD VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMAHD = MAX(MAHD) FROM HOADON
IF EXISTS (SELECT MAHD FROM HOADON)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAHD, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAHD = 'HD00' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MAHD = 'HD0' + CONVERT (VARCHAR(2), @MAX)
RETURN @MAHD
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMAKH]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[TAOMAKH]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAKH VARCHAR(10)
DECLARE @MAXMAKH VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMAKH = MAX(MAKH) FROM KHACHHANG
IF EXISTS (SELECT MAKH FROM KHACHHANG)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAKH, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAKH = 'KH00' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MAKH = 'KH0' + CONVERT (VARCHAR(2), @MAX)
RETURN @MAKH
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMAKM]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TAOMAKM]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAKM VARCHAR(10)
DECLARE @MAXMAKM VARCHAR(10)
DECLARE @MAX INT
SELECT  @MAXMAKM = MAX(MAKM) FROM KHUYENMAI
IF EXISTS (SELECT MAKM FROM KHUYENMAI)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAKM, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAKM = 'KM00' + CONVERT (VARCHAR(1), @MAX)
ELSE IF (@MAX < 100) SET @MAKM = 'KM0' + CONVERT (VARCHAR(2), @MAX)
ELSE IF (@MAX < 1000) SET @MAKM = 'KM' + CONVERT (VARCHAR(3), @MAX)
RETURN @MAKM
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMALOAIMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TAOMALOAIMON]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MALM VARCHAR(10)
DECLARE @MAXMALM VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMALM = MAX(MALOAI) FROM LOAIMON
IF EXISTS (SELECT MALOAI FROM LOAIMON)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMALM, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MALM = 'LM0' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MALM = 'LM' + CONVERT (VARCHAR(2), @MAX)
RETURN @MALM
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMAMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- TU TAO MA MON
CREATE FUNCTION [dbo].[TAOMAMON]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAMA VARCHAR(10)
DECLARE @MAXMAMA VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMAMA = MAX(MAMA) FROM MONAN
IF EXISTS (SELECT MAMA FROM MONAN)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAMA, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAMA = 'MA0' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MAMA = 'MA' + CONVERT (VARCHAR(2), @MAX)
RETURN @MAMA
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMANCC]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[TAOMANCC]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MANCC VARCHAR(10)
DECLARE @MAXMANCC VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMANCC = MAX(MANCC) FROM dbo.NHACUNGCAP
IF EXISTS (SELECT MANCC FROM dbo.NHACUNGCAP)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMANCC, 4 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MANCC = 'NCC000' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MANCC = 'NCC00' + CONVERT (VARCHAR(2), @MAX)
ELSE
IF (@MAX < 1000) SET @MANCC = 'NCC0' + CONVERT (VARCHAR(3), @MAX)
RETURN @MANCC
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMANV]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[TAOMANV]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MANV VARCHAR(10)
DECLARE @MAXMANV VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMANV = MAX(MANV) FROM NHANVIEN
IF EXISTS (SELECT MANV FROM NHANVIEN)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMANV, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MANV = 'NV00' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MANV = 'NV0' + CONVERT (VARCHAR(2), @MAX)
ELSE
IF (@MAX < 1000) SET @MANV = 'NV' + CONVERT (VARCHAR(3), @MAX)
RETURN @MANV
END
GO
/****** Object:  UserDefinedFunction [dbo].[TaoMaPhieuNhap]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[TaoMaPhieuNhap]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAPN VARCHAR(10)
DECLARE @MAXMAPN VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMAPN = MAX(MAPN) FROM PHIEUNHAP
IF EXISTS (SELECT MAPN FROM PHIEUNHAP)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAPN, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAPN = 'PN00' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MAPN = 'PN0' + CONVERT (VARCHAR(2), @MAX)
RETURN @MAPN
END
GO
/****** Object:  UserDefinedFunction [dbo].[TAOMAPYC]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TAOMAPYC]()
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @MAPYC VARCHAR(10)
DECLARE @MAXMAPYC VARCHAR(10)
DECLARE @MAX INT
SELECT @MAXMAPYC = MAX(MAPYC) FROM PHIEUYEUCAU
IF EXISTS (SELECT MAPYC FROM PHIEUYEUCAU)
	SET @MAX = CONVERT(INT, SUBSTRING(@MAXMAPYC, 3 ,8))+1
ELSE SET @MAX = 1
IF (@MAX < 10) SET @MAPYC = '000' + CONVERT (VARCHAR(1), @MAX)
ELSE
IF (@MAX < 100) SET @MAPYC = '00' + CONVERT (VARCHAR(2), @MAX)
ELSE
IF (@MAX < 1000) SET @MAPYC = '0' + CONVERT (VARCHAR(3), @MAX)
RETURN @MAPYC
END
GO
/****** Object:  UserDefinedFunction [dbo].[ThanhToan]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ThanhToan](
@mapyc varchar(10), @km float)
returns float 
as
begin
	declare @tongtien float
	select @tongtien = sum(thanhtien) from CHITIETDATMON where MAPYC = @mapyc
	set @tongtien = @tongtien * (100 - @km ) / 100
	return @tongtien
end
GO
/****** Object:  UserDefinedFunction [dbo].[ThongkeTongtien]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ThongkeTongtien](@Ngaydau datetime , @Ngaycuoi datetime)
returns int 
as
begin
	declare @Tien int
	select @Tien =sum(TONGTIEN)  from HOADON h, TAIKHOAN t, KHUYENMAI k, KHACHHANG kh, PHIEUYEUCAU p where (h.NGAYLAP between @Ngaydau and @Ngaycuoi) and h.MAKM = k.MAKM and h.USERNAME = t.USERNAME and h.MAPYC = p.MAPYC and p.MAKH = kh.MAKH
	return @Tien
end
GO
/****** Object:  Table [dbo].[BANAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BANAN](
	[MABAN] [varchar](10) NOT NULL,
	[SOCHONGOI] [int] NOT NULL,
	[MAPYC] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MABAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHITIETDATMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETDATMON](
	[MAPYC] [varchar](10) NOT NULL,
	[MAMA] [varchar](10) NOT NULL,
	[DONGIA] [int] NOT NULL,
	[SOLUONG] [int] NOT NULL,
	[THANHTIEN] [int] NOT NULL,
 CONSTRAINT [MONAN_PHIEUYEUCAU] PRIMARY KEY CLUSTERED 
(
	[MAPYC] ASC,
	[MAMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHITIETPHIEUNHAP]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETPHIEUNHAP](
	[MAPN] [varchar](10) NOT NULL,
	[MANL] [varchar](10) NOT NULL,
	[DONGIA] [int] NOT NULL,
	[SOLUONG] [int] NOT NULL,
	[THANHTIEN] [int] NOT NULL,
 CONSTRAINT [NGUYENLIEU_PHIEUNHAP] PRIMARY KEY CLUSTERED 
(
	[MANL] ASC,
	[MAPN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON](
	[MAHD] [varchar](10) NOT NULL,
	[NGAYLAP] [datetime] NULL,
	[TONGTIEN] [int] NULL,
	[USERNAME] [varchar](30) NULL,
	[MAPYC] [varchar](10) NOT NULL,
	[MAKM] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[MAKH] [varchar](10) NOT NULL,
	[TENKH] [nvarchar](50) NOT NULL,
	[SDT] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHUYENMAI]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHUYENMAI](
	[MAKM] [varchar](10) NOT NULL,
	[NGAYBATDAU] [date] NOT NULL,
	[NGAYKETTHUC] [date] NOT NULL,
	[PHANTRAM] [decimal](18, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAKM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAIMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIMON](
	[MALOAI] [varchar](10) NOT NULL,
	[TENLOAIMON] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MALOAI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MONAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MONAN](
	[MAMA] [varchar](10) NOT NULL,
	[TENMONAN] [nvarchar](100) NOT NULL,
	[DVT] [nvarchar](20) NOT NULL,
	[DONGIA] [int] NOT NULL,
	[MALOAI] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAMA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NGUYENLIEU]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGUYENLIEU](
	[MANL] [varchar](10) NOT NULL,
	[TENNL] [nvarchar](50) NOT NULL,
	[DVT] [nvarchar](30) NOT NULL,
	[DONGIA] [int] NOT NULL,
	[SOLUONG] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MANL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHACUNGCAP](
	[MANCC] [varchar](10) NOT NULL,
	[TENNCC] [nvarchar](50) NOT NULL,
	[DIACHI] [nvarchar](100) NOT NULL,
	[SDT] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MANCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MANV] [varchar](10) NOT NULL,
	[TENNV] [nvarchar](50) NOT NULL,
	[NGAYSINH] [date] NOT NULL,
	[DIACHI] [nvarchar](100) NOT NULL,
	[GIOITINH] [nchar](3) NOT NULL,
	[SDT] [varchar](10) NULL,
	[LUONG] [int] NOT NULL,
	[NGAYVAOLAM] [date] NOT NULL,
	[CHUCVU] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MANV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEUNHAP]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEUNHAP](
	[MAPN] [varchar](10) NOT NULL,
	[NGAYLAP] [datetime] NULL,
	[TONGTIEN] [int] NOT NULL,
	[MANCC] [varchar](10) NOT NULL,
	[USERNAME] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAPN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEUYEUCAU]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEUYEUCAU](
	[MAPYC] [varchar](10) NOT NULL,
	[NGAYLAP] [datetime] NULL,
	[USERNAME] [varchar](30) NULL,
	[MAKH] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAPYC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAIKHOAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOAN](
	[USERNAME] [varchar](30) NOT NULL,
	[PASSWORD] [varchar](1000) NOT NULL,
	[HOTEN] [nvarchar](50) NOT NULL,
	[PHANQUYEN] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[USERNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CHITIETDATMON] ADD  DEFAULT ((0)) FOR [DONGIA]
GO
ALTER TABLE [dbo].[CHITIETDATMON] ADD  DEFAULT ((0)) FOR [THANHTIEN]
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP] ADD  DEFAULT ((0)) FOR [DONGIA]
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP] ADD  DEFAULT ((0)) FOR [THANHTIEN]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT (getdate()) FOR [NGAYLAP]
GO
ALTER TABLE [dbo].[HOADON] ADD  DEFAULT ((0)) FOR [TONGTIEN]
GO
ALTER TABLE [dbo].[PHIEUNHAP] ADD  DEFAULT (getdate()) FOR [NGAYLAP]
GO
ALTER TABLE [dbo].[PHIEUNHAP] ADD  DEFAULT ((0)) FOR [TONGTIEN]
GO
ALTER TABLE [dbo].[PHIEUYEUCAU] ADD  DEFAULT (getdate()) FOR [NGAYLAP]
GO
ALTER TABLE [dbo].[TAIKHOAN] ADD  CONSTRAINT [df_pass]  DEFAULT ('123') FOR [PASSWORD]
GO
ALTER TABLE [dbo].[BANAN]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[BANAN]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[CHITIETDATMON]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[CHITIETDATMON]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[CHITIETDATMON]  WITH CHECK ADD FOREIGN KEY([MAMA])
REFERENCES [dbo].[MONAN] ([MAMA])
GO
ALTER TABLE [dbo].[CHITIETDATMON]  WITH CHECK ADD FOREIGN KEY([MAMA])
REFERENCES [dbo].[MONAN] ([MAMA])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MANL])
REFERENCES [dbo].[NGUYENLIEU] ([MANL])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MANL])
REFERENCES [dbo].[NGUYENLIEU] ([MANL])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MAPN])
REFERENCES [dbo].[PHIEUNHAP] ([MAPN])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MAPN])
REFERENCES [dbo].[PHIEUNHAP] ([MAPN])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MAKM])
REFERENCES [dbo].[KHUYENMAI] ([MAKM])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MAKM])
REFERENCES [dbo].[KHUYENMAI] ([MAKM])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MAPYC])
REFERENCES [dbo].[PHIEUYEUCAU] ([MAPYC])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[MONAN]  WITH CHECK ADD FOREIGN KEY([MALOAI])
REFERENCES [dbo].[LOAIMON] ([MALOAI])
GO
ALTER TABLE [dbo].[MONAN]  WITH CHECK ADD FOREIGN KEY([MALOAI])
REFERENCES [dbo].[LOAIMON] ([MALOAI])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MANCC])
REFERENCES [dbo].[NHACUNGCAP] ([MANCC])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MANCC])
REFERENCES [dbo].[NHACUNGCAP] ([MANCC])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[PHIEUYEUCAU]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[PHIEUYEUCAU]  WITH CHECK ADD FOREIGN KEY([USERNAME])
REFERENCES [dbo].[TAIKHOAN] ([USERNAME])
GO
ALTER TABLE [dbo].[PHIEUYEUCAU]  WITH CHECK ADD FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHACHHANG] ([MAKH])
GO
ALTER TABLE [dbo].[PHIEUYEUCAU]  WITH CHECK ADD FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHACHHANG] ([MAKH])
GO
ALTER TABLE [dbo].[NHANVIEN]  WITH CHECK ADD CHECK  (([GIOITINH]=N'NỮ' OR [GIOITINH]='NAM'))
GO
ALTER TABLE [dbo].[NHANVIEN]  WITH CHECK ADD CHECK  (([GIOITINH]=N'NỮ' OR [GIOITINH]='NAM'))
GO
/****** Object:  StoredProcedure [dbo].[CHUYENBAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CHUYENBAN]
@maban1 varchar(10), @maban2 varchar(10)
as
begin
	declare @mapyc1 varchar(10)
	declare @mapyc2 varchar(10)
	select @mapyc1 = mapyc from BANAN where MABAN = @maban1
	select @mapyc2 = mapyc from BANAN where MABAN = @maban2

	if (@mapyc1 is not null)
	begin
		update CHITIETDATMON
		set MAPYC = @mapyc2 
		where MAPYC = @mapyc1
		delete PHIEUYEUCAU where MAPYC = @mapyc1
		update BANAN
		set MAPYC = NULL
		where MABAN = @maban1
	end
end
GO
/****** Object:  StoredProcedure [dbo].[DemSoMonAn]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DemSoMonAn]
@From DATE, @To DATE
AS
BEGIN
    SELECT dbo.MONAN.MAMA, TENMONAN, COUNT(CHITIETDATMON.MAMA) AS 'SoLuong'
	FROM dbo.CHITIETDATMON
	INNER JOIN dbo.MONAN
	ON MONAN.MAMA = CHITIETDATMON.MAMA
	INNER JOIN (SELECT * FROM dbo.PHIEUYEUCAU WHERE NGAYLAP > @From AND NGAYLAP < @To) C
	ON C.MAPYC = CHITIETDATMON.MAPYC
	GROUP BY dbo.MONAN.MAMA, TENMONAN
END
GO
/****** Object:  StoredProcedure [dbo].[getCTPNmax]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[getCTPNmax]
as
begin
	select TENNL,DVT,NGUYENLIEU.DONGIA,CHITIETPHIEUNHAP.SOLUONG,THANHTIEN
	from CHITIETPHIEUNHAP,NGUYENLIEU
	where MAPN = (select max(MAPN) from PHIEUNHAP) and CHITIETPHIEUNHAP.MANL = NGUYENLIEU.MANL
end
GO
/****** Object:  StoredProcedure [dbo].[getCTPYC]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getCTPYC] 
@mapyc varchar(10)
as
begin
	select TENMONAN,DVT,MONAN.DONGIA,SOLUONG,THANHTIEN from CHITIETDATMON, MONAN where MAPYC = @mapyc and CHITIETDATMON.MAMA = MONAN.MAMA
end
GO
/****** Object:  StoredProcedure [dbo].[GetTableList]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetTableList]
as
begin
	select * from BANAN
end
GO
/****** Object:  StoredProcedure [dbo].[HuyBan]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HuyBan]
@maban varchar(10)
as
begin
	declare @mapyc varchar(10)
	select @mapyc = mapyc from BANAN where @maban = MABAN
	if (@mapyc is not null)
	begin
		delete CHITIETDATMON where MAPYC = @mapyc
		update banan set MAPYC = null where MABAN = @maban
		delete PHIEUYEUCAU where MAPYC = @mapyc
		
	end
end

select * from BANAN,CHITIETDATMON,PHIEUYEUCAU where BANAN.MAPYC = CHITIETDATMON.MAPYC and CHITIETDATMON.MAPYC=PHIEUYEUCAU.MAPYC
select * from CHITIETDATMON
GO
/****** Object:  StoredProcedure [dbo].[proc_insertBA]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[proc_insertBA] @maban varchar(10), @socho int
as begin
insert into BANAN(MABAN,SOCHONGOI) values(@maban,@socho)
end
GO
/****** Object:  StoredProcedure [dbo].[proc_insertNL]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc[dbo].[proc_insertNL] (@ma nchar (10),@ten nvarchar(50), @dvt nvarchar(30), @dongia int, @soluong int)
           as
           begin
               insert into NGUYENLIEU(MANL, TENNL, DVT, DONGIA, SoLuong)
               values(@Ma, @ten, @dvt, @dongia, @soluong)
           end
GO
/****** Object:  StoredProcedure [dbo].[SUALOAIMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SUA LOAI MON
CREATE PROCEDURE [dbo].[SUALOAIMON]
    @MALOAI VARCHAR(10),
	@TENLOAIMON NVARCHAR(50)
AS
BEGIN
    UPDATE LOAIMON SET TENLOAIMON=@TENLOAIMON WHERE MALOAI=@MALOAI
END
GO
/****** Object:  StoredProcedure [dbo].[SUAMONAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SUA MON AN
CREATE PROCEDURE [dbo].[SUAMONAN]
    @MAMA VARCHAR(10),
	@TENMONAN NVARCHAR(100),
	@DVT NVARCHAR(20),
	@DONGIA DECIMAL(18,0),
	@MALOAI VARCHAR(10)
AS
BEGIN
    UPDATE MONAN SET  TENMONAN=@TENMONAN, DVT=@DVT, DONGIA=@DONGIA, MALOAI=@MALOAI WHERE MAMA=@MAMA
END
GO
/****** Object:  StoredProcedure [dbo].[ThanhToanHoaDon]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[ThanhToanHoaDon]
@tongtien int, @user varchar(30), @mapyc varchar(10), @makm varchar(10), @makhn varchar(10)
as
begin

	update PHIEUYEUCAU 
	set MAKH = @makhn
	where MAPYC = @mapyc

	insert into HOADON
	values 
	(
		[dbo].[TAOMAHOADON](),
		GETDATE(),
		@tongtien,
		@user,
		@mapyc,
		@makm
	)

	declare @maban varchar(10) 
	select @maban = maban from BANAN where MAPYC = @mapyc
	update BANAN
	set MAPYC = null
	where MABAN = @maban

end
GO
/****** Object:  StoredProcedure [dbo].[ThemCTDatMon]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ThemCTDatMon]
@mapyc varchar(10), @mama varchar(10), @soluong int
as
begin
	declare @tontai int
	declare @soluongtt int

	select @tontai = count(*)
	from CHITIETDATMON
	where @mapyc = MAPYC and @mama=MAMA

	if (@tontai >0)
	begin
		select @soluongtt = soluong
		from CHITIETDATMON
		where @mapyc = MAPYC and @mama=MAMA

		
				declare @soluongmoi int = @soluongtt + @soluong
				if (@soluongmoi > 0)
					update CHITIETDATMON set SOLUONG = @soluongmoi where @mapyc = MAPYC and @mama=MAMA
				else 
					delete CHITIETDATMON where @mapyc = MAPYC and @mama=MAMA
	end		
	else
		begin
			if(@soluong > 0)
			begin
			insert into CHITIETDATMON(MAPYC,MAMA,SOLUONG)
			values (@mapyc,@mama,@soluong)
			end
		end

end
GO
/****** Object:  StoredProcedure [dbo].[ThemCTPhieuNhap]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ThemCTPhieuNhap]
@mapn varchar(10), @manl varchar(10), @dongia int , @soluong int, @thanhtien int
as
begin
	insert into CHITIETPHIEUNHAP values
	(@mapn, @manl, @dongia, @soluong, @thanhtien)
end
GO
/****** Object:  StoredProcedure [dbo].[ThemKhachHang]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ThemKhachHang]
    @MAKH AS varCHAR(10),
	@TENKH AS NVARCHAR(50),
	@SDT AS varCHAR(10)
AS
BEGIN
    INSERT into dbo.KHACHHANG
    (
        MAKH,
        TENKH,
        SDT
    )
    VALUES
    (   @MAKH,  -- MAKH - char(10)
        N''+@tenkh+'', -- TENKH - nvarchar(50)
        @SDT   -- SDT - char(10)
        )
END
GO
/****** Object:  StoredProcedure [dbo].[THEMLOAIMON]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--THEM LOAI MON
CREATE PROCEDURE [dbo].[THEMLOAIMON]
    @MALOAI VARCHAR(10),
	@TENLOAIMON NVARCHAR(50)
AS
BEGIN
    INSERT INTO LOAIMON
    VALUES
    (   @MALOAI, @TENLOAIMON )
END
GO
/****** Object:  StoredProcedure [dbo].[THEMMONAN]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--THEM MON AN
CREATE PROCEDURE [dbo].[THEMMONAN]
    @MAMA VARCHAR(10),
	@TENMONAN AS NVARCHAR(100),
	@DVT AS NVARCHAR(20),
	@DONGIA AS DECIMAL(18,0),
	@MALOAI VARCHAR(10)
AS
BEGIN
    INSERT INTO MONAN
	VALUES(@MAMA, @TENMONAN,@DVT, @DONGIA, @MALOAI)
END
GO
/****** Object:  StoredProcedure [dbo].[themNL]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[themNL] 
@manl varchar(10), @sl int
as
begin
	update NGUYENLIEU
	set SOLUONG = SOLUONG + @sl
	where MANL = @manl
	
end
GO
/****** Object:  StoredProcedure [dbo].[ThemPhieuNhap]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ThemPhieuNhap]
@tongtien int, @mancc varchar(10), @username varchar(30)
as
begin
	insert into phieunhap values ([dbo].[TaoMaPhieuNhap](), GETDATE(), @tongtien, @mancc, @username)
end
GO
/****** Object:  StoredProcedure [dbo].[ThemPYC]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThemPYC]
@username varchar(10), @maban varchar(10)
as 
begin
	declare @mapyc varchar(10)
	set @mapyc = [dbo].TAOMAPYC()
	insert into PHIEUYEUCAU
	values (@mapyc, GETDATE(), @username, NULL)
	update BANAN
	set MAPYC = @mapyc
	where MABAN = @maban
end
GO
/****** Object:  StoredProcedure [dbo].[ThemSuaKH]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ThemSuaKH]
@makh VARCHAR(10), @tenkh nVARCHAR(50), @sdtkh VARCHAR(10)
as
begin
	declare @tontai int

	select @tontai = count(*)
	from dbo.KHACHHANG
	where MAKH = @makh
	if (@tontai = 0)
	begin
		insert into dbo.KHACHHANG
		(
		    MAKH,
		    TENKH,
		    SDT
		)
		VALUES
		(   @makh,  -- MAKH - char(10)
		    @tenkh, -- TENKH - nvarchar(50)
		    @sdtkh   -- SDT - char(10)
		    )
	end
	else if(@tontai > 0)
	begin
		update dbo.KHACHHANG
		set TENKH = @tenkh, SDT = @sdtkh
		where MAKH = @makh
	end
END
GO
/****** Object:  StoredProcedure [dbo].[ThemSuaLoaiMon]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThemSuaLoaiMon]
@malm varchar(10), @tenlm nvarchar(50)
as
begin
	declare @tontai int

	select @tontai = count(*)
	from LOAIMON
	where maloai = @malm
	if (@tontai = 0)
	begin
		insert into LOAIMON values (@malm, @tenlm)
	end
	else if(@tontai > 0)
	begin
		update LOAIMON
		set TENLOAIMON = @tenlm
		where MALOAI = @malm
	end

end
GO
/****** Object:  StoredProcedure [dbo].[ThemSuaNCC]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ThemSuaNCC]
@mancc VARCHAR(10), @tenncc NVARCHAR(50), @sdtncc VARCHAR(10), @diachincc NVARCHAR(100)
as
begin
	declare @tontai int

	select @tontai = count(*)
	from dbo.NHACUNGCAP
	where MANCC = @mancc
	if (@tontai = 0)
	begin
		insert into dbo.NHACUNGCAP
		(
		    MANCC,
		    TENNCC,
		    DIACHI,
		    SDT
		)
		VALUES
		(   @mancc,  -- MANCC - char(10)
		    @tenncc, -- TENNCC - nvarchar(50)
		    @diachincc, -- DIACHI - nvarchar(100)
		    @sdtncc   -- SDT - char(10)
		    )
	end
	else if(@tontai > 0)
	begin
		update dbo.NHACUNGCAP
		set TENNCC = @tenncc, SDT = @sdtncc
		where MANCC = @mancc
	end
END
GO
/****** Object:  StoredProcedure [dbo].[TimKiemMonAn]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[TimKiemMonAn]
@mamon varchar(10), @tenmon nvarchar(50)
as
begin
	select *
	from MONAN
	where (MAMA like '%' + @mamon + '%' or @mamon = '') and (TENMONAN LIKE N'%'+ @tenmon +'%' OR @tenmon = '') 
end
GO
/****** Object:  StoredProcedure [dbo].[updateBA]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[updateBA] @maban varchar(10), @socho int
as begin
update BANAN set SOCHONGOI = @socho where MABAN = @maban
end
GO
/****** Object:  StoredProcedure [dbo].[updateNL]    Script Date: 29/06/2021 11:24:20 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc[dbo].[updateNL] (@ma nchar (10), @ten nvarchar(50), @dvt nvarchar(30), @dongia int, @soluong int )
           as
           begin
             update NGUYENLIEU set DVT = @dvt, DONGIA = @dongia, TenNL = @ten, SoLuong = @soluong where MaNL = @ma
          end
GO
/****** Object:  Trigger [dbo].[XOA_NL]    Script Date: 29/06/2021 11:25:57 SA ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[XOA_NL] ON [dbo].[NGUYENLIEU] INSTEAD OF DELETE AS BEGIN
	DECLARE @MANL VARCHAR(10)
	SELECT @MANL = MANL FROM deleted
	DECLARE @MAPN TABLE (MAPN VARCHAR(10))
	INSERT INTO @MAPN(MAPN) SELECT MAPN FROM CHITIETPHIEUNHAP WHERE MANL = @MANL
	DELETE FROM CHITIETPHIEUNHAP WHERE MAPN IN (SELECT * FROM @MAPN)
	DELETE FROM	NGUYENLIEU WHERE MANL = @MANL
END
GO

/****** Object:  Trigger [dbo].[XOA_NCC]    Script Date: 29/06/2021 11:26:56 SA ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[XOA_NCC] ON [dbo].[NHACUNGCAP] INSTEAD OF DELETE AS BEGIN
	DECLARE @MANCC VARCHAR(10)
	SELECT @MANCC = MANCC FROM deleted 
	DECLARE @MAPN TABLE (MAPN VARCHAR(10))
	INSERT INTO @MAPN(MAPN) SELECT MAPN FROM PHIEUNHAP WHERE MANCC=@MANCC
	DELETE FROM CHITIETPHIEUNHAP WHERE MAPN IN (SELECT * FROM @MAPN)
	DELETE FROM PHIEUNHAP WHERE MAPN IN (SELECT * FROM @MAPN)
	DELETE FROM	NHACUNGCAP WHERE MANCC=@MANCC
END
GO

create trigger [dbo].[Update_ChiTietDatMon] on [dbo].[CHITIETDATMON] after insert,update as
begin
	update chitietdatmon
	set chitietdatmon.dongia = monan.dongia
	from CHITIETDATMON, MONAN
	where monan.mama = chitietdatmon.mama
	
	update chitietdatmon
	set thanhtien = soluong * dongia
	from CHITIETDATMON
end
go

USE [master]
GO
ALTER DATABASE [QUANLYNHAHANG] SET  READ_WRITE 
GO

