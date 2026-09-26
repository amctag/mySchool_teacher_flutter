# Multi-stage production build for the Flutter teacher app (Flutter Web + nginx).
# Used by Easypanel: build context "." , Dockerfile path "Dockerfile", port 80.

# ---------------------------------------------------------------------------
# Stage 1 - compile the Flutter web bundle
# ---------------------------------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Backend base URL baked into main.dart.js at build time.
# Override it with a Docker build argument (Easypanel -> Build args).
# This is a public URL, never a secret - do not put tokens here.
ARG API_BASE_URL=https://amctag-my-school.38f0fz.easypanel.host
# Web app from Firebase Console. VAPID is the Web Push public key
# (Project settings → Cloud Messaging → Web Push certificates).
ARG FIREBASE_WEB_APP_ID=1:756524911884:web:f145cca98f3f37c8398d29
ARG FIREBASE_API_KEY=AIzaSyCT1WLuTArbf8dGVMrEfhWFrMsj2B3JqMg
ARG FIREBASE_VAPID_KEY=BGo3RdBGObVk1_me8rcci6ww6fDJOIvNy7Wd0fk_yJmdOXC4bErjDlhLesopMHtRsNKWsfOiTFLVTrMOR8xgwqQ

# Dependency layer: only re-runs when the pubspec files change.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# --no-web-resources-cdn : serve engine/CanvasKit files from this server
#                          instead of a third-party CDN.
# --no-wasm-dry-run      : silence the informational wasm dry-run warning.
RUN flutter build web --release \
    --no-web-resources-cdn \
    --no-wasm-dry-run \
    --pwa-strategy=none \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=FIREBASE_API_KEY=${FIREBASE_API_KEY} \
    --dart-define=FIREBASE_WEB_APP_ID=${FIREBASE_WEB_APP_ID} \
    --dart-define=FIREBASE_VAPID_KEY=${FIREBASE_VAPID_KEY}

# ---------------------------------------------------------------------------
# Stage 2 - serve the static bundle with nginx
# ---------------------------------------------------------------------------
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
