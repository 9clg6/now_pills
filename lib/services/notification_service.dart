import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  NotificationService._internal();

  factory NotificationService(){
    _instance.localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    return _instance;
  }

  Future<void> setup() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(
        await FlutterNativeTimezone.getLocalTimezone(),
      ),
    );

    const androidSetting = AndroidInitializationSettings('@mipmap/pills_notif');
    const iosSetting = DarwinInitializationSettings(requestSoundPermission: true);

    const initSettings = InitializationSettings(android: androidSetting, iOS: iosSetting);

    await localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required tz.TZDateTime endTime,
    required String channel,
    required String sound,
    required int id,
  }) async {
    final soundFile = sound.replaceAll('.mp3', '');
    final notificationSound = sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);
    final androidDetail = AndroidNotificationDetails(
        channel,
        channel,
        playSound: true,
        sound: notificationSound,
        importance: Importance.max,
        priority: Priority.high,
        icon: "@mipmap/pills_notif",
        channelShowBadge: true,
    );

    final iosDetail = sound == ''
        ? null
        : DarwinNotificationDetails(presentSound: true, sound: sound);

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    await localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body.toLowerCase(),
      endTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );

    Logger().wtf("Pending notif : ${(await localNotificationsPlugin.pendingNotificationRequests()).length}");
  }
}