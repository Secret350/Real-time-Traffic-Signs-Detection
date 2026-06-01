FROM ultralytics/ultralytics:latest

LABEL maintainer="Nguyen Duc Minh Tri"
LABEL project="VN Real-time Traffic Object Detection"
LABEL model="YOLOv11s"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DISPLAY=:0 \
    QT_X11_NO_MITSHM=1 \
    QT_LOGGING_RULES="*.debug=false;qt.qpa.xcb=false" \
    CUDA_VISIBLE_DEVICES=0 \
    DISPLAY=host.docker.internal:0.0 \
    LIBGL_ALWAYS_INDIRECT=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcb-glx0 \
    libxcb-xinerama0 \
    libxext6 \
    libxrender1 \
    libxi6 \
    x11-utils \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libdbus-1-3 \
    libfontconfig1 \
    python3-pyqt5 \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /app/output /app/models /app/logs

CMD ["python", "ui_design.py"]
