import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService
{
  LocalNotificationService._();
  static LocalNotificationService notificationService =LocalNotificationService._();
  FlutterLocalNotificationsPlugin plugin=FlutterLocalNotificationsPlugin();

  Future<void> initNotificationService()
  async {
    plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
     AndroidInitializationSettings android = const AndroidInitializationSettings("mipmap/ic_launcher");
     DarwinInitializationSettings ios=const DarwinInitializationSettings();
     InitializationSettings settings =InitializationSettings(
       android: android,
       iOS: ios,
     );
     await plugin.initialize(settings);

  }
  Future<void> showNotification(String title,String body)
  async {
    AndroidNotificationDetails androidDetails =const AndroidNotificationDetails(
        "chat-app", "Local Notification",
    importance:Importance.max,
      priority:Priority.max,

    );
    NotificationDetails notificationDetails =NotificationDetails(android: androidDetails);
    await plugin.show(0, title, body, notificationDetails);
  }

}