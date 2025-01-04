import 'dart:io';
import 'package:path/path.dart' as path;
import '../file_organizer.dart';
import 'package:logging/logging.dart';
import 'package:colorize/colorize.dart';

final log = Logger('FileHandler');

void showProgress(int current, int total) {
  const width = 40;
  final progress = (current / total * width).round();
  final percent = (current / total * 100).round();
  stdout.write('\r[');
  stdout.write('=' * progress);
  stdout.write('>' + ' ' * (width - progress - 1));
  stdout.write('] $percent%');
}

Future<void> handleCurrentDirectoryOrganization() async {
  log.info('Starting organization of current directory');

  final organizer = FileOrganizer(directory: Directory.current.path);
  final files = Directory.current.listSync().whereType<File>().toList();

  print(Colorize('\nOrganizing files...').green());
  var processed = 0;

  for (var file in files) {
    await organizer.organizeFile(file);
    processed++;
    showProgress(processed, files.length);
  }
  print(''); // New line after progress

  print(Colorize('\n✓ Organization complete!').green().bold());
}

Future<void> handleSpecificDirectoryOrganization() async {
  print('\n\x1B[33mEnter directory path:\x1B[0m');
  final directoryPath = stdin.readLineSync();
  if (directoryPath != null) {
    final normalizedPath = path.normalize(directoryPath);
    print('\x1B[32m\nOrganizing directory: $normalizedPath\x1B[0m');
    final organizer = FileOrganizer(directory: normalizedPath);
    await organizer.organize();
  }
  print('\nPress Enter to continue...');
  stdin.readLineSync();
}

Future<void> handleFilteredOrganization() async {
  print('\n\x1B[36mEnter file extensions to organize (comma separated)\x1B[0m');
  print('Example: pdf,jpg,doc');
  print('Type "all" for all files\n');

  final input = stdin.readLineSync()?.toLowerCase();
  if (input == null) return;

  final extensions = input == 'all'
      ? <String>[]
      : input.split(',').map((e) => e.trim()).toList().cast<String>();

  print(
      '\x1B[32m\nOrganizing files with extensions: ${extensions.isEmpty ? "all" : extensions.join(", ")}\x1B[0m');

  final organizer = FileOrganizer(
    directory: Directory.current.path,
    includeExtensions: extensions,
  );

  final stats = await organizer.organize();

  print('\n\x1B[33mOrganization Summary:\x1B[0m');
  print('Files processed: ${stats['files_processed']}');
  print('Files moved: ${stats['files_moved']}');
  print('Folders created: ${stats['folders_created']}');
  print('Errors: ${stats['errors']}\n');

  print('\nPress Enter to continue...');
  stdin.readLineSync();
}

Future<void> handlePreviewOrganization() async {
  print('\n\x1B[36mChoose directory to preview:\x1B[0m');
  print('1. Current directory');
  print('2. Specific directory');

  final choice = stdin.readLineSync();
  String directoryPath;

  if (choice == '1') {
    directoryPath = path.normalize(Directory.current.path);
  } else if (choice == '2') {
    print('\n\x1B[33mEnter directory path:\x1B[0m');
    final input = stdin.readLineSync();
    if (input == null) return;
    directoryPath = path.normalize(input);
  } else {
    print('\x1B[31mInvalid choice!\x1B[0m');
    return;
  }

  final organizer = FileOrganizer(directory: directoryPath, dryRun: true);
  print(Colorize('\nAnalyzing directory...').cyan());

  try {
    final files = Directory(directoryPath)
        .listSync(recursive: false)
        .whereType<File>()
        .where((f) => !path.basename(f.path).startsWith('.'))
        .toList();

    if (files.isEmpty) {
      print(Colorize('\nNo files to organize!').yellow());
      return;
    }

    final groupedFiles = <String, List<String>>{};
    var totalSize = 0;

    for (var file in files) {
      final ext = path.extension(file.path).toLowerCase().replaceAll('.', '');
      if (ext.isNotEmpty) {
        groupedFiles
            .putIfAbsent(ext.toUpperCase(), () => [])
            .add(path.basename(file.path));
        totalSize += file.lengthSync();
      }
    }

    print('\n\x1B[36mFiles will be organized as follows:\x1B[0m');
    for (var entry in groupedFiles.entries) {
      print(
          '\n\x1B[32m${entry.key} Folder (${entry.value.length} files):\x1B[0m');
      for (var file in entry.value) {
        print('  • $file');
      }
    }

    print('\n\x1B[33mSummary:\x1B[0m');
    print('• Total files: ${files.length}');
    print('• Total size: ${_formatSize(totalSize)}');
    print('• Folders to be created: ${groupedFiles.length}');
  } catch (e) {
    print(Colorize('\nError analyzing directory: $e').red());
  }

  print('\n\x1B[32mWould you like to proceed with organization? (y/n):\x1B[0m');
  final proceed = stdin.readLineSync()?.toLowerCase();

  if (proceed == 'y') {
    await handleCurrentDirectoryOrganization();
  }
}

String _formatSize(int bytes) {
  if (bytes < 1024) {
    return '${bytes} bytes';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).round()} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).round()} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).round()} GB';
  }
}
