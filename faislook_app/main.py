import os
from datetime import datetime

from flask import Flask, flash, redirect, render_template, request, session, url_for
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash, generate_password_hash

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "dev-secret-change-me")
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL", "sqlite:///faislook.db")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)


class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    text = db.Column(db.Text, nullable=False)
    media_url = db.Column(db.Text)
    media_type = db.Column(db.String(10))  # image | video
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    user = db.relationship("User", backref=db.backref("posts", lazy=True))


class ChatMessage(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    message = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    user = db.relationship("User", backref=db.backref("messages", lazy=True))


def current_user():
    uid = session.get("user_id")
    if not uid:
        return None
    return User.query.get(uid)


@app.route("/")
def home():
    user = current_user()
    posts = Post.query.order_by(Post.created_at.desc()).limit(50).all()
    chat_messages = ChatMessage.query.order_by(ChatMessage.created_at.desc()).limit(50).all()[::-1]
    return render_template("index.html", user=user, posts=posts, chat_messages=chat_messages)


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        if not username or not email or not password:
            flash("كل الحقول مطلوبة", "error")
            return redirect(url_for("register"))

        if User.query.filter((User.username == username) | (User.email == email)).first():
            flash("اسم المستخدم أو البريد مستخدم مسبقًا", "error")
            return redirect(url_for("register"))

        user = User(
            username=username,
            email=email,
            password_hash=generate_password_hash(password),
        )
        db.session.add(user)
        db.session.commit()

        session["user_id"] = user.id
        flash("تم إنشاء الحساب بنجاح", "success")
        return redirect(url_for("home"))

    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")
        user = User.query.filter_by(email=email).first()

        if not user or not check_password_hash(user.password_hash, password):
            flash("بيانات الدخول غير صحيحة", "error")
            return redirect(url_for("login"))

        session["user_id"] = user.id
        flash("تم تسجيل الدخول", "success")
        return redirect(url_for("home"))

    return render_template("login.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("تم تسجيل الخروج", "success")
    return redirect(url_for("home"))


@app.route("/posts", methods=["POST"])
def create_post():
    user = current_user()
    if not user:
        flash("سجل الدخول أولاً", "error")
        return redirect(url_for("login"))

    text = request.form.get("text", "").strip()
    media_url = request.form.get("media_url", "").strip() or None
    media_type = request.form.get("media_type", "").strip() or None

    if not text:
        flash("اكتب محتوى المنشور", "error")
        return redirect(url_for("home"))

    if media_type and media_type not in {"image", "video"}:
        flash("نوع الوسائط غير مدعوم", "error")
        return redirect(url_for("home"))

    post = Post(user_id=user.id, text=text, media_url=media_url, media_type=media_type)
    db.session.add(post)
    db.session.commit()
    flash("تم نشر المنشور", "success")
    return redirect(url_for("home"))


@app.route("/chat", methods=["POST"])
def send_chat_message():
    user = current_user()
    if not user:
        flash("سجل الدخول لإرسال رسائل", "error")
        return redirect(url_for("login"))

    message = request.form.get("message", "").strip()
    if not message:
        flash("الرسالة فارغة", "error")
        return redirect(url_for("home"))

    db.session.add(ChatMessage(user_id=user.id, message=message))
    db.session.commit()
    flash("تم إرسال الرسالة", "success")
    return redirect(url_for("home"))


@app.cli.command("init-db")
def init_db():
    db.create_all()
    print("Database initialized")


with app.app_context():
    db.create_all()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
