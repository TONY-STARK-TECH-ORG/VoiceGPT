# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.11.6
FROM python:${PYTHON_VERSION}-slim 

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/appuser" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    appuser


# Install gcc and other build dependencies.
RUN apt-get update && \
    apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

USER appuser

RUN mkdir -p /home/appuser/.cache
RUN chown -R appuser /home/appuser/.cache

WORKDIR /home/appuser

COPY requirements.txt .
RUN python -m pip install --upgrade Pillow
RUN python -m pip install --upgrade defusedxml olefile
RUN python -m pip install 'torch==2.2.2'
RUN python -m pip install 'torchaudio==2.2.2'
RUN python -m pip install 'numpy==1.26.4'
RUN python -m pip install 'onnxruntime==1.17.3'
RUN python -m pip install 'openai==1.30.5'
RUN python -m pip install 'pillow==10.3.0'
RUN python -m pip install 'requests==2.32.3'

RUN python -m pip install --user --no-cache-dir -r requirements.txt

COPY . .

RUN python kitt.py download-files 

# Run the application.
CMD python kitt.py start