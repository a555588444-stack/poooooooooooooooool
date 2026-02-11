# نشر فايسلووك على Render (خدمة فعلية)

هذا الملف يجهّزك لنشر الموقع على خدمة **Render** برابط عام.

## ماذا تم تجهيزه؟
- ملف `render.yaml` يحتوي:
  - خدمة ويب بايثون (`faislook-web`) للتطبيق الديناميكي.
  - قاعدة بيانات PostgreSQL (`faislook-db`).
  - خدمة Static (`faislook-static`) لصفحة `study-site.html`.

## خطوات النشر
1. ارفع المشروع إلى GitHub.
2. ادخل إلى Render: `https://dashboard.render.com`.
3. اختر **New +** ثم **Blueprint**.
4. اربط مستودع GitHub الخاص بك.
5. Render سيقرأ `render.yaml` وينشئ الخدمات تلقائياً.
6. انتظر حتى تصبح الحالة **Live**.

## الروابط بعد النشر
- رابط التطبيق الديناميكي (حسابات/منشورات/دردشة):
  - `https://faislook-web.onrender.com`
- رابط الصفحة الثابتة:
  - `https://faislook-static.onrender.com`

> ملاحظة: الأسماء قد تختلف إذا Render غيّر الاسم لسبب توفر الدومين.

## متغيرات مهمة
- `SECRET_KEY` يتم توليدها تلقائياً في `render.yaml`.
- `DATABASE_URL` مرتبطة تلقائياً بقاعدة البيانات المُنشأة.
