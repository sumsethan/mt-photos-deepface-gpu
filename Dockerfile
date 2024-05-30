# FROM python:3.8.10-buster
FROM tensorflow/tensorflow:2.10.0-gpu
USER root

# COPY ./sources.list /etc/apt/sources.list
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt update && \
    apt install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libfontconfig1 wget && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

WORKDIR /app
COPY requirements.txt .

# 安装依赖包
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip install ultralytics

RUN mkdir -p /models/.deepface/weights
RUN wget -nv -O /models/.deepface/weights/retinaface.h5 https://github.com/serengil/deepface_models/releases/download/v1.0/retinaface.h5 
RUN wget -nv -O /models/.deepface/weights/vgg_face_weights.h5 https://github.com/serengil/deepface_models/releases/download/v1.0/vgg_face_weights.h5


COPY server.py .
ENV DEEPFACE_HOME=/models
ENV API_AUTH_KEY=mt_photos_ai_extra
EXPOSE 8066

CMD [ "python3", "server.py" ]
