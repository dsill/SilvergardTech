USE [AngeionCalcs]
GO

if exists (select * from sys.objects where schema_name(schema_id) = 'reports' and name = 'ImportDequeue_Detail' and type = 'P')
begin
    drop procedure [reports].[ImportDequeue_Detail]
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
    Create date:	Dec 13, 2016
    Description:	Returns detail of Import/Dequeue record from ImportLog

---------------------------------------------------------------------------------------------------------------------------
-- USAGE
---------------------------------------------------------------------------------------------------------------------------
    
    exec [reports].[ImportDequeue_Detail] 838

---------------------------------------------------------------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------------------------------------------------------------

    select * from [dbo].[ImportLog]
    select * from [dbo].[lk_ImportStatus]

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [reports].[ImportDequeue_Detail]
(
    @ImportLogID int,
    @TimeOffsetHrs int = 0
)
AS
BEGIN

	SET NOCOUNT ON

    declare @BatchID int

    select  @BatchID = max(BatchID)
    from    [dbo].[ImportLog]
    where   [ImportLogID] = @ImportLogID

    if (@BatchID is not NULL)
    begin

        select  a.[ImportLogID]
        ,       a.[BatchID]
        ,       a.[DateFileImportStarted]
        ,       a.[DateFileImportFinished]
        ,       a.[FileImportTimeInMS]
        ,       a.[QtyRowsInFile]
        ,       a.[QtyRowsImported]
        ,       a.[QtyRowsFail]
        ,       a.[DateDequeueStarted]
        ,       a.[DateDequeueFinished]
        ,       a.[DequeueTimeInMS]
        ,       a.[QtyClaims]
        ,       a.[QtyTransactions]
        ,       a.[ImportFileName]
        ,       a.[ImportStatusID]
        ,       b.[ImportStatusName]
        ,       a.[ImportMsg]
        ,       case when a.[isUpdate] = 0 then 'New' else 'Update' end as [ImportType]
        from    [dbo].[ImportLog] a
                inner join [dbo].[lk_ImportStatus] b on a.[ImportStatusID] = b.[ImportStatusID]
        where   a.[BatchID] = @BatchID

    end
    else
    begin

        select  a.[ImportLogID]
        ,       a.[BatchID]
        ,       a.[DateFileImportStarted]
        ,       a.[DateFileImportFinished]
        ,       a.[FileImportTimeInMS]
        ,       a.[QtyRowsInFile]
        ,       a.[QtyRowsImported]
        ,       a.[QtyRowsFail]
        ,       a.[DateDequeueStarted]
        ,       a.[DateDequeueFinished]
        ,       a.[DequeueTimeInMS]
        ,       a.[QtyClaims]
        ,       a.[QtyTransactions]
        ,       a.[ImportFileName]
        ,       a.[ImportStatusID]
        ,       b.[ImportStatusName]
        ,       a.[ImportMsg]
        ,       case when a.[isUpdate] = 0 then 'New' else 'Update' end as [ImportType]
        from    [dbo].[ImportLog] a
                inner join [dbo].[lk_ImportStatus] b on a.[ImportStatusID] = b.[ImportStatusID]
        where   [ImportLogID] = @ImportLogID

    end
END