import 'package:win32/win32.dart';

Future<bool> confirmAction(String message) async {
  final result = MessageBox(
    NULL,
    TEXT(message),
    TEXT('Confirm Action'),
    MB_YESNO | MB_ICONQUESTION,
  );
  return result == IDYES;
}

// Other utility functions
