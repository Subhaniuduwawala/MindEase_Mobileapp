class UserSettings {
  bool isDarkMode;
  bool notificationsEnabled;
  UserSettings({this.isDarkMode = false, this.notificationsEnabled = true});
  void toggleDarkMode() => isDarkMode = !isDarkMode;
  void toggleNotifications() => notificationsEnabled = !notificationsEnabled;
  @override
  String toString() => 'UserSettings(dark: $isDarkMode, notifications: $notificationsEnabled)';
}