USE [AngeionCalcs]
GO

if exists (select * from sysobjects where name = 'ImportLog_Add' and type = 'P')
begin
    drop procedure [dbo].[ImportLog_Add]
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
    Create date:	Sep 4, 2016
    Description:	Add record to ImportLog table at the beginning of the import

---------------------------------------------------------------------------------------------------------------------------
-- USAGE
---------------------------------------------------------------------------------------------------------------------------
    
    exec [dbo].[ImportLog_Add]	@ImportStatusID = 10
    ,                           @ImportFileName = 'example_file.xls'
	,							@ImportMsg = 'File import in process'

---------------------------------------------------------------------------------------------------------------------------
-- DEBUG
---------------------------------------------------------------------------------------------------------------------------

    select * from [dbo].[ImportLog]

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[ImportLog_Add]
(
    @ImportStatusID int,
    @ImportFileName nvarchar(255),
	@ImportMsg nvarchar(max)
)
AS
BEGIN

	SET NOCOUNT ON

    declare @ImportLogID int

	insert into [dbo].[ImportLog] 
	(	
		[BatchID]
	,	[DateFileImportStarted]
	,	[ImportStatusID]
    ,   [ImportFileName]
	,	[ImportMsg]
	)
	values 
	(
		NULL
	,	getutcdate()
	,	@ImportStatusID
    ,   @ImportFileName
	,	@ImportMsg
	)

    set @ImportLogID = scope_identity()

    select @ImportLogID as [ImportLogID]

END