CREATE OR ALTER PROCEDURE DW.FullLoad_SpotifyTracks
AS
BEGIN
    DELETE FROM DW.SpotifyTracks;

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
        track_id,
        artists,
        album_name,
        track_name,
        popularity,
        duration_ms,
        explicit,
        danceability,
        energy,
        track_genre
    FROM Landing.SpotifyTracks;
END;
GO
