--liquibase formatted sql
--changeset adrian_koszalka:2

CREATE TABLE youtube_channels (
	"channel_id" TEXT UNIQUE,
	"etag" TEXT,
	"type" TEXT,
	"title" TEXT,
	"country_code" TEXT,
	"description" TEXT,
	"published_at" TIMESTAMPTZ,
	"view_count" INTEGER,
	"video_count" INTEGER,
	"subscriber_count" INTEGER,
	"hidden_subscriber_count" BOOLEAN,
	"upload_playlist_id" TEXT
);

CREATE TABLE youtube_videos (
	"video_id" TEXT UNIQUE,
	"etag" TEXT,
	"type" TEXT,
	"license" TEXT,
	"embeddable" BOOLEAN,
	"made_for_kids" BOOLEAN,
	"upload_status" TEXT,
	"privacy_status" TEXT,
	"public_stats_viewable" BOOLEAN,
	"tags" TEXT,
	"category_id" INTEGER,
	"title" TEXT,
	"channel_id" TEXT REFERENCES youtube_channels(channel_id),
	"description" TEXT,
	"published_at" TIMESTAMPTZ,
	"live_broadcast_content" TEXT,
	"like_count" INTEGER,
	"view_count" INTEGER,
	"comment_count" INTEGER,
	"favorite_count" INTEGER,
	"topic_categories" TEXT,
	"caption" BOOLEAN,
	"duration" TEXT,
	"dimension" TEXT,
	"definition" TEXT,
	"projection" TEXT,
	"contentRating" JSONB,
	"licensedContent" BOOLEAN,
	"recordingDetails" JSONB
);

CREATE TABLE youtube_comments (
	"comment_id" TEXT UNIQUE,
	"video_id" TEXT REFERENCES youtube_videos(video_id),
	"can_reply" BOOLEAN,
	"is_public" BOOLEAN,
	"kind" TEXT,
	"can_rate" BOOLEAN,
	"like_count" INTEGER,
	"updated_at" TIMESTAMPTZ,
	"published_at" TIMESTAMPTZ,
	"text_display" TEXT,
	"text_original" TEXT,
	"viewer_rating" TEXT,
	"viewer_id" TEXT,
	"viewer_channel_url" TEXT,
	"viewer_display_name" TEXT,
	"viewer_image_url" TEXT,
	"total_reply_count" INTEGER
);

CREATE TABLE youtube_comment_replies (
	"reply_id" TEXT,
	"video_id" TEXT REFERENCES youtube_videos(video_id),
	"parent_id" TEXT REFERENCES youtube_comments(comment_id),
	"like_count" INTEGER,
	"can_rate" BOOLEAN,
	"updated_at" TIMESTAMPTZ,
	"published_at" TIMESTAMPTZ,
	"text_display" TEXT,
	"text_original" TEXT,
	"viewer_rating" TEXT,
	"author_channel_id" TEXT,
	"author_channel_url" TEXT,
	"author_display_name" TEXT,
	"author_profile_image_url" TEXT
);

--rollback DROP TABLE youtube_comment_replies;
--rollback DROP TABLE youtube_comments;
--rollback DROP TABLE youtube_videos;
--rollback DROP TABLE youtube_channels;