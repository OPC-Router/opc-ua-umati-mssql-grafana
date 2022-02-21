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
		[ActualCycle] [int] NOT NULL,
		[RunsPlanned] [int] NOT NULL,
		[RunsCompleted] [int] NOT NULL,
		[ErrorTime] [int] NOT NULL,
		[StandbyTime] [int] NOT NULL,
		[WorkingTime] [int] NOT NULL
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
		[Timestamp] [datetime] NOT NULL,
		[RecipeInRun] [bit] NOT NULL,
		[SignalLamp1] [bit] NOT NULL,
		[SignalLamp2] [bit] NOT NULL,
		[SignalLamp3] [bit] NOT NULL,
		[Calibrated] [bit] NOT NULL,
		[MachineOn] [bit] NOT NULL,
		[Moving] [bit] NOT NULL,
		[currentState] [int] NOT NULL,
	) ON [PRIMARY]
END
GO"
sleep infinity
