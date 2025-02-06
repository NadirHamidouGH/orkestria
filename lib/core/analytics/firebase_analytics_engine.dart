import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:orkestria/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAnalyticsEngine {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Firebase and related services
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully.');

      await _requestNotificationPermissions();
      await _saveFcmToken();
      _setupNotificationListeners();
    } catch (e) {
      print('❌ Error initializing Firebase: $e');
    }
  }

  /// Request notification permissions (useful for iOS)
  static Future<void> _requestNotificationPermissions() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notifications authorized.');
      } else {
        print('⚠️ Notifications not authorized.');
      }
    } catch (e) {
      print('❌ Error requesting notification permissions: $e');
    }
  }

  /// Retrieve and save the FCM token
  static Future<void> _saveFcmToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
        print('📲 FCM Token saved: $token');
      } else {
        print('⚠️ No FCM token received.');
      }
    } catch (e) {
      print('❌ Error retrieving FCM token: $e');
    }
  }

  /// Setup all notification listeners
  static void _setupNotificationListeners() {
    // 1️⃣ Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message: ${message.notification?.title}');
    });

    // 2️⃣ Background notifications (when the app is minimized)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🚀 App opened from background via notification: ${message.notification?.title}');
    });

    // 3️⃣ App opened from terminated state via a notification
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('⚡ App launched via notification (terminated state): ${message.notification?.title}');
      }
    });
  }

  /// Log user login events
  static Future<void> userLogsIn(String loginMethod) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
      print('🔑 Login event sent with method: $loginMethod');
    } catch (e) {
      print('❌ Error sending login event: $e');
    }
  }

  static Future<void> alertsPressed() async {
    await _logEvent('alerts_pressed');
  }

  static Future<void> sitesPressed() async {
    await _logEvent('sites_pressed');
  }

  static Future<void> cameraKpiPressed() async {
    await _logEvent('cameraKpi_pressed');
  }

  static Future<void> liveCamTabPressed() async {
    await _logEvent('live_cam_pressed');
  }

  /// Generic function to log custom events
  static Future<void> _logEvent(String eventName) async {
    try {
      await _analytics.logEvent(name: eventName);
      print('📊 $eventName event sent successfully.');
    } catch (e) {
      print('❌ Error sending $eventName event: $e');
    }
  }
}
