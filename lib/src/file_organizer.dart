import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:logging/logging.dart' as logging;

class FileOrganizer {
  final String directory;
  final bool dryRun;
  final bool includeHidden;
  final List<String> includeExtensions;
  final logging.Logger logger;

  FileOrganizer({
    required this.directory,
    this.dryRun = false,
    this.includeHidden = false,
    this.includeExtensions = const [],
  }) : logger = logging.Logger('FileOrganizer');

  Future<Map<String, int>> organize() async {
    final dir = Directory(directory);
    Map<String, int> statistics = {
      'files_processed': 0,
      'files_moved': 0,
      'folders_created': 0,
      'errors': 0,
    };

    if (!dir.existsSync()) {
      logger.info('Directory does not exist: $directory');
      return statistics;
    }

    logger.info('Starting file organization...');

    try {
      await for (final entity in dir.list(recursive: false)) {
        if (entity is File) {
          if (!includeHidden && path.basename(entity.path).startsWith('.')) {
            continue;
          }

          final extension = path.extension(entity.path).toLowerCase();
          if (extension.isEmpty) continue;

          if (includeExtensions.isNotEmpty &&
              !includeExtensions.contains(extension.replaceAll('.', ''))) {
            continue;
          }

          statistics['files_processed'] = statistics['files_processed']! + 1;

          final folderName = extension.replaceAll('.', '').toUpperCase();
          final newDir = _createFolder(path.join(directory, folderName));

          if (!dryRun) {
            await _moveFile(entity as File,
                path.join(newDir.path, path.basename(entity.path)));
            statistics['files_moved'] = statistics['files_moved']! + 1;
          }
        }
      }
    } catch (e) {
      logger.severe('Error: $e');
      statistics['errors'] = statistics['errors']! + 1;
    }

    logger.info('Organization complete. Statistics: $statistics');
    return statistics;
  }

  // Helper methods
  Future<void> _moveFile(File file, String destination) async {
    try {
      if (await File(destination).exists()) {
        // Handle duplicate files
        final fileName = path.basenameWithoutExtension(destination);
        final extension = path.extension(destination);
        var counter = 1;
        var newPath = destination;

        while (await File(newPath).exists()) {
          newPath = path.join(
              path.dirname(destination), '${fileName}_${counter++}$extension');
        }
        destination = newPath;
      }

      await file.rename(destination);
    } catch (e) {
      try {
        await file.copy(destination);
        await file.delete();
      } catch (e) {
        throw Exception('Failed to move file: $e');
      }
    }
  }

  Directory _createFolder(String folderPath) {
    // ... folder creation logic ...
    return Directory(folderPath)..createSync(recursive: true);
  }

  Future<void> organizeFile(File file) async {
    try {
      final extension = path.extension(file.path).toLowerCase();
      if (extension.isEmpty) {
        logger.warning('Skipping file without extension: ${file.path}');
        return;
      }

      // Add actual organization logic
      final folderName = extension.replaceAll('.', '').toUpperCase();
      final newDir = _createFolder(path.join(directory, folderName));
      final newPath = path.join(newDir.path, path.basename(file.path));

      if (!dryRun) {
        await _moveFile(file, newPath);
      }
    } catch (e) {
      logger.severe('Error organizing file ${file.path}: $e');
      rethrow;
    }
  }
}
