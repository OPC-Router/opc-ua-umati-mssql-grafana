#!/bin/bash
RESULT=1
while [[ RESULT -ne 0 ]]
do
	/opt/mssql-tools/bin/sqlcmd -S $MSSQL_HOST -U $MSSQL_USERNAME -P $MSSQL_PASSWORD -b -Q "SELECT 1 AS connected" 2>/dev/null
	RESULT=$?
	echo "waiting for database"
done

/opt/mssql-tools/bin/sqlcmd -S $MSSQL_HOST -U $MSSQL_USERNAME -P $MSSQL_PASSWORD -Q "use master
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF DB_ID('ExampleDB') IS NULL
BEGIN
	CREATE DATABASE [ExampleDB]
END
GO

IF NOT EXISTS(SELECT * FROM sysobjects WHERE name='MachineProductivity' AND xtype='U')
BEGIN
	USE [ExampleDB]

	CREATE TABLE [dbo].[MachineProductivity](
		[SerialNumber] [varchar](50) NOT NULL,
		[AbsolutePiecesOut] [int] NOT NULL,
		[AbsolutePiecesIn] [int] NOT NULL,
		[RelativePiecesOut] [int] NOT NULL,
		[RelativePiecesIn] [int] NOT NULL,
		[FeedSpeed] [int] NOT NULL,
		[Timestamp] [datetime] NOT NULL,
		[ActualCycle] [int] NOT NULL
	) ON [PRIMARY]
END

IF NOT EXISTS(SELECT * FROM sysobjects WHERE name='MachineStatus' AND xtype='U')
BEGIN
	USE [ExampleDB]

	CREATE TABLE [dbo].[MachineStatus](
		[SerialNumber] [varchar](50) NOT NULL,
		[Alarm] [bit] NOT NULL,
		[Error] [bit] NOT NULL,
		[Warning] [bit] NOT NULL,
		[Timestamp] [datetime] NOT NULL
	) ON [PRIMARY]
END
GO"
sleep infinity
