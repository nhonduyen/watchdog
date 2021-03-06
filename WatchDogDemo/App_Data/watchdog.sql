USE [master]
GO
/****** Object:  Database [WatchDog]    Script Date: 07/13/2018 11:20:23 ******/
CREATE DATABASE [WatchDog] ON  PRIMARY 
( NAME = N'WatchDog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\WatchDog.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WatchDog_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\WatchDog_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WatchDog] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WatchDog].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WatchDog] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [WatchDog] SET ANSI_NULLS OFF
GO
ALTER DATABASE [WatchDog] SET ANSI_PADDING OFF
GO
ALTER DATABASE [WatchDog] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [WatchDog] SET ARITHABORT OFF
GO
ALTER DATABASE [WatchDog] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [WatchDog] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [WatchDog] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [WatchDog] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [WatchDog] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [WatchDog] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [WatchDog] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [WatchDog] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [WatchDog] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [WatchDog] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [WatchDog] SET  ENABLE_BROKER
GO
ALTER DATABASE [WatchDog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [WatchDog] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [WatchDog] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [WatchDog] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [WatchDog] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [WatchDog] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [WatchDog] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [WatchDog] SET  READ_WRITE
GO
ALTER DATABASE [WatchDog] SET RECOVERY SIMPLE
GO
ALTER DATABASE [WatchDog] SET  MULTI_USER
GO
ALTER DATABASE [WatchDog] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [WatchDog] SET DB_CHAINING OFF
GO
USE [WatchDog]
GO
/****** Object:  Table [dbo].[STOCK]    Script Date: 07/13/2018 11:20:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STOCK](
	[CODE] [char](5) NOT NULL,
	[NAME] [nvarchar](50) NULL,
	[PRICE] [decimal](18, 0) NULL,
 CONSTRAINT [PK_STOCK] PRIMARY KEY CLUSTERED 
(
	[CODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_QueueActivationSender]    Script Date: 07/13/2018 11:20:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_QueueActivationSender] AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @h AS UNIQUEIDENTIFIER;
    DECLARE @mt NVARCHAR(200);

    RECEIVE TOP(1) @h = conversation_handle, @mt = message_type_name FROM [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender];

    IF @mt = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
    BEGIN
        END CONVERSATION @h;
    END

    IF @mt = N'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer' OR @mt = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
    BEGIN 
        

        END CONVERSATION @h;

        DECLARE @conversation_handle UNIQUEIDENTIFIER;
        DECLARE @schema_id INT;
        SELECT @schema_id = schema_id FROM sys.schemas WITH (NOLOCK) WHERE name = N'dbo';

        
        IF EXISTS (SELECT * FROM sys.triggers WITH (NOLOCK) WHERE object_id = OBJECT_ID(N'[dbo].[tr_dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender]')) DROP TRIGGER [dbo].[tr_dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender];

        
        IF EXISTS (SELECT * FROM sys.service_queues WITH (NOLOCK) WHERE schema_id = @schema_id AND name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender') EXEC (N'ALTER QUEUE [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender] WITH ACTIVATION (STATUS = OFF)');

        
        SELECT conversation_handle INTO #Conversations FROM sys.conversation_endpoints WITH (NOLOCK) WHERE far_service LIKE N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_%' ORDER BY is_initiator ASC;
        DECLARE conversation_cursor CURSOR FAST_FORWARD FOR SELECT conversation_handle FROM #Conversations;
        OPEN conversation_cursor;
        FETCH NEXT FROM conversation_cursor INTO @conversation_handle;
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            END CONVERSATION @conversation_handle WITH CLEANUP;
            FETCH NEXT FROM conversation_cursor INTO @conversation_handle;
        END
        CLOSE conversation_cursor;
        DEALLOCATE conversation_cursor;
        DROP TABLE #Conversations;

        
        IF EXISTS (SELECT * FROM sys.services WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Receiver') DROP SERVICE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Receiver];
        
        IF EXISTS (SELECT * FROM sys.services WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender') DROP SERVICE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender];

        
        IF EXISTS (SELECT * FROM sys.service_queues WITH (NOLOCK) WHERE schema_id = @schema_id AND name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Receiver') DROP QUEUE [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Receiver];
        
        IF EXISTS (SELECT * FROM sys.service_queues WITH (NOLOCK) WHERE schema_id = @schema_id AND name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender') DROP QUEUE [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_Sender];

        
        IF EXISTS (SELECT * FROM sys.service_contracts WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b') DROP CONTRACT [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b];
        
        IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Insert') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Insert];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Update') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Update];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Delete') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/StartMessage/Delete];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/CODE') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/CODE];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/NAME') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/NAME];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/PRICE') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/PRICE];
IF EXISTS (SELECT * FROM sys.service_message_types WITH (NOLOCK) WHERE name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/EndMessage') DROP MESSAGE TYPE [dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b/EndMessage];

        
        IF EXISTS (SELECT * FROM sys.objects WITH (NOLOCK) WHERE schema_id = @schema_id AND name = N'dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_QueueActivationSender') DROP PROCEDURE [dbo].[dbo_STOCK_7a0c25fb-050c-4275-b835-03fa5d79882b_QueueActivationSender];

        
    END
END
GO
