# حل مشكلة GitHub Pages 404 (File not found)

إذا ظهر الخطأ:

`404 File not found`

فهذا يعني غالبًا أن GitHub Pages لم يجد `index.html` في النسخة المنشورة.

## ما تم إصلاحه في المشروع
- Workflow النشر يدعم الفروع: `main` و`master` و`work`.
- تمت إضافة خطوة تحقق من وجود `index.html` و`study-site.html` قبل النشر.
- تمت إضافة `404.html` تلقائيًا (نسخة من `index.html`) لتقليل أخطاء الروابط.
- تمت إضافة ملف `.nojekyll` داخل artifact حتى لا يتم تجاهل الملفات بشكل غير متوقع.

## ما يجب فعله في GitHub
1. ادخل إلى: `Settings > Pages`.
2. اختر **Source = GitHub Actions**.
3. ادفع التغييرات إلى الفرع الذي تستخدمه (`main` أو `master` أو `work`).
4. انتظر نجاح workflow: **Deploy static site to GitHub Pages**.

## رابط الموقع
بعد النجاح:
- `https://<username>.github.io/<repo>/`

## إذا استمرت المشكلة
- تأكد من اسم المستودع والرابط الصحيح.
- تأكد أن آخر workflow لصفحات GitHub حالته **Success**.
- امسح كاش المتصفح أو افتح الرابط في نافذة خاصة.
