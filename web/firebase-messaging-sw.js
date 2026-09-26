importScripts('https://www.gstatic.com/firebasejs/12.17.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.17.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCT1WLuTArbf8dGVMrEfhWFrMsj2B3JqMg',
  authDomain: 'koi-beirut.firebaseapp.com',
  databaseURL: 'https://koi-beirut.firebaseio.com',
  projectId: 'koi-beirut',
  storageBucket: 'koi-beirut.firebasestorage.app',
  messagingSenderId: '756524911884',
  appId: '1:756524911884:web:f145cca98f3f37c8398d29',
});

const messaging = firebase.messaging();

// Always show a system notification. Returning early when
// payload.notification exists leaves Chrome with nothing to display.
messaging.onBackgroundMessage((payload) => {
  const title =
    (payload.notification && payload.notification.title) ||
    (payload.data && payload.data.title) ||
    'MS Teacher';
  const body =
    (payload.notification && payload.notification.body) ||
    (payload.data && payload.data.body) ||
    '';
  return self.registration.showNotification(title, {
    body: body,
    icon: '/icons/Icon-192.png?v=2',
    data: payload.data || {},
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const route =
    (event.notification.data && event.notification.data.route) || 'dashboard';
  const path = route.startsWith('/') ? route : '/' + route;
  event.waitUntil(clients.openWindow(path));
});
