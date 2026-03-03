import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/workmanager_helper.dart';
import 'package:restaurant_flutter/presentation/providers/reminder_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Customize your experience',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionTitle(theme, 'Appearance'),
                  const SizedBox(height: 8),
                  _buildThemeCard(context, theme),
                  const SizedBox(height: 24),
                  _buildSectionTitle(theme, 'Notifications'),
                  const SizedBox(height: 8),
                  _buildReminderCard(context, theme),
                  const SizedBox(height: 24),
                  _buildSectionTitle(theme, 'About'),
                  const SizedBox(height: 8),
                  _buildAboutCard(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text('Dark Theme', style: theme.textTheme.titleLarge),
            subtitle: Text(
              themeProvider.isDarkMode ? 'Dark mode is on' : 'Light mode is on',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Switch.adaptive(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeTrackColor: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReminderCard(BuildContext context, ThemeData theme) {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: theme.colorScheme.secondary,
              ),
            ),
            title: Text('Daily Reminder', style: theme.textTheme.titleLarge),
            subtitle: Text(
              'Get notified at 11:00 AM',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Switch.adaptive(
              value: reminderProvider.isDailyReminderActive,
              onChanged: (value) async {
                await reminderProvider.setDailyReminder(value);
                if (value) {
                  await WorkManagerHelper.registerDailyReminder();
                } else {
                  await WorkManagerHelper.cancelDailyReminder();
                }
              },
              activeTrackColor: theme.colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.info_outline_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text('Restaurant App', style: theme.textTheme.titleLarge),
        subtitle: Text(
          'Version 2.0.0 • Dicoding Submission',
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}
