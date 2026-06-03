USE SpotifyDW;
GO

CREATE OR ALTER PROCEDURE DW.Append_SpotifyTracks
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        INSERT INTO DW.SpotifyTracks
        (
            TrackID, Artists, AlbumName, TrackName,
            Popularity, DurationMs, Explicit,
            Danceability, Energy, TrackGenre
        )
        SELECT
            l.track_id, l.artists, l.album_name, l.track_name,
            l.popularity, l.duration_ms, l.explicit,
            l.danceability, l.energy, l.track_genre
        FROM Landing.SpotifyTracks l
        WHERE NOT EXISTS (
            SELECT 1
            FROM DW.SpotifyTracks d
            WHERE d.TrackID = l.track_id
        );

        INSERT INTO Config.LoadAudit
        (
            ProcedureName,
            LoadType,
            Status
        )
        VALUES
        (
            'DW.Append_SpotifyTracks',
            'Append',
            'Success'
        );

    END TRY
    BEGIN CATCH

        INSERT INTO Config.LoadAudit
        (
            ProcedureName,
            LoadType,
            Status,
            ErrorMessage
        )
        VALUES
        (
            'DW.Append_SpotifyTracks',
            'Append',
            'Failed',
            ERROR_MESSAGE()
        );

    END CATCH
END;
GO