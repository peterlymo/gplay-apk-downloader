FROM python:3.11-slim-bookworm

# Java 17 runs APKEditor.jar (split-APK merging), apksigner signs merged APKs,
# keytool (bundled with the JRE) generates the debug keystore, curl is for healthchecks.
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        apksigner \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home --uid 1000 gplay \
    && chown -R gplay:gplay /app \
    && chmod +x /app/docker-entrypoint.sh
USER gplay
ENV HOME=/home/gplay

EXPOSE 5000

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["gunicorn", "-c", "gunicorn.conf.py", "server:app"]
