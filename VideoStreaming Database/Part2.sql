
--------------------- PART 2 ------------------------
-------------- 1a) Creation of tables ---------------

USE [master]
GO

if exists (select * from sysdatabases where name='VideoStreaming')
		drop database VideoStreaming
go
DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

EXECUTE (N'CREATE DATABASE VideoStreaming
  ON PRIMARY (NAME = N''VideoStreaming'', FILENAME = N''' + @device_directory + N'VideoStreaming.mdf'')
  LOG ON (NAME = N''VideoStreaming_log'',  FILENAME = N''' + @device_directory + N'VideoStreaming.ldf'')')
go

USE [VideoStreaming]
GO

/****** Object:  Table [dbo].[Categories]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Category_id] [int] NOT NULL, --(PK)
	[Category_name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Channels]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Channels](
	[Channel_name] [varchar](20) NOT NULL, --(PK)
	[Category_id] [int] NULL,  --(FK)
	[Expiration_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Channels] PRIMARY KEY CLUSTERED 
(
	[Channel_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Channel_Server]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Channel_Server](
	[Channel_name] [varchar](20) NOT NULL,  --(FK)
	[Server_id] [int] NOT NULL, --(FK) 
 CONSTRAINT [PK_Channel_Server] PRIMARY KEY CLUSTERED 
(
	[Channel_name] ASC,
	[Server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[Servers]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servers](
	[Server_id] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[Server_Name] [varchar](50) NOT NULL,
	[CurrentViewers_no] [int] NOT NULL,
	[Creation_Date] [datetime] NOT NULL,
	[Destruction_Date] [datetime] NULL,
 CONSTRAINT [PK_Servers] PRIMARY KEY CLUSTERED 
(
	[Server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[Viewers]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Viewers](
	[Viewer_id] [int] NOT NULL,  --(PK)
	[Username] [varchar](50) NOT NULL,
	[Viewer_Country] [varchar](30) NOT NULL,
	[Email] [nchar](30) NOT NULL UNIQUE,
	[Server_id] [int]  NULL, --(FK)
 CONSTRAINT [PK_Viewers] PRIMARY KEY CLUSTERED 
(
	[Viewer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Viewing_Request]    Script Date: 27.05.2020 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Viewing_Request](
	[Request_id] [int] NOT NULL, --(PK)
	[Channel_name] [varchar](20) NOT NULL, --(FK)
	[Request_Date] [datetime] NOT NULL,
	[Request_Status] [varchar](20) NOT NULL,
	[Status_Date] [datetime] NOT NULL,
	[Viewer_id] [int] NOT NULL, --(FK)
	[Server_id] [int] NULL, --(FK)
 CONSTRAINT [PK_Viewing_Request] PRIMARY KEY CLUSTERED
(
	[Request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



----------------- 2) Data Insertion  ---------------------
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (1, N'Sport')
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (2, N'News')
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (3, N'Kids')
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (4, N'Movies')
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (5, N'Music')
GO
INSERT [dbo].[Categories] ([Category_id], [Category_name]) VALUES (6, N'Cooking')

GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'CALENDAR', NULL, CONVERT(datetime, N'2020-11-01 09:30:00'))
GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'MusicTV',  5, CONVERT(datetime, N'2020-12-31 09:30:00'))
GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'Master Chef',  6, CONVERT(datetime, N'2019-12-31 09:30:00'))
GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'POP',  NULL, CONVERT(datetime, N'2020-01-30 10:30:00'))
GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'Eurosport',  1, CONVERT(datetime, N'2020-10-01 10:30:00'))
GO
INSERT [dbo].[Channels] ([Channel_name], [Category_id], [Expiration_Date]) VALUES (N'NewsTV',  2, CONVERT(datetime, N'2021-01-30 10:30:00'))




GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'CALENDAR', 101)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'CALENDAR', 102)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'CALENDAR', 103)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'CALENDAR', 105)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'MusicTV', 101)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'MusicTV', 102)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'MusicTV', 106)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'Master Chef', 104)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'Master Chef', 105)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'POP', 103)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'POP', 104)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'Eurosport', 101)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'Eurosport', 105)
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'NewsTV', 101) 
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'NewsTV', 103) 
GO
INSERT [dbo].[Channel_Server] ([Channel_name], [Server_id]) VALUES (N'NewsTV', 106) 




GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (101, 4, N'server1', 2,  CONVERT(datetime, N'2016-10-30 13:20:00'), NULL)
GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (102, 3, N'Server2', 1,  CONVERT(datetime, N'2017-04-07 14:20:00'), NULL)
GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (103, 100, N'MainServer', 0,  CONVERT(datetime, N'2017-06-10 14:20:00'), NULL)
GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (104, 20, N'server4', 0,  CONVERT(datetime, N'2017-08-19 12:40:00'), CONVERT(datetime, N'2019-01-01 14:20:13'))
GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (105, 7, N'server5', 1,  CONVERT(datetime, N'2018-10-10 13:20:00'), NULL)
GO
INSERT [dbo].[Servers] ([Server_id], [Capacity], [Server_Name],	[CurrentViewers_no], [Creation_Date], [Destruction_Date]) VALUES (106, 42, N'Server6', 0,  CONVERT(datetime, N'2018-12-30 14:15:00'), NULL)



GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (11, N'JohnSmith', N'US', N'jsmith@us.com', NULL)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email], [Server_id]) VALUES (12, N'flower55', N'Poland', N'12345@pl.pl', 102)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (13, N'KLausP', N'Germany', N'KLAUS@germany.com', 105)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (14, N'JackSparrow3', N'Poland', N'pirate@pl.pl', NULL)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (15, N'Atlantis', N'US', N'atlanta@us.com', 101)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (16, N'ALFKI', N'Poland', N'alf@xx.pl', NULL)
GO
INSERT [dbo].[Viewers] ([Viewer_id], [Username], [Viewer_Country], [Email],	[Server_id]) VALUES (17, N'misterX', N'Russia', N'sdfrusopen@plot.com', 101)



GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (1, N'POP', CONVERT(Datetime, N'2019-01-01 23:09:22'), N'closed', CONVERT(Datetime, N'2019-01-02 01:01:04'), 11, 105) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (2, N'Eurosport', CONVERT(Datetime, N'2019-01-11 14:09:00'), N'closed', CONVERT(Datetime, N'2019-01-11 16:15:10'), 17, 101) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (3, N'Master Chef', CONVERT(Datetime, N'2019-02-22 18:07:07'), N'rejected', CONVERT(Datetime, N'2019-02-22 18:07:38'), 12, NULL) --no server 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (4, N'CALENDAR', CONVERT(Datetime, N'2019-03-05 22:47:02'), N'closed', CONVERT(Datetime, N'2019-03-06 02:30:45'), 14, 103)
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (5, N'CALENDAR', CONVERT(Datetime, N'2019-04-07 19:08:07'), N'closed', CONVERT(Datetime, N'2019-04-07 23:48:36'), 11, 102) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (6, N'MusicTV', CONVERT(Datetime, N'2019-04-21 10:06:20'), N'closed', CONVERT(Datetime, N'2019-04-21 12:06:30'), 11, 102) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (7, N'NewsTV', CONVERT(Datetime, N'2019-05-01 20:20:09'), N'closed', CONVERT(Datetime, N'2019-05-02 00:40:09'), 13, 103)
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (8, N'Master Chef', CONVERT(Datetime, N'2019-06-23 19:35:29'), N'closed', CONVERT(Datetime, N'2019-06-23 23:40:08'), 11, 105) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (9, N'Eurosport', CONVERT(Datetime, N'2019-07-01 19:45:17'), N'rejected', CONVERT(Datetime, N'2019-07-01 19:45:34'), 14, NULL) --no server
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (10, N'NewsTV', CONVERT(Datetime, N'2019-08-20 15:17:08'), N'closed', CONVERT(Datetime, N'2019-08-20 20:11:05'), 11, 106)
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (11, N'MusicTV', CONVERT(Datetime, N'2019-09-07 23:34:08'), N'closed', CONVERT(Datetime, N'2019-09-07 23:34:20'), 12, 105) --12s
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (12, N'Master Chef', CONVERT(Datetime, N'2019-09-16 19:12:44'), N'closed', CONVERT(Datetime, N'2019-09-16 19:12:55'), 14, 105) --11s
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (13, N'Eurosport', CONVERT(Datetime, N'2019-10-07 17:45:08'), N'closed', CONVERT(Datetime, N'2019-10-07 21:58:20'), 11, 105) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (14, N'Master Chef', CONVERT(Datetime, N'2019-12-06 16:57:34'), N'closed', CONVERT(Datetime, N'2019-12-06 19:28:14'), 17, 105) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (15, N'POP', CONVERT(Datetime, N'2019-12-25 15:06:20'), N'closed', CONVERT(Datetime, N'2019-12-25 18:47:22'), 16, 103) -->End of 2019
GO

INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (16, N'POP', CONVERT(Datetime, N'2020-02-11 20:06:20'), N'rejected', CONVERT(Datetime, N'2020-02-11 20:06:30'), 15, NULL) --channel expired 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (17, N'CALENDAR', CONVERT(Datetime, N'2020-02-22 18:20:05'), N'closed', CONVERT(Datetime, N'2020-02-22 22:37:00'), 14, 102) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (18, N'Master Chef', CONVERT(Datetime, N'2020-03-08 20:07:20'), N'rejected', CONVERT(Datetime, N'2020-03-08 20:07:27'), 17, NULL) --channel expired 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (19, N'CALENDAR', CONVERT(Datetime, N'2020-03-25 21:20:05'), N'closed', CONVERT(Datetime, N'2020-04-25 21:37:00'), 13, 103) --/
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (20, N'CALENDAR', CONVERT(Datetime, N'2020-04-05 15:28:05'), N'closed', CONVERT(Datetime, N'2020-04-05 15:28:14'), 12, 102) --10s
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (21, N'MusicTV', CONVERT(Datetime, N'2020-04-19 20:57:26'), N'closed', CONVERT(Datetime, N'2020-04-19 20:57:29'), 15, 101)  --10s
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (22, N'NewsTV', CONVERT(Datetime, N'2020-04-27 21:48:05'), N'closed', CONVERT(Datetime, N'2020-04-27 21:37:00'), 16, 103) 

GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (23, N'Eurosport', CONVERT(Datetime, N'2020-05-25 10:24:30'), N'closed', CONVERT(Datetime, N'2020-05-25 10:24:40'), 13, 105) --102=0
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (24, N'MusicTV', CONVERT(Datetime, N'2020-05-27 13:40:09'), N'closed', CONVERT(Datetime, N'2020-05-27 18:40:18'), 12, 102) --101=0
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (25, N'NewsTV', CONVERT(Datetime, N'2020-05-28 16:17:03'), N'closed', CONVERT(Datetime, N'2020-05-28 16:39:17'), 17, 101) --105=0 ---------28.05.2020
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (26, N'CALENDAR', CONVERT(Datetime, N'2020-05-28 16:40:19'), N'closed', CONVERT(Datetime, N'2020-05-28 16:40:24'), 15, 101)  --101=0~~~~
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES   (27, N'Eurosport', CONVERT(Datetime, N'2020-05-28 18:19:03'), N'served', CONVERT(Datetime, N'2020-05-28 18:19:17'), 13, 105) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (28, N'MusicTV', CONVERT(Datetime, N'2020-05-28 19:02:12'), N'served', CONVERT(Datetime, N'2020-05-28 19:02:24'), 12, 102)  
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (29, N'NewsTV', CONVERT(Datetime, N'2020-05-28 21:16:05'), N'served', CONVERT(Datetime, N'2020-05-28 21:16:09'), 17, 101) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (30, N'CALENDAR', CONVERT(Datetime, N'2020-05-28 23:44:12'), N'served', CONVERT(Datetime, N'2020-05-28 23:44:24'), 15, 101)  ------28.05.2020
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (31, N'NewsTV', CONVERT(Datetime, N'2020-05-30 18:46:53'), N'open', CONVERT(Datetime, N'2020-05-30 18:46:53'), 16, NULL) 
GO
INSERT [dbo].[Viewing_Request] ([Request_id], [Channel_name], [Request_Date], [Request_Status], [Status_Date], [Viewer_id], [Server_id]) VALUES (32, N'Eurosport', CONVERT(Datetime, N'2020-05-30 18:48:22'), N'open', CONVERT(Datetime, N'2020-05-30 18:48:22'), 11, NULL) --




-------------------------- 1b) Adding Foreign Keys ---------------------------
GO
ALTER TABLE [dbo].[Channels]  WITH CHECK ADD  CONSTRAINT [FK_Channels_Category] FOREIGN KEY([Category_id]) REFERENCES [dbo].[Categories] ([Category_id])
GO
ALTER TABLE [dbo].[Channels] CHECK CONSTRAINT [FK_Channels_Category]
GO

ALTER TABLE [dbo].[Channel_Server]  WITH CHECK ADD  CONSTRAINT [FK_chann_server_ChannelName] FOREIGN KEY([Channel_name]) REFERENCES [dbo].[Channels] ([Channel_name])
GO
ALTER TABLE [dbo].[Channel_Server] CHECK CONSTRAINT [FK_chann_server_ChannelName]
GO
ALTER TABLE [dbo].[Channel_Server]  WITH CHECK ADD  CONSTRAINT [FK_chann_server_Serverid] FOREIGN KEY([Server_id]) REFERENCES [dbo].[Servers] ([Server_id])
GO
ALTER TABLE [dbo].[Channel_Server] CHECK CONSTRAINT [FK_chann_server_Serverid]
GO

ALTER TABLE [dbo].[Viewers]  WITH CHECK ADD  CONSTRAINT [FK_Viewer_Server] FOREIGN KEY([Server_id]) REFERENCES [dbo].[Servers] ([Server_id])
GO
ALTER TABLE [dbo].[Viewers] CHECK CONSTRAINT [FK_Viewer_Server]
GO

ALTER TABLE [dbo].[Viewing_Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_Channel] FOREIGN KEY([Channel_name]) REFERENCES [dbo].[Channels] ([Channel_name])
GO
ALTER TABLE [dbo].[Viewing_Request] CHECK CONSTRAINT [FK_Request_Channel]
GO
ALTER TABLE [dbo].[Viewing_Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_Server] FOREIGN KEY([Server_id]) REFERENCES [dbo].[Servers] ([Server_id])
GO
ALTER TABLE [dbo].[Viewing_Request] CHECK CONSTRAINT [FK_Request_Server]
GO
ALTER TABLE [dbo].[Viewing_Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_Viewer] FOREIGN KEY([Viewer_id]) REFERENCES [dbo].[Viewers] ([Viewer_id])
GO
ALTER TABLE [dbo].[Viewing_Request] CHECK CONSTRAINT [FK_Request_Viewer]
GO



----------- HELPER QUERIES ---------------
--select * from Categories
--select * from Channels
--select * from Channel_Server
--select * from Servers
--select * from Viewers
--select * from Viewing_Request


--delete from Viewing_Request
--delete from Viewers
--delete from Channel_Server
--delete from Channels
--delete from Servers
--delete from Categories

--drop table Viewing_Request
--drop table Viewers
--drop table Channel_Server
--drop table Channels
--drop table Servers
--drop table Categories



