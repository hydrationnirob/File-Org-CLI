import 'package:logging/logging.dart' as logging;
import 'dart:io';

class AppLogger {
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((record) {
      final timestamp = record.time.toString().split('.')[0];
      final color = _getColorForLevel(record.level);
      final message =
          '$color[$timestamp] ${record.level.name}: ${record.message}\x1B[0m';

      // Write to console and file
      print(message);
      _writeToFile(message);
    });

    _initialized = true;
  }

  static void _writeToFile(String message) {
    try {
      final logFile = File('file_organizer.log');
      logFile.writeAsStringSync('$message\n', mode: FileMode.append);
    } catch (e) {
      print('\x1B[31mFailed to write to log file: $e\x1B[0m');
    }
  }

  static String _getColorForLevel(logging.Level level) {
    if (level == logging.Level.SEVERE) return '\x1B[31m'; // Red
    if (level == logging.Level.WARNING) return '\x1B[33m'; // Yellow
    if (level == logging.Level.INFO) return '\x1B[36m'; // Cyan
    return '\x1B[0m'; // Reset
  }
}
