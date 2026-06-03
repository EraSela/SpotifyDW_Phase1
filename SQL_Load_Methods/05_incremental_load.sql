USE SpotifyDW;
GO

CREATE OR ALTER PROCEDURE DW.IncrementalLoad_SpotifyTracks
AS
BEGIN
    INSERT INTO DW.SpotifyTracks
    (
        TrackID,
        Artists,
        AlbumName,
        TrackName,
        Popularity,
        DurationMs,
        Explicit,
        Danceability,
        Energy,
        TrackGenre
    )
    SELECT
        l.track_id,
        l.artists,
        l.album_name,
        l.track_name,
        l.popularity,
        l.duration_ms,
        l.explicit,
        l.danceability,
        l.energy,
        l.track_genre
    FROM Landing.SpotifyTracks l
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM DW.SpotifyTracks d
        WHERE d.TrackID = l.track_id
    );

    UPDATE Config.IncrementalLoadConfig
    SET LastLoadDate = GETDATE()
    WHERE TableName = 'SpotifyTracks';
END;
GO