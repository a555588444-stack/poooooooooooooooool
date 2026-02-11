# تشغيل فايسلووك محلياً بدون مشكلة `ERR_CONNECTION_REFUSED`

الخطأ يحدث غالباً لأن السيرفر **غير شغّال** أو شغّال على بورت مختلف.

## الطريقة الأسرع (محلي على نفس الجهاز)
```bash
cd /workspace/poooooooooooooooool
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
./start_local.sh
```

إذا اشتغل السيرفر سترى سطر مشابه:
`Running on http://127.0.0.1:5000`

افتح بعدها في نفس الجهاز:
- `http://localhost:5000`
- `http://127.0.0.1:5000`
- فحص الصحة: `http://127.0.0.1:5000/health`

## تشغيل عبر Docker
```bash
docker compose up --build
```
ثم افتح:
- `http://localhost:5000`

## إصلاح مشكلة رفض الاتصال
1. تأكد أن أمر التشغيل ما زال يعمل ولم يتوقف.
2. لا تغلق نافذة التيرمنال التي فيها السيرفر.
3. جرّب `127.0.0.1` بدل `localhost`.
4. تأكد أنه لا يوجد برنامج آخر حاجز البورت 5000.
5. إن استمرت المشكلة جرّب بورت آخر:
   ```bash
   PORT=8080 ./start_local.sh
   ```
   ثم افتح `http://127.0.0.1:8080`.

## رابط عام (اختياري)
للنشر العلني استخدم Render/Fly/Railway، مثال:
- `https://your-app-name.onrender.com`
