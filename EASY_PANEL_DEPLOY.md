# Deploying the Teacher App (Flutter Web) with Easypanel

This repository builds the Flutter **web** app from source inside Docker and
serves the result with **nginx**. You do **not** need `build/web` in GitHub.

---

## 1. Repository

| | |
|---|---|
| Repository | your GitHub repo containing this Flutter project (`my_school_teacher`) |
| Branch | `main` |
| Build type | **Dockerfile** |
| Build context | `.` |
| Dockerfile path | `Dockerfile` |
| Container port | **80** |

Files that drive the deployment (already in the repo root):

- `Dockerfile` – multi-stage build: `ghcr.io/cirruslabs/flutter:stable` → `nginx:alpine`
- `nginx.conf` – SPA fallback (`try_files … /index.html`) + cache policy
- `.dockerignore` – keeps `build/`, `.git/`, `.dart_tool/`, mobile build output out of the context

---

## 2. Easypanel setup (exact steps)

1. **Create Project** in Easypanel.
2. **New Service → App**.
3. Source: **GitHub** → select this repository.
4. Branch: **`main`**.
5. Deployment / build type: **Dockerfile**.
6. Build context: **`.`**
7. Dockerfile path: **`Dockerfile`**
8. Internal / container port: **`80`**
9. (Optional) Build args: `API_BASE_URL=https://api.your-backend.com` → see §4.
10. **Deploy**.
11. After the first successful deploy: **Domains → Add custom domain**
    (e.g. `teacher.example.com`) → **enable HTTPS** (Easypanel issues the
    Let's Encrypt certificate automatically).

> `build/web` does **not** have to exist on GitHub. The Docker build runs
> `flutter build web --release` and nginx serves `/app/build/web`.
> `/build/` stays in `.gitignore` on purpose.

### Local verification (same commands the Dockerfile runs)

```bash
flutter pub get
flutter analyze
flutter build web --release --no-web-resources-cdn --dart-define=API_BASE_URL=https://api.your-backend.com
```

---

## 3. URLs / routing

nginx falls back to `index.html` for every unknown path, so all of these work
when opened directly, bookmarked, refreshed or shared:

- `https://teacher.example.com/` → redirects in-app to `/login` or `/dashboard`
- `https://teacher.example.com/login`
- `https://teacher.example.com/dashboard`
- deep links such as `https://teacher.example.com/agenda` (opens the feature
  after sign-in)

The app uses Flutter's **path** URL strategy, so there is no `#` in the URL.

---

## 4. API URL configuration (what you must provide)

The backend base URL is **compile-time** configuration, injected with
`--dart-define`:

```bash
flutter build web --release --dart-define=API_BASE_URL=https://api.example.com
```

- Source of truth: `lib/services/network/api_config.dart`
  (`String.fromEnvironment('API_BASE_URL')`).
- `Dockerfile` exposes it as a build arg:

  ```dockerfile
  ARG API_BASE_URL=https://amctag-my-school.38f0fz.easypanel.host
  RUN flutter build web --release ... --dart-define=API_BASE_URL=${API_BASE_URL}
  ```

- **In Easypanel**, set it as a *build arg* (`API_BASE_URL=<your backend URL>`).
- The teacher web Firebase app is already in the build
  (`1:756524911884:web:f145cca98f3f37c8398d29`). Do not put it in the backend `.env`.
- Browser push still needs the VAPID public key as a **teacher** build arg
  (Firebase → Project settings → Cloud Messaging → Web Push certificates):

  ```text
  FIREBASE_VAPID_KEY=YOUR_PUBLIC_VAPID_KEY
  ```

  The phone app does not use this key.
  If your Easypanel version has no build-arg field, edit the `ARG` default in
  `Dockerfile`, commit and redeploy.
- The value is a **public URL** – it is embedded in `main.dart.js` on purpose.
  Never put tokens, secrets or credentials here; keep them on the backend.

Example for a production backend:

```text
API_BASE_URL=https://api.teacher.example.com
```

The app calls `${API_BASE_URL}/api/v1/...`.

---

## 5. CORS (backend configuration)

The Flutter site is served from a different origin than the API, so the
**backend** must allow it (nothing in this repository needs changing).

| | |
|---|---|
| Frontend origin | `https://teacher.example.com` (your custom domain) |
| Local dev origin | `http://localhost:xxxx` if you run `flutter run -d chrome` |
| Backend | `${API_BASE_URL}` (e.g. `https://api.teacher.example.com`) |

Required response headers on the API:

```http
Access-Control-Allow-Origin: https://teacher.example.com
Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Accept, Authorization
Access-Control-Allow-Credentials: true   # only if you use cookies
```

Also answer preflight `OPTIONS` requests with `204`/`200`.
In production, prefer listing the exact origin (or your reverse proxy's allow
list) instead of `*` when credentials are involved.

Browser console symptom if this is missing: **CORS policy … No
'Access-Control-Allow-Origin' header**.

---

## 6. Caching / service worker (no stale app)

- `nginx.conf` serves `index.html`, `main.dart.js`, `flutter.js`, `canvaskit`,
  `assets/` with `Cache-Control: no-cache` → the browser revalidates (304) on
  every load, so a new deployment is visible on the next refresh. App icons are
  cached for 7 days.
- Flutter ≥ 3.47 does **not** install a caching service worker for new
  visitors; `flutter_service_worker.js` only unregisters legacy workers and
  reloads old clients. Combined with the nginx headers, users cannot get
  permanently stuck on an old release.
- If you ever need to force a clean state: open the site → DevTools →
  Application → Service Workers → **Unregister** + Storage → **Clear site data**,
  then reload.
- The build uses `--no-web-resources-cdn`, so CanvasKit and all engine files
  are served from your own domain (no dependency on a third-party CDN).

---

## 7. Mobile is untouched

Android/iOS behaviour is unchanged: `usePathUrlStrategy()`, `WebRouteSync` and
the web route paths are all no-ops on mobile (`kIsWeb` / conditional web
plugin), and `SystemChrome` calls are skipped on web only.

---

## 8. Troubleshooting

| Symptom | Check |
|---|---|
| Build fails on `flutter build web` | Easypanel build logs; `lib/`, `web/`, `images/`, `l10n.yaml` must be present (see `.dockerignore`) |
| 404 on `/login` | `nginx.conf` copied to `/etc/nginx/conf.d/default.conf`, `try_files … /index.html` present |
| Wrong API host | Build arg `API_BASE_URL` (it is baked at build time → redeploy) |
| CORS errors | §5, backend allow-list |
| Old UI after deploy | Hard refresh (Ctrl+Shift+R); confirm the new `main.dart.js` `Last-Modified` date |
