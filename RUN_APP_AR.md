# تشغيل فايسلووك كبيئة كاملة (موقع + قاعدة بيانات)

## 1) تشغيل عبر Docker (المفضل)
```bash
docker compose up --build
```

بعد التشغيل افتح:
- `http://localhost:5000`

ستحصل على:
- إنشاء حساب
- تسجيل دخول
- نشر منشورات نص/صور/فيديو
- دردشة عامة
- تصفح المنشورات

## 2) تشغيل بدون Docker
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export FLASK_APP=faislook_app.main:app
export DATABASE_URL=sqlite:///faislook.db
flask run --host 0.0.0.0 --port 5000
```

## 3) نشر علني (رابط عام)
يمكن نشره على Render/Fly.io/Railway باستخدام Dockerfile.
الرابط سيكون مثل:
- `https://your-app-name.onrender.com`
