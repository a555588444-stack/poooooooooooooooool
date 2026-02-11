# Faislook (فايسلووك) - Social Platform Blueprint

هذا المجلد يحتوي بنية ضخمة لمشروع **فايسلووك**: منصة اجتماعية عربية بقدرات شبيهة بـ Facebook + Discord.

## المحتويات
- `sql/` مخطط PostgreSQL كبير ومجزّأ.
- `docs/` توثيق الميزات، API مقترح، ملاحظات التوسع، ودليل النشر العلني.
- `scripts/verify_sql_structure.py` فحص آلي لقياس حجم المخطط.

## الميزات الأساسية
- نظام حسابات وتسجيل دخول وتسجيل جديد.
- Social Graph: أصدقاء، متابعة، حظر، Close Friends.
- محتوى متقدم: Posts, Stories, Reels, Marketplace.
- مجتمع لحظي: Servers/Channels/Voice Sessions.
- إدارة وإعلانات وتحليلات.
- عناصر توسّع: indexes, views, triggers, partitioning, sharding metadata.

## التنفيذ
1. شغّل ملفات SQL حسب الترتيب داخل `sql/`.
2. أو استخدم الملف الجامع `sql/full_schema.sql` داخل بيئة psql.
3. للتحقق البنيوي:
   ```bash
   python3 social_platform/scripts/verify_sql_structure.py
   ```

## نشر الموقع علنياً
راجع:
- `social_platform/docs/PUBLIC_DEPLOYMENT_AR.md`
