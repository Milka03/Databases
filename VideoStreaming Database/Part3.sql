
--------------------- PART 3 ------------------------
---------------- Index Structure --------------------

-- 1. clustered indexes are setup on PK (during creation of tables)
-- So here I define indexes for column combinations used to frequently access group of records 
-- In this case it is mapping table: Channel_Server
	create unique clustered index IX_channel_server on Channel_Server([Channel_name], [Server_id])

-- 2. Non-clustered indexes for all FK
	-- Channels
	--create nonclustered index IX_Channel_category on Channels([Category_id])
	-- Viewers
	create nonclustered index IX_Viewers_server on Viewers([Server_id])
	-- Channel_Server
	create nonclustered index IX_Chan_serv_channel on Channel_Server([Channel_name])
	create nonclustered index IX_Chan_serv_server on Channel_Server([Server_id])
	-- Viewing_Request
	create nonclustered index IX_Request_channel on Viewing_Request([Channel_name])
	create nonclustered index IX_Request_viewer on Viewing_Request([Viewer_id])
	create nonclustered index IX_Request_server on Viewing_Request([Server_id])
	

-- 3. Indexes for columns often used for search operations
	create nonclustered index IS_Server_capacity on Servers([Capacity])
	create nonclustered index IS_Server_currentViewers on Servers([CurrentViewers_no])
	create nonclustered index IS_Channel_exp_date on Channels([Expiration_Date])
	create nonclustered index IS_Viewing_Request_date on Viewing_Request([Request_Date],[Status_Date])


-- 4. Here enforce unique constraints - Email column in Viewers table
	create unique nonclustered index UX_Viewers_email on Viewers([Email])
	


