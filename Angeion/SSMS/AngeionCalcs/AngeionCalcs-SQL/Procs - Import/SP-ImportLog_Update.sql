USE [AngeionCalcs]
GO

if exists (select * from sysobjects where name = 'ImportLog_Update' and type = 'P')
begin
    drop procedure [dbo].[ImportLog_Update]
end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
---------------------------------------------------------------------------------------------------------------------------
-- ABOUT
---------------------------------------------------------------------------------------------------------------------------

    Author:			Daniel Sill
    Create date:	Sep 2, 2016
    Description:	Update ImportLog table following import or any other logged activity. Input is a TVP in order to 
                    update a set records.

---------------------------------------------------------------------------------------------------------------------------
-- USAGE
---------------------------------------------------------------------------------------------------------------------------

    exec [dbo].[ImportLog_Update]	@ImportLogList = @table_ImportLogList

---------------------------------------------------------------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------------------------------------------------------------

    select * from [dbo].[ImportLog]

    select  * --distinct ImportLogID, ImportStatusID
    from    [dbo].[ImportQueue]
    where   [ImportStatusID] = 10

    --dbo.intList TVP
    [ImportLogID] int NULL
    [BatchID] int NULL
    [QtyRowsInFile] int NULL
    [QtyRowsImported] int NULL
    [QtyRowsFail] int NULL
    [QtyClaims] int NULL
    [QtyTransactions] int NULL
    [isUpdate] bit NULL
    [ImportStatusID] int NULL
    [ImportMsg] nvarchar(max) NULL

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ImportLog_Update]
(
	@ImportLogList dbo.ImportLogList READONLY,
    @isDebug bit = 0
)
AS
BEGIN

	SET NOCOUNT ON

    declare @CurrentUTCDate datetime  
    set     @CurrentUTCDate =  getutcdate()



    if (@isDebug = 0)
    begin

        --update log table
	    update	a
	    set		a.[BatchID] = isnull(b.[BatchID], a.[BatchID])
        ,		a.[DateFileImportFinished] = case when b.[ImportStatusID] = 20 then @CurrentUTCDate else a.[DateFileImportFinished] end --completed file import - set time finished
        ,       a.[FileImportTimeInMS] = case when b.[ImportStatusID] = 20 then datediff(ms, a.[DateFileImportStarted], @CurrentUTCDate) else a.[FileImportTimeInMS] end --completed file import - set time elapsed
        ,       a.[QtyRowsInFile] = isnull(b.[QtyRowsInFile], a.[QtyRowsInFile])
        ,       a.[QtyRowsImported] = isnull(b.[QtyRowsImported], a.[QtyRowsImported])
        ,       a.[QtyRowsFail] = isnull(b.[QtyRowsFail], a.[QtyRowsFail])
        ,		a.[DateDequeueStarted] = case when b.[ImportStatusID] = 30 then @CurrentUTCDate else a.[DateDequeueStarted] end --started dequeue process - set time started
        ,		a.[DateDequeueFinished] = case when b.[ImportStatusID] = 40 then @CurrentUTCDate else a.[DateDequeueFinished] end --completed dequeue process - set time finished
        ,       a.[DequeueTimeInMS] = case when b.[ImportStatusID] = 40 then datediff(ms, a.[DateDequeueStarted], @CurrentUTCDate) else a.[DequeueTimeInMS] end --completed dequeue process - set time elapsed
	    ,       a.[QtyClaims] = isnull(b.[QtyClaims], a.[QtyClaims])
	    ,		a.[QtyTransactions] = isnull(b.[QtyTransactions], a.[QtyTransactions])
        ,       a.[isUpdate] = isnull(b.[isUpdate], a.[isUpdate])
        ,		a.[ImportStatusID] = isnull(b.[ImportStatusID], a.[ImportStatusID])
	    ,		a.[ImportMsg] = isnull(b.[ImportMsg], a.[ImportMsg])
        from    [dbo].[ImportLog] a
                inner join @ImportLogList b on a.ImportLogID = b.ImportLogID

    end
    else
    begin

        --select debug data
        select	b.ImportLogID
        ,       isnull(b.[BatchID], a.[BatchID]) as [BatchID]
        ,		case when b.[ImportStatusID] = 20 then @CurrentUTCDate else a.[DateFileImportFinished] end as [DateFileImportFinished] --completed file import - set time finished
        ,       case when b.[ImportStatusID] = 20 then datediff(ms, a.[DateFileImportStarted], @CurrentUTCDate) else a.[FileImportTimeInMS] end as [FileImportTimeInMS] --completed file import - set time elapsed
        ,       isnull(b.[QtyRowsInFile], a.[QtyRowsInFile]) as [QtyRowsInFile]
        ,       isnull(b.[QtyRowsImported], a.[QtyRowsImported]) as [QtyRowsImported]
        ,       isnull(b.[QtyRowsFail], a.[QtyRowsFail]) as [QtyRowsFail]
        ,		case when b.[ImportStatusID] = 30 then @CurrentUTCDate else a.[DateDequeueStarted] end as [DateDequeueStarted] --started dequeue process - set time started
        ,		case when b.[ImportStatusID] = 40 then @CurrentUTCDate else a.[DateDequeueFinished] end as [DateDequeueFinished] --completed dequeue process - set time finished
        ,       case when b.[ImportStatusID] = 40 then datediff(ms, a.[DateDequeueStarted], @CurrentUTCDate) else a.[DequeueTimeInMS] end as [DequeueTimeInMS] --completed dequeue process - set time elapsed
        ,       isnull(b.[QtyClaims], a.[QtyClaims]) as [QtyClaims]
	    ,		isnull(b.[QtyTransactions], a.[QtyTransactions]) as [QtyTransactions]
        ,       isnull(b.[isUpdate], a.[isUpdate]) as [isUpdate]
	    ,		isnull(b.[ImportStatusID], a.[ImportStatusID]) as [ImportStatusID]
	    ,		isnull(b.[ImportMsg], a.[ImportMsg]) as [ImportMsg]
        from    [dbo].[ImportLog] a
                inner join @ImportLogList b on a.ImportLogID = b.ImportLogID

    
    end


END