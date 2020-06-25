
--------------------- PART 4 ------------------------

--------------------- QUERY 1 ----------------------- 

Select v.Viewer_id, v.Username, c.Channel_name 
from Viewers v 
cross join Channels c where not exists 
	(Select vr.Viewer_id, vr.Channel_name from Viewing_Request vr 
	where vr.Viewer_id=v.Viewer_id and c.Channel_name=vr.Channel_name)
order by 1



--------------------- QUERY 2 -----------------------
	
-- Query displaying all viewers with number of channels they watched for at least an hour in 2019: 
SELECT v.Viewer_id, v.Username,
	(Select COUNT(*) as NumberOfRequests from Viewing_Request vr 
	join Channels c on c.Channel_name=vr.Channel_name and vr.Viewer_id=v.Viewer_id
	where 
	Datediff(hour, vr.Request_Date, vr.Status_Date) >=1 
	and year(vr.Request_Date)=2019)
	--order by COUNT(*)) 
	AS NumberOfChannelsIn2019
FROM Viewers v 
ORDER BY Viewer_id


-- Final Answer below:
-- Query displaying only users who watched all channels for at least an hour in 2019:
SELECT S.Viewer_id, S.Username, S.NumberOfChannelsIn2019 FROM ( 
	SELECT v.Viewer_id, v.Username,
		(Select COUNT(*) as NumberOfRequests from Viewing_Request vr 
		join Channels c on c.Channel_name=vr.Channel_name and vr.Viewer_id=v.Viewer_id
		WHERE 
		Datediff(hour, vr.Request_Date, vr.Status_Date) >=1 
		and year(vr.Request_Date)=2019)
		AS NumberOfChannelsIn2019
	FROM Viewers v ) S
WHERE s.NumberOfChannelsIn2019=(SELECT COUNT(*) from Channels)
ORDER BY Viewer_id

		

--------------------- QUERY 3 ----------------------- 

-- I calculate only complited views i.e. those with status='served' or status='closed'
-- NOTE: To test calculation of Current day total views and average I used date 28.05.2020 (commented), since I have several records on that date

--- Query displaying all dates in requested period (fromdate - todate) for which any viewing requests are made on that date
DECLARE @todate datetime, @fromdate datetime
SELECT @fromdate='2020-05-01', @todate='2020-05-31'

;WITH calendar (DateData) AS (
    SELECT @fromdate AS Datetime
    UNION ALL
    SELECT DATEADD(day, 1, DateData)
    FROM Calendar
    WHERE DateData  < @todate
)

SELECT t1.DateData, vr.Channel_name, vr.Request_Date, vr.Status_Date
FROM calendar t1
JOIN Viewing_Request vr ON vr.Request_Date BETWEEN t1.DateData AND DATEADD(SECOND, 86340, DateData) --Request date is on day 'DateData'
--OPTION (MAXRECURSION 0)
GO

--- Query displaying Total daily views and Average daily views for all Channels
SELECT c.Channel_name, 
	(SELECT COUNT(*) FROM Viewing_Request vr 
	WHERE 
	vr.Request_Date=GETDATE()  --BETWEEN CONVERT(datetime, N'2020-05-28 00:00:00') AND CONVERT(datetime,N'2020-05-28 23:59:59')
	and (vr.Request_Status='served' or vr.Request_Status='closed')
	and c.Channel_name=vr.Channel_name
	GROUP BY vr.Channel_name) AS TodayTotalViews,

	(SELECT AVG(DailyViews) FROM (
		SELECT COUNT(*) as DailyViews FROM Viewing_Request vr 
		WHERE 
		vr.Request_Date=GETDATE() --BETWEEN CONVERT(datetime, N'2020-05-28 00:00:00') AND CONVERT(datetime,N'2020-05-28 23:59:59')
		and (vr.Request_Status='served' or vr.Request_Status='closed')
		and c.Channel_name=vr.Channel_name
		GROUP BY vr.Channel_name) AS Average)
		AS DailyAverage

FROM Channels c


---- Final answer:
---- Query displaying Channel with lowest TotalDailyViews/DailyAverge Ratio
SELECT TOP 1 S.Channel_name, S.Ratio FROM 
(
SELECT c.Channel_name, 
	(
	(SELECT COUNT(*) FROM Viewing_Request vr 
	WHERE 
	vr.Request_Date=GETDATE()  --BETWEEN CONVERT(datetime, N'2020-05-28 00:00:00') AND CONVERT(datetime,N'2020-05-28 23:59:59')
	and (vr.Request_Status='served' or vr.Request_Status='closed')
	and c.Channel_name=vr.Channel_name
	GROUP BY vr.Channel_name) / -- AS TodayTotalViews /

	(SELECT AVG(DailyViews) FROM (
		SELECT COUNT(*) as DailyViews FROM Viewing_Request vr 
		WHERE 
		vr.Request_Date=GETDATE()  --BETWEEN CONVERT(datetime, N'2020-05-28 00:00:00') AND CONVERT(datetime,N'2020-05-28 23:59:59')
		and (vr.Request_Status='served' or vr.Request_Status='closed')
		and c.Channel_name=vr.Channel_name
		GROUP BY vr.Channel_name) AS Average)
		--AS DailyAverage
	) AS Ratio
FROM Channels c
) S
ORDER BY Ratio ASC



--------------------- QUERY 4 ----------------------- 
----- Solution with creating temporary table of Unique Viewers per Channel from different countries
GO
if OBJECT_ID('#temp') IS NOT NULL  
	drop table #temp;
SELECT * INTO #temp FROM (SELECT S.Viewer_Country, S.Channel_name, COUNT(Viewer_id) AS UniqueViewers FROM 
		(SELECT DISTINCT R.Viewer_id, R.Channel_name, V.Viewer_Country FROM Viewing_Request R JOIN Viewers V ON R.Viewer_id = V.Viewer_id) S
			GROUP BY S.Viewer_Country,S.Channel_name) AS x;
 
WITH TOPTHREE AS (
    SELECT *, ROW_NUMBER() 
    OVER (
        PARTITION BY Viewer_Country 
        ORDER BY UniqueViewers ASC
    ) AS CountryRowNo 
    FROM #temp
)
SELECT * FROM TOPTHREE WHERE CountryRowNo <= 3
GO


------> 2nd Solution: First check all Unique Viewers per Channel from different countries
SELECT S.Viewer_Country, S.Channel_name, COUNT(Viewer_id) AS UniqueViewers FROM 
		(SELECT DISTINCT R.Viewer_id, R.Channel_name, V.Viewer_Country FROM Viewing_Request R JOIN Viewers V ON R.Viewer_id = V.Viewer_id) S
			GROUP BY S.Viewer_Country,S.Channel_name
			ORDER BY Viewer_Country, UniqueViewers


---- Final query 
---- Display top 3 records for each country -----
SELECT * FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY Viewer_Country ORDER BY UniqueViewers) AS RowNo 
FROM
	(SELECT S.Viewer_Country, S.Channel_name, COUNT(Viewer_id) AS UniqueViewers 
	FROM 
	(SELECT DISTINCT R.Viewer_id, Channel_name, Viewer_Country FROM Viewing_Request R 
	JOIN Viewers V ON R.Viewer_id = V.Viewer_id) S
	GROUP BY S.Viewer_Country, S.Channel_name) as results) as x WHERE RowNo <= 3




--------------------- QUERY 5 ----------------------- 

--- Here I assume a completed view is one with status='closed' or status='served' since 
--- if I take only 'served' requests the amount of data is insufficient

---- Displaying all Channels with number of short views their sharing:
SELECT DISTINCT vr.Channel_name, COUNT(*) as NumberOfShortViews from Viewing_Request vr 
	--join Channels c on c.Channel_name=vr.Channel_name 
	where 
	Datediff(SECOND, vr.Request_Date, vr.Status_Date)<15 
	and (vr.Request_Status='served' or vr.Request_Status='closed')
	GROUP BY vr.Channel_name
	ORDER BY NumberOfShortViews DESC


----- Final answer:
----- Displaying top 3 Channels with largest amount of Short views:
SELECT TOP 3 c.Channel_name, 
	(
	SELECT  COUNT(*)  from Viewing_Request vr 
	where 
	Datediff(SECOND, vr.Request_Date, vr.Status_Date)<15 
	and (vr.Request_Status='served' or vr.Request_Status='closed')
	and vr.Channel_name=c.Channel_name
	GROUP BY vr.Channel_name
	) AS  NumberOfShortViews,

	(SELECT COUNT(*)  from Viewing_Request vr 
	where
	--Datediff(SECOND, vr.Request_Date, vr.Status_Date)<15
	(vr.Request_Status='served' or vr.Request_Status='closed')
	and vr.Channel_name=c.Channel_name)
	AS ALLViews

FROM Channels c
GROUP BY c.Channel_name
ORDER BY NumberOfShortViews DESC


