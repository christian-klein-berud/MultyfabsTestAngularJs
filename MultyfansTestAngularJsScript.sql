USE [master]
GO
/****** Object:  Database [MultifabsDB]    Script Date: 04-Nov-16 9:44:00 AM ******/
CREATE DATABASE [MultifabsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MultifabsDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MultifabsDB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MultifabsDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MultifabsDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MultifabsDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MultifabsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MultifabsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MultifabsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MultifabsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MultifabsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MultifabsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MultifabsDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MultifabsDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MultifabsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MultifabsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MultifabsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MultifabsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MultifabsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MultifabsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MultifabsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MultifabsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MultifabsDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MultifabsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MultifabsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MultifabsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MultifabsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MultifabsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MultifabsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MultifabsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MultifabsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MultifabsDB] SET  MULTI_USER 
GO
ALTER DATABASE [MultifabsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MultifabsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MultifabsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MultifabsDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [MultifabsDB]
GO
/****** Object:  StoredProcedure [dbo].[spInsertMachineOperator]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spInsertMachineOperator]
@EmployeeCode nvarchar(50),
@EmployeeName nvarchar(50),
@EffectDate date,
@Schedule nvarchar(100),
@MachineNumber nvarchar(50)
as
begin 
insert into MachineOperator
values(@EmployeeCode, @EmployeeName, @EffectDate, @Schedule, @MachineNumber)
end
GO
/****** Object:  StoredProcedure [dbo].[spIsMachineAssigned]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spIsMachineAssigned]

@MachineNumber nvarchar(50),
@EmployeeCode nvarchar(50)
as
begin 
declare @Count int

select @Count = COUNT(MachineOperatorId)
from MachineOperator
where MachineNumber = @MachineNumber and EmployeeCode = @EmployeeCode

if(@count>0)
select 1 as IsMachineAssigned
else
select 0 as IsMachineAssigned
end
GO
/****** Object:  StoredProcedure [dbo].[spIsScheduleAvailable]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spIsScheduleAvailable]
@MachineNumber nvarchar(50),
@Schedule nvarchar(100)
as
begin
declare @Result int
select @Result = COUNT(MachineOperatorId)
from MachineOperator
where MachineNumber = @MachineNumber
and Schedule = @Schedule

if(@Result>0)
select 1 as IsScheduleAvailable
else
select 0 as IsScheduleAvailable
end
GO
/****** Object:  StoredProcedure [dbo].[spMachineAssignedTest]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spMachineAssignedTest]

@MachineNumber nvarchar(50),
@EmployeeCode nvarchar(50),
@Schedule nvarchar(100)
as
begin 
declare @Result int

select @Result = COUNT(MachineOperatorId)
from MachineOperator
where MachineNumber = @MachineNumber 
and EmployeeCode = @EmployeeCode
and Schedule = @Schedule

if(@Result>0)

select 1 as MachineAssignedTest
else
select 0 as MachineAssignedTest
end
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCode] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Machine]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Machine](
	[MachineId] [int] IDENTITY(1,1) NOT NULL,
	[MachineNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_Machine] PRIMARY KEY CLUSTERED 
(
	[MachineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MachineOperator]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MachineOperator](
	[MachineOperatorId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCode] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](50) NULL,
	[EffectDate] [date] NULL,
	[Schedule] [nvarchar](100) NULL,
	[MachineNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_MachineOperator] PRIMARY KEY CLUSTERED 
(
	[MachineOperatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 04-Nov-16 9:44:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleName] [nvarchar](50) NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeId], [EmployeeCode], [EmployeeName]) VALUES (1, N'KNT-10009', N'Md. Humayun Kabir')
INSERT [dbo].[Employee] ([EmployeeId], [EmployeeCode], [EmployeeName]) VALUES (2, N'KNT-10010', N'Anwar Hossain')
INSERT [dbo].[Employee] ([EmployeeId], [EmployeeCode], [EmployeeName]) VALUES (3, N'KNT-10024', N'Md. Abdul Jalil Miah')
INSERT [dbo].[Employee] ([EmployeeId], [EmployeeCode], [EmployeeName]) VALUES (4, N'KNT-10055', N'Md. Abdul Quddus')
SET IDENTITY_INSERT [dbo].[Employee] OFF
SET IDENTITY_INSERT [dbo].[Machine] ON 

INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (1, N'TST-01')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (2, N'TST-02')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (3, N'TST-03')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (4, N'TST-04')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (5, N'TST-05')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (6, N'TST-06')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (7, N'TST-07')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (8, N'TST-08')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (9, N'TST-09')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (10, N'TST-10')
INSERT [dbo].[Machine] ([MachineId], [MachineNumber]) VALUES (11, N'TST-11')
SET IDENTITY_INSERT [dbo].[Machine] OFF
SET IDENTITY_INSERT [dbo].[MachineOperator] ON 

INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (1, N'KNT-10009', N'Md. Humayun Kabir', CAST(0xF63B0B00 AS Date), N'A Shift 6:00 AM-2:00PM', N'TST-01')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (23, N'KNT-10010', N'Anwar Hossain', CAST(0x153C0B00 AS Date), N'A Shift 6:00 AM-2:00PM', N'TST-02')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (25, N'KNT-10009', N'Md. Humayun Kabir', CAST(0x0E3C0B00 AS Date), N'A Shift 6:00 AM-2:00PM', N'TST-05')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (26, N'KNT-10055', N'Md. Abdul Quddus', CAST(0x0E3C0B00 AS Date), N'B Shift 2:00 AM-10:00PM', N'TST-06')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (27, N'KNT-10009', N'Md. Humayun Kabir', CAST(0x0F3C0B00 AS Date), N'B Shift 2:00 AM-10:00PM', N'TST-06')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (28, N'KNT-10010', N'Anwar Hossain', CAST(0x0D3C0B00 AS Date), N'B Shift 2:00 AM-10:00PM', N'TST-01')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (29, N'KNT-10055', N'Md. Abdul Quddus', CAST(0x0F3C0B00 AS Date), N'B Shift 2:00 AM-10:00PM', N'TST-10')
INSERT [dbo].[MachineOperator] ([MachineOperatorId], [EmployeeCode], [EmployeeName], [EffectDate], [Schedule], [MachineNumber]) VALUES (30, N'KNT-10024', N'Md. Abdul Jalil Miah', CAST(0x0F3C0B00 AS Date), N'C Shift 10:00 PM-6:00AM', N'TST-11')
SET IDENTITY_INSERT [dbo].[MachineOperator] OFF
SET IDENTITY_INSERT [dbo].[Schedule] ON 

INSERT [dbo].[Schedule] ([ScheduleId], [ScheduleName]) VALUES (1, N'A Shift 6:00 AM-2:00PM')
INSERT [dbo].[Schedule] ([ScheduleId], [ScheduleName]) VALUES (2, N'B Shift 2:00 AM-10:00PM')
INSERT [dbo].[Schedule] ([ScheduleId], [ScheduleName]) VALUES (3, N'C Shift 10:00 PM-6:00AM')
SET IDENTITY_INSERT [dbo].[Schedule] OFF
USE [master]
GO
ALTER DATABASE [MultifabsDB] SET  READ_WRITE 
GO
