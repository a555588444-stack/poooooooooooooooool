FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY faislook_app /app/faislook_app

ENV FLASK_APP=faislook_app.main:app
ENV PYTHONUNBUFFERED=1

EXPOSE 5000
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "faislook_app.main:app"]
