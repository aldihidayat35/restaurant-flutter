import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _reminderKey = 'daily_reminder';

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  ReminderProvider() {
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    _isDailyReminderActive = prefs.getBool(_reminderKey) ?? false;
    notifyListeners();
  }

  Future<void> setDailyReminder(bool value) async {
    _isDailyReminderActive = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, value);
  }
}
