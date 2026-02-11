BEGIN;

CREATE VIEW post_engagement_summary AS
SELECT
    p.id AS post_id,
    p.author_id,
    COUNT(DISTINCT c.id) AS comments_count,
    COUNT(DISTINCT pr.user_id) AS reactions_count,
    COUNT(DISTINCT sp.user_id) AS saves_count
FROM posts p
LEFT JOIN comments c ON c.post_id = p.id AND c.is_deleted = FALSE
LEFT JOIN post_reactions pr ON pr.post_id = p.id
LEFT JOIN saved_posts sp ON sp.post_id = p.id
GROUP BY p.id, p.author_id;

CREATE VIEW user_social_stats AS
SELECT
    u.id AS user_id,
    u.username,
    (SELECT COUNT(*) FROM friendships f WHERE (f.requester_id = u.id OR f.addressee_id = u.id) AND f.status = 'accepted') AS friends_count,
    (SELECT COUNT(*) FROM user_follows uf WHERE uf.followee_id = u.id) AS followers_count,
    (SELECT COUNT(*) FROM posts p WHERE p.author_id = u.id AND p.is_deleted = FALSE) AS posts_count,
    (SELECT COUNT(*) FROM reels r WHERE r.author_id = u.id) AS reels_count
FROM users u;

CREATE MATERIALIZED VIEW trending_hashtags_daily AS
SELECT
    h.id AS hashtag_id,
    h.tag,
    DATE_TRUNC('day', p.created_at)::date AS day,
    COUNT(*) AS usage_count
FROM post_hashtags ph
JOIN hashtags h ON h.id = ph.hashtag_id
JOIN posts p ON p.id = ph.post_id
GROUP BY h.id, h.tag, DATE_TRUNC('day', p.created_at)::date;

COMMIT;
