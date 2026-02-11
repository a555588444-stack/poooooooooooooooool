-- مثال تقسيم للجداول الثقيلة (اختياري)
-- ملاحظة: هذا نموذج هندسي، ويُنفّذ عادة قبل إدخال بيانات ضخمة.

BEGIN;

CREATE TABLE notifications_partitioned (
    LIKE notifications INCLUDING ALL
) PARTITION BY RANGE (created_at);

CREATE TABLE notifications_2026_q1 PARTITION OF notifications_partitioned
FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');

CREATE TABLE notifications_2026_q2 PARTITION OF notifications_partitioned
FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');

COMMIT;
