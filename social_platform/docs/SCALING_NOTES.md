# ملاحظات التوسّع (Scalability)

- استخدم Redis لتخزين جلسات المستخدم والـ feed cache.
- استخدم Queue (Kafka/RabbitMQ) للأحداث: notifications, emails, fanout.
- ابحث النصوص والهاشتاقات عبر Elasticsearch/OpenSearch.
- استخدم CDN للصور والفيديو.
- فعّل partitioning للجداول الضخمة: notifications, messages, reactions.
- ابنِ read replicas للقراءة الكثيفة.
- أضف rate limiting وWAF للحماية.
