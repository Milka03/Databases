
--------------------- PART 2 ------------------------
---------------- 3) UPDATE Query  -------------------


BEGIN TRANSACTION
	UPDATE Servers SET CurrentViewers_no = CAST(Capacity as int);
	
	-- rollback --no changes 
	COMMIT 
		Select * from Servers


--------------- Back to previous state -------------
--select * from Servers

BEGIN TRANSACTION
	UPDATE Servers SET CurrentViewers_no = 0;
	COMMIT

BEGIN TRANSACTION
	UPDATE Servers SET CurrentViewers_no = 2 where Server_id=101;
	UPDATE Servers SET CurrentViewers_no = 1 where Server_id=102;
	UPDATE Servers SET CurrentViewers_no = 1 where Server_id=105;

	COMMIT
		Select * from Servers

----------------------- END -------------------------

SELECT s.Server_id,
(SELECT Count(*) From Viewing_Request vr 
WHERE vr.Server_id=s.Server_id and vr.Request_Status='served') AS Serverno
FROM Servers s


BEGIN TRANSACTION
	UPDATE Servers SET CurrentViewers_no = (SELECT Count(*) From Viewing_Request vr 
			WHERE vr.Server_id=s.Server_id and vr.Request_Status='served');
	
	-- rollback --no changes 
	COMMIT 
		Select * from Servers
 

