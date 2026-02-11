BEGIN;
CREATE TYPE privacy_level AS ENUM ('public', 'friends', 'private');
CREATE TYPE relationship_status AS ENUM ('single', 'in_a_relationship', 'engaged', 'married', 'complicated', 'prefer_not_to_say');
CREATE TYPE reaction_type AS ENUM ('like', 'love', 'haha', 'wow', 'sad', 'angry', 'care');
CREATE TYPE friendship_status AS ENUM ('pending', 'accepted', 'declined', 'blocked');
CREATE TYPE group_role AS ENUM ('member', 'moderator', 'admin');
CREATE TYPE page_role AS ENUM ('editor', 'moderator', 'admin', 'analyst');
CREATE TYPE media_type AS ENUM ('image', 'video', 'audio', 'document');
CREATE TYPE story_type AS ENUM ('image', 'video', 'text');
CREATE TYPE message_content_type AS ENUM ('text', 'image', 'video', 'file', 'voice', 'sticker');
CREATE TYPE notification_type AS ENUM (
    'friend_request','friend_accept','post_like','post_comment','comment_like',
    'mention','group_invite','event_invite','message','page_invite','story_reply','marketplace_offer'
);
CREATE TYPE report_status AS ENUM ('open', 'in_review', 'resolved', 'rejected');
CREATE TYPE report_target_type AS ENUM ('user', 'post', 'comment', 'group', 'page', 'message', 'story', 'reel', 'listing');
CREATE TYPE event_privacy AS ENUM ('public', 'friends', 'group_only', 'private');
CREATE TYPE listing_status AS ENUM ('draft', 'active', 'sold', 'archived');
CREATE TYPE ad_status AS ENUM ('draft', 'active', 'paused', 'completed', 'rejected');
COMMIT;
