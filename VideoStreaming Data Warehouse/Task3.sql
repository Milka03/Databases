
---------------------- TASK III -------------------------
--------------- Model of a Data Warehouse ---------------
------ ETL script building DWH for VideoStreaming--------

--- These queries assume that the database VideoStreaming_DWH
--- is already created 


USE [VideoStreaming]
GO

SELECT 
	vr.Request_id, 
	vr.Viewer_id,  --> dimension 1 viewer
	c.Channel_name,  --> dimension 2 channel
	c.Category_id,
	vr.Request_Date,
	vr.Request_Status,
	vr.Status_Date,
	vr.Server_id --> dimension 3 server

INTO VideoStreaming_DWH.dbo.Requests_Facts
FROM Viewing_Request vr, Channels c
WHERE vr.Channel_name=c.Channel_name



--- Dimension 1
SELECT v.Viewer_id,v.Username,v.Email, v.Viewer_Country 
	INTO VideoStreaming_DWH.dbo.ViewersInfo FROM Viewers v; 

--- Dimension 2
SELECT c.Channel_name, c.Expiration_Date 
	INTO VideoStreaming_DWH.dbo.ChannelsInfo 
	FROM Channels c

--- Dimension 3
SELECT * INTO VideoStreaming_DWH.dbo.ServersInfo FROM Servers;


--- Relations
alter table VideoStreaming_DWH.dbo.ViewersInfo
	add constraint pk_viewer1 primary key (Viewer_id);

alter table VideoStreaming_DWH.dbo.ChannelsInfo
	add constraint pk_channel1 primary key (Channel_name);

alter table VideoStreaming_DWH.dbo.ServersInfo 
	add constraint pk_server1 primary key (Server_id);

alter table  VideoStreaming_DWH.dbo.Requests_Facts
	add constraint pk_rf1 primary key (Request_id),
		constraint fk_dim1 foreign key (Viewer_id) references VideoStreaming_DWH.dbo.ViewersInfo(Viewer_id), 
		constraint fk_dim2 foreign key (Channel_name) references VideoStreaming_DWH.dbo.ChannelsInfo(Channel_name),
		constraint fk_dim3 foreign key (Server_id) references VideoStreaming_DWH.dbo.ServersInfo(Server_id)



------ Helper queries -------
--SELECT * FROM VideoStreaming_DWH.dbo.Requests_Facts
--SELECT * FROM VideoStreaming_DWH.dbo.ViewersInfo
--SELECT * FROM VideoStreaming_DWH.dbo.ChannelsInfo
--SELECT * FROM VideoStreaming_DWH.dbo.ServersInfo