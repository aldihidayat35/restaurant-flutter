import 'package:restaurant_flutter/common/notification_helper.dart';
import 'package:workmanager/workmanager.dart';

const String dailyReminderTask = 'dailyReminderTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case dailyReminderTask:
        await NotificationHelper.showRandomRestaurantNotification();
        return Future.value(true);
      default:
        return Future.value(false);
    }
  });
}

class WorkManagerHelper {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerDailyReminder() async {
    await Workmanager().registerPeriodicTask(
      '1',
      dailyReminderTask,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName('1');
  }

  static Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime.difference(now);
  }
}
