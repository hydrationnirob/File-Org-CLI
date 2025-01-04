import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
import 'package:colorize/colorize.dart';
import 'package:logging/logging.dart';

final log = Logger('BackupHandler');

void showProgress(int current, int total, String message) {
  const width = 40;
  final progress = (current / total * width).round();
  final percent = (current / total * 100).round();
  stdout.write('\r\x1B[36m$message: [\x1B[0m');
  stdout.write('\x1B[32m=' * progress);
  stdout.write('\x1B[36m>\x1B[0m');
  stdout.write(' ' * (width - progress - 1));
  stdout.write('\x1B[36m] $percent%\x1B[0m');
}

Future<void> handleBackup() async {
  print('\n\x1B[36m╔════════════════════════════════════╗\x1B[0m');
  print('\x1B[36m║         Creating Backup...          ║\x1B[0m');
  print('\x1B[36m╚════════════════════════════════════╝\x1B[0m\n');

  final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
  final backupDir =
      Directory(path.join(Directory.current.path, 'backup_$timestamp'));
  final zipPath = '${backupDir.path}.zip';

  try {
    final archive = Archive();
    var totalFiles = 0;
    var totalSize = 0;

    // First count total files and size
    print('\n\x1B[36mScanning files...\x1B[0m');
    var scanned = 0;
    var estimatedTotal = 100;

    await for (final entity in Directory.current.list(recursive: false)) {
      if (entity is File) {
        totalFiles++;
        totalSize += await entity.length();
        scanned++;
        showProgress(scanned, estimatedTotal, 'Scanning');
      }
    }
    stdout.write('\r\x1B[2K'); // Clear progress line
    stdout.write('\x1B[36mScanning complete!\x1B[0m\n');

    if (totalFiles == 0) {
      print(Colorize('\nNo files found to backup!').yellow());
      return;
    }

    // Show size in box
    print('\n\x1B[33m╔════════════ Backup Details ═══════════╗\x1B[0m');
    print('\x1B[33m║\x1B[0m Files found: $totalFiles'.padRight(41) +
        '\x1B[33m║\x1B[0m');
    print(
        '\x1B[33m║\x1B[0m Total size: ${_formatSize(totalSize)}'.padRight(41) +
            '\x1B[33m║\x1B[0m');
    print('\x1B[33m╚════════════════════════════════════���══╝\x1B[0m\n');

    print('\x1B[32mProceed with backup? (y/n):\x1B[0m');

    final proceed = stdin.readLineSync()?.toLowerCase();
    if (proceed != 'y') return;

    var processed = 0;
    print('\n\x1B[36mCreating backup archive...\x1B[0m\n');

    await for (final entity in Directory.current.list(recursive: false)) {
      if (entity is File) {
        final data = await entity.readAsBytes();
        archive.addFile(
            ArchiveFile(path.basename(entity.path), data.length, data));
        processed++;
        showProgress(processed, totalFiles, 'Progress');
      }
    }
    print('\n'); // New line after progress bar

    print('\x1B[36mSaving backup file...\x1B[0m');
    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) {
      throw Exception('Failed to create zip archive');
    }

    print('\x1B[36mWriting backup file...\x1B[0m');
    await File(zipPath).writeAsBytes(zipData);

    // Verify backup
    if (!await File(zipPath).exists()) {
      throw Exception('Backup file was not created');
    }

    print(Colorize('\n✓ Backup created successfully!').green().bold());
    print('\n\x1B[33mBackup Summary:\x1B[0m');
    print('• Location: ${backupDir.path}');
    print('• Total Files: $totalFiles');
    print('• Total Size: ${_formatSize(zipData.length)}');
    print('• Timestamp: ${DateTime.now().toString().split('.')[0]}');

    print('\n\x1B[32mWould you like to open the backup folder? (y/n):\x1B[0m');
    final choice = stdin.readLineSync()?.toLowerCase();

    if (choice == 'y') {
      if (Platform.isWindows) {
        Process.run('explorer', [backupDir.path]);
      } else if (Platform.isMacOS) {
        Process.run('open', [backupDir.path]);
      } else if (Platform.isLinux) {
        Process.run('xdg-open', [backupDir.path]);
      }
      print('\x1B[32mOpening backup folder...\x1B[0m');
    }
  } catch (e) {
    log.severe('Backup failed: $e');
    print(Colorize('\nError creating backup: $e').red());
    rethrow;
  }

  print('\nPress Enter to return to main menu...');
  stdin.readLineSync();
}

String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
  if (bytes < 1024 * 1024 * 1024)
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
