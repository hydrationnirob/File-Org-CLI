import 'dart:io';
import 'package:colorize/colorize.dart';
import 'handlers/file_handler.dart';
import 'handlers/rename_handler.dart';
import 'handlers/backup_handler.dart';
import 'handlers/info_handler.dart';

Future<void> startInteractiveMode() async {
  while (true) {
    try {
      print('\x1B[2J\x1B[0;0H'); // Clear screen

      // Title Box
      print('\x1B[36m╔════════════════════════════════════╗\x1B[0m');
      print('\x1B[36m║        File Organizer v1.0         ║\x1B[0m');
      print('\x1B[36m╚════════════════════════════════════╝\x1B[0m\n');

      // Main Menu
      displayMainMenu();

      final choice = stdin.readLineSync();
      if (choice == '9') {
        print('\x1B[32m\nThank you for using File Organizer!\x1B[0m');
        print('\x1B[32mDeveloped with ❤️ by Md Rakibul Islam\x1B[0m');
        break;
      }

      await handleMenuChoice(choice);

      print('\nPress Enter to return to main menu...');
      stdin.readLineSync();
    } catch (e) {
      print(Colorize('\nAn error occurred: $e').red());
      print('\nPress Enter to continue...');
      stdin.readLineSync();
    }
  }
}

void displayMainMenu() {
  print('\x1B[2J\x1B[0;0H'); // Clear screen
  print('\x1B[36m'); // Set cyan color

  final menuItems = [
    'Organize current directory',
    'Organize specific directory',
    'Preview organization',
    'Filter and organize files',
    'Bulk rename files',
    'Create backup',
    'Show User Guide',
    'Developer Information',
    'Exit'
  ];

  print(Colorize('\n=== File Organizer v1.0 ===\n').cyan().bold());

  for (var i = 0; i < menuItems.length; i++) {
    print('  ${i + 1}. ${menuItems[i]}');
  }

  print('\x1B[0m'); // Reset color
  print('\nEnter your choice (1-${menuItems.length}):');

  final choice = stdin.readLineSync();
  handleMenuChoice(choice);
}

Future<void> handleMenuChoice(String? choice) async {
  switch (choice) {
    case '1':
      await handleCurrentDirectoryOrganization();
      break;
    case '2':
      await handleSpecificDirectoryOrganization();
      break;
    case '3':
      await handlePreviewOrganization();
      break;
    case '4':
      await handleFilteredOrganization();
      break;
    case '5':
      await handleBulkRename();
      break;
    case '6':
      await handleBackup();
      break;
    case '7':
      await showUserGuide();
      break;
    case '8':
      showDeveloperInfo();
      break;
    default:
      print('\x1B[31m\nInvalid choice! Please enter 1-9.\x1B[0m');
      await Future.delayed(Duration(seconds: 2));
  }
}
