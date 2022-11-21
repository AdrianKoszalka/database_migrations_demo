--liquibase formatted sql
--changeset adrian_koszalka:1

CREATE TABLE raw_youtube_channels (
  raw_data jsonb NULL,
  arguments jsonb NULL
);

CREATE TABLE raw_youtube_videos (
  raw_data jsonb NULL,
  arguments jsonb NULL
);

CREATE TABLE raw_youtube_video_comments (
  raw_data jsonb NULL,
  arguments jsonb NULL
);

--rollback DROP TABLE raw_youtube_video_comments;
--rollback DROP TABLE raw_youtube_videos;
--rollback DROP TABLE raw_youtube_channels;
