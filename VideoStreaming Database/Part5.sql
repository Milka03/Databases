
--------------------- PART 5 ------------------------
----------------- Stored Pocedure -------------------

-- Here I assume that the only requests that need to be served are those with status='open'
-- Hence Procedure will search for 'open' requests in Viewing_Request table and serve them according to the instructions

USE [VideoStreaming]
GO

/*Specifying a table type of variable - not used*/
CREATE TYPE LocationTableType 
   AS TABLE
    ( [Request_id] INT NOT NULL, 
	[Channel_name] VARCHAR(20) NOT NULL,
	[Request_Date] DATETIME NOT NULL,
	[Request_Status] VARCHAR(20) NOT NULL,
	[Status_Date] DATETIME NOT NULL,
	[Viewer_id] INT NOT NULL, 
	[Server_id] INT NULL )
GO

CREATE PROC serveRequest
	--@tab LocationTableType READONLY
AS BEGIN
	DECLARE @msg varchar(100)
	DECLARE @currentDate datetime

	/*Variables for Viewing Request*/
	DECLARE @channel VARCHAR(20)
	DECLARE @requestDate DATETIME
	DECLARE @status VARCHAR(20)
	DECLARE @statusDate DATETIME
	DECLARE @ViewerID INT

	/*Variables for Channel info*/
	DECLARE @EXPIREdate DATETIME

	/*Variables for Server info*/
	DECLARE @newServerId INT

	DECLARE @serv INT
	
	SET @currentDate = GETDATE()

	if not exists(select * from Viewing_Request where Request_Status='open')
		begin 
			print 'There are no requests to serve'
			return;
		end

	DECLARE cursor_request CURSOR
	FOR SELECT Channel_name, Request_Date, Request_Status, Status_Date, Viewer_id FROM Viewing_Request
	ORDER BY Request_Date ASC

	OPEN cursor_request
	FETCH NEXT FROM cursor_request INTO @channel,@requestDate,@status,@statusDate,@ViewerID
	WHILE @@FETCH_STATUS=0
	BEGIN
		if (@status!='open')
		BEGIN
			GOTO Cont
		END 
		
		SET @EXPIREdate = (SELECT TOP 1 c.Expiration_Date FROM Channels c WHERE c.Channel_name=@channel);
		if (@EXPIREdate<=@requestDate)
			BEGIN
				begin try
					begin transaction 
						UPDATE Viewing_Request SET Request_Status='rejected' WHERE Channel_name=@channel;
						UPDATE Viewing_Request SET Status_Date=@currentDate WHERE Channel_name=@channel;
						UPDATE Viewing_Request SET Server_id=NULL WHERE Channel_name=@channel;
					commit
					GOTO Cont
				end try
				begin catch
					print error_message()
					ROLLBACK
					GOTO Cont
				end catch
				
			END
		else
			BEGIN
				SET @serv = (SELECT cs.Server_id FROM Channel_Server cs 
							JOIN Servers s1 on cs.Server_id=s1.Server_id 
							WHERE cs.Channel_name=@channel and s1.CurrentViewers_no<s1.Capacity and
							s1.CurrentViewers_no=(select MAX(s.CurrentViewers_no) FROM Servers s where s.Capacity>s.CurrentViewers_no
								and s.Destruction_Date IS NULL));
				
				if(@serv IS NULL)
					BEGIN 
						Begin try
							SET @newServerId = (SELECT COUNT(*) FROM Servers)
							SET @newServerId+=1
							INSERT INTO Servers ([Server_id],[Capacity],[Server_Name],[CurrentViewers_no],[Creation_Date],[Destruction_Date]) 
								VALUES(@newServerId,10, N'NewServer',0, @currentDate, NULL)

							begin transaction 
								UPDATE Viewing_Request SET Request_Status='rejected' WHERE Channel_name=@channel;
								UPDATE Viewing_Request SET Status_Date=@currentDate WHERE Channel_name=@channel;
								UPDATE Viewing_Request SET Server_id=NULL WHERE Channel_name=@channel;
							commit
						end try
						begin catch
							print error_message()
							ROLLBACK
						end catch
					END 
				else
					BEGIN
						begin try
							begin transaction 
								UPDATE Viewing_Request SET Request_Status='served' WHERE Channel_name=@channel;
								UPDATE Viewing_Request SET Status_Date=@currentDate WHERE Channel_name=@channel;
								UPDATE Viewing_Request SET Server_id=@serv WHERE Channel_name=@channel;
								UPDATE Servers SET CurrentViewers_no=CurrentViewers_no+1 WHERE Server_id=@serv;
								UPDATE Viewers SET Server_id=@serv WHERE Viewer_id=@ViewerID;
							commit
						end try
						begin catch
							print error_message()
							ROLLBACK
						end catch
					END		
			END
		

		Cont:
		FETCH NEXT FROM cursor_request INTO @channel,@requestDate,@status,@statusDate,@ViewerID
	END
	CLOSE cursor_request
	DEALLOCATE cursor_request

END ------- End of procedure



-------- Check of Procedure work ---------

SELECT * FROM Viewing_Request
SELECT * FROM SERVERS
SELECT * FROM Viewers

exec serveRequest

SELECT * FROM Viewing_Request
SELECT * FROM SERVERS
SELECT * FROM Viewers


