importScripts('/firebase-config.js');
importScripts('https://www.gstatic.com/firebasejs/12.17.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.17.0/firebase-messaging-compat.js');

if (self.FIREBASE_WEB_CONFIG && self.FIREBASE_WEB_CONFIG.appId &&
    !String(self.FIREBASE_WEB_CONFIG.appId).startsWith('__')) {
  firebase.initializeApp(self.FIREBASE_WEB_CONFIG);
  const messaging = firebase.messaging();

  messaging.onBackgroundMessage((payload) => {
    if (payload.notification) {
      return;
    }
    const title = (payload.data && payload.data.title) || 'MS Teacher';
    const body = (payload.data && payload.data.body) || '';
    return self.registration.showNotification(title, {
      body: body,
      icon: '/icons/Icon-192.png?v=2',
    });
  });
}

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(clients.openWindow('/'));
});
