import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';

import 'package:ffmpeg_bin/core/keys.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final packageName = input.packageName;
    final packageRootDir = input.packageRoot.toFilePath();
    final nativeAssets = p.join(packageRootDir, '.dart_tool', 'native_assets');

    final archiveLib = LibArchiveConfig.create(input.config.code);

    await extractLib(archiveLib, nativeAssets: nativeAssets);

    for (var lib in archiveLib.libs) {
      final f = File(
        p.join(nativeAssets, archiveLib.platform, archiveLib.arch, lib.libName),
      );

      if (!f.existsSync()) continue;

      output.assets.code.add(
        .new(
          package: packageName,
          name: lib.libName,
          linkMode: DynamicLoadingBundled(),
          file: f.uri,
        ),
      );
    }
  });
}

class ArchiveLib {
  final String archivePath;
  final String libName;

  const ArchiveLib({required this.archivePath, required this.libName});
}

class LibArchiveConfig {
  const LibArchiveConfig({
    required this.config,
    required this.platform,
    required this.arch,
    required this.libs,
    required this.downloadUrl,
  });

  final CodeConfig config;
  final String downloadUrl;
  final List<ArchiveLib> libs;
  final String platform;
  final String arch;

  factory LibArchiveConfig.create(CodeConfig cf) {
    final targetOS = cf.targetOS;
    final targetArch = cf.targetArchitecture;

    if (cf.targetOS == .linux) {
      return .new(
        config: cf,
        libs: [
          .new(archivePath: 'ffmpeg', libName: ffmpegLibName),
          .new(archivePath: 'ffprobe', libName: ffprobeLibName),
        ],
        platform: targetOS.name,
        arch: targetArch.name,
        downloadUrl: linuxLibUrl,
      );
    }
    if (cf.targetOS == .windows) {
      return .new(
        config: cf,
        libs: [
          .new(archivePath: 'ffmpeg.exe', libName: ffmpegLibName),
          .new(archivePath: 'ffprobe.exe', libName: ffprobeLibName),
        ],
        platform: targetOS.name,
        arch: targetArch.name,
        downloadUrl: windowLibUrl,
      );
    }
    if (targetOS == .android) {
      final downloadUrl = switch (targetArch) {
        .arm => androidArmLibUrl,
        .arm64 => androidArm64LibUrl,
        _ => UnsupportedError('error: ${targetOS.name} - ${targetArch.name}'),
      };
      return .new(
        config: cf,
        libs: [
          .new(archivePath: 'ffmpeg', libName: ffmpegLibName),
          .new(archivePath: 'ffprobe', libName: ffprobeLibName),
        ],
        platform: targetOS.name,
        arch: targetArch.name,
        downloadUrl: downloadUrl as String,
      );
    }

    throw UnsupportedError(
      'Not Supported: ${targetOS.name} - ${targetArch.name}',
    );
  }
}

Future<void> extractLib(
  LibArchiveConfig config, {
  required String nativeAssets,
}) async {
  final outDir = Directory(p.join(nativeAssets, config.platform, config.arch));
  if (!outDir.existsSync()) {
    await outDir.create(recursive: true);
  }

  final libFiles = config.libs
      .map((lib) => File(p.join(outDir.path, lib.libName)))
      .toList();
  if (libFiles.any((e) => e.existsSync())) return;
  final libZipFile = File(
    p.join(nativeAssets, 'ffmpeg_bin-${config.platform}-${config.arch}.zip'),
  );
  if (libZipFile.existsSync()) {
    await extractZip(libZipFile, outDir: outDir, libs: config.libs);
    return;
  }
  // libZipFile.writeAsStringSync('contents');

  // download
  await downloadLib(config.downloadUrl, libZipFile);
  await extractZip(libZipFile, outDir: outDir, libs: config.libs);
}

Future<void> downloadLib(String url, File output) async {
  final client = HttpClient();

  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Download failed: ${response.statusCode}',
        uri: Uri.parse(url),
      );
    }

    await output.parent.create(recursive: true);

    final sink = output.openWrite();

    try {
      await response.pipe(sink);
    } finally {
      await sink.close();
    }
  } catch (e) {
    if (await output.exists()) {
      await output.delete();
    }

    rethrow;
  } finally {
    client.close(force: true);
  }
}

Future<void> extractZip(
  File input, {
  required Directory outDir,
  required List<ArchiveLib> libs,
}) async {
  final archive = ZipDecoder().decodeBytes(input.readAsBytesSync());
  await outDir.create(recursive: true);

  for (var lib in libs) {
    final libFile = File(p.join(outDir.path, lib.libName));
    if (libFile.existsSync()) continue;
    final f = archive.findFile(lib.archivePath);
    if (f == null) {
      throw PathNotFoundException(lib.archivePath, .new('Not Found Lib Path'));
    }
    await libFile.writeAsBytes(f.content, flush: true);
  }
}
