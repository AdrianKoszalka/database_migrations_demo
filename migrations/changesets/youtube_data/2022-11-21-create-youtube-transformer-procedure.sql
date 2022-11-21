--liquibase formatted sql
--changeset adrian_koszalka:3

DO '
BEGIN
  EXECUTE ''
    CREATE PROCEDURE transform_youtube_data()
    LANGUAGE plpgsql
    AS $$
    BEGIN

      WITH channels AS (
      SELECT jsonb_array_elements("raw_data"->''''items'''') AS channel
        FROM youtube_data.raw_youtube_channels
      )
      INSERT INTO youtube_data.youtube_channels (
        "channel_id",
        "etag",
        "type",
        "title",
        "country_code",
        "description",
        "published_at",
        "view_count",
        "video_count",
        "subscriber_count",
        "hidden_subscriber_count",
        "upload_playlist_id"
      )
      SELECT
        channel->>''''id'''' AS "channel_id",
        channel->>''''etag'''' AS "etag",
        channel->>''''kind'''' AS "type",
        channel->''''snippet''''->>''''title'''' AS "title",
        channel->''''snippet''''->>''''country'''' AS "country_code",
        channel->''''snippet''''->>''''description'''' AS "description",
        (channel->''''snippet''''->>''''publishedAt'''')::TIMESTAMPTZ AS "published_at",
        (channel->''''statistics''''->>''''viewCount'''')::INTEGER AS "view_count",
        (channel->''''statistics''''->>''''videoCount'''')::INTEGER AS "video_count",
        (channel->''''statistics''''->>''''subscriberCount'''')::INTEGER AS "subscriber_count",
        (channel->''''statistics''''->>''''hiddenSubscriberCount'''')::BOOLEAN AS "hidden_subscriber_count",
        channel->''''contentDetails''''->''''relatedPlaylists''''->>''''uploads'''' AS "upload_playlist_id"
      FROM channels;

      WITH videos AS (
      SELECT jsonb_array_elements("raw_data"->''''items'''') AS video
        FROM youtube_data.raw_youtube_videos
      )
      INSERT INTO youtube_data.youtube_videos (
        "video_id",
        "etag",
        "type",
        "license",
        "embeddable",
        "made_for_kids",
        "upload_status",
        "privacy_status",
        "public_stats_viewable",
        "tags",
        "category_id",
        "title",
        "channel_id",
        "description",
        "published_at",
        "live_broadcast_content",
        "like_count",
        "view_count",
        "comment_count",
        "favorite_count",
        "topic_categories",
        "caption",
        "duration",
        "dimension",
        "definition",
        "projection",
        "contentRating",
        "licensedContent",
        "recordingDetails"
      )
      SELECT
        video->>''''id'''' AS "video_id",
        video->>''''etag'''' AS "etag",
        video->>''''kind'''' AS "type",
        video->''''status''''->>''''license'''' AS "license",
        (video->''''status''''->>''''embeddable'''')::BOOLEAN AS "embeddable",
        (video->''''status''''->>''''madeForKids'''')::BOOLEAN AS "made_for_kids",
        video->''''status''''->>''''uploadStatus'''' AS "upload_status",
        video->''''status''''->>''''privacyStatus'''' AS "privacy_status",
        (video->''''status''''->>''''publicStatsViewable'''')::BOOLEAN AS "public_stats_viewable",
        video->''''snippet''''->>''''tags'''' AS "tags",
        (video->''''snippet''''->>''''categoryId'''')::INTEGER AS "category_id",
        video->''''snippet''''->>''''title'''' AS "title",
        video->''''snippet''''->>''''channelId'''' AS "channel_id",
        video->''''snippet''''->>''''description'''' AS "description",
        (video->''''snippet''''->>''''publishedAt'''')::TIMESTAMPTZ AS "published_at",
        video->''''snippet''''->>''''liveBroadcastContent'''' AS "live_broadcast_content",
        (video->''''statistics''''->>''''likeCount'''')::INTEGER AS "like_count",
        (video->''''statistics''''->>''''viewCount'''')::INTEGER AS "view_count",
        (video->''''statistics''''->>''''commentCount'''')::INTEGER AS "comment_count",
        (video->''''statistics''''->>''''favoriteCount'''')::INTEGER AS "favorite_count",
        video->''''topicDetails''''->>''''topicCategories'''' AS "topic_categories",
        (video->''''contentDetails''''->>''''caption'''')::BOOLEAN AS "caption",
        video->''''contentDetails''''->>''''duration'''' AS "duration",
        video->''''contentDetails''''->>''''dimension'''' AS "dimension",
        video->''''contentDetails''''->>''''definition'''' AS "definition",
        video->''''contentDetails''''->>''''projection'''' AS "projection",
        (video->''''contentDetails''''->>''''contentRating'''')::JSONB AS "contentRating",
        (video->''''contentDetails''''->>''''licensedContent'''')::BOOLEAN AS "licensedContent",
        (video->''''recordingDetails'''')::JSONB AS "recordingDetails"
      FROM videos;

      WITH video_comments AS (
      SELECT jsonb_array_elements("raw_data"->''''items'''')  AS video_comment
        FROM youtube_data.raw_youtube_video_comments
      )
      INSERT INTO youtube_data.youtube_comments (
        "comment_id",
        "video_id",
        "can_reply",
        "is_public",
        "kind",
        "can_rate",
        "like_count",
        "updated_at",
        "published_at",
        "text_display",
        "text_original",
        "viewer_rating",
        "viewer_id",
        "viewer_channel_url",
        "viewer_display_name",
        "viewer_image_url",
        "total_reply_count"
      )
      SELECT
        video_comment->>''''id'''' AS "comment_id",
        video_comment->''''snippet''''->>''''videoId'''' AS "video_id",
        (video_comment->''''snippet''''->>''''canReply'''')::BOOLEAN AS "can_reply",
        (video_comment->''''snippet''''->>''''isPublic'''')::BOOLEAN AS "is_public",
        video_comment->''''snippet''''->''''topLevelComment''''->>''''kind'''' AS "kind",
        (video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''canRate'''')::BOOLEAN AS "can_rate",
        (video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''likeCount'''')::INTEGER AS "like_count",
        (video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''updatedAt'''')::TIMESTAMPTZ AS "updated_at",
        (video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''publishedAt'''')::TIMESTAMPTZ AS "published_at",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''textDisplay'''' AS "text_display",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''textOriginal'''' AS "text_original",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''viewerRating'''' AS "viewer_rating",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->''''authorChannelId''''->>''''value'''' AS "viewer_id",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''authorChannelUrl'''' AS "viewer_channel_url",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''authorDisplayName'''' AS "viewer_display_name",
        video_comment->''''snippet''''->''''topLevelComment''''->''''snippet''''->>''''authorProfileImageUrl'''' AS "viewer_image_url",
        (video_comment->''''snippet''''->>''''totalReplyCount'''')::INTEGER AS "total_reply_count"
      FROM video_comments;

      WITH video_comments AS (
      SELECT jsonb_array_elements("raw_data"->''''items'''')  AS video_comment
        FROM youtube_data.raw_youtube_video_comments
      ), video_replies AS (
      SELECT
        jsonb_array_elements(video_comment->''''replies''''->''''comments'''') AS video_reply
      FROM video_comments
      WHERE video_comment->>''''replies'''' IS NOT NULL
      )
      INSERT INTO youtube_data.youtube_comment_replies (
        "reply_id",
        "video_id",
        "parent_id",
        "like_count",
        "can_rate",
        "updated_at",
        "published_at",
        "text_display",
        "text_original",
        "viewer_rating",
        "author_channel_id",
        "author_channel_url",
        "author_display_name",
        "author_profile_image_url"
      )
      SELECT
        video_reply->>''''id'''' AS reply_id,
        video_reply->''''snippet''''->>''''videoId'''' AS video_id,
        video_reply->''''snippet''''->>''''parentId'''' AS parent_id,
        (video_reply->''''snippet''''->>''''likeCount'''')::INTEGER AS like_count,
        (video_reply->''''snippet''''->>''''canRate'''')::BOOLEAN AS can_rate,
        (video_reply->''''snippet''''->>''''updatedAt'''')::TIMESTAMPTZ AS updated_at,
        (video_reply->''''snippet''''->>''''publishedAt'''')::TIMESTAMPTZ AS published_at,
        video_reply->''''snippet''''->>''''textDisplay'''' AS text_display,
        video_reply->''''snippet''''->>''''textOriginal'''' AS text_original,
        video_reply->''''snippet''''->>''''viewerRating'''' AS viewer_rating,
        video_reply->''''snippet''''->''''authorChannelId''''->>''''value'''' AS author_channel_id,
        video_reply->''''snippet''''->>''''authorChannelUrl'''' AS author_channel_url,
        video_reply->''''snippet''''->>''''authorDisplayName'''' AS author_display_name,
        video_reply->''''snippet''''->>''''authorProfileImageUrl'''' AS author_profile_image_url
      FROM video_replies;

      COMMIT;
    END; $$;
  '';
END ';

--rollback DROP PROCEDURE transform_youtube_data;