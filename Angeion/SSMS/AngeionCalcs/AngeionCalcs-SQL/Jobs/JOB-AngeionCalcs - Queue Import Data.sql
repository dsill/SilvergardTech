USE [msdb]
GO

declare @ServerName nvarchar(255)
,       @DBUserName nvarchar(255)
,       @DBPassword nvarchar(255)
,       @CommandStr nvarchar(max) 

select  @ServerName = 'DS-LAPTOP'
,       @DBUserName = 'ImportWorker'
,       @DBPassword = 'beth7880?'
,       @CommandStr = N'/ISSERVER "\"\SSISDB\AngeionCalcs\AngeionCalcs\CaseImport.dtsx\"" /SERVER "\"' + @ServerName + '\"" /X86 /Par DBPassword;"\"' + @DBPassword + '\"" /Par "\"DB_ConnectionString\"";"\"Data Source=' + @ServerName + ';User ID=' + @DBUserName + ';Initial Catalog=AngeionCalcs;Provider=SQLNCLI11.1;Persist Security Info=True;Auto Translate=False;\"" /Par "\"CM.DBConnection.InitialCatalog\"";AngeionCalcs /Par "\"CM.DBConnection.RetainSameConnection(Boolean)\"";False /Par "\"CM.DBConnection.ServerName\"";"\"' + @ServerName + '\"" /Par "\"CM.DBConnection.UserName\"";' + @DBUserName + ' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'



/****** Object:  Job [AngeionCalcs - Queue Import Data]    Script Date: 12/5/2016 4:09:54 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 12/5/2016 4:09:54 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'AngeionCalcs - Queue Import Data', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import Excel Data]    Script Date: 12/5/2016 4:09:54 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import Excel Data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@CommandStr, 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 60 seconds', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161027, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'0c7adf7c-724d-46db-a10a-f2891b44fc64'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


