USE [AngeionCalcs]
GO

if exists (select * from sys.objects where schema_name(schema_id) = 'reports' and name = 'ImportDequeue_Overview' and type = 'P')
begin
    drop procedure [reports].[ImportDequeue_Overview]
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
    Description:	Returns overview of Import/Dequeue from ImportLog

---------------------------------------------------------------------------------------------------------------------------
-- USAGE
---------------------------------------------------------------------------------------------------------------------------
    
    exec [reports].[ImportDequeue_Overview]

---------------------------------------------------------------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------------------------------------------------------------

    select * from [dbo].[ImportLog]
    select * from [dbo].[lk_ImportStatus]

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [reports].[ImportDequeue_Overview]
(
    @TimeInterval_Minutes int NULL,
    @DateStart datetime NULL,
    @DateEnd datetime NULL
)
AS
BEGIN

	SET NOCOUNT ON

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
    ,       a.[isUpdate]
    from    [dbo].[ImportLog] a
            inner join [dbo].[lk_ImportStatus] b on a.[ImportStatusID] = b.[ImportStatusID]

END