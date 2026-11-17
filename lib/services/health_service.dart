import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ConnectResult { connected, notInstalled, denied, noData }

class HealthService {
  HealthService._();
  static final HealthService instance = HealthService._();

  // Hug's own on/off switch (does NOT touch Health Connect or the watch app)
  static const String _kEnabledKey = 'hug_health_enabled';

  /// How fresh the newest heart rate must be to count as "watch is sending data".
  static const Duration kFreshWindow = Duration(minutes: 45);

  final Health _health = Health();
  bool _configured = false;

  static const List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
  ];

  List<HealthDataAccess> get _access =>
      _types.map((_) => HealthDataAccess.READ).toList();

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  Future<bool> _isEnabledInApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kEnabledKey) ?? false;
  }

  Future<void> _setEnabledInApp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabledKey, value);
  }

  /// True only if Health Connect has a heart rate from the last 45 minutes.
  /// (Old records do not count, so a stopped sync is detected.)
  Future<bool> hasWatchData() async {
    await _ensureConfigured();
    final now = DateTime.now();
    final points = await _health.getHealthDataFromTypes(
      types: [HealthDataType.HEART_RATE],
      startTime: now.subtract(kFreshWindow),
      endTime: now,
    );
    return points.isNotEmpty;
  }

  /// "Find your smartwatch": permission first, then check for real data.
  /// Hug only turns on if the watch is actually sending data.
  Future<ConnectResult> connect() async {
    await _ensureConfigured();

    final status = await _health.getHealthConnectSdkStatus();
    if (status != HealthConnectSdkStatus.sdkAvailable) {
      await _health.installHealthConnect();
      return ConnectResult.notInstalled;
    }

    final granted = await _health.requestAuthorization(
      _types,
      permissions: _access,
    );
    if (!granted) return ConnectResult.denied;

    final hasData = await hasWatchData();
    if (!hasData) {
      await _setEnabledInApp(false);
      return ConnectResult.noData;
    }

    await _setEnabledInApp(true);
    return ConnectResult.connected;
  }

  /// Turns Hug's switch off. Health Connect and the watch app are not touched.
  Future<void> disconnect() async {
    await _setEnabledInApp(false);
  }

  /// Connected = the user connected inside Hug AND the permission still exists.
  Future<bool> isConnected() async {
    if (!await _isEnabledInApp()) return false;
    await _ensureConfigured();
    return await _health.hasPermissions(_types, permissions: _access) ?? false;
  }

  /// Total steps from midnight until now.
  Future<int?> todaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    return _health.getTotalStepsInInterval(midnight, now);
  }

  /// Newest heart rate in the last 24 hours.
  Future<HealthDataPoint?> latestHeartRate() async {
    final now = DateTime.now();
    final points = await _health.getHealthDataFromTypes(
      types: [HealthDataType.HEART_RATE],
      startTime: now.subtract(const Duration(hours: 24)),
      endTime: now,
    );
    if (points.isEmpty) return null;
    points.sort((a, b) => b.dateTo.compareTo(a.dateTo));
    return points.first;
  }
}
