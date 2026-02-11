BEGIN;

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_posts_author_created ON posts(author_id, created_at DESC);
CREATE INDEX idx_posts_privacy_created ON posts(privacy, created_at DESC);
CREATE INDEX idx_comments_post_created ON comments(post_id, created_at DESC);
CREATE INDEX idx_post_reactions_post ON post_reactions(post_id);
CREATE INDEX idx_friendships_requester_status ON friendships(requester_id, status);
CREATE INDEX idx_friendships_addressee_status ON friendships(addressee_id, status);
CREATE INDEX idx_notifications_recipient_unread ON notifications(recipient_id, is_read, created_at DESC);
CREATE INDEX idx_messages_conversation_sent ON messages(conversation_id, sent_at DESC);
CREATE INDEX idx_reports_status_created ON reports(status, created_at DESC);
CREATE INDEX idx_reels_author_created ON reels(author_id, created_at DESC);
CREATE INDEX idx_stories_author_expires ON stories(author_id, expires_at DESC);
CREATE INDEX idx_listing_status_created ON marketplace_listings(status, created_at DESC);
CREATE INDEX idx_user_security_logs_user_created ON user_security_logs(user_id, created_at DESC);

COMMIT;
