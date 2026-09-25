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
    --dart-define=API_BASE_URL=${API_BASE_URL}

# ---------------------------------------------------------------------------
# Stage 2 - serve the static bundle with nginx
# ---------------------------------------------------------------------------
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
