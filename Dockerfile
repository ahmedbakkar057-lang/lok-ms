FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    BASE_PATH=/data

WORKDIR /app

# Node.js مطلوب لبعض التطبيقات التي يمكن رفعها من لوحة التحكم.
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# تثبيت الاعتماديات أثناء بناء الصورة.
COPY requirements.txt ./
RUN python -m pip install --upgrade pip \
    && python -m pip install --no-cache-dir -r requirements.txt

# الملف الفعلي الموجود في المشروع هو panel.py؛ لا يوجد main.py أو bot.py.
COPY panel.py ./panel.py

EXPOSE 8080

# Railway يمرر PORT تلقائيًا إلى التطبيق.
CMD ["python", "panel.py"]
