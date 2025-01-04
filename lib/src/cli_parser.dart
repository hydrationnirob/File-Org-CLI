import 'package:args/args.dart';
import 'file_organizer.dart';

Future<void> handleCommandLineArgs(List<String> args) async {
  final parser = getParser();

  try {
    final results = parser.parse(args);

    // Use the parsed arguments
    final directory = results['directory'] as String;
    final dryRun = results['dry-run'] as bool;
    final includeHidden = results['include-hidden'] as bool;

    final organizer = FileOrganizer(
      directory: directory,
      dryRun: dryRun,
      includeHidden: includeHidden,
    );

    await organizer.organize();
  } catch (e) {
    print('Error parsing arguments: $e');
  }
}

ArgParser getParser() {
  return ArgParser()
    ..addFlag('verbose', abbr: 'v', help: 'Show detailed output')
    ..addOption('format',
        allowed: ['simple', 'detailed'], help: 'Output format')
    ..addFlag('backup', help: 'Create backup before organizing')
    ..addOption('filter', help: 'Filter by extensions (comma-separated)');
}
