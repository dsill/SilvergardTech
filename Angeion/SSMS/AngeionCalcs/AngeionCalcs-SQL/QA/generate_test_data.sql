/*
    select * from [dbo].[ImportLog]
    select floor(rand() * (10-5) + 5)
*/

--/*
--Update all import/dequeue dates
declare @StartDate datetime
,       @minBatchID int
,       @randFloorSmall int
,       @randFloorLarge int
,       @randCeilingSmall int
,       @randCeilingLarge int
,       @randInt int
,       @randMultiplyerSmall int
,       @randMultiplyerLarge int

select  @StartDate = '7/1/2016'
,       @randFloorSmall = 1
,       @randFloorLarge = 10
,       @randCeilingSmall = 10
,       @randCeilingLarge = 50

declare @tbl_BatchList table (BatchID int)
declare @tbl_DateListPre table (ImportLogID int, 
                             BatchID int, 
                             DateFileImportStarted datetime, 
                             DateFileImportFinished datetime)
declare @tbl_DateList table (ImportLogID int, 
                             BatchID int, 
                             DateFileImportStarted datetime, 
                             DateFileImportFinished datetime, 
                             FileImportTimeInMS int,
                             DateDequeueStarted datetime, 
                             DateDequeueFinished datetime, 
                             DequeueTimeInMS int)
declare @tbl_DequeueList table (BatchID int, DateFileImportStarted datetime)

insert into @tbl_BatchList
select distinct BatchID from [dbo].[ImportLog]

while exists(select * from @tbl_BatchList)
begin

    select  @minBatchID = min(BatchID)
    ,       @randInt = floor(rand() * (@randCeilingLarge - @randFloorSmall) + @randFloorSmall)
    ,       @randMultiplyerSmall = floor(rand() * (@randCeilingLarge - @randFloorSmall) + @randFloorSmall)
    ,       @randMultiplyerLarge = floor(rand() * (@randCeilingLarge - @randFloorLarge) + @randFloorLarge)
    from    @tbl_BatchList

    
    insert into @tbl_DateListPre
    select  a.ImportLogID
    ,       a.BatchID
    ,       dateadd(ms, @randInt*@randMultiplyerSmall, isnull(LAG(b.DateFileImportFinished) OVER (ORDER BY b.ImportLogID), @StartDate))
    ,       dateadd(ms, a.QtyRowsImported, dateadd(ms, @randInt*@randMultiplyerSmall, isnull(LAG(b.DateFileImportFinished) OVER (ORDER BY b.ImportLogID), @StartDate)))
    from    [dbo].[ImportLog] a
            left join @tbl_DateList b on a.ImportLogID = b.ImportLogID
    where   a.BatchID = @minBatchID

    insert into @tbl_DateList
    select  a.ImportLogID
    ,       a.BatchID
    ,       dateadd(ms, @randInt*@randMultiplyerSmall, isnull(LAG(b.DateFileImportFinished) OVER (ORDER BY b.ImportLogID), @StartDate))
    ,       dateadd(ms, a.QtyRowsImported, dateadd(ms, @randInt*@randMultiplyerSmall, isnull(LAG(b.DateFileImportFinished) OVER (ORDER BY b.ImportLogID), @StartDate)))
    ,       NULL
    ,       NULL
    ,       NULL
    ,       NULL
    from    [dbo].[ImportLog] a
            left join @tbl_DateListPre b on a.ImportLogID = b.ImportLogID
    where   a.BatchID = @minBatchID


    select  @StartDate = dateadd(mi, @randInt*@randMultiplyerLarge, max(DateFileImportFinished))
    from    @tbl_DateList

    delete  from @tbl_BatchList
    where   BatchID = @minBatchID
end

update  @tbl_DateList
set     FileImportTimeInMS = datediff(ms, DateFileImportStarted, DateFileImportFinished)


insert into @tbl_DequeueList
select  [BatchID]
,       max([DateFileImportStarted])
from    @tbl_DateList
group by [BatchID]

update  a
set     a.DateDequeueStarted = dateadd(s, floor(rand() * (@randCeilingSmall - @randFloorSmall) + @randFloorSmall), b.DateFileImportStarted)
from    @tbl_DateList a
        inner join @tbl_DequeueList b on a.BatchID = b.BatchID

update  a
set     a.DateDequeueFinished = dateadd(ms, b.SumFileImportTimeInMS/8, a.DateDequeueStarted)
from    @tbl_DateList a
        inner join (select BatchID, sum(FileImportTimeInMS) as SumFileImportTimeInMS from @tbl_DateList group by BatchID) b on a.BatchID = b.BatchID

update  a
set     a.DequeueTimeinMS = datediff(ms, a.DateDequeueStarted, a.DateDequeueFinished)
from    @tbl_DateList a




--select * from @tbl_DateList

update  a 
set     a.[DateFileImportStarted] = b.[DateFileImportStarted]
,       a.[DateFileImportFinished] = b.[DateFileImportFinished]
,       a.[FileImportTimeInMS] = b.[FileImportTimeInMS]
from    [dbo].[ImportLog] a
        inner join @tbl_DateList b on a.ImportLogID = b.ImportLogID

update  a 
set     a.[DateDequeueStarted] = b.[DateDequeueStarted]
,       a.[DateDequeueFinished] = b.[DateDequeueFinished]
,       a.[DequeueTimeInMS] = b.[DequeueTimeInMS]
from    [dbo].[ImportLog] a
        inner join @tbl_DateList b on a.ImportLogID = b.ImportLogID
where   a.[ImportStatusID] = 40

update  a
set     a.[ImportMsg] = case when a.[ImportStatusID] = 50 then c.ErrorMsg
                            else b.[ImportStatusDescription]
                        end
from    [dbo].[ImportLog] a
        inner join [dbo].[lk_ImportStatus] b on a.ImportStatusID = b.ImportStatusID
        cross apply (select top 1 ErrorMsg from [dbo].[lk_ErrorMsg] where a.QtyRowsInFile = a.QtyRowsInFile order by NEWID()) c

update  a
set     a.[QtyClaims] = NULL
,       a.[QtyTransactions] = NULL
from    [dbo].[ImportLog] a
where   a.ImportStatusID = 50


delete 
from    [dbo].[ImportLog]
where   DateFileImportStarted > getdate()

--*/