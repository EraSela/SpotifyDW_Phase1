USE SpotifyDW;
GO

CREATE OR ALTER PROCEDURE DW.Upsert_SpotifyTracks
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE d
        SET
            d.Artists = l.artists,
            d.AlbumName = l.album_name,
            d.TrackName = l.track_name,
            d.Popularity = l.popularity,
            d.DurationMs = l.duration_ms,
            d.Explicit = l.explicit,
            d.Danceability = l.danceability,
            d.Energy = l.energy,
            d.TrackGenre = l.track_genre,
            d.LoadDate = GETDATE()
        FROM DW.SpotifyTracks d
        JOIN Landing.SpotifyTracks l
            ON d.TrackID = l.track_id;

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
        (ProcedureName, LoadType, Status)
        VALUES
        ('DW.Upsert_SpotifyTracks', 'Upsert', 'Success');

    END TRY
    BEGIN CATCH
        INSERT INTO Config.LoadAudit
        (ProcedureName, LoadType, Status, ErrorMessage)
        VALUES
        ('DW.Upsert_SpotifyTracks', 'Upsert', 'Failed', ERROR_MESSAGE());
    END CATCH
END;
GO