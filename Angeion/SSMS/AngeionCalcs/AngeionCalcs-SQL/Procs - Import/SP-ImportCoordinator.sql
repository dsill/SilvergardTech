USE [AngeionCalcs]
GO

if exists (select * from sysobjects where name = 'ImportCoordinator' and type = 'P')
begin
    drop procedure [dbo].[ImportCoordinator]
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
    Description:	Called from SSIS to update ImportQueue and ImportLog

---------------------------------------------------------------------------------------------------------------------------
-- USAGE
---------------------------------------------------------------------------------------------------------------------------

    exec [dbo].[ImportCoordinator]	@ImportLogID = 1
	,                               @ImportStatusID = 20
	--,                               @ImportMsg = 'Imported records queued for processing - DS'
    ,                               @isDebug = 1


---------------------------------------------------------------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ImportCoordinator]
(
	@ImportLogID int,
    @ImportStatusID int,
    @ImportMsg nvarchar(max) = NULL,
    @QtyRowsInFile int = NULL,
    @QtyRowsImported int = NULL,
    @QtyRowsFail int = NULL,
    @isDebug bit = 0
)
AS
BEGIN

	SET NOCOUNT ON

    declare @BatchID int
    ,       @QtyClaims int
    ,       @QtyTransactions int
    ,       @isUpdate bit
    
    select  @BatchID = NULL
    ,       @QtyClaims = NULL
    ,       @QtyTransactions = NULL
    ,       @isUpdate = NULL      

    --if ImportMsg is NULL then set according to ImportStatusID from [dbo].[lk_ImportStatus]
    select  @ImportMsg = isnull( @ImportMsg, a.[ImportStatusDescription])
    from    [dbo].[lk_ImportStatus] a
    where   a.[ImportStatusID] = @ImportStatusID


    -- insert input params into table variable of TVP type to be passed to [dbo].[ImportLog_BulkUpdate] which accepts TVP as input.
    -- this was done to allow log updates to be performed in bulk or individually with one set of logic.
    declare  @table_ImportLogList dbo.ImportLogList 

    insert into @table_ImportLogList 
    values (  @ImportLogID 
            , @BatchID
            , @QtyRowsInFile
            , @QtyRowsImported
            , @QtyRowsFail
            , @QtyClaims
            , @QtyTransactions
            , @isUpdate
            , @ImportStatusID
            , @ImportMsg)


    if (@isDebug = 0)
    begin

        -- update imported records in ImportQueue as needed
        update  a 
        set     a.[ImportStatusID] = isnull(b.[ImportStatusID], a.[ImportStatusID])
        from    [dbo].[ImportQueue] a
                inner join @table_ImportLogList b on a.[ImportLogID] = b.[ImportLogID]
                

        -- update ImportLog record
        exec [dbo].[ImportLog_Update] @ImportLogList = @table_ImportLogList

    end
    else
    begin
        
        select  a.*, b.*
        from    [dbo].[ImportQueue] a
                inner join @table_ImportLogList b on a.[ImportLogID] = b.[ImportLogID]

        select * from @table_ImportLogList

        exec [dbo].[ImportLog_Update] @ImportLogList = @table_ImportLogList, @isDebug = 1
    end

END