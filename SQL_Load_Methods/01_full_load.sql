CREATE OR ALTER PROCEDURE DW.FullLoad_SpotifyTracks
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        DELETE FROM DW.SpotifyTracks;

        INSERT INTO DW.SpotifyTracks
        (
            TrackID, Artists, AlbumName, TrackName,
            Popularity, DurationMs, Explicit,
            Danceability, Energy, TrackGenre
        )
        SELECT
            track_id, artists, album_name, track_name,
            popularity, duration_ms, explicit,
            danceability, energy, track_genre
        FROM Landing.SpotifyTracks;

        INSERT INTO Config.LoadAudit
        (
            ProcedureName,
            LoadType,
            Status
        )
        VALUES
        (
            'DW.FullLoad_SpotifyTracks',
            'Full Load',
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
            'DW.FullLoad_SpotifyTracks',
            'Full Load',
            'Failed',
            ERROR_MESSAGE()
        );

    END CATCH
END;
GO
