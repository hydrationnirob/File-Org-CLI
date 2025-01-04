import 'dart:io';

Future<void> showUserGuide() async {
  print('\n\x1B[1mDetailed Feature Guide:\x1B[0m\n');

  // Option 1 & 2
  print('\x1B[1m1. File Organization:\x1B[0m');
  print('   • Automatically sorts files by type');
  print('   • Creates folders like PDF, JPG, DOC');
  print('   • Works in current/specific directory\n');

  // Option 3
  print('\x1B[1m2. Preview Feature:\x1B[0m');
  print('   • Shows which files will go where');
  print('   • Displays total files and folders');
  print('   • Option to proceed or cancel\n');

  // Option 4
  print('\x1B[1m3. File Filtering:\x1B[0m');
  print('   • Choose specific file types to organize');
  print('   • Example: "pdf,jpg,doc" for specific types');
  print('   • Use "all" to include every file type');
  print('   • Ignores unwanted file types\n');

  // Option 5
  print('\x1B[1m4. Bulk Rename:\x1B[0m');
  print('   • Add prefix to all files (e.g., "2024_")');
  print('   • Add suffix before extension (e.g., "_final")');
  print('   • Replace text in all filenames');
  print('   • Preserves original file extensions\n');

  // Option 6
  print('\x1B[1m5. Backup System:\x1B[0m');
  print('   • Creates timestamped backup folder');
  print('   • Copies all files before organizing');
  print('   • Safe way to prevent data loss');
  print('   • Easy to restore if needed\n');

  print('\x1B[1mTips:\x1B[0m');
  print('• Always preview before organizing');
  print('• Create backup for important files');
  print('• Use filter for specific file types');
  print('• Check backup folder after completion\n');

  print('\nPress Enter to return to main menu...');
  stdin.readLineSync();
}

void showDeveloperInfo() {
  print('\n\x1B[1mDeveloper Information\x1B[0m\n');
  print('Name: Md Rakibul Islam');
  print('Email: rakibulislam667s@gmail.com');
  print('GitHub: github.com/rakibulislam667s\n');
  print('\x1B[1mAbout:\x1B[0m');
  print('A passionate programmer who loves to create');
  print('useful tools to make life easier.\n');

  print('\nPress Enter to return to main menu...');
  stdin.readLineSync();
}
