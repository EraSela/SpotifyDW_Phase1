USE SpotifyDW;
GO

EXEC DW.FullLoad_SpotifyTracks;
EXEC DW.Append_SpotifyTracks;
EXEC DW.Upsert_SpotifyTracks;
EXEC DW.InsertUpdateDelete_SpotifyTracks;
EXEC DW.IncrementalLoad_SpotifyTracks;

SELECT COUNT(*) AS DWRows
FROM DW.SpotifyTracks;

SELECT *
FROM Config.LoadAudit;

SELECT *
FROM Config.IncrementalLoadConfig;