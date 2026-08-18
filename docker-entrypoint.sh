#!/bin/sh
# Generate the debug keystore on first run (persisted via the home-dir volume),
# then hand off to gunicorn.
set -e

KEYSTORE="$HOME/.android/debug.keystore"
if [ ! -f "$KEYSTORE" ]; then
    echo "Generating debug keystore at $KEYSTORE..."
    mkdir -p "$HOME/.android"
    keytool -genkey -v -keystore "$KEYSTORE" \
        -storepass android -alias androiddebugkey -keypass android \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -dname "CN=Android Debug,O=Android,C=US"
fi

exec "$@"
