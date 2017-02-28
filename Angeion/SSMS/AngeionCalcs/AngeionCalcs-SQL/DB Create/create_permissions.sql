USE [master]
GO

--create logins
CREATE LOGIN [ImportWorker] WITH PASSWORD=N'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [ReportUser] WITH PASSWORD=N'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


USE [AngeionCalcs]
GO

--create users
CREATE USER [ImportWorker] FOR LOGIN [ImportWorker] WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [ReportUser] FOR LOGIN [ReportUser] WITH DEFAULT_SCHEMA=[reports]
GO

--create schema
create schema [reports]
authorization [dbo]

create schema [temp]
authorization [dbo]

--grant permissions to users on schema
grant select, update, insert, delete on schema::[dbo] to [ImportWorker]
grant execute on schema::[dbo] to [ImportWorker]

grant select, update, insert, delete on schema::[temp] to [ImportWorker]
grant execute on schema::[temp] to [ImportWorker]

grant select, update, insert, delete on schema::[reports] to [ReportUser]
grant execute on schema::[reports] to [ReportUser]

