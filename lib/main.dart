import 'package:win32/win32.dart';
import 'src/menu_handler.dart';
import 'src/cli_parser.dart';

void main(List<String> args) async {
  try {
    if (args.isNotEmpty) {
      // Handle command line arguments
      await handleCommandLineArgs(args);
      return;
    }

    // Interactive mode
    await startInteractiveMode();
  } finally {
    CoUninitialize();
  }
}
