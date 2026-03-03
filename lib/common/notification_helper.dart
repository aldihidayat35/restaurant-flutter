import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelper {
  static const String _channelId = 'restaurant_channel';
  static const String _channelName = 'Restaurant Reminder';
  static const String _channelDesc = 'Daily lunch reminder notification';

  static Future<void> initNotifications() async {
    try {
      tzdata.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> scheduleDailyElevenAMNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Restaurant Recommendation',
      'It\'s lunch time! Check out a restaurant for today.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showRandomRestaurantNotification() async {
    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> restaurants = body['restaurants'];

        if (restaurants.isNotEmpty) {
          final random = Random();
          final restaurant = restaurants[random.nextInt(restaurants.length)];

          const androidDetails = AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
          );

          const notificationDetails =
              NotificationDetails(android: androidDetails);

          await flutterLocalNotificationsPlugin.show(
            0,
            'Restaurant Recommendation 🍽️',
            'How about ${restaurant['name']} in ${restaurant['city']}? ⭐ ${restaurant['rating']}',
            notificationDetails,
          );
        }
      }
    } catch (e) {
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Lunch Reminder 🍽️',
        'It\'s lunch time! Don\'t forget to eat.',
        notificationDetails,
      );
    }
  }
}
