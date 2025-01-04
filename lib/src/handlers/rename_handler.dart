import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:colorize/colorize.dart';

void showProgress(int current, int total) {
  const width = 40;
  final progress = (current / total * width).round();
  final percent = (current / total * 100).round();
  stdout.write('\r[');
  stdout.write('=' * progress);
  stdout.write('>' + ' ' * (width - progress - 1));
  stdout.write('] $percent%');
}

Future<void> handleBulkRename() async {
  print(Colorize('\nBulk Rename Files').cyan().bold());
  print('\n1. Add prefix to all files');
  print('2. Add suffix before extension');
  print('3. Replace text in filenames');
  print('4. Select specific files to rename');

  final choice = stdin.readLineSync();
  switch (choice) {
    case '1':
      await handlePrefixRename();
      break;
    case '2':
      await handleSuffixRename();
      break;
    case '3':
      await handleReplaceRename();
      break;
    case '4':
      await handleSelectiveRename();
      break;
  }
}

Future<void> handleSelectiveRename() async {
  final files = Directory.current.listSync().whereType<File>().toList();

  if (files.isEmpty) {
    print(Colorize('\nNo files found in current directory!').red());
    return;
  }

  print(Colorize('\nAvailable files:').cyan());
  for (var i = 0; i < files.length; i++) {
    print('${i + 1}. ${path.basename(files[i].path)}');
  }

  print('\nEnter file numbers to rename (comma-separated):');
  final input = stdin.readLineSync();
  if (input == null) return;

  final selectedIndices = input
      .split(',')
      .map((e) => int.tryParse(e.trim()))
      .where((e) => e != null && e > 0 && e <= files.length)
      .map((e) => e! - 1)
      .toList();

  if (selectedIndices.isEmpty) {
    print(Colorize('\nNo valid files selected!').red());
    return;
  }

  print('\nSelect rename operation:');
  print('1. Add prefix');
  print('2. Add suffix');
  print('3. Replace text');

  final operation = stdin.readLineSync();
  switch (operation) {
    case '1':
      print('Enter prefix:');
      final prefix = stdin.readLineSync();
      if (prefix != null) {
        var processed = 0;
        for (var index in selectedIndices) {
          await _addPrefix(files[index], prefix);
          processed++;
          showProgress(processed, selectedIndices.length);
        }
        print(''); // New line after progress
      }
      break;
    // ... similar cases for suffix and replace
  }
}

Future<void> _addPrefix(File file, String prefix) async {
  final fileName = path.basename(file.path);
  final newPath = path.join(path.dirname(file.path), '$prefix$fileName');
  await file.rename(newPath);
}

Future<void> _addSuffix(String suffix) async {
  await for (final entity in Directory.current.list()) {
    if (entity is File) {
      final fileName = path.basenameWithoutExtension(entity.path);
      final extension = path.extension(entity.path);
      final newPath =
          path.join(path.dirname(entity.path), '$fileName$suffix$extension');
      await entity.rename(newPath);
    }
  }
}

Future<void> _replaceInFilenames(String oldText, String newText) async {
  await for (final entity in Directory.current.list()) {
    if (entity is File) {
      final fileName = path.basename(entity.path);
      if (fileName.contains(oldText)) {
        final newName = fileName.replaceAll(oldText, newText);
        final newPath = path.join(path.dirname(entity.path), newName);
        await entity.rename(newPath);
      }
    }
  }
}

Future<void> handlePrefixRename() async {
  print('\nEnter prefix:');
  final prefix = stdin.readLineSync();
  if (prefix != null) {
    await for (final entity in Directory.current.list()) {
      if (entity is File) {
        await _addPrefix(entity, prefix);
      }
    }
  }
}

Future<void> handleSuffixRename() async {
  print('\nEnter suffix (before extension):');
  final suffix = stdin.readLineSync();
  if (suffix != null) await _addSuffix(suffix);
}

Future<void> handleReplaceRename() async {
  print('\nEnter text to replace:');
  final oldText = stdin.readLineSync();
  print('Enter new text:');
  final newText = stdin.readLineSync();
  if (oldText != null && newText != null) {
    await _replaceInFilenames(oldText, newText);
  }
}

// ... other rename methods ... 