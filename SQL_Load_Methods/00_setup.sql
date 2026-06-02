USE SpotifyDW;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Landing')
    EXEC('CREATE SCHEMA Landing');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'DW')
    EXEC('CREATE SCHEMA DW');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Config')
    EXEC('CREATE SCHEMA Config');
GO

IF OBJECT_ID('DW.SpotifyTracks', 'U') IS NULL
CREATE TABLE DW.SpotifyTracks
(
    TrackID NVARCHAR(100),
    Artists NVARCHAR(MAX),
    AlbumName NVARCHAR(MAX),
    TrackName NVARCHAR(MAX),
    Popularity INT,
    DurationMs INT,
    Explicit BIT,
    Danceability FLOAT,
    Energy FLOAT,
    TrackGenre NVARCHAR(100),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('Config.LoadAudit', 'U') IS NULL
CREATE TABLE Config.LoadAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ProcedureName NVARCHAR(100),
    LoadType NVARCHAR(50),
    Status NVARCHAR(20),
    ErrorMessage NVARCHAR(MAX),
    LoadDate DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('Config.IncrementalLoadConfig', 'U') IS NULL
CREATE TABLE Config.IncrementalLoadConfig
(
    ConfigID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100),
    LastLoadDate DATETIME
);
GO

IF NOT EXISTS (SELECT 1 FROM Config.IncrementalLoadConfig WHERE TableName = 'SpotifyTracks')
INSERT INTO Config.IncrementalLoadConfig
VALUES ('SpotifyTracks', '2000-01-01');
GO