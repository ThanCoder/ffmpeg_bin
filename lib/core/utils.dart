// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart' as p;

String getDesktopLibFullPath(String libName) {
  // 1. App binary ရှိနေသည့် file path ကို ယူခြင်း
  final executablePath = Platform.resolvedExecutable;

  // 2. ၎င်း၏ Parent directory (folder) ကို ဖြတ်ယူခြင်း
  final executableDir = File(executablePath).parent.path;

  // 3. lib folder ထဲရှိ libName ရဲ့ absolute path ကို တည်ဆောက်ခြင်း
  // (ဥပမာ - app တည်ရှိရာ folder အောက်မှ lib/libname.so)

  if (Platform.isWindows) {
    return File(p.join(executableDir, libName)).absolute.path;
  }
  final libPath = p.join(executableDir, 'lib', libName);

  return File(libPath).absolute.path;
}

Future<void> makeExecutableAndRun(String filePath) async {
  try {
    // ၁။ chmod +x ပေးခြင်း
    final chmodResult = await Process.run('chmod', ['+x', filePath]);

    if (chmodResult.exitCode != 0) {
      print('Failed to grant execution permission: ${chmodResult.stderr}');
      return;
    }

    print(
      'Successfully granted execution permission! - ${filePath.split(Platform.pathSeparator).last}',
    );
  } catch (e) {
    print('Error: $e');
  }
}
