# نشر الموقع مجاناً (GitHub Pages)

تم تجهيز المشروع ليُنشر مجاناً على GitHub Pages عبر GitHub Actions.

## الخطوات
1. أنشئ مستودع GitHub جديد وارفع هذا المشروع إليه.
2. في إعدادات المستودع:
   - **Settings → Pages**
   - تأكد أن **Source = GitHub Actions**.
3. ادفع التغييرات على فرع `main` أو `work`.
4. انتظر اكتمال Workflow باسم **Deploy static site to GitHub Pages**.

## رابط الموقع
بعد نجاح النشر سيكون الرابط غالباً:

`https://<github-username>.github.io/<repo-name>/`

وسيحوّلك تلقائياً إلى `study-site.html`.

## ملاحظات
- النشر مجاني بالكامل.
- أي تحديث على الصفحة سيُنشَر تلقائياً بعد `git push`.
